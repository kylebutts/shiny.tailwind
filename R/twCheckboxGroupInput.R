#' Wrapper around [`shiny::checkboxGroupInput()`] but allowing for more classes
#'
#' @inheritParams shiny::checkboxGroupInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#' @param main_label_class additional classes to be applied to the main label
#' @param inner_container_class additional classes to be applied to the container
#' for each option
#' @param disabled if the user should not be able to interact with the field
#' @seealso [shiny::checkboxGroupInput()]
#'
#' @export
#' @examples
#' shiny::checkboxGroupInput("id", "label", choices = c("A", "B"))
#' twCheckboxGroupInput("id", "label", choices = c("A", "B"),
#'                      width = "200px", disabled = c(TRUE, FALSE),
#'                      container_class = "OUTER.CONTAINER",
#'                      inner_container_class = c("INNER CONTAINER 1", "INNER CONTAINER 2"),
#'                      label_class = c("LABEL 1", "LABEL 2"),
#'                      input_class = "INPUT-ALL")
#'
#' if (interactive()) {
#' library(shiny)
#' # basic example
#' shinyApp(
#'   ui = fluidPage(
#'     use_tailwind(),
#'     twCheckboxGroupInput(
#'       "chks", "Check all that apply:",
#'       choices = c("I want this" = "a", "I want that" = "b", "None (disabled)" = "c"),
#'       disabled = c(FALSE, FALSE, TRUE),
#'       container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
#'       label_class = "font-serif text-gray-600",
#'       input_class = "rounded rounded-full text-pink-500 border-pink-200 focus:ring-pink-500",
#'     ),
#'     verbatimTextOutput("out")
#'   ),
#'   server = function(input, output) {
#'     output$out <- renderText({input$chks})
#'   }
#' )
#' }
twCheckboxGroupInput <- function(inputId, label, choices = NULL, selected = NULL,
                                 inline = FALSE, width = NULL,
                                 container_class = NULL, main_label_class = NULL,
                                 input_class = NULL, label_class = NULL,
                                 inner_container_class = NULL, disabled = FALSE) {

  container_class <- paste("form-group shiny-input-checkboxgroup shiny-input-container",
                           if (inline) "shiny-input-container-inline",
                           container_class)
  input_class <- paste("form-check-input", input_class)
  label_class <- paste("form-check-label", label_class)
  main_label_class <- paste("control-label", main_label_class)
  inner_container_class <- paste("checkbox", inner_container_class)

  width <- shiny::validateCssUnit(width)

  if (length(disabled) == 1) disabled <- rep(disabled, length(choices))
  if (length(input_class) == 1) input_class <- rep(input_class, length(choices))
  if (length(label_class) == 1) label_class <- rep(label_class, length(choices))
  if (length(inner_container_class) == 1)
    inner_container_class <- rep(inner_container_class, length(choices))

  if (length(disabled) != length(choices))
    stop("'disabled' has to be either length 1 or the same length as 'choices'")
  if (length(input_class) != length(choices))
    stop("'input_class' has to be either NULL, length 1, or the same length as 'choices'")
  if (length(label_class) != length(choices))
    stop("'label_class' has to be either NULL, length 1, or the same length as 'choices'")
  if (length(inner_container_class) != length(choices))
    stop("'inner_container_class' has to be either NULL, length 1, or the same length as 'choices'")

  label_id <- paste0(inputId, "-label")
  if (is.null(names(choices))) names(choices) <- choices
  nn <- names(choices)
  if (is.null(selected)) selected <- nn[[1]]

  shiny::div(
    id = inputId,
    role = "group",
    "aria-labelledby" = label_id,
    class = container_class,
    shiny::tags$label(
      class = main_label_class,
      id = label_id,
      "for" = inputId,
      label
    ),
    shiny::div(
      class = paste("shiny-options-group", if (inline) "flex flex-wrap"),
      lapply(seq_along(choices), function(i) {
        shiny::div(
          class = inner_container_class[[i]],
          shiny::tags$label(
            shiny::tags$input(
              class = input_class[[i]],
              type = "checkbox",
              name = inputId,
              value = choices[[i]],
              checked = if (choices[[i]] %in% selected) "checked" else NULL,
              disabled = if (disabled[[i]]) "" else NULL
            ),
            shiny::tags$span(
              class = label_class[[i]],
              names(choices)[[i]]
            )
          )
        )
      })
    )
  )
}
