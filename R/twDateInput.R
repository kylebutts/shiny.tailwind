#' Wrapper around [`shiny::dateInput()`] but allowing for more classes
#'
#' @inheritParams shiny::dateInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#' @param label_after_input TRUE/FALSE if the label should be put after the
#' input box. Default is FALSE. Useful for special cases (floating labels),
#' c.f. 04-shiny-inputs example app.
#'
#' @seealso [shiny::dateInput()]
#'
#' @export
#' @examples
#' shiny::dateInput("date", "A Date")
#' twDateInput("date", "A Date",
#'             container_class = "CONTAINER", label_class = "LABEL", input_class = "INPUT")
#'
#' if (interactive()) {
#' library(shiny)
#' # basic example
#' shinyApp(
#'   ui = fluidPage(
#'     use_tailwind(),
#'     twDateInput(
#'       "date", "A Date",
#'       # Apply tailwind classes
#'       container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
#'       label_class = "font-mono text-gray-600",
#'       input_class = "drop-shadow-lg text-gray-600 font-mono rounded-md border-amber-400"
#'     ),
#'     verbatimTextOutput("value")
#'   ),
#'   server = function(input, output) {
#'     output$value <- renderText({ as.character(input$date) })
#'   }
#' )
#' }
twDateInput <- function(inputId,
                        label,
                        value = NULL,
                        min = NULL,
                        max = NULL,
                        format = "yyyy-mm-dd",
                        startview = "month",
                        weekstart = 0,
                        language = "en",
                        width = NULL,
                        autoclose = TRUE,
                        datesdisabled = NULL,
                        daysofweekdisabled = NULL,
                        container_class = NULL,
                        label_class = NULL,
                        input_class = NULL,
                        label_after_input = FALSE) {

  res <- shiny::dateInput(
    inputId = inputId,
    label = label,
    value = value,
    min = min,
    max = max,
    format = format,
    startview = startview,
    weekstart = weekstart,
    language = language,
    width = width,
    autoclose = autoclose,
    datesdisabled = datesdisabled,
    daysofweekdisabled = daysofweekdisabled
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
