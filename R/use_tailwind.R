#' TailwindCSS with Shiny
#'
#' @import htmltools
#'
#' @details
#'   TailwindCSS is a utility-based design framework that makes designing simple.
#'   See details in the README for this package for why this is so great.
#'
#'   However, the complete set of tailwind css classes is massive (~15mb), so
#'   you don't want to load all of these. That is where Tailwind's new Just in
#'   Time compiling comes in. It will only load the css classes you use, as you
#'   use them. So if your shiny app renders ui dynamically, it will load
#'   appropriate css whenever the UI is rendered.
#'
#'   Custom css can use the `@apply` directives that come with tailwind to easily
#'   compile set of classes. See
#'   \url{https://tailwindcss.com/docs/functions-and-directives#apply} for
#'   more details. It just *has* to be passed to the use_tailwind function if you
#'   want to use the `@apply` directive.
#'
#'   Custom configuration of tailwind is also possible. There are two options
#'   available in `use_tailwind`. First, if you don't want to use any custom
#'   modules, uses tailwindConfig. An example is in the folder
#'   `inst/examples/02-config` in the github repository. Note the `.js` file should
#'   only consist of the creation of the JSON object `tailwind.config = {}`.
#'   The function will place it in the appropriate script tag.
#'
#' @param css Optional. Path to ".css" file. Can use @apply tags for applying
#'   Tailwind classes. See description for more details.
#' @param tailwindConfig Optional. Path to ".js" file containing json object
#'   `tailwind.config = {}`. See
#'   \url{https://github.com/tailwindlabs/tailwindcss/releases/tag/v3.0.0-alpha.1}.
#'
#' @export
#' @examples
#' library(shiny)
#' example_apps <- list.files(system.file("examples", package = "shiny.tailwind"),
#'   full.names = TRUE
#' )
#' basename(example_apps)
#'
#' if(interactive()) runApp(example_apps[1])
use_tailwind <- function(css = NULL, tailwindConfig = NULL) {
  # Check files exists
  if(!is.null(css) && any(!file.exists(css))) {
    stop(sprintf(
      "File: %s doesn't exist.",
      paste(css[!file.exists(css)], collapse = ", ")
    ))
  }

  if(!is.null(tailwindConfig) && !file.exists(tailwindConfig)) {
    stop(sprintf("File: %s doesn't exist", tailwindConfig))
  }

  # https://tailwindcss.com/docs/installation/play-cdn
  url <- "https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,line-clamp"

  html_cdn <- list(htmltools::HTML(sprintf(
    "<!-- Include CDN JavaScript -->\n<script src='%s'></script>",
    url
  )))

  html_css <- NULL
  html_config <- NULL

  # Prepare html elements
  if(!is.null(css)) {
    html_css <- lapply(css, function(x) {
      htmltools::HTML(paste(
        "<style type='text/tailwindcss'>\n\n",
        paste(read_utf8_(x), collapse = "\n"),
        "\n\n</style>",
        collapse = "\n"
      ))
    })
  }

  if(!is.null(tailwindConfig)) {
    html_config <- list(htmltools::HTML(paste(
      "<!-- Specify a custom TailwindCSS configuration -->\n",
      "<script>\n\n",
      paste(read_utf8_(tailwindConfig), collapse = "\n"),
      "\n\n</script>",
      collapse = "\n"
    )))
  }

  shiny::tagList(c(
    html_cdn,
    html_config,
    html_css
  ))
}

# internal helper function to read utf8
read_utf8_ <- function(file) {
  r <- readLines(file, encoding = "UTF-8", warn = FALSE)
  if(!any(validUTF8(r))) {
    stop(sprintf("The file %s is not encoded in UTF 8.", file))
  }
  r
}
