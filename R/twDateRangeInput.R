#' Wrapper around [`shiny::dateRangeInput()`] but allowing for more classes
#'
#' @inheritParams shiny::dateRangeInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param input_class additional classes to be applied to the input element
#' @param sep_class additional classes to be applied to the separator element
#' @param label_after_input TRUE/FALSE if the label should be put after the
#' input box. Default is FALSE. Useful for special cases (floating labels),
#' c.f. 04-shiny-inputs example app.
#'
#' @seealso [shiny::dateRangeInput()]
#'
#' @return a HTML element
#' 
#' @export
#' @examples
#' shiny::dateRangeInput("date", "A Date")
#' twDateRangeInput(
#'   "date", "A Date Range",
#'   container_class = "CONTAINER", label_class = "LABEL",
#'   input_class = "INPUT", sep_class = "SEP"
#' )
#'
#' # basic full shiny example
#' library(shiny)
#'
#' ui <- fluidPage(
#'   use_tailwind(),
#'   twDateRangeInput(
#'     "date", "A Date",
#'     # Apply tailwind classes
#'     container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
#'     label_class = "font-mono text-gray-600",
#'     input_class = "drop-shadow-lg text-gray-600 font-mono rounded-md border-amber-400",
#'     sep_class = "bg-amber-600 text-white font-bold font-mono"
#'   ),
#'   verbatimTextOutput("value")
#' )
#'
#' server <- function(input, output) {
#'   output$value <- renderText({
#'     as.character(input$date)
#'   })
#' }
#'
#' if(interactive()) shiny::shinyApp(ui, server)
twDateRangeInput <- function(inputId,
                             label,
                             start = NULL,
                             end = NULL,
                             min = NULL,
                             max = NULL,
                             format = "yyyy-mm-dd",
                             startview = "month",
                             weekstart = 0,
                             language = "en",
                             separator = " to ",
                             width = NULL,
                             autoclose = TRUE,
                             container_class = NULL,
                             label_class = NULL,
                             input_class = NULL,
                             sep_class = NULL,
                             label_after_input = FALSE) {
  res <- shiny::dateRangeInput(
    inputId = inputId,
    label = label,
    start = start,
    end = end,
    min = min,
    max = max,
    format = format,
    startview = startview,
    weekstart = weekstart,
    language = language,
    separator = separator,
    width = width,
    autoclose = autoclose
  )

  res$attribs$class <- paste(res$attribs$class, container_class)
  res$children[[1]]$attribs$class <- paste(res$children[[1]]$attribs$class, label_class)

  res$children[[2]]$children[[1]]$attribs$class <- paste(
    res$children[[2]]$children[[1]]$attribs$class,
    input_class
  )
  res$children[[2]]$children[[2]]$attribs$class <- paste(
    res$children[[2]]$children[[2]]$attribs$class,
    sep_class
  )
  res$children[[2]]$children[[3]]$attribs$class <- paste(
    res$children[[2]]$children[[3]]$attribs$class,
    input_class
  )

  if(label_after_input) {
    tmp <- res$children[[1]]
    res$children[[1]] <- res$children[[2]]
    res$children[[2]] <- tmp
  }

  res
}
