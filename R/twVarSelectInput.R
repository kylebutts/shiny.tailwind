#' Wrapper around [`shiny::varSelectInput()`] but allowing for more classes
#'
#' @inheritParams shiny::varSelectInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param select_class additional classes to be applied to the select elements
#'
#' @seealso [shiny::varSelectInput()]
#'
#' @export
#' @examples
#' shiny::varSelectInput("id", "label", mtcars, width = "200px",
#'                       selected = c("vs", "cyl"), multiple = TRUE)
#' twVarSelectInput("id", "label", mtcars,
#'                  selected = c("vs", "cyl"), width = "200px",
#'                  multiple = TRUE, selectize = TRUE,
#'                  container_class = "CONTAINER", label_class = "LABEL",
#'                  select_class = "SELECT")
#'
#' if (interactive()) {
#' library(shiny)
#' # requires dplyr for dplyr::select
#' # basic example
#' shinyApp(
#'     ui = fluidPage(
#'         use_tailwind(),
#'         twVarSelectInput(
#'           "variable", "Variable to select:",
#'           mtcars,
#'           multiple = TRUE,
#'           # Apply tailwind classes
#'           container_class = "shadow-md rounded-md bg-gray-50 m-4 p-2 w-64",
#'           label_class = "font-serif",
#'           select_class = "font-mono font-bold text-red-800 rounded-md bg-stone-50"
#'         ),
#'         tableOutput("data")
#'     ),
#'     server = function(input, output) {
#'         output$data <- renderTable({
#'             dplyr::select(mtcars, !!!input$variable)
#'         }, rownames = TRUE)
#'     }
#' )
#' }
twVarSelectInput <- function(inputId, label, data, selected = NULL,
                             multiple = FALSE, selectize = TRUE, width = NULL,
                             container_class = NULL, label_class = NULL,
                             select_class = NULL) {

  # see the return value of ?varSelectInput
  select_class <- paste("symbol", select_class)

  ch <- names(data)
  if (is.null(ch)) ch <- colnames(data)
  if (is.null(ch))
    stop("Could not determine the column names of 'data'. Is it a named data.frame/matrix?")

  twSelectInput(
    inputId = inputId, label = label, choices = names(data), selected = selected,
    multiple = multiple, selectize = selectize, width = width,
    container_class = container_class, label_class = label_class,
    select_class = select_class
  )
}
