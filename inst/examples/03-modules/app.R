library(shiny)

# Define UI for application that draws a histogram
# Note div uses custom.css page-div that @applies a lot of things
ui <- div(class="page-div",
          # Load Tailwind CSS Just-in-time
          shiny.tailwind::use_tailwind(
              css = c("custom.css"), version = 2,
              # Custom coral color
              tailwindModule = "tailwind.config.js"
          ),

          # Title
          div(class = "bg-coral-600 flex flex-col w-full text-center py-12",
              h1(class = "text-3xl font-extrabold text-black tracking-tight sm:text-4xl md:text-5xl md:leading-[3.5rem]",
                 "Old Faithful"
             )
          ),
          # Use Tailwind Typography with prose class
          div(class = "prose mx-auto mb-10 shadow-md py-4 px-4",
              p("Old Faithful is located in Yellowstone’s Upper Geyser Basin in the southwest section of the park. The geyser-viewing area is the most accessible and visitor-friendly in the park with bench seating, a large parking lot, and a ranger station that tracks the time, height and length of an eruption to predict the next eruption."),
              h2("How high does Old Faithful erupt and how long will it last?"),
              p("Old Faithful can vary in height from 100-180 feet with an average near 130-140 feet. This has been the historical range of its recorded height. Eruptions normally last between 1.5 to 5 minutes.")
          ),

          # Inputs
          div(class = "block shadow-md py-4 px-4 flex flex-row",
              div(class = "flex-initial mx-4",
                  sliderInput("bins", "Number of Bins:",
                              min = 1, max = 10, value = 5)
              ),
              div(class = "flex-initial mx-4",
                  textInput("firstname", "First Name", value = "")
              ),
              div(class = "flex-initial mx-4",
                  textInput("lastname", "Last Name", value = "")
              ),
          ),

          # Plot
          div(class = "block shadow-md py-4 px-4 mt-4",
              plotOutput("distPlot")
          )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x,
             breaks = bins,
             col = 'darkgray', border = 'white')
    })
}

# Run the application
shinyApp(ui = ui, server = server)
