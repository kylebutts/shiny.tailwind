library(shiny)
library(shiny.tailwind)

# Install tailwindcss if needed
if (!is_tailwindcss_installed()) {
  install_tailwindcss_cli()
  system("chmod +x tailwindcss")
}

# css goes into "www/" folder in shiny apps
compile_tailwindcss(
  infile = "custom.css", outfile = "www/tailwind-out.css",
  verbose = T
)

ui <- div(
  class = "page-div",
  # tailwindcss_compile returns the outfile silently, therefore this should work
  tags$head(
    tags$link(
      rel = "stylesheet", type = "text/css",
      href = "tailwind-out.css" # no www/ here
    ),
  ),
  div(
    class = "w-full text-center py-12",
    h1("Hello World")
  )
)

server <- function(input, output) {

}

# Run the application
shinyApp(ui = ui, server = server)
