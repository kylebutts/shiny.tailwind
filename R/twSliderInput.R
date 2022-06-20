#' Wrapper around [`shiny::sliderInput()`] but allowing for more classes
#'
#' Note that the colors for the slider bar can be customized by overriding the
#' `irs` class. c.f. 05-apply-directive example app
#'
#' @inheritParams shiny::sliderInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#' @param label_after_input TRUE/FALSE if the label should be put after the
#' input box. Default is FALSE. Useful for special cases (floating labels),
#' c.f. 05-apply-directive example app.
#'
#' @seealso [shiny::sliderInput()]
#'
#' @export
#' @examples
#' shiny::sliderInput("values", "A Range", min = 0, max = 100, value = 75)
#' twSliderInput("values", "A Range", min = 0, max = 100, value = 75,
#'               container_class = "CONTAINER", label_class = "LABEL",
#'               input_class = "INPUT")
#'
#' # basic full shiny example
#' library(shiny)
#'
#' ui <- fluidPage(
#'   use_tailwind(),
#'   twSliderInput(
#'     "values", "A Range", min = 0, max = 100, value = 75,
#'     # Apply tailwind classes
#'     container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
#'     label_class = "font-mono text-gray-600",
#'     input_class = "drop-shadow-lg text-gray-600 font-mono rounded-md border-amber-400"
#'   ),
#'   verbatimTextOutput("value")
#' )
#'
#' server <- function(input, output) {
#'   output$value <- renderText({ as.character(input$date) })
#' }
#'
#' if (interactive()) shinyApp(ui, server)
twSliderInput <- function(inputId,
                          label,
                          min,
                          max,
                          value,
                          step = NULL,
                          round = FALSE,
                          ticks = TRUE,
                          animate = FALSE,
                          width = NULL,
                          sep = ",",
                          pre = NULL,
                          post = NULL,
                          timeFormat = NULL,
                          timezone = NULL,
                          dragRange = TRUE,
                          container_class = NULL,
                          label_class = NULL,
                          input_class = NULL,
                          label_after_input = FALSE) {

  res <- shiny::sliderInput(
    inputId = inputId,
    label = label,
    min = min,
    max = max,
    value = value,
    step = step,
    round = round,
    ticks = ticks,
    animate = animate,
    width = width,
    sep = sep,
    pre = pre,
    post = post,
    timeFormat = timeFormat,
    timezone = timezone,
    dragRange = dragRange
  )

  res$attribs$class <- paste(res$attribs$class, container_class)
  res$children[[1]]$attribs$class <- paste(res$children[[1]]$attribs$class, label_class)
  res$children[[2]]$attribs$class <- paste(res$children[[2]]$attribs$class, input_class)

  if (label_after_input) {
    tmp <- res$children[[1]]
    res$children[[1]] <- res$children[[2]]
    res$children[[2]] <- tmp
  }

  res
}
