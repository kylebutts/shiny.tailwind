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
theme_set(theme_light())

dataset <- mpg[, c("displ", "year", "cyl", "cty", "hwy")]

# Define UI for application that draws a histogram
ui <- div(
  class = "main-div",
  # Load Tailwind CSS Just-in-time
  use_tailwind(css = "apply-custom.css"),

  # Title
  div(
    class = "flex flex-col w-full text-center py-12",
    h1(class = "fancy-title", "Histogram of Cars")
  ),

  # Inputs
  div(
    class = "rounded-box block py-4 px-4 flex flex-row justify-around",
    div(
      # note the background of the inputs is styled in apply-custom.css
      twVarSelectInput(
        "var", "Variable:", dataset,
        selectize = FALSE,
        container_class = "w-64",
        select_class = "rounded-md text-indigo-500 w-64"
      ),
    ),
    div(
      twSliderInput(
        "bins", "Number of Bins:",
        min = 1, max = 10, value = 5,
        label_class = "font-mono",
        input_class = "drop-shadow"
      )
    ),
    div(
      twTextInput(
        "title", "Title",
        value = "Histogram of Cars",
        input_class = "rounded-md text-indigo-500 font-bold w-64"
      )
    )
  ),

  # Plot
  div(
    class = "rounded-box block py-4 px-4 mt-4",
    plotOutput("distPlot")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$distPlot <- renderPlot({
    var <- as.character(input$var)
    hist(
      dataset[[var]],
      main = input$title, xlab = var,
      breaks = input$bins
    )
  })
}

# Run the application
shiny::shinyApp(ui = ui, server = server)
