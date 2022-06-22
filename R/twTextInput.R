#' Wrapper around [`shiny::textInput()`] but allowing for more classes
#'
#' @inheritParams shiny::textInput
#' @param type the type for the input, eg "text" (default), "password", "email",
#' "month", "url", ... see also [MDN Input Types](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Input#input_types])
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#' @param label_after_input TRUE/FALSE if the label should be put after the
#' input box. Default is FALSE. Useful for special cases (floating labels),
#' c.f. 04-shiny-inputs example app.
#'
#' @seealso [shiny::textInput()]
#'
#' @export
#' @examples
#' shiny::textInput(
#'   "id", "Label", value = "The value", width = "200px",
#'   placeholder = "Placeholder"
#' )
#' twTextInput(
#'   "id", "Label", value = "The value", width = "200px",
#'   placeholder = "Placeholder", type = "email",
#'   container_class = "CONTAINER", label_class = "LABEL",
#'   input_class = "INPUT"
#' )
#'
#' # basic full shiny example
#' library(shiny)
#' # basic example
#' ui <- fluidPage(
#'     use_tailwind(),
#'     div(
#'       class = "flex flex-wrap",
#'       twTextInput(
#'         "text", "A Text", type = "text", placeholder = "Some Text",
#'         # Apply tailwind classes
#'         container_class = paste("w-48 m-4 p-2 border border-gray-200",
#'           "rounded-md drop-shadow-md"),
#'         label_class = "font-serif text-gray-600",
#'         input_class = paste("drop-shadow-lg font-mono text-gray-600",
#'           "rounded-md border-amber-400")
#'       ),
#'       twTextInput(
#'         "email", "An Email", type = "email",
#'         placeholder = "me@example.com",
#'         # Apply tailwind classes
#'         container_class = paste("w-48 m-4 p-2 border border-gray-200",
#'         "rounded-md drop-shadow-md"),
#'         label_class = "font-serif text-gray-600",
#'         input_class = paste("drop-shadow-lg font-mono text-gray-600",
#'         "rounded-md border-amber-400")
#'       ),
#'       twTextInput(
#'         "pw", "A Password", type = "password",
#'         placeholder = "dont let it be password",
#'         # Apply tailwind classes
#'         container_class = paste("w-48 m-4 p-2 border border-gray-200",
#'         "rounded-md drop-shadow-md"),
#'         label_class = "font-serif text-gray-600",
#'         input_class = paste("drop-shadow-lg font-mono text-gray-600",
#'         "rounded-md border-amber-400")
#'       )
#'     ),
#'     twTextInput(
#'       "pw", "A Password", type = "password", placeholder = "dont let it be password",
#'       # Apply tailwind classes
#'       container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
#'       label_class = "font-serif text-gray-600",
#'       input_class = "drop-shadow-lg font-mono text-gray-600 rounded-md border-amber-400"
#'     )
#'   ),
#'   verbatimTextOutput("value")
#' )
#'
#' server <- function(input, output) {
#'   output$value <- renderText({
#'     paste(capture.output(str(list(
#'       text = input$text,
#'       email = input$email,
#'       pw = input$pw
#'     ))), collapse = "\n")
#'   })
#' }
#'
#' if (interactive()) shiny::shinyApp(ui, server)
#'
twTextInput <- function(inputId, label = NULL, value = NULL, placeholder = NULL,
                        width = NULL, type = "text",
                        container_class = NULL, label_class = NULL,
                        input_class = NULL, label_after_input = FALSE) {
  input_class <- paste("block form-control", input_class)
  container_class <- paste("block twTextInput form-group", container_class)
  label_class <- paste("control-label", label_class)

  width <- shiny::validateCssUnit(width)

  label_tag <- NULL

  if (!is.null(label))
    label_tag <- shiny::tags$label(
      class = label_class,
      id = paste0(inputId, "-label"),
      `for` = inputId,
      label
    )

  shiny::tagList(
    shiny::tags$div(
      class = container_class,
      style = if (!is.null(width)) paste0("width:", width, ";") else NULL,
      if (!label_after_input) label_tag,
      shiny::tags$input(
        id = inputId,
        type = type,
        value = value,
        placeholder = placeholder,
        class = input_class
      ),
      if (label_after_input) label_tag,
    )
  )
}
