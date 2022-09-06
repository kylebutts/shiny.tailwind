#' Wrapper around [`shiny::textAreaInput()`] but allowing for more classes

#' @inheritParams shiny::textAreaInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#' @param label_after_input TRUE/FALSE if the label should be put after the
#' input box. Default is FALSE. Useful for special cases (floating labels),
#' c.f. 04-shiny-inputs example app.
#'
#' @seealso [shiny::textAreaInput()]
#'
#' @return a HTML element
#' 
#' @export
#' @examples
#' shiny::textAreaInput("id", "Label",
#'   value = "The value", width = "200px",
#'   placeholder = "Placeholder"
#' )
#' twTextAreaInput("id", "Label",
#'   value = "The value", width = "200px",
#'   height = "200px", placeholder = "Placeholder",
#'   container_class = "CONTAINER", label_class = "LABEL", input_class = "INPUT"
#' )
#'
#' # basic full shiny example
#' library(shiny)
#'
#' ui <- fluidPage(
#'   use_tailwind(),
#'   twTextAreaInput(
#'     "text", "A Text",
#'     placeholder = "Here goes a placeholder",
#'     width = "400px", height = "400px",
#'     # Apply tailwind classes
#'     container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
#'     label_class = "font-serif text-gray-600",
#'     input_class = "drop-shadow-lg font-mono text-gray-600 rounded-md border-amber-400"
#'   ),
#'   verbatimTextOutput("value")
#' )
#'
#' server <- function(input, output) {
#'   output$value <- renderText(input$text)
#' }
#'
#' if(interactive()) shiny::shinyApp(ui_basic, server)
twTextAreaInput <- function(inputId, label, value = "", placeholder = NULL, width = NULL, height = NULL,
                            rows = NULL, cols = NULL, resize = NULL,
                            container_class = NULL, label_class = NULL,
                            input_class = NULL,
                            label_after_input = FALSE) {
  input_class <- paste("form-control", input_class)
  container_class <- paste("twTextInput form-group", container_class)
  label_class <- paste("control-label", label_class)

  width <- shiny::validateCssUnit(width)
  height <- shiny::validateCssUnit(height)

  if(is.null(resize)) resize <- "both"
  allowed_resize <- c("both", "none", "vertical", "horizontal")
  if(!resize %in% allowed_resize) {
    stop("'resize' should be one of '", paste(allowed_resize, collapse = "', '"), "'")
  }

  if(!is.null(label)) {
    label_tag <- shiny::tags$label(
      class = label_class,
      id = paste0(inputId, "-label"),
      `for` = inputId, label
    )
  }

  st <- paste0("resize: ", resize, ";")
  if(!is.null(width)) st <- paste0("width:", width, ";")
  if(!is.null(height)) st <- paste0(st, paste0("height:", height, ";"))

  html_label <- shiny::tags$label(
    class = label_class,
    id = paste0(inputId, "-label"),
    "for" = inputId,
    label
  )

  shiny::div(
    class = container_class,
    # NOTE, no height here! only in textarea
    style = if(!is.null(width)) paste0("width:", width, ";") else NULL,
    if(!label_after_input) html_label,
    shiny::tags$textarea(
      id = inputId,
      class = input_class,
      placeholder = placeholder,
      style = st,
      rows = rows,
      cols = cols,
      value
    ),
    if(label_after_input) html_label
  )
}
