#' Wrapper around [`shiny::fileInput()`] but allowing for more classes
#'
#' @inheritParams shiny::fileInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param select_class additional classes to be applied to the select elements
#' @param button_class additional classes to be applied to the upload button
#' @param progress_class additional classes to be applied to the progress bar (ie color)
#'
#' @seealso [shiny::fileInput()]
#'
#' @return a HTML element
#' 
#' @export
#' @examples
#' shiny::fileInput("id", "label",
#'   multiple = TRUE, accept = c(".csv", ".rds"),
#'   width = "200px", buttonLabel = "Upload", placeholder = "Here"
#' )
#' twFileInput("id", "label",
#'   multiple = TRUE, accept = c(".csv", ".rds"),
#'   width = "200px", buttonLabel = "Upload", placeholder = "Here",
#'   container_class = "CONTAINER", label_class = "LABEL",
#'   select_class = "SELECT"
#' )
#'
#' # basic full shiny example
#' library(shiny)
#' ui <- fluidPage(
#'   use_tailwind(),
#'   twFileInput(
#'     inputId = "file", label = "Upload", multiple = TRUE,
#'     buttonLabel = "Upload", placeholder = "Nothing selected",
#'     container_class = "shadow-md rounded-md bg-gray-50 m-2 p-2 w-96",
#'     label_class = "font-serif text-red-800",
#'     select_class = "font-mono font-bold text-red-800 rounded-r-lg",
#'     button_class = paste(
#'       "bg-red-800 border-red-800 hover:bg-red-700",
#'       "hover:border-red-700 text-white hover:text-gray-50"
#'     ),
#'     progress_class = "bg-red-800"
#'   ),
#'   verbatimTextOutput("data")
#' )
#'
#' server <- function(input, output) {
#'   output$data <- renderText({
#'     paste(capture.output(str(input$file)), collapse = "\n")
#'   })
#' }
#'
#' if(interactive()) shiny::shinyApp(ui, server)
twFileInput <- function(inputId, label, multiple = FALSE, accept = NULL,
                        width = NULL, buttonLabel = "Browse...",
                        placeholder = "No file selected",
                        container_class = NULL, label_class = NULL,
                        select_class = NULL, button_class = NULL,
                        progress_class = NULL) {
  container_class <- paste("twFileInput form-group", container_class)
  label_class <- paste("control-label", label_class)
  select_class <- paste("form-control", select_class)
  button_class <- paste("btn btn-default btn-file", button_class)
  progress_class <- paste("progress-bar", progress_class)

  width <- shiny::validateCssUnit(width)

  label_id <- paste0(inputId, "-label")

  shiny::div(
    style = if(!is.null(width)) paste0("width:", width, ";") else NULL,
    class = container_class,
    shiny::tags$label(
      id = label_id,
      "for" = inputId,
      class = label_class,
      label
    ),
    shiny::div(
      class = "input-group",
      shiny::tags$label(
        class = "input-group-btn btn-file",
        shiny::tags$span(
          class = button_class,
          buttonLabel,
          shiny::tags$input(
            id = inputId,
            name = inputId,
            type = "file",
            style = "position: absolute !important; top: -99999px !important; left: -99999px !important;",
            multiple = if(multiple) "multiple" else NULL,
            accept = if(length(accept) > 0) paste(accept, collapse = ",") else NULL
          )
        )
      ),
      shiny::tags$input(
        type = "text",
        placeholder = placeholder,
        readonly = "readonly",
        class = select_class
      )
    ),
    shiny::div(
      id = paste0(inputId, "_progress"),
      class = "progress active shiny-file-input-progress",
      shiny::div(class = progress_class)
    )
  )
}
