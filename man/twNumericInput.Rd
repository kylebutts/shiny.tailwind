% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/twNumericInput.R
\name{twNumericInput}
\alias{twNumericInput}
\title{Wrapper around \code{\link[shiny:numericInput]{shiny::numericInput()}} but allowing for more classes}
\usage{
twNumericInput(
  inputId,
  label,
  value,
  min = NA,
  max = NA,
  step = NA,
  width = NULL,
  placeholder = "",
  disabled = FALSE,
  container_class = NULL,
  label_class = NULL,
  input_class = NULL,
  label_after_input = FALSE
)
}
\arguments{
\item{inputId}{The \code{input} slot that will be used to access the value.}

\item{label}{Display label for the control, or \code{NULL} for no label.}

\item{value}{Initial value.}

\item{min}{Minimum allowed value}

\item{max}{Maximum allowed value}

\item{step}{Interval to use when stepping between min and max}

\item{width}{The width of the input, e.g. \code{'400px'}, or \code{'100\%'};
see \code{\link[shiny:validateCssUnit]{validateCssUnit()}}.}

\item{placeholder}{Placeholder text for numeric input. Disappears after input}

\item{disabled}{if the user should not be able to interact with the field}

\item{container_class}{additional classes to be applied to the container}

\item{label_class}{additional classes to be applied to the label}

\item{input_class}{additional classes to be applied to the input element}

\item{label_after_input}{TRUE/FALSE if the label should be put after the
input box. Default is FALSE. Useful for special cases (floating labels),
c.f. 04-shiny-inputs example app.}
}
\value{
a list with a \code{shiny.tag} class
}
\description{
Wrapper around \code{\link[shiny:numericInput]{shiny::numericInput()}} but allowing for more classes
}
\examples{
shiny::numericInput("number", "A Number", 42, min = 10, max = 100, step = 13, width = "200px")
twNumericInput("number", "A Number", 42,
  min = 10, max = 100, step = 13, width = "200px",
  container_class = "CONTAINER", label_class = "LABEL", input_class = "INPUT"
)

# basic full shiny example
library(shiny)

ui <- fluidPage(
  use_tailwind(),
  twNumericInput(
    "number", "A Number", 123456,
    # Apply tailwind classes
    container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
    label_class = "font-mono text-gray-600",
    input_class = "drop-shadow-lg text-gray-600 font-mono rounded-md border-amber-400"
  ),
  verbatimTextOutput("value")
)

server <- function(input, output) {
  output$value <- renderText({
    input$number
  })
}

if(interactive()) shiny::shinyApp(ui, server)
}
\seealso{
\code{\link[shiny:numericInput]{shiny::numericInput()}}
}
