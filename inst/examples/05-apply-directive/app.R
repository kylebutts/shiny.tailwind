################################################################################
#' This app and its "apply-custom.css" show how the @apply directive can be used
#' inside a shiny application using shiny.tailwind.
#'
#' We define new classes in the css file and reference them here, eg: main-div,
#' fancy-title, and rounded-box.
#'
#' See also: https://tailwindcss.com/docs/reusing-styles#extracting-classes-with-apply
################################################################################

library(shiny)
library(shiny.tailwind)

# Define UI for application that draws a histogram
ui <- div(
  class = "main-div",
  # Load Tailwind CSS Just-in-time
  shiny.tailwind::use_tailwind(css = "apply-custom.css"),

  # Title
  div(class = "flex flex-col w-full text-center py-12",
      h1(class = "fancy-title", "Old Faithful")
  ),

  # Inputs
  div(class = "rounded-box block py-4 px-4 flex flex-row",
      div(class = "rounded-box flex-initial mx-4",
          sliderInput("bins", "Number of Bins:",
                      min = 1, max = 10, value = 5)
      ),
      div(class = "rounded-box flex-initial mx-4",
          textInput("firstname", "First Name", value = "")
      ),
      div(class = "rounded-box flex-initial mx-4",
          textInput("lastname", "Last Name", value = "")
      ),
  ),

  # Plot
  div(class = "rounded-box block py-4 px-4 mt-4",
      plotOutput("distPlot")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x,
         breaks = bins,
         col = 'darkgray', border = 'white')
  })
}

# Run the application
shinyApp(ui = ui, server = server)
