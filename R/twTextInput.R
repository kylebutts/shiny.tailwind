#' Wrapper around [`shiny::textInput()`] but allowing for more classes

#' @inheritParams shiny::textInput
#' @param type the type for the input, eg "text" (default), "password", "email",
#' "month", "url", ... see also [MDN Input Types](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Input#input_types])
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#'
#' @seealso [shiny::textInput()]
#'
#' @export
#' @examples
#' shiny::textInput("id", "Label", value = "The value", width = "200px", placeholder = "Placeholder")
#' twTextInput("id", "Label", value = "The value", width = "200px", placeholder = "Placeholder",
#'             type = "email", container_class = "CONTAINER", label_class = "LABEL", input_class = "INPUT")
#'
#' if (interactive()) {
#' library(shiny)
#' # basic example
#' shinyApp(
#'     ui = fluidPage(
#'         use_tailwind(),
#'         twTextInput(
#'           "caption", "Caption", "Data Summary",
#'           # Apply tailwind classes
#'           container_class = "rounded-tl-lg bg-teal-500 m-4 p-2",
#'           label_class = "font-serif",
#'           input_class = "drop-shadow-lg font-mono"
#'         ),
#'         verbatimTextOutput("value")
#'     ),
#'     server = function(input, output) {
#'         output$value <- renderText({ input$caption })
#'     }
#' )
#' }
twTextInput <- function(inputId, label = NULL, value = NULL, placeholder = NULL, width = NULL,
                        type = "text",
                        container_class = NULL, label_class = NULL, input_class = NULL) {
    input_class <- paste("block form-control", input_class)
    container_class <- paste("block twTextInput form-group", container_class)
    label_class <- paste("control-label", label_class)

    label_tag <- NULL

    if (!is.null(label))
        label_tag <- shiny::tags$label(class = label_class,
        							   id = paste0(inputId, "-label"),
                                       `for` = inputId, label)

    shiny::tagList(
        shiny::tags$div(
            class = container_class,
            style = if (!is.null(width)) paste0("width:", width, ";") else NULL,
            label_tag,
            shiny::tags$input(
                id = inputId,
                class = input_class, type = type,
                value = value,
                placeholder = placeholder
            )
        )
    )
}
