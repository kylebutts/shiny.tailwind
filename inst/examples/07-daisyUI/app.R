################################################################################
#' This app shows some basic UI elements using daisyUI
#'
#' Note that this app has no server component. As daisyUI works via classes,
#' the usage within a shiny app requires custom JS which can be created using
#' the shinyjs package (eg shinyjs::toggleClass())
#'
#' For a full list of components see: https://daisyui.com/components
################################################################################

library(shiny)
library(shiny.tailwind)

# small helper to create a pre.code tag.
# Note that shiny::tags$pre + shiny::tags$code create new lines which break the
# way the code will be displayed
code <- function(code, prefix = "$", class = NULL) {
  shiny::HTML(sprintf(
    '<pre data-prefix="%s"%s><code>%s</code></pre>',
    prefix,
    ifelse(!is.null(class),
           paste0(' class="', paste(class, collapse = " "), '"'),
           ""),
    code
  ))
}


ui <- div(
  class = "grid grid-cols-4 gap-4 p2",
  use_daisyui(),

  div(
    div("Breadcrumbs", class = "text-2xl font-bold"),
    div(
      class = "text-sm breadcrumbs",
      tags$ul(
        tags$li(tags$a("Home")),
        tags$li(tags$a("Documents")),
        tags$li(tags$a("Add Documents")),
      )
    )
  ),

  div(
    div("Steps", class = "text-2xl font-bold"),
    tags$ul(
      class = "steps",
      tags$li(class = "step step-primary", "Learn R"),
      tags$li(class = "step step-primary", "Make Shiny App"),
      tags$li(class = "step", "???"),
      tags$li(class = "step", "Profit!!!"),
    )
  ),

  div(
    div("Pagination", class = "text-2xl font-bold"),
    div(
      class = "btn-group",
      tags$button(class = "btn btn-md", 1),
      tags$button(class = "btn btn-md", 2),
      tags$button(class = "btn btn-md btn-active", 3),
      tags$button(class = "btn btn-md", 4),
    )
  ),

  div(
    class = "w-96",
    div("Code", class = "text-2xl font-bold"),
    div(
      class="mockup-code",
      # Note that tags$pre + tags$code introduces newlines which breaks the code
      code("R"),
      code("install.packages(\"shiny.tailwind\")", prefix = "R", class = "text-warning"),
      code("install_tailwindcss_ui()", prefix = "R", class = "text-success")
    )
  )
)

shinyApp(ui, function(input, output) {})
