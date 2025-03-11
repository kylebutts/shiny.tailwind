################################################################################
#' This app shows some basic UI elements using preline UI
#'
#' Note that this app has no server component. As preline works via classes,
#' the usage within a shiny app requires custom JS which can be created using
#' the shinyjs or htmltools package (eg shinyjs::toggleClass())
#'
#' For a full list of components see: https://preline.co/docs/index.html
################################################################################

library(shiny)
library(shiny.tailwind)
library(htmltools)

# 1) Define Helper Functions ====
# Function to generate PIN input fields
generate_pin_inputs <- function(n = 6) {
  div(
    id = "pin-input",
    `data-hs-pin-input` = '{"availableCharsRE": "^[0-9]+$"}',
    style = "display: flex; gap: 1rem; padding: 1rem; border: 1px solid #ffffff;",
    lapply(seq_len(n), function(i) {
      tags$input(
        type = "text",
        id = paste0("pin_", i),
        name = paste0("pin_", i),
        placeholder = "",
        `data-hs-pin-input-item` = "",
        maxlength = 1,
        class = "block size-[80px] text-center border border-[#236e32] rounded-md text-4xl
                 focus:scale-105 focus:border-[#236e32] focus:border-2 focus:ring-[#236e32] focus:outline-none
                 [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none
                 disabled:opacity-50 disabled:pointer-events-none"
      )
    })
  )
}

# Define the App ================
ui <- div(
  use_preline(),

  # PIN Input Card
  div(
    class = "max-w-[85rem] px-4 py-10 sm:px-6 lg:px-8 mx-auto",
    div(
      class = "bg-white border border-gray-200 rounded-xl shadow-sm p-4 md:p-5",
      div(
        class = "mb-6 text-center",
        h3("VALIDATION CODE", class = "text-lg font-semibold text-gray-800")
      ),
      div(
        class = "space-y-4 flex justify-center",
        # Generate 6 PIN input fields
        generate_pin_inputs(6)
      )
    )
  ),

  # Results Card
  div(
    class = "mt-6 bg-white border border-gray-200 rounded-xl shadow-sm p-4 md:p-5",
    div(
      class = "mb-6",
      h3("Result", class = "text-lg font-semibold text-gray-800")
    ),
    verbatimTextOutput("result")
  ),

  # JS for initializing the PIN input and updating Shiny input
  tags$script(HTML("
    document.addEventListener('DOMContentLoaded', function() {
      if (typeof HSPinInput !== 'undefined') {
        HSPinInput.autoInit();
        var pinInstance = HSPinInput.getInstance('#pin-input');
        if (pinInstance) {
          pinInstance.on('completed', function(e) {
            console.log('PIN completed:', e.currentValue);
            Shiny.setInputValue('pin', e.currentValue, {priority: 'event'});
          });
          var inputs = document.querySelectorAll('#pin-input [data-hs-pin-input-item]');
          function updatePin() {
            var currentValue = Array.from(inputs).map(function(el) { return el.value || ''; }).join('');
            console.log('PIN updated:', currentValue);
            Shiny.setInputValue('pin', currentValue, {priority: 'event'});
          }
          inputs.forEach(function(input) {
            input.addEventListener('input', updatePin);
            input.addEventListener('keyup', updatePin);
          });
        } else {
          console.error('Unable to get HSPinInput instance for #pin-input');
        }
      } else {
        console.error('HSPinInput is not defined');
      }
    });
  "))
)

server <- function(input, output, session) {

  output$result <- renderText({

    # Consolidate the PIN into a single string
    pin_consolidated <- if (!is.null(input$pin)) paste(input$pin, collapse = "") else ""

    pin_value <- if (pin_consolidated != "") {
      pin_consolidated
    } else {
      "not entered"
    }

    paste("PIN Code:", pin_value)
  })
}

shiny::shinyApp(ui, server)
