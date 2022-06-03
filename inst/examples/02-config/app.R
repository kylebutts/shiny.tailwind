library(shiny)

# Define UI for application that draws a histogram
# Note div uses custom.css page-div that @applies a lot of things
ui <- div(class = "page-div",
          # Load Tailwind CSS Just-in-time
          shiny.tailwind::use_tailwind(
              css = c("custom.css"), version = 3,
              # Custom coral color
              tailwindConfig = "tailwind.config.js"
          ),

          # Title
          # Custom defined color coral-600
          div(class = "bg-coral-600 flex flex-col w-full text-center py-12",
              h1(class = "text-3xl font-extrabold text-black tracking-tight sm:text-4xl md:text-5xl md:leading-[3.5rem]",
                 "Spooky"
              )
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
