#' Wrapper around [`shiny::textInput()`] but allowing for more classes

#' @inheritParams shiny::textInput
#' @param container_class additional classes to be applied to the container
#' @param label_class additional classes to be applied to the label
#' @param select_class additional classes to be applied to the select elements
#'
#' @seealso [shiny::textInput()]
#'
#' @export
#' @examples
#' if (interactive()) {
#' library(shiny)
#' # basic example
#' shinyApp(
#' 	ui = fluidPage(
#' 		use_tailwind(),
#' 		twTextInput(
#' 		  "caption", "Caption", "Data Summary",
#' 		  # Apply tailwind classes
#' 		  container_class = "rounded-tl-lg bg-teal-500 m-4 p-2",
#' 		  label_class = "font-serif",
#' 		  input_class = "drop-shadow-lg font-mono"
#' 		),
#' 		verbatimTextOutput("value")
#' 	),
#' 	server = function(input, output) {
#' 		output$value <- renderText({ input$caption })
#' 	}
#' )
#' }
twTextInput <- function(inputId,
						label = NULL, value = NULL, placeholder = NULL,
						type = "text",
						container_class = NULL, label_class = NULL, input_class = NULL) {
	if (!is.null(input_class)) {
		input_class <- paste0("block form-control ", input_class, sep = " ")
	} else {
		input_class <- "block form-control"
	}

	if (!is.null(container_class)) {
		container_class <- paste0("block twTextInput form-group ", container_class, sep = " ")
	} else {
		container_class <- "block twTextInput form-group"
	}

	if (!is.null(label_class)) {
		label_class <- paste0("control-label ", label_class, sep = " ")
	} else {
		label_class <- "control-label"
	}
	label_id <- paste0(inputId, "label")

	if (!is.null(label)) {
		label_tag <- tags$label(class = label_class, id = inputId, `for` = inputId, label)
	} else {
		label_tag <- NULL
	}

	tagList(
		tags$div(
			class = container_class,
			label_tag,
			tags$input(
				id = inputId,
				class = input_class, type = type,
				value = value,
				placeholder = placeholder
			)
		)
	)
}
