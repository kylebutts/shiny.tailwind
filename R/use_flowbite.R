#' Allows you to use 'flowbite' components
#'
#' See also: <https://flowbite.com/> and <https://flowbite.com/#components>
#'
#' @param version the version of 'flowbite' to use, default is 3.1.2
#' @param ... further arguments passed to [use_tailwind()]
#'
#' @return the required HTML-head tags to use 'flowbite' as `shiny.tag`
#'
#' @export
use_flowbite <- function(version = "3.1.2", ...) {
  min_css <- sprintf(
    "https://cdn.jsdelivr.net/npm/flowbite@%s/dist/flowbite.min.css",
    version
  )
  js <- sprintf(
    "https://cdn.jsdelivr.net/npm/flowbite@%s/dist/flowbite.min.js",
    version
  )

  shiny::tagList(
    use_tailwind(...),
    shiny::tags$head(shiny::tags$link(rel = "stylesheet", href = min_css)),
    shiny::tags$script(src = js)
  )
}
