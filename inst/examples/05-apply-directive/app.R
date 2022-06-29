################################################################################
#' This app and its "apply-custom.css" show how the @apply directive can be used
#' inside a shiny application using shiny.tailwind.
#'
#' We define new classes in the css file and reference them here, eg: main-div,
#' fancy-title, rounded-box as well as the the background of the twSelectInput
#' elements (these elements are styled by selectize.bootstrap.css but are
#' overridden using the @apply directive.
#'
#' See also: https://tailwindcss.com/docs/reusing-styles#extracting-classes-with-apply
################################################################################

library(shiny)
library(shiny.tailwind)
library(ggplot2)
library(dplyr)
theme_set(theme_light())

dataset <- mpg[, c("displ", "year", "cyl", "cty", "hwy")]

# Define UI for application that draws a histogram
ui <- div(
  class = "main-div",
  # Load Tailwind CSS Just-in-time
  use_tailwind(css = "apply-custom.css"),

  # Title
  div(class = "flex flex-col w-full text-center py-12",
      h1(class = "fancy-title", "Histogram of Cars")
  ),

  # Inputs
  div(class = "rounded-box block py-4 px-4 flex flex-row",

      div(class = "rounded-box flex-initial mx-4",
          # note the background of the inputs is styled in apply-custom.css
          twVarSelectInput("var", "Variable:", dataset, multiple = TRUE,
                           container_class = "mx-2 w-64"
          ),
      ),
      div(class = "rounded-box flex-initial mx-4",
          twSliderInput("bins", "Number of Bins:",
                        min = 1, max = 10, value = 5,
                        container_class = "border border-gray",
                        label_class = "font-mono",
                        input_class = "drop-shadow")
      ),
      div(class = "rounded-box flex-initial mx-4",
          twTextInput("title", "Title", value = "Histogram of Cars",
                      input_class = "rounded-md text-teal-500 font-bold")
      )
  ),

  # Plot
  div(class = "rounded-box block py-4 px-4 mt-4",
      plotOutput("distPlot")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$distPlot <- renderPlot({
    dataset %>%
      select(!!!input$var) %>%
      # alternatively use tidyr::pivot_longer(everything())
      stack() %>%
      ggplot(aes(x = values, fill = ind)) +
      geom_histogram(bins = input$bins + 1) +
      facet_wrap(~ind, scales = "free_x") +
      labs(title = input$title)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
