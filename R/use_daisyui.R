#' Allows you to use 'daisyUI' elements
#'
#' See also: <https://daisyui.com/> and <https://daisyui.com/components/>
#'
#' Note that this uses the CDN version, which is not recommended for production
#' by 'daisyUI'.
#'
#' @param version the version of 'daisyUI' to use, default is 5.0.0
#' @param ... additional arguments passed to [use_tailwind()]
#'
#' @return the required HTML-head tags to use 'daisyUI' as `shiny.tag`
#' @export
#'
#' @examples
#' library(shiny)
#'
#' ui <- div(
#'   class = "h-full w-full",
#'   use_daisyui(),
#'   div(
#'     class = "text-sm breadcrumbs",
#'     tags$ul(
#'       tags$li(tags$a("Home")),
#'       tags$li(tags$a("Documents")),
#'       tags$li(tags$a("Add Documents"))
#'     )
#'   )
#' )
#' if(interactive()) shiny::shinyApp(ui, function(input, output) {})
use_daisyui <- function(version = "5.0.0", ...) {
  min_css <- sprintf(
    "https://cdn.jsdelivr.net/npm/daisyui@%s/daisyui.css",
    version
  )

  shiny::tagList(
    use_tailwind(...),
    shiny::tags$head(shiny::tags$link(rel = "stylesheet", href = min_css))
  )
}
