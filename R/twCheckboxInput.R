#' Wrapper around [`shiny::checkboxInput()`] but allowing for more classes
#'
#' @inheritParams shiny::checkboxInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#' @param disabled if the user should not be able to interact with the field
#' @param center if a margin of 0px !important should be applied, effectively
#'  removing bootstrap styling (if applied) to center the checkbox easier
#' @seealso [shiny::checkboxInput()]
#'
#' @export
#' @examples
#' shiny::checkboxInput("id", "label", value = FALSE)
#' twCheckboxInput("id", "label", value = TRUE, width = "200px", disabled = TRUE,
#'                 container_class = "CONTAINER", label_class = "LABEL", input_class = "INPUT")
#'
#' # basic full shiny example
#' library(shiny)
#'
#' ui <- fluidPage(
#'   use_tailwind(),
#'   twCheckboxInput(
#'     "chk", "Check me!", value = TRUE,
#'     container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
#'     label_class = "font-serif text-gray-600",
#'     input_class = "text-pink-500 focus:ring-pink-500",
#'     center = TRUE
#'   ),
#'   verbatimTextOutput("out")
#' )
#'
#' server <- function(input, output) {
#'   output$out <- renderText({input$chk})
#' }
#'
#' if (interactive()) shinyApp(ui, server)
twCheckboxInput <- function(inputId, label, value = FALSE, width = NULL,
                            disabled = FALSE,
                            container_class = NULL, label_class = NULL,
                            input_class = NULL, center = FALSE) {

  container_class <- paste("form-check", container_class)
  input_class <- paste("form-check-input", input_class)
  label_class <- paste("form-check-label", label_class)

  width <- shiny::validateCssUnit(width)

  res <- shiny::div(
    class = container_class,
    style = if (!is.null(width)) paste0("width: ", width) else NULL,
    shiny::tags$input(
      type = "checkbox",
      id = inputId,
      style = if (center) "margin: 0px !important;" else NULL,
      checked = if (value) "" else NULL,
      disabled = if (disabled) "" else NULL,
      class = input_class
    ),
    shiny::tags$label(
      class = label_class, "for" = inputId,
      label
    )
  )

  return(res)
}
