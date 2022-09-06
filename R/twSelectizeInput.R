#' Wrapper around [`shiny::selectizeInput()`] but allowing for more classes
#'
#' Note that the colors for the slider bar can be customized by overriding the
#' `irs` class. c.f. 05-apply-directive example app
#'
#' @inheritParams shiny::selectizeInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#' @param label_after_input TRUE/FALSE if the label should be put after the
#' input box. Default is FALSE. Useful for special cases (floating labels),
#' c.f. 05-apply-directive example app.
#'
#' @seealso [shiny::selectizeInput()]
#'
#' @return a list with a `shiny.tag` class
#' 
#' @export
#' @examples
#' shiny::selectizeInput("selectize", "A Selection", choice = c("A", "B"))
#' twSelectizeInput("selectize", "A Selection",
#'   choice = c("A", "B"),
#'   container_class = "CONTAINER", label_class = "LABEL",
#'   input_class = "INPUT"
#' )
#'
#' # basic full shiny example
#' library(shiny)
#'
#' ui <- fluidPage(
#'   use_tailwind(),
#'   twSelectizeInput(
#'     "values", "A Selection",
#'     choice = c("A", "B"), multiple = TRUE,
#'     # Apply tailwind classes
#'     container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
#'     label_class = "font-mono text-gray-600",
#'     input_class = "drop-shadow-lg text-gray-600 font-mono rounded-md border-amber-400"
#'   ),
#'   verbatimTextOutput("value")
#' )
#'
#' server <- function(input, output) {
#'   output$value <- renderText({
#'     as.character(input$values)
#'   })
#' }
#'
#' if(interactive()) shiny::shinyApp(ui, server)
twSelectizeInput <- function(inputId,
                             ...,
                             options = NULL,
                             width = NULL,
                             container_class = NULL,
                             label_class = NULL,
                             input_class = NULL,
                             label_after_input = FALSE) {
  res <- shiny::selectizeInput(
    inputId = inputId,
    ...,
    options = options,
    width = width
  )

  res$attribs$class <- paste(res$attribs$class, container_class)
  res$children[[1]]$attribs$class <- paste(res$children[[1]]$attribs$class, label_class)
  res$children[[2]]$attribs$class <- paste(res$children[[2]]$attribs$class, input_class)

  if(label_after_input) {
    tmp <- res$children[[1]]
    res$children[[1]] <- res$children[[2]]
    res$children[[2]] <- tmp
  }

  res
}
