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
code_mockup <- function(code, prefix = "$", class = NULL) {
  shiny::HTML(sprintf(
    '<pre data-prefix="%s"%s><code>%s</code></pre>',
    prefix,
    ifelse(!is.null(class),
           paste0(' class="', paste(class, collapse = " "), '"'),
           ""),
    code
  ))
}

# title element similar to h1()
title <- function(txt) div(txt, class = "text-4xl font-bold mb-2")

# styled element for more info
see_also <- function(txt, url, class = "") {
  div(class = paste("text-gray-500", class),
      txt,
      a(href = url, url,
        target = "_blank",
        class = "text-blue-600 hover:underline decoration-blue-600")
  )
}


ui <- div(
  use_daisyui(),

  div(
    class = "p-2 mb-4",
    div("daisyUI Examples", class = "text-center text-6xl font-bold mb-2"),
    see_also("More information about daisyUI can be found here:",
             "https://daisyui.com/", class = "text-center text-xl")
  ),

  div(
    class = "max-w-4xl mx-auto grid grid-cols-2 gap-16 p-2",

    div(
      title("Breadcrumbs"),
      see_also("See also: ", "https://daisyui.com/components/breadcrumbs/",
               class = "mb-2"),

      div(
        class = "text-sm breadcrumbs",
        tags$ul(
          tags$li(icon("home"), a("Home", class = "ml-1")),
          tags$li(icon("folder"), a("Documents", class = "ml-1")),
          tags$li(icon("folder-plus"), a("Add Documents", class = "ml-1")),
        )
      )
    ),

    div(
      title("Steps"),
      see_also("See also: ", "https://daisyui.com/components/steps/",
               class = "mb-2"),

      tags$ul(
        class = "steps",
        tags$li(class = "step step-primary", "Learn R"),
        tags$li(class = "step step-primary", "Make Shiny App"),
        tags$li(class = "step", "???"),
        tags$li(class = "step", "Profit!!!"),
      )
    ),

    div(
      title("Pagination"),
      see_also("See also: ", "https://daisyui.com/components/pagination/",
               class = "mb-2"),
      div(
        class = "btn-group",
        tags$button(class = "btn btn-md", 1),
        tags$button(class = "btn btn-md", 2),
        tags$button(class = "btn btn-md btn-active", 3),
        tags$button(class = "btn btn-md", 4),
      )
    ),

    div(
      # class = "w-96",
      title("Code"),
      see_also("See also: ", "https://daisyui.com/components/code/"),

      div(
        class="mockup-code",
        # Note that tags$pre + tags$code introduces newlines which breaks the code
        code_mockup("R"),
        code_mockup("install.packages(\"shiny.tailwind\")", prefix = "R",
                    class = "text-warning"),
        code_mockup("install_tailwindcss_ui()", prefix = "R",
                    class = "text-success")
      )
    )
  )
)

shiny::shinyApp(ui, function(input, output) {})
