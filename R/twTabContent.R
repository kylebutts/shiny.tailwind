#' Creates the Content Elements of Tabs
#'
#' This function only creates the content elements of tabs, the navigation
#' elements can by created by the [twTabNav()] function.
#' A full example is included in the example 06-sidebar-dashboard.
#'
#' @param ... UI element to include in the tab
#' @param ids a list of reference IDs to the navigation elements. This will be
#' overridden by ID fields of the `...` values (if given). Default is
#' `twTab-{i}-content` (note that the ids must end with `-content` where the
#' part before matches the IDs of the navigation elements. Note that this
#' option is only needed when multiple tab systems are used within a page or
#' when the elements of the `twTabContent`s are given out of order.
#' @param container_class additional classes to be applied to the container
#' @param content_class additional classes to be applied to each content container
#' @param tabsetid an optional class that is added to the container to be
#' identify and linked the tabsets. Must match the `tabsetid` of [twTabContent()].
#' Can be an arbitrary text, but due to it being a class, make sure to not have
#' class-clashes (eg `"button"` would be a bad idea). This allows to have
#' multiple nested tabsets. See also Example 09-nested-tabsets.
#'
#' @details Note that contrary how [shiny::tabPanel()] constructs a tab page,
#' these funtions (`twTabContent()` and [twTabNav()]) construct navigation and
#' content independently, allowing more flexibility.
#'
#' The active elements all have either a `twTab-active` or `twTabContent-active`
#' CSS class if their styling needs to be overriden (see also the example).
#'
#' @return a list with a `shiny.tag` class
#' @export
#'
#' @seealso [twTabNav()]
#' @examples
#' twTabContent(
#'   div(h1("First Tab"), shiny::plotOutput("plot1")),
#'   div(h1("Second Tab"), shiny::plotOutput("plot2"))
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
#'   })
#' }
#'
#' if(interactive()) shiny::shinyApp(ui_basic, server)
#'
#' #############################################################################
#' # Styled App
#'
#' ui_styled <- shiny::div(
#'   class = "h-screen bg-white overflow-hidden flex",
#'   shiny.tailwind::use_tailwind(),
#'   twTabNav(
#'     shiny::div(icon("database"), shiny::span("Tab One", class = "pl-2")),
#'     shiny::div(icon("server"), shiny::span("Tab Two", class = "pl-2")),
#'     container_class = "h-full pt-10 pt-2 bg-indigo-900",
#'     tab_class = "cursor-pointer py-2 px-4 my-4 w-full text-white hover:bg-indigo-700"
#'   ),
#'   twTabContent(
#'     shiny::div(
#'       shiny::h1("First Tab",
#'         class = "p-10 text-center font-sans text-8xl font-extrabold text-slate-800"
#'       ),
#'       shiny::plotOutput("plot1")
#'     ),
#'     shiny::div(
#'       shiny::h1("Second Tab",
#'         class = "p-10 text-center font-sans text-8xl font-extrabold text-slate-800"
#'       ),
#'       shiny::plotOutput("plot2")
#'     ),
#'     container_class = "flex-1 bg-indigo-50"
#'   )
#' )
#'
#' if(interactive()) shiny::shinyApp(ui_styled, server)
#'
#' @export
twTabContent <- function(..., ids = NULL, container_class = NULL,
                         content_class = NULL, tabsetid = "tabSet1") {
  dots <- list(...)

  if(is.null(ids)) ids <- paste0("twTab-", seq_along(dots))

  if(length(dots) != length(ids)) {
    stop("ids has to have the same length as the provided tab navigation elements")
  }


  shiny::div(
    class = container_class,
    lapply(seq_along(dots), function(i) {
      id <- dots[[i]]$attribs$id
      if(is.null(id)) id <- ids[[i]]

      idc <- strsplit(id, "-")[[1]]
      if(idc[length(idc)] != "content") id <- paste0(id, "-content")

      shiny::div(
        class = paste("twTabContent",
                      paste0(tabsetid, "-content"),
                      if(i == 1) "twTabContent-active", content_class),
        style = if(i == 1) "display: block;" else "display: none;",
        id = id,
        dots[[i]]
      )
    })
  )
}
