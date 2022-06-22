#' Creates the Navigation Element of Tabs
#'
#' This function creates only the navigation elements of tabs, the content
#' elements can be created by the [twTabContent()] function.
#' A full example is included in the example 06-sidebar-dashboard.
#'
#' @param ... titles for the navigation elements
#' @param ids a list of reference IDs for each tab. This will be overridden by
#' ID fields of the `...` values (if given). Default is `twTab-{i}`. Note that
#' this option is only needed when multiple tab systems are used within a page
#' or when the elements of the `twTabContent`s are given out of order.
#' @param container_class additional classes to be applied to the container
#' @param tab_class additional classes to be applied to each tab container
#'
#' @details Note that contrary how [shiny::tabPanel()] constructs a tab page,
#' these funtions (`twTabContent()` and [twTabNav()]) construct navigation and
#' content independently, allowing more flexibility.
#'
#' The active elements all have either a `twTab-active` or `twTabContent-active`
#' CSS class if their styling needs to be overriden (see also the example).
#'
#' @return a HTML element to be included in the UI
#' @export
#'
#' @seealso [twTabContent()]
#'
#' @examples
#' twTabNav(
#'   div("Tab 1", id = "firstTab"),
#'   div("Tab 2", id = "secondTab"),
#'   container_class = "CONTAINER", tab_class = "TAB"
#' )
#'
#' #############################################################################
#' # Example App
#'
#' library(shiny)
#' # basic Tabs
#'
#' ui_basic <- shiny::div(
#'   shiny::h1("Completely Unstyled Tabs..."),
#'   twTabNav(
#'     shiny::div("Tab 1 (click me)"),
#'     shiny::div("Tab 2 (click me)")
#'   ),
#'
#'   twTabContent(
#'     shiny::div(shiny::h1("First Tab"), shiny::plotOutput("plot1")),
#'     shiny::div(shiny::h1("Second Tab"), shiny::plotOutput("plot2"))
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'   output$plot1 <- shiny::renderPlot({
#'     print("Plot 1")
#'     plot(1:10, rnorm(10))
#'   })
#'   output$plot2 <- shiny::renderPlot({
#'     print("Plot 2")
#'     plot(1:100, rnorm(100))
#'  })
#' }
#'
<<<<<<< HEAD
#' if (interactive()) {
#' shiny::shinyApp(ui_basic, server)
#' }
=======
#' if (interactive()) shinyApp(ui_basic, server)
>>>>>>> 98e938d9f77b30625679f4b7af4d275a7b618dc7
#'
#' #############################################################################
#' # Styled App
#'
#' ui_styled <- div(
#'   class = "h-screen bg-white overflow-hidden flex",
#'   shiny.tailwind::use_tailwind(),
#'
#'   twTabNav(
#'     div(icon("database"), span("Tab One", class = "pl-2")),
#'     div(icon("server"), span("Tab Two", class = "pl-2")),
#'     container_class = "h-full pt-10 pt-2 bg-indigo-900",
#'     tab_class = "cursor-pointer py-2 px-4 my-4 w-full text-white hover:bg-indigo-700"
#'   ),
#'
#'   twTabContent(
#'     div(
#'       h1("First Tab",
#'          class = "p-10 text-center font-sans text-8xl font-extrabold text-slate-800"),
#'       plotOutput("plot1")
#'     ),
#'     div(
#'       h1("Second Tab", 
#'          class = "p-10 text-center font-sans text-8xl font-extrabold text-slate-800"),
#'       plotOutput("plot2")
#'     ),
#'     container_class = "flex-1 bg-indigo-50"
#'   )
#' )
#'
#' if (interactive()) shinyApp(ui_styled, server)
twTabNav <- function(..., ids = NULL, container_class = NULL, tab_class = NULL) {
  dots <- list(...)

  if (is.null(ids)) ids <- paste0("twTab-", seq_along(dots))

  if (length(dots) != length(ids))
    stop("ids has to have the same length as the provided tab navigation elements")

  shiny::div(
    class = container_class,

    lapply(seq_along(dots), function(i) {
      id <- dots[[i]]$attribs$id
      if (is.null(id)) id <- ids[[i]]
      shiny::div(
        class = paste("twTab", if (i == 1) "twTab-active", tab_class),
        id = id,
        dots[[i]]
      )
    }),

    shiny::includeScript(path = system.file("twTab.js", package = "shiny.tailwind"))
  )
}
