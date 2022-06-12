#' Wrapper around [`shiny::selectInput()`] but allowing for more classes
#'
#' @inheritParams shiny::selectInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param select_class additional classes to be applied to the select elements
#'
#' @seealso [shiny::selectInput()]
#'
#' @export
#' @examples
#' shiny::selectInput("id", "label", c("A" = "a", "B" = "b", "C" = "c"),
#'                    selected = c("a", "b"), width = "200px",
#'                    multiple = TRUE)
#' twSelectInput("id", "label", c("A" = "a", "B" = "b", "C" = "c"),
#'               selected = c("a", "b"), width = "200px",
#'               multiple = TRUE, selectize = TRUE,
#'               container_class = "CONTAINER", label_class = "LABEL",
#'               select_class = "SELECT")
#'
#' if (interactive()) {
#' library(shiny)
#' # basic example
#' shinyApp(
#'   ui = fluidPage(
#'     use_tailwind(),
#'     twSelectInput(
#'       "variable", "Variable to select:",
#'       c("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear"),
#'       multiple = TRUE,
#'       # Apply tailwind classes
#'       container_class = "shadow-md rounded-md bg-gray-50 m-4 p-2 w-72",
#'       label_class = "font-serif",
#'       select_class = "font-mono font-bold text-red-800 rounded-md bg-stone-50"
#'     ),
#'     tableOutput("data")
#'   ),
#'   server = function(input, output) {
#'     output$data <- renderTable({
#'       mtcars[, c("mpg", input$variable), drop = FALSE]
#'     }, rownames = TRUE)
#'   }
#' )
#' }
twSelectInput <- function(inputId, label, choices, selected = NULL,
                          multiple = FALSE, selectize = TRUE, width = NULL, size = NULL,
                          container_class = NULL, label_class = NULL,
                          select_class = NULL) {

  if (selectize && !is.null(size))
    stop("'size' argument is incompatible with 'selectize=TRUE'.")

  container_class <- paste("block twSelectInput form-group", container_class)
  label_class <- paste("control-label", label_class)
  select_class <- paste("block form-control", select_class)

  width <- shiny::validateCssUnit(width)

  if (is.null(names(choices))) names(choices) <- choices
  nn <- names(choices)
  if (is.null(selected)) selected <- nn[[1]]

  label_id <- paste0(inputId, "-label")
  res <- shiny::div(
    class = container_class,
    style = if (!is.null(width)) paste0("width: ", width, ";") else NULL,
    size = if (!is.null(size)) size else NULL,
    shiny::tags$label(class = label_class,
                      id = label_id,
                      "for" = inputId,
                      label),
    shiny::div(
      shiny::tags$select(
        id = inputId,
        class = select_class,
        multiple = if (multiple) "multiple" else NULL,
        lapply(seq_along(choices), function(i) {
          choice <- choices[[i]]
          shiny::HTML(sprintf('<option value="%s"%s>%s</option>',
                              choice,
                              ifelse(choice %in% selected, " selected", ""),
                              nn[[i]]))
        })
      ),
      if (selectize) shiny::tags$script(type = "application/json",
                                        "data-for" = inputId,
                                        "data-nonempty" = "",
                                        '{"plugins":["selectize-plugin-a11y"]}')
    )
  )

  if (selectize)
    attr(res, "html_dependencies") <- attr(shiny::selectInput("a", "a", "a",
                                                              selectize = TRUE),
                                           "html_dependencies")
  res
}

