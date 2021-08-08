#' TailwindCSS with Shiny
#'
#' @details
#'   TailwindCSS is a utility-based design framework that makes designing simple.
#'
#'   However, the complete set of tailwind css classes is massive (~15mb), so
#'   you don't want to load all of these. That is where Tailwind's new Just in
#'   Time compiling comes in. It will only load the css classes you use, as you
#'   use them. So if your shiny app renders ui dynamically, it will load whenever
#'   the UI is rendered.
#'
#'   This is all possible thanks to the company Beyond Code who created a browser
#'   version of Tailwind Just in Time. See
#'   \url{https://beyondco.de/blog/tailwind-jit-compiler-via-cdn}.
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
#'   only consist of the JSON object. The function will place it in the appropriate
#'   script tag.
#'
#'   If you want to use custom modules, for example TailwindTypography, note that
#'   you need to use the browser-version and you have to layout the config file in
#'   a specific way. You need to define the config JSON object as
#'   `window.tailwindConfig` and you must call `window.tailwindCSS.refresh();`.
#'   An example is in the folder
#'   `inst/examples/03-modules` in the github repository.
#'
#' @param css Optional. Path to ".css" file. Can use @apply tags from Tiny.
#' @param tailwindConfig Optional. Path to ".js" file containing json object
#'   `window.tailwindConfig`. Do not wrap in script lines.
#'   Pass special tailwind config, following
#'   \url{https://beyondco.de/blog/tailwind-jit-compiler-via-cdn}.
#' @param tailwindModule Optional. Path to ".js" file. You must define
#'   `window.tailwindConfig` in this script. Do not wrap in script lines.
#'   For an example of loading module, see
#'   \url{https://beyondco.de/blog/tailwind-jit-compiler-via-cdn}
#'
#' @export
use_tailwind = function(css = NULL, tailwindConfig = NULL, tailwindModule = NULL) {

	# Check files exists
	if(!is.null(css)) {
		for(i in seq_along(css)) {
			if(!file.exists(css[i])) {
				stop(glue::glue("File: {css[i]} doesn't exist"))
			}
		}
	}
	if(!is.null(tailwindConfig)) {
		if(!file.exists(tailwindConfig)) {
			stop(glue::glue("File: {tailwindConfig} doesn't exist"))
		}
	}
	if(!is.null(tailwindModule)) {
		if(!file.exists(tailwindModule)) {
			stop(glue::glue("File: {tailwindModule} doesn't exist"))
		}
	}

	# Initialize html elements
	html_cdn <- list(htmltools::HTML("<!-- Include CDN JavaScript -->\n<script src='https://unpkg.com/tailwindcss-jit-cdn'></script>"))

	html_css <- NULL
	html_config <- NULL
	html_module <- NULL

	# Prepare html elements
	if(!is.null(css)) {
		html_css <- lapply(css, function(x) {
			htmltools::HTML(
				paste0(
					"<style type='postcss'>\n\n",
					paste0(xfun::read_utf8(x), collapse = "\n"),
					"\n\n</style>",
					collapse = "\n"
				)
			)
		})
	}

	if(!is.null(tailwindConfig)) {
		html_config <- list(htmltools::HTML(
			paste0(
				"<!-- Specify a custom TailwindCSS configuration -->\n",
				"<script type='tailwind-config'>\n\n",
				paste0(xfun::read_utf8(tailwindConfig), collapse = "\n"),
				"\n\n</script>",
				collapse = "\n"
			)
		))
	}

	if(!is.null(tailwindModule)) {
		html_module <- list(
			htmltools::HTML(
				paste0(
					"<!-- Specify a custom TailwindCSS configuration -->\n",
					"<script type='module'>\n\n",
					paste0(xfun::read_utf8(tailwindModule), collapse = "\n"),
					"\n\n</script>"
				)
			),
			htmltools::HTML(
				"<script type='tailwind-config'>\nwindow.tailwindConfig\n</script>"
			)
		)
	}

	shiny::tagList(
		c(
			html_cdn,
			html_config,
			html_module,
			html_css
		)
	)

}
