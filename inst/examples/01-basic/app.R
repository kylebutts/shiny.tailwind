library(shiny)

# Define UI for application that draws a histogram
# Note div uses custom.css page-div that @applies a lot of things
ui <- div(class="page-div",
          # Load Tailwind CSS Just-in-time
          use_tailwind(css = c("custom.css")),

          # Title
          div(class = "flex flex-col w-full text-center py-12",
              h1(class = "text-3xl font-extrabold text-black tracking-tight sm:text-4xl md:text-5xl md:leading-[3.5rem]",
                 "Old Faithful"
             )
          ),

          # Inputs
          div(
              sliderInput("bins",
                          "Number of Bins:",
                          min = 1,
                          max = 10,
                          value = 5)
          ),

          # Plot
          div(
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
