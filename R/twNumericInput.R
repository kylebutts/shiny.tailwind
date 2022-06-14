#' Wrapper around [`shiny::numericInput()`] but allowing for more classes
#'
#' @inheritParams shiny::numericInput
#' @param type the type for the input, eg "text" (default), "password", "email",
#' "month", "url", ... see also [MDN Input Types](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Input#input_types])
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#' @param disabled if the user should not be able to interact with the field
#' @param label_after_input TRUE/FALSE if the label should be put after the
#' input box. Default is FALSE. Useful for special cases (floating labels),
#' c.f. 04-shiny-inputs example app.
#'
#' @seealso [shiny::numericInput()]
#'
#' @export
#' @examples
#' shiny::numericInput("number", "A Number", 42, min = 10, max = 100, step = 13, width = "200px")
#' twNumericInput("number", "A Number", 42, min = 10, max = 100, step = 13, width = "200px",
#'                container_class = "CONTAINER", label_class = "LABEL", input_class = "INPUT")
#'
#' if (interactive()) {
#' library(shiny)
#' # basic example
#' shinyApp(
#'   ui = fluidPage(
#'     use_tailwind(),
#'     twNumericInput(
#'       "number", "A Number", 123456,
#'       # Apply tailwind classes
#'       container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
#'       label_class = "font-mono text-gray-600",
#'       input_class = "drop-shadow-lg text-gray-600 font-mono rounded-md border-amber-400"
#'     ),
#'     verbatimTextOutput("value")
#'   ),
#'   server = function(input, output) {
#'     output$value <- renderText({ input$number })
#'   }
#' )
#' }
twNumericInput <- function(inputId, label, value,
                           min = NA, max = NA, step = NA, width = NULL,
                           placeholder = "",
                           disabled = FALSE, container_class = NULL,
                           label_class = NULL, input_class = NULL, label_after_input = FALSE) {

  container_class <- paste("form-group", container_class)
  input_class <- paste("form-control", input_class)
  label_class <- paste("form-label", label_class)

  width <- shiny::validateCssUnit(width)

  html_label <- shiny::tags$label(
    class = label_class, "for" = inputId,
    label
  )

  res <- shiny::div(
    class = container_class,
    style = if (!is.null(width)) paste0("width:", width) else NULL,
    if (!label_after_input) html_label,
    shiny::tags$input(
      type = "number",
      id = inputId,
      value = if (!is.null(value)) value else NULL,
      min = if (!is.null(min)) min else NULL,
      max = if (!is.null(max)) max else NULL,
      step = if (!is.null(step)) step else NULL,
      disabled = if (disabled) "" else NULL,
      placeholder = placeholder,
      class = input_class
    ),
    if (label_after_input) html_label
  )

  return(res)

}
