#' TailwindCSS with Shiny
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
#'   If you want to use custom modules, for example TailwindTypography, note that
#'   you need to use the browser-version and you have to layout the config file in
#'   a specific way. You need to define the config JSON object as
#'   `window.tailwindConfig` and you must call `window.tailwindCSS.refresh();`.
#'   An example is in the folder
#'   `inst/examples/03-modules` in the github repository. **N.B.** This only
#'   works for version 2. Version 3 will load all the "first-party" plugins:
#'   \url{https://github.com/tailwindlabs/tailwindcss/releases/tag/v3.0.0-alpha.1}.
#'
#'
#' @param css Optional. Path to ".css" file. Can use @apply tags for applying
#'   Tailwind classes. See description for more details.
#' @param tailwindConfig Optional. Path to ".js" file containing json object
#'   `tailwind.config = {}`. See
#'   \url{https://github.com/tailwindlabs/tailwindcss/releases/tag/v3.0.0-alpha.1}.
#' @param version Either 2/3. Which version of Tailwind to use. Default is 3.
#' @param tailwindModule Only for version 2. Path to ".js" file. You must define
#'   `window.tailwindConfig` in this script. Do not wrap in script lines.
#'   For an example of loading module, see
#'   \url{https://beyondco.de/blog/tailwind-jit-compiler-via-cdn}
#'
#' @export
#' @examples
#' if (interactive()) {
#' library(shiny)
#' list.files(system.file("examples", package = "shiny.tailwind"))
#' runApp(system.file("examples", "01-basic", package = "shiny.tailwind"))
#' }
use_tailwind <- function(css = NULL, tailwindConfig = NULL,
						 tailwindModule = NULL, version = c(3, 2)) {
	version <- match.arg(version)

	# Check files exists
	if (!is.null(css) && any(!file.exists(css)))
		stop(sprintf("File: %s doesn't exist.",
					 paste(css[!file.exists(css)], collapse = ", ")))

	if (!is.null(tailwindConfig) && !file.exists(tailwindConfig))
		stop(sprintf("File: %s doesn't exist", tailwindConfig))
	if (!is.null(tailwindModule) && !file.exists(tailwindModule))
		stop(sprintf("File: %s doesn't exist", tailwindModule))

	# Initialize html elements
	# CDN either version 2 or version 3
	if (version == 2) {
		url <- "https://unpkg.com/tailwindcss-jit-cdn"
	} else {
		url <- "https://cdn-tailwindcss.vercel.app/?plugins=forms,typography,aspect-ratio,line-clamp"
	}

	html_cdn <- list(htmltools::HTML(sprintf(
		"<!-- Include CDN JavaScript -->\n<script src='%s'></script>",
		url
	)))


	html_css <- NULL
	html_config <- NULL
	html_module <- NULL

	# Prepare html elements
	if (!is.null(css))
		html_css <- lapply(css, function(x) {
			htmltools::HTML(paste(
				sprintf("<style type='%s'>\n\n",
						if (version == 2) "postcss" else "text/tailwindcss"),
				paste(read_utf8_(x), collapse = "\n"),
				"\n\n</style>",
				collapse = "\n"
			))
		})

	if (!is.null(tailwindConfig))
		html_config <- list(htmltools::HTML(paste(
			"<!-- Specify a custom TailwindCSS configuration -->\n",
			sprintf("<script%s>\n\n",
					if (version == 2) " type='tailwind-config'" else ""),
			paste(read_utf8_(tailwindConfig), collapse = "\n"),
			"\n\n</script>",
			collapse = "\n"
		)))

	if (!is.null(tailwindModule))
		html_module <- lapply(list(
			paste(
				"<!-- Specify a custom TailwindCSS configuration -->\n",
				"<script type='module'>\n\n",
				paste(read_utf8_(tailwindModule), collapse = "\n"),
				"\n\n</script>"
			),
			"<script type='tailwind-config'>\nwindow.tailwindConfig\n</script>"
		), htmltools::HTML)

	shiny::tagList(c(
		html_cdn,
		html_config,
		html_module,
		html_css
	))
}

# internal helper function to read utf8
read_utf8_ <- function(file) {
	r <- readLines(file, encoding = 'UTF-8', warn = FALSE)
	if (!any(validUTF8(r))) stop(sprintf("The file %s is not encoded in UTF 8.", file))
	r
}
