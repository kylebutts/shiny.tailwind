% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/twSliderInput.R
\name{twSliderInput}
\alias{twSliderInput}
\title{Wrapper around \code{\link[shiny:sliderInput]{shiny::sliderInput()}} but allowing for more classes}
\usage{
twSliderInput(
  inputId,
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
  label_after_input = FALSE
)
}
\arguments{
\item{inputId}{The \code{input} slot that will be used to access the value.}

\item{label}{Display label for the control, or \code{NULL} for no label.}

\item{min, max}{The minimum and maximum values (inclusive) that can be
selected.}

\item{value}{The initial value of the slider, either a number, a date
(class Date), or a date-time (class POSIXt). A length one vector will
create a regular slider; a length two vector will create a double-ended
range slider. Must lie between \code{min} and \code{max}.}

\item{step}{Specifies the interval between each selectable value on the
slider. Either \code{NULL}, the default, which uses a heuristic to determine the
step size or a single number. If the values are dates, \code{step} is in days;
if the values are date-times, \code{step} is in seconds.}

\item{round}{\code{TRUE} to round all values to the nearest integer;
\code{FALSE} if no rounding is desired; or an integer to round to that
number of digits (for example, 1 will round to the nearest 10, and -2 will
round to the nearest .01). Any rounding will be applied after snapping to
the nearest step.}

\item{ticks}{\code{FALSE} to hide tick marks, \code{TRUE} to show them
according to some simple heuristics.}

\item{animate}{\code{TRUE} to show simple animation controls with default
settings; \code{FALSE} not to; or a custom settings list, such as those
created using \code{\link[shiny:animationOptions]{animationOptions()}}.}

\item{width}{The width of the input, e.g. \code{'400px'}, or \code{'100\%'};
see \code{\link[shiny:validateCssUnit]{validateCssUnit()}}.}

\item{sep}{Separator between thousands places in numbers.}

\item{pre}{A prefix string to put in front of the value.}

\item{post}{A suffix string to put after the value.}

\item{timeFormat}{Only used if the values are Date or POSIXt objects. A time
format string, to be passed to the Javascript strftime library. See
\url{https://github.com/samsonjs/strftime} for more details. The allowed
format specifications are very similar, but not identical, to those for R's
\code{\link[base:strptime]{base::strftime()}} function. For Dates, the default is \code{"\%F"}
(like \code{"2015-07-01"}), and for POSIXt, the default is \code{"\%F \%T"}
(like \code{"2015-07-01 15:32:10"}).}

\item{timezone}{Only used if the values are POSIXt objects. A string
specifying the time zone offset for the displayed times, in the format
\code{"+HHMM"} or \code{"-HHMM"}. If \code{NULL} (the default), times will
be displayed in the browser's time zone. The value \code{"+0000"} will
result in UTC time.}

\item{dragRange}{This option is used only if it is a range slider (with two
values). If \code{TRUE} (the default), the range can be dragged. In other
words, the min and max can be dragged together. If \code{FALSE}, the range
cannot be dragged.}

\item{container_class}{additional classes to be applied to the container}

\item{label_class}{additional classes to be applied to the label}

\item{input_class}{additional classes to be applied to the input element}

\item{label_after_input}{TRUE/FALSE if the label should be put after the
input box. Default is FALSE. Useful for special cases (floating labels),
c.f. 05-apply-directive example app.}
}
\value{
a list with a \code{shiny.tag} class
}
\description{
Note that the colors for the slider bar can be customized by overriding the
\code{irs} class. c.f. 05-apply-directive example app
}
\examples{
shiny::sliderInput("values", "A Range", min = 0, max = 100, value = 75)
twSliderInput("values", "A Range",
  min = 0, max = 100, value = 75,
  container_class = "CONTAINER", label_class = "LABEL",
  input_class = "INPUT"
)

# basic full shiny example
library(shiny)

ui <- fluidPage(
  use_tailwind(),
  twSliderInput(
    "values", "A Range",
    min = 0, max = 100, value = 75,
    # Apply tailwind classes
    container_class = "w-48 m-4 p-2 border border-gray-200 rounded-md drop-shadow-md",
    label_class = "font-mono text-gray-600",
    input_class = "drop-shadow-lg text-gray-600 font-mono rounded-md border-amber-400"
  ),
  verbatimTextOutput("value")
)

server <- function(input, output) {
  output$value <- renderText({
    as.character(input$date)
  })
}

if(interactive()) shiny::shinyApp(ui, server)
}
\seealso{
\code{\link[shiny:sliderInput]{shiny::sliderInput()}}
}
