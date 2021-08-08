
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shiny.tailwind

<!-- badges: start -->
<!-- badges: end -->

The goal of shiny.tailwind is to bring TailwindCSS to Shiny apps.

## Installation

You can install the developmental version of shiny.tailwind with:

``` r
install.packages("devtools")
devtools::install_github("kylebutts/shiny.tailwind")
```

## Basic Use

In your shiny UI declaration, just include
`shiny.tailwind::use_tailwind` and all the appropraite files will be
inserted into your shiny app. Therefore you can just start using
tailwind classes and they will load dynamically and automatically.

## Example

Here is a basic example.

<img src="man/figures/README-example.png" width="100%" />

Here is the example code. Note how easy it is to use tailwind classes
with `shiny.tailwind::use_tailwind()`

``` r
library(shiny)
library(shiny.tailwind)

# Define UI for application that draws a histogram
ui <- div(class="px-4 py-10 max-w-3xl mx-auto sm:px-6 sm:py-12 lg:max-w-4xl lg:py-16 lg:px-8 xl:max-w-6xl",
          # Load Tailwind CSS Just-in-time
          shiny.tailwind::use_tailwind(),

          # Title
          div(class = "flex flex-col w-full text-center py-12",
              h1(class = "text-3xl font-extrabold text-black tracking-tight sm:text-4xl md:text-5xl md:leading-[3.5rem]",
                 "Old Faithful"
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
```

Additonal examples are found in the `inst/examples/` folder.

## What is Tailwind CSS?

Tailwind CSS is a *utility-based* CSS framework that allows really quick
and incredibly customizable styling of html all through classes. Here
are some example classes

-   `my-4` which sets the margin top and bottom to size `4` (Tailwind
    has sizes that are consistent across classes. 4 happens to be
    `1rem`)
-   `shadow-sm`/`shadow-md`/`shadow-lg`/`shadow-xl` set a drop shadow on
    divs
-   `text-left`/`text-center`/`text-right` left/center/right- align
    text.
-   `w-#/12` sets a column of width #/12 (similar to bootstrap’s grid)
-   [Much, much more](https://tailwindcss.com/docs/)

This makes a common framework for designing that is quick and intuitive.

## Details about `shiny.tailwind`

TailwindCSS is a utility-based design framework that makes designing
simple. There is basically a class for every css idea you could have.
However, the complete set of tailwind css classes is massive (\~15mb),
so you don’t want to load all of these. That is where Tailwind’s new
Just in Time compiling comes in. It will only load the css classes you
use, as you use them. So if your shiny app renders ui dynamically, it
will load just the css needed whenever the UI is rendered.

Normally, doing just in time requires a fancy node setup that is
constantly monitoring html in a terminal. However, the company Beyond
Code created a browser version of Tailwind Just in Time that runs
completely in JS in the browser. See
<https://beyondco.de/blog/tailwind-jit-compiler-via-cdn>. Therefore, you
can just use tailwind css classes and they will load automatically.

### Custom css and the `@apply` directive:

Writing css in Tailwind is incredibly easy too, with the
[`@apply`](https://tailwindcss.com/docs/functions-and-directives#apply)
directive. For example, lets say you want to create a blue button class,
say `.btn-blue`. I can use the `@apply` directive to autmoatically use a
bunch of TailwindCSS utility classes:

``` css
.btn-blue {
  @apply bg-blue-500 hover:bg-blue-700 text-white;
}
```

Setting `class = "btn-blue"` is equivalent to setting
`class = "bg-blue-500 hover:bg-blue-700 text-white"`.

You can write custom css files for your shiny app, you just need to pass
them through `use_tailwind()` in order to use the apply directive. Just
pass `use_tailwind(css = "custom.css")` and the @apply directive will
work automatically. (Technical note, the `<style>` tag that holds the
custom.css needs the property `type='postcss'` in order to work, and
use_tailwind does this automatically.)

### Customizing Tailwind

Custom configuration of tailwind is also possible. There are two options
available in ‘use_tailwind’. First, if you don’t want to use any custom
modules, uses tailwindConfig. An example is in the folder
‘inst/examples/02-config’ in the github repository. Note the ‘.js’ file
should only consist of the JSON object. The function will place it in
the appropriate script tag.

If you want to use custom modules, for example TailwindTypography, note
that you need to use the browser-version and you have to layout the
config file in a specific way. You need to define the config JSON object
as ‘window.tailwindConfig’ and you must call
‘window.tailwindCSS.refresh();’. An example is in the folder
‘inst/examples/03-modules’ in the github repository.

## Credits

-   [TailwindCSS](https://tailwindcss.com/) and [Tailwind
    Typography](https://github.com/tailwindlabs/tailwindcss-typography)

-   [BeyondCo Tailwind JIT Broswer
    Compiler](https://beyondco.de/blog/tailwind-jit-compiler-via-cdn)
