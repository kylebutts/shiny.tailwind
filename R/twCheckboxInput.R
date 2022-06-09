#' Wrapper around [`shiny::checkboxInput()`] but allowing for more classes
#'
#' @inheritParams shiny::checkboxInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input elements
#' @param disabled if the user should not be able to interact with the field
#'
#' @seealso [shiny::checkboxInput()]
#'
#' @export
#' @examples
#' shiny::checkboxInput("id", "label", value = FALSE)
#' twCheckboxInput("id", "label", value = TRUE,
#'                 container_class = "CONTAINER", label_class = "LABEL",
#'                 input_class = "INPUT")
#'
#' if (interactive()) {
#' library(shiny)
#' # basic example
#' shinyApp(
#'     ui = fluidPage(
#'         use_tailwind(),
#'         twCheckboxInput(
#'           "chk", "Check me!", value = TRUE,
#'           container_class = "runded-tl-lg bg-gray-200 m-4 p-2",
#'           label_class = "font-serif text-red-500",
#'           input_class = "checked:focus:bg-red-200 hover:bg-red-500 bg-red-200"
#'         ),
#'         verbatimTextOutput("out")
#'     ),
#'     server = function(input, output) {
#'         output$out <- renderText({input$chk})
#'     }
#' )
#' }
twCheckboxInput <- function(inputId, label = NULL, value = FALSE, width = NULL,
                            disabled = FALSE,
                            container_class = NULL, label_class = NULL,
                            input_class = NULL) {

  container_class <- paste("form-check", container_class)
  input_class <- paste("form-check-input", input_class)
  label_class <- paste("form-check-label", label_class)

  res <- shiny::div(
    class = container_class,
    style = if (!is.null(width)) paste0("width:", width) else NULL,
    shiny::tags$input(
      type = "checkbox",
      id = inputId,
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