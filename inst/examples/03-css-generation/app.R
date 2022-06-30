################################################################################
#' This example app shows how the TailwindCSS CLI can be used
#'
#' The basic idea of the CLI is that the CSS classes are not fetched live from a
#' CDN (an online source) and thus has a dependency on another online source.
#' Instead the CLI looks at the code, extracts TailwindCSS classes that are used
#' and compiles them to a local file, thus removing the online dependency.
#'
#' This requires the CLI (~35MB) to be installed locally, see also
#' ?install_tailwindcss_cli. Note this needs to be done only once
#'
#' See also: ?compile_tailwindcss, ?install_tailwindcss_cli and
#' https://tailwindcss.com/blog/standalone-cli
#'
################################################################################

library(shiny)
library(shiny.tailwind)

# 1) Install tailwindcss if needed ----
if(!is_tailwindcss_installed()) {
  install_tailwindcss_cli()
  if(Sys.info()[["sysname"]] != "Windows")
    system("chmod +x tailwindcss")
}


# 3) Define UI for the shiny app, including the compiled Tailwind CSS ----
ui <- div(
  class = "page-div",
  # 2) Compile the used Tailwind CSS rules to a specific CSS file ----
  # This makes the CSS rules available for offline use
  # css goes into "www/" folder in shiny apps
  # Runs each refresh
  compile_tailwindcss(
    infile = "custom.css", outfile = "www/tailwind-out.css",
    verbose = TRUE
  ),
  # Adds the compiled CSS files to the app
  tags$head(
    tags$link(
      rel = "stylesheet", type = "text/css",
      href = "tailwind-out.css" # no www/ here
    ),
  ),
  # add some Tailwind CSS classes here
  div(
    class = "w-full text-center py-12 flex justify-center",
    div(class = "p-4 max-w-xl bg-violet-400 border-2 border-violet-300 hover:shadow-lg rounded text-2xl font-serif font-normal text-white",
        "Hello World"
    )
  )
)

server <- function(input, output) {

}

# 4) Run the application ----
shiny::shinyApp(ui = ui, server = server)
