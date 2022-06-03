#' Wrapper around [`shiny::selectInput()`] but allowing for more classes
#'
#' Note selectize is turned off (for now)
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
#' if (interactive()) {
#' library(shiny)
#' # basic example
#' shinyApp(
#' 	ui = fluidPage(
#' 		use_tailwind(),
#' 		twSelectInput(
#' 		  "variable", "Variable:",
#' 		  c("Cylinders" = "cyl", "Transmission" = "am", "Gears" = "gear"),
#' 		  # Apply tailwind classes
#' 		  container_class = "rounded-tl-lg bg-teal-500 m-4 p-2",
#' 		  label_class = "font-serif",
#' 		  select_class = "drop-shadow-lg font-mono"
#' 		),
#' 		tableOutput("data")
#' 	),
#' 	server = function(input, output) {
#' 		output$data <- renderTable({
#' 			mtcars[, c("mpg", input$variable), drop = FALSE]
#' 		}, rownames = TRUE)
#' 	}
#' )
#' }
twSelectInput <- function(inputId,
						label = NULL, choices, selected = NULL, multiple = FALSE,
						container_class = NULL, label_class = NULL, select_class = NULL) {

	if (!is.null(select_class)) {
		select_class <- paste0("block form-control ", select_class, sep = " ")
	} else {
		select_class <- "block form-control"
	}

	if (!is.null(container_class)) {
		container_class <- paste0("block twSelectInput form-group ", container_class, sep = " ")
	} else {
		container_class <- "block twSelectInput form-group"
	}

	if (!is.null(label_class)) {
		label_class <- paste0("control-label ", label_class, sep = " ")
	} else {
		label_class <- "control-label"
	}

	if (!is.null(label)) {
		label_tag <- tags$label(
				class = label_class, id = paste0(inputId,"-label"),
				`for` = inputId, label
			)
	} else {
		label_tag <- NULL
	}


	# Extract options from select (IMO easier than rewriting)
	temp <- shiny::selectInput(inputId = inputId, label = NULL, choices = choices, selectize = FALSE)

	# remove everything before the first option
	opts <- gsub("^[\\s\\S]*?(?=<option)", "", toString(temp), perl = TRUE)
	# remove everything between options
	opts <- gsub("<\\/option>[\\S\\s]+?<option", "</option><option", opts, perl = TRUE)
	# remove everything after the last options
	opts <- gsub("<\\/option>[^(<option)]*$", "</option>", opts, perl = TRUE)

	options <- shiny::HTML(opts)

	tagList(
		tags$div(
			class = container_class,
			label_tag,
			tags$select(
				id = inputId,
				class = select_class,
				options
			)
		)
	)
}
