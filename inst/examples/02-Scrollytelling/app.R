################################################################################
#' This app shows a basic "Scrollytelling" application.
#'
#' See also: https://tailwindcss.com/docs/
################################################################################

# ---- Setup -------------------------------------------------------------------
library(shiny)
library(DT)
library(shiny.tailwind)
library(palmerpenguins)
library(ggplot2)
data(penguins)

var_names <- colnames(penguins)
# Only select numeric columns
var_names <- var_names[unlist(lapply(penguins, is.numeric))]

# ---- Helper Functions --------------------------------------------------------
title <- function(title) {
  div(
    class = "border-t-2 border-gray-400 px-4 py-4",
    h2(class = "text-4xl lg:text-xl tracking-wide text-gray-600", title)
  )
}

section <- function(section_title = "Section", section_subtitle = "", ...) {
  div(
    class = "grid grid-cols-1 lg:grid-cols-3 gap-x-4 px-4 pt-4 pb-8 border-t-2 border-gray-200",
    # Section Title
    div(
      class = "lg:col-span-1 mb-8 lg:mb-0 ",
      h3(class = "text-3xl lg:text-base text-gray-500 font-medium", section_title),
      p(class = "text-2xl lg:text-sm text-gray-400 italic pt-1", section_subtitle)
    ),
    # Content
    div(class = "lg:col-span-2 grid grid-flow-row gap-y-4", ...)
  )
}


# ---- App ---------------------------------------------------------------------

ui <- div(
  tags$head(
    # Load Tailwind CSS Just-in-time
    shiny.tailwind::use_tailwind()
  ),
  tags$main(
    class = "h-screen overflow-y-scroll snap snap-y snap-center",
    div(
      class = "relative w-full min-h-screen snap-start bg-black flex flex-col items-center justify-center",
      img(
        src = "https://allisonhorst.github.io/palmerpenguins/reference/figures/lter_penguins.png",
        class = "block w-full lg:w-1/3 pb-8 -mt-6"
      ),
      h1(class = "block text-8xl tracking-tight font-extrabold text-white", "Palmer's Penguins"),
      div(
        class = "absolute inset-x-0 bottom-8 text-center",
        icon("chevron-down", class = "md:text-2xl lg:text-4xl text-white animate-bounce")
      )
    ),
    # Page 2 -------------------------------------------------------------------
    div(
      class = "w-full min-h-screen snap-start relative",
      div(
        class = "min-h-screen bg-gray-100 py-6 flex flex-col justify-start lg:justify-center sm:py-12",
        # Plot Settings Pane ---------------------------------------------------
        div(
          class = "mx-auto w-[960px] bg-white shadow-md",
          title("Plot Settings"),
          # Variable Selection -------------------------------------------------
          section(
            "Variable Selection", "",
            div(
              class = "grid grid-flow-row grid-cols-2 lg:grid-cols-2 gap-y-8 gap-x-8",
              shiny.tailwind::twSelectInput(
                "x_var", "X variable:",
                choices = var_names, selected = "bill_length_mm",
                container_class = "block w-2/3 lg:w-full", label_class = "text-lg lg:text-sm text-gray-600 italic",
                select_class = "w-full px-0.5 border-0 border-b-2 border-gray-200 focus:ring-0 focus:border-black"
              ),
              shiny.tailwind::twSelectInput(
                "y_var", "Y variable:",
                choices = var_names, selected = "flipper_length_mm",
                container_class = "block w-2/3 lg:w-full", label_class = "text-lg lg:text-sm text-gray-600 italic",
                select_class = "w-full px-0.5 border-0 border-b-2 border-gray-200 focus:ring-0 focus:border-black"
              )
            )
          ),
          # Plot Options -------------------------------------------------------
          section(
            "Plot Options", "Personalize the plot to make it production ready.",
            div(
              class = "grid grid-flow-row grid-cols-2 lg:grid-cols-2 gap-y-8 gap-x-8",
              shiny.tailwind::twTextInput(
                "plot_title",
                label = "Plot Title:", placeholder = "Plot Label",
                value = "Palmer's Penguins",
                container_class = "block w-full", label_class = "text-lg lg:text-sm text-gray-600 italic",
                input_class = "w-full px-0.5 border-0 border-b-2 border-gray-200 focus:ring-0 focus:border-black"
              ),
              shiny.tailwind::twTextInput(
                "x_axis",
                label = "X-axis Title:", placeholder = "Plot Label",
                value = "Bill Length (mm)",
                container_class = "block w-full", label_class = "text-lg lg:text-sm text-gray-600 italic",
                input_class = "w-full px-0.5 border-0 border-b-2 border-gray-200 focus:ring-0 focus:border-black"
              ),
              shiny.tailwind::twTextInput(
                "y_axis",
                label = "Y-axis Title:", placeholder = "Plot Label",
                value = "Flipper Length (mm)",
                container_class = "block w-full", label_class = "text-lg lg:text-sm text-gray-600 italic",
                input_class = "w-full px-0.5 border-0 border-b-2 border-gray-200 focus:ring-0 focus:border-black"
              )
            )
          )
        ),
        # Scatter Plot ---------------------------------------------------------
        div(
          class = "mx-auto w-[960px] bg-white shadow-md mt-12",
          title("Scatter Plot"),
          div(
            class = "px-4 pt-4 pb-8 border-t-2 border-gray-200",
            shiny::plotOutput("scatter")
          )
        ),
        # Icon
        div(
          class = "absolute bottom-8 text-center lg:text-right lg:pr-8 inset-x-0",
          icon("chevron-down", class = "text-8xl lg:text-4xl text-gray-800 animate-bounce")
        )
      )
    ),
    # Page 3 -------------------------------------------------------------------
    div(
      class = "w-full min-h-screen snap-start mx-auto py-16",
      div(
        class = "w-prose mx-auto prose",
        h2("About the App"),
        p("Data were collected and made available by ", a(href = "https://www.uaf.edu/cfos/people/faculty/detail/kristen-gorman.php", target = "_blank", "Dr. Kristen Gorman"), "and the ", a(href = "https://pal.lternet.edu/", target = "_blank", "Palmer Station, Antarctica LTER,"), "a member of the ", a(href = "https://lternet.edu/", target = "_blank", "Long Term Ecological Research Network."), "See more about the data and R package", a(href = "https://allisonhorst.github.io/palmerpenguins/", target = "_blank", "here."), "You can find these and more code examples for exploring palmerpenguins in", a(href = "https://allisonhorst.github.io/palmerpenguins/articles/examples.html", target = "_blank", tags$code("vignette('examples', package='penguins')."))),
        p("Made with <3 using", a(href = "https://tailwindcss.com/", target = "_blank", "tailwindcss,"), a(href = "https://github.com/kylebutts/shiny.tailwind", target = "_blank", "shiny.tailwind,"), "and ", a(href = "https://github.com/rstudio/shiny", target = "_blank", "shiny."))
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$scatter <- renderPlot({
    ggplot(penguins) +
      geom_point(aes(x = !!sym(input$x_var), y = !!sym(input$y_var))) +
      theme_grey(base_size = 18) +
      labs(
        title = input$plot_title, x = input$x_axis, y = input$y_axis
      )
  })
}

# Run the application
shiny::shinyApp(ui = ui, server = server)
