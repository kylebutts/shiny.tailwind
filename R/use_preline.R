#' Allows you to use 'preline' components
#'
#' See also: <https://preline.co/> and <https://preline.co/docs/index.html>
#'
#' @param version the version of 'preline' to use, default is 3.0.0
#' @param ... further arguments passed to [use_tailwind()]
#'
#' @return the required HTML-head tags to use 'preline' as `shiny.tag`
#'
#' @export
use_preline <- function(version = "3.0.0", ...) {
  js <- sprintf("https://cdn.jsdelivr.net/npm/preline@%s/preline.js", version)

  shiny::tagList(
    use_tailwind(...),
    shiny::tags$script(src = js)
  )
}
