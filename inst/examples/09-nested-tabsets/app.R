################################################################################
#' This example app shows how nested tabs can work
#'
#' The app has to main tabs: database and server; whereas server has two tabs
#' itself: pie-chart and line-chart.
#'
#' Note that the key is to give matching `tabsetid`s to the twTabNav() and
#' twTabContent() calls to make them find each other. If the two levels have the
#' identical `tabsetid`, the nested tabs won't work.
################################################################################

library(shiny)
library(shiny.tailwind)
library(fontawesome)

# 1) Define UI with nested Tabs ----
ui <- div(
  class = "h-screen bg-white overflow-hidden flex",
  use_tailwind(),
  fa_html_dependency(),

  # Define Outer Tab Nav ====
  twTabNav(
    div(icon("database"), span("Database", class = "pl-2")),
    div(icon("server"), span("Server", class = "pl-2")),
    container_class = "h-full pt-10 pt-2 bg-indigo-900",
    tab_class = "cursor-pointer py-2 px-4 my-4 w-full text-white hover:bg-indigo-700"
  ),


  # Outer Tab Content ====
  twTabContent(
    container_class = "flex-1 bg-indigo-50",
    div(
      h1("First Tab - Database",
         class = "p-4 text-center font-sans text-4xl font-extrabold text-slate-800"
      ),
      plotOutput("plot1")
    ),
    div(
      h1("Second Tab - Server",
         class = "p-4 text-center font-sans text-4xl font-extrabold text-slate-800"
      ),

      # Define Inner Tab Nav ====
      twTabNav(tabsetid = "tabSet-inner",
               container_class = "w-full bg-indigo-200 flex",
               tab_class = "cursor-pointer bg-indigo-400 rounded m-2 p-2",
               div(icon("chart-pie"), span("Pie Chart", class = "pl-2")),
               div(icon("chart-line"), span("Line Chart", class = "pl-2"))
      ),


      # Inner Tab Content ====
      twTabContent(tabsetid = "tabSet-inner",
        div(
          h1("2nd level - First Tab - A Pie Chart",
             class = "p-2 text-center font-sans text-2xl font-extrabold text-slate-800"
          ),
          plotOutput("plot2")
        ),
        div(
          h1("2nd level - Second Tab - A Line Chart",
             class = "p-2 text-center font-sans text-2xl font-extrabold text-slate-800"
          ),
          plotOutput("plot3")
        )
      )
    )
  )
)


# 2) Define the server functions ----
server <- function(input, output, session) {
  output$plot1 <- shiny::renderPlot({
    print("Rendering Plot 1")
    plot(1:10, rnorm(10))
    title("Plot 1")
  })
  output$plot2 <- shiny::renderPlot({
    print("Rendering Plot 2")
    pie(runif(3))
    title("Plot 2")
  })
  output$plot3 <- shiny::renderPlot({
    print("Rendering Plot 3")
    plot(1:100, cumsum(rnorm(100)), type = "l")
    title("Plot 3")
  })
}


# 3) Run the application ----
shiny::shinyApp(ui, server)
