################################################################################
#' This simple app shows the basic usage of the tailwindcss.
#'
#' The app recreates the old-faithful app use in the basic shiny tutorials but
#' adds styling using tailwindcss.
#'
#' The meaning of the different classes can be found in the official tailwindcss
#' documentation: https://tailwindcss.com/docs/
################################################################################

library(shiny)

ui <- div(
  class = "page-div",

  # Load Tailwind CSS Just-in-time
  shiny.tailwind::use_tailwind(
	  # Custom class page-div using @apply
    css = c("custom.css"),

    # configuration, see here: https://tailwindcss.com/docs/configuration
    # This one adds extra colors
    tailwindConfig = "tailwind.config.js"
  ),

  # Title
  div(
    class = "w-full text-center py-12",
    h1(
      class = "font-extrabold bg-gradient-to-r from-tahiti to-bubble-gum text-transparent text-8xl bg-clip-text",
      "Old Faithful"
    )
  ),
  # Use Tailwind Typography with prose class
  div(
    class = "prose lg:prose-lg mx-auto",
    p("Old Faithful is located in Yellowstone’s Upper Geyser Basin in the southwest section of the park. The geyser-viewing area is the most accessible and visitor-friendly in the park with bench seating, a large parking lot, and a ranger station that tracks the time, height and length of an eruption to predict the next eruption."),
    h2("How high does Old Faithful erupt and how long will it last?"),
    p("Old Faithful can vary in height from 100-180 feet with an average near 130-140 feet. This has been the historical range of its recorded height. Eruptions normally last between 1.5 to 5 minutes."),
    p("Let's see a distribution of the duration of eruptions."),

    div(
      class = "not-prose italic border-2 flex flex-col place-items-center gap-y-4 py-4 px-4 rounded shadow-xl",
      sliderInput("bins", "Number of Bins:",
        min = 1, max = 10, value = 5
      ),
      plotOutput("distPlot")
    ),

    p("More text about the old faithful. At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio."),
    h2("Nam libero tempore"),
    p("Soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.")
  ),
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x,
      breaks = bins,
      col = "darkgray", border = "white"
    )
  })
}

# Run the application
shiny::shinyApp(ui = ui, server = server)
