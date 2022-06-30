################################################################################
#' This example app shows how to construct a sidebar-dashboard using tailwindcss
#'
#' Note that contrary to shiny::tabsetPanel() and shinydashboard::dashboardPage()
#' shiny.tailwind does not have a combined tabset-nav and tabset-content function
#' instead the functions are separated to allow more flexibility.
#' Ie you have the twTabNav() function to create the navigation part of the tabs
#' and twTabContent() to create the content of the tabs.
#' This allows you to create tabs and nav elements independently from each other.
#'
#' Note that internally, the nav element includes a small JS script to allow
#' shiny to detect which tab is active and applies the twTab-active class for
#' styling purposes.
################################################################################

library(shiny)
library(shiny.tailwind)

fancy_title <- function(txt) {
  shiny::div(
    class = "w-full text-center py-12",
    shiny::h1(
      class = "font-extrabold text-8xl text-indigo-600",
      txt
    )
  )
}

ui <- div(
  class = "overflow-hidden",
  use_tailwind(),
  # Rest of App below
  div(
    class = "flex flex-col h-screen",
    # Top Bar
    div(
      class = "border-b px-5 py-1 h-16 flex shrink-0",
      h1("Example Dashboard Layout",
        class = "my-auto font-sans font-bold tracking-wider"
      )
    ),
    div(
      class = "flex flex-row h-screen",
      # Left Side Navigation
      twTabNav(
        div(icon("database"), span("Database", class = "pl-2")),
        div(icon("server"), span("Server", class = "pl-2")),
        container_class = "h-full flex-none pt-5 bg-indigo-900",
        tab_class = "py-2 pl-8 pr-8 md:pr-20 w-full text-white hover:bg-indigo-700"
      ),

      # Body of the App
      twTabContent(
        div(
          fancy_title("First Tab"),
          plotOutput("plot1"),
          div(
            class="min-h-screen flex items-center justify-center",
            "Hello!"
          )
        ),
        div(
          fancy_title("Second Tab"),
          plotOutput("plot2")
        ),
        container_class = "flex-1 bg-indigo-50 overflow-scroll px-4 md:px-8 lg:px-16 py-4"
      )
    )
  )
)

server <- function(input, output, session) {
  output$plot1 <- renderPlot({
    print("Plot 1")
    plot(1:10, rnorm(10))
  })
  output$plot2 <- renderPlot({
    print("Plot 2")
    plot(1:100, rnorm(100))
  })
}

shiny::shinyApp(ui, server)
