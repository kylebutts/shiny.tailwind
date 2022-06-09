
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shiny.tailwind

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/shiny.tailwind)](https://cran.r-project.org/package=shiny.tailwind)
<!-- badges: end -->

The goal of `shiny.tailwind` is to bring
[TailwindCSS](https://tailwindcss.com/) to Shiny apps.

## Installation

You can install the package with:

``` r
install.packages("shiny.tailwind")
# development version
# remotes::install_github("kylebutts/shiny.tailwind")
```

## Basic Use

In your shiny UI declaration, just include
`shiny.tailwind::use_tailwind()` and all the appropriate files will be
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
# there is a bug (at the moment), that tailwind does not render correctly in the
# RStudio viewer, the following code uses your default browser
options(shiny.launch.browser = .rs.invokeShinyWindowExternal)

# Define UI for application that draws a histogram
ui <- div(
  class = "px-4 py-10 max-w-3xl mx-auto sm:px-6 sm:py-12 lg:max-w-4xl lg:py-16 lg:px-8 xl:max-w-6xl",
  # Load Tailwind CSS Just-in-time
  shiny.tailwind::use_tailwind(),
  
  # Title
  div(class = "flex flex-col w-full text-center py-12",
      h1(class = "text-3xl font-extrabold tracking-tight sm:text-4xl md:text-5xl md:leading-[3.5rem] text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500",
         "Old Faithful"
      )
  ),
  
  # Inputs
  div(class = "block shadow-md py-4 px-4 flex flex-row rounded-md",
      div(class = "flex-initial mx-4",
          sliderInput("bins", "Number of Bins:",
                      min = 1, max = 10, value = 5)
      ),
      div(class = "flex-initial mx-4",
          twTextInput("firstname", "First Name", value = "",
                      input_class = "rounded-md border border-2 border-lime-500")
      ),
      div(class = "flex-initial mx-4",
          twTextInput("lastname", "Last Name", value = "",
                      input_class = "rounded-md border border-2 border-amber-500")
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

Additional examples are found in the `inst/examples/` folder, eg

``` r
library(shiny)
library(shiny.tailwind)

list.files(system.file("examples", package = "shiny.tailwind"))
runApp(system.file("examples", "01-old-faithful", package = "shiny.tailwind"))
```

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
-   `w-#/12` sets a column of width \#/12 (similar to bootstrap’s grid)
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
say `.btn-blue`. I can use the `@apply` directive to automatically use a
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

See also the
[`05-apply-directive`](https://github.com/kylebutts/shiny.tailwind/blob/master/inst/examples/05-apply-directive/app.R),
which you can run with

``` r
runApp(system.file("examples", "05-apply-directive", package = "shiny.tailwind"))
```

### Reusing Classes

As the [official tailwindcss
documentation](https://tailwindcss.com/docs/reusing-styles) puts it, the
best way to reuse classes is to define loops and components. For
example, let’s say we want to have a multiple containers with the
classes
`p-2 bg-stone-200 border border-gray-600 rounded-md drop-shadow-md`, we
could either re-type this string every time, or use something along the
lines of this:

``` r
mybox <- function(...) {
  div(
    class = "p-2 bg-stone-200 border border-gray-600 rounded-md drop-shadow-md",
    ...
  )
}

# in UI:

div(
  class = "flex flex-wrap",
  mybox("This is the first box"),
  mybox("This is a second box"),
  mybox("This is a third box"),
)
```

### Customizing Tailwind

Custom configuration of Tailwind is also possible. There are two options
available in ‘use_tailwind’, but moving forward the option
`tailwindConfig` will be the only one supported (with version 3.0 of
Tailwind). See [this
release](https://github.com/tailwindlabs/tailwindcss/releases/tag/v3.0.0-alpha.1)
for details, but you need to define `tailwind.config = {}` as a JSON
object. An example is in the folder ‘inst/examples/01-old-faithful’ in
the github repository. Note the ‘.js’ file should only consist of the
JSON object. The function will place it in the appropriate script tag.
For details on all the ways you can configure Tailwind, see [this
page](https://tailwindcss.com/docs/configuration) in their docs.

Version 3 of tailwind (the default by `use_tailwind`) will come loaded
with all first-party plugins from Tailwind, i.e. Typography, Aspect
Ratio, Forms, Line-clamp.

For version 2, if you want to use custom modules, for example
TailwindTypography, note that you need to use the browser-version and
you have to layout the config file in a specific way. You need to define
the config JSON object as ‘window.tailwindConfig’ and you must call
‘window.tailwindCSS.refresh();’.

## Credits

-   [TailwindCSS](https://tailwindcss.com/) and [Tailwind
    Typography](https://github.com/tailwindlabs/tailwindcss-typography)

-   [BeyondCo Tailwind JIT Broswer
    Compiler](https://beyondco.de/blog/tailwind-jit-compiler-via-cdn)
