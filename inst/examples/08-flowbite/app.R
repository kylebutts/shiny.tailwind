################################################################################
#' This app shows some basic UI elements using flowbite UI
#'
#' Note that this app has no server component. As flowbite works via classes,
#' the usage within a shiny app requires custom JS which can be created using
#' the shinyjs package (eg shinyjs::toggleClass())
#'
#' For a full list of components see: https://flowbite.com/#components
################################################################################

library(shiny)
library(shiny.tailwind)

# 1) Define Helper Functions ====

# title element similar to h1()
title <- function(txt) div(txt, class = "text-4xl font-bold mb-2")

# styled element for more info
see_also <- function(txt, url, class = "") {
  div(
    class = paste("text-gray-500", class),
    txt,
    a(
      href = url, url,
      target = "_blank",
      class = "text-blue-600 hover:underline decoration-blue-600"
    )
  )
}

# creates a button with a tooltip
tooltip_button <- function(id, label, tooltip_text,
                           tooltip_position = c("top", "right", "bottom", "left")) {
  tooltip_position <- match.arg(tooltip_position)

  tagList(
    # the button element
    tags$button(
      "data-tooltip-target" = paste0(id, "-tooltip"),
      "data-tooltip-placement" = tooltip_position,
      type = "button",
      class = paste(
        "mb-2 text-white bg-blue-700 hover:bg-blue-800 focus:ring-4",
        "focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm",
        "px-5 py-2.5 text-center"
      ),
      label
    ),

    # the tooltip
    div(
      id = paste0(id, "-tooltip"), role = "tooltip",
      class = paste(
        "inline-block absolute invisible z-10 py-2 px-3 text-sm font-medium",
        "text-white bg-gray-900 rounded-lg shadow-sm opacity-0",
        "transition-opacity duration-300 tooltip"
      ),
      tooltip_text,
      div(class = "tooltip-arrow", "data-popper-arrow" = NA)
    )
  )
}

# creates the HTML code for the accordion
flowbite_accordion <- function(id, ...) {
  ll <- list(...)

  svg_path <- paste(
    "M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4",
    "4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
  )
  svg_down <- tags$svg(
    "data-accordion-icon" = NA, class = "w-6 h-6 shrink-0",
    fill = "currentColor", viewBox = "0 0 20 20",
    xmlns = "http://www.w3.org/2000/svg",
    tags$path(
      "fill-rule" = "evenodd", d = svg_path,
      "clip-rule" = "evenodd"
    )
  )

  div(
    id = id, "data-accordion" = "collapse",
    "data-active-classes" = "bg-blue-100 text-blue-600",
    lapply(seq_along(ll), function(i) {
      tagList(
        h2(
          id = paste0(id, "-heading-", i),
          tags$button(
            type = "button",
            class = paste(
              "flex justify-between items-center p-5 w-full font-medium",
              "text-left text-gray-500 border",
              "border-gray-200 focus:ring-4 focus:ring-gray-200",
              "hover:bg-gray-100", if (i == 1) "rounded-t-xl"
            ),
            "data-accordion-target" = paste0("#", id, "-body-", i),
            "aria-expanded" = "true",
            "aria-controls" = paste0(id, "-body-", i),
            span(names(ll)[[i]]),
            svg_down
          )
        ),
        div(
          id = paste0(id, "-body-", i), class = "hidden",
          "aria-labelledby" = paste0(id, "-heading-", i),
          div(
            class = "p-5 border border-gray-200",
            ll[[i]]
          )
        )
      )
    })
  )
}
# define the svg code for a paperplane -> simple toast element
svg_plane <- paste(
  "M511.6 36.86l-64 415.1c-1.5 9.734-7.375 18.22-15.97 23.05c-4.844 2.719-10.27",
  "4.097-15.68 4.097c-4.188 0-8.319-.8154-12.29-2.472l-122.6-51.1l-50.86",
  "76.29C226.3 508.5 219.8 512 212.8 512C201.3 512 192 502.7 192",
  "491.2v-96.18c0-7.115 2.372-14.03 6.742-19.64L416 96l-293.7 264.3L19.69",
  "317.5C8.438 312.8 .8125 302.2 .0625 289.1s5.469-23.72",
  "16.06-29.77l448-255.1c10.69-6.109 23.88-5.547 34 1.406S513.5 24.72 511.6 36.86z"
)

# Define the App =======
ui <- div(
  use_flowbite(),

  # Header element :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  div(
    class = "p-2 mb-4",
    div("Flowbite UI Examples", class = "text-center text-6xl font-bold mb-2"),
    see_also("More information about flowbite can be found here:",
      "https://flowbite.com/",
      class = "text-center text-xl"
    )
  ),

  # Example elements :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  div(
    class = "max-w-4xl mx-auto grid grid-cols-2 gap-16 p-2",

    # Tooltips :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    div(
      title("Tooltips"),
      see_also("See also:", "https://flowbite.com/docs/components/tooltips/",
        class = "mb-2"
      ),
      div(
        class = "flex justify-start gap-2",
        tooltip_button("btn1", "Above me", "Now I am visible", "top"),
        tooltip_button("btn2", "To the right", "Now I am visible", "right"),
        tooltip_button("btn3", "Below me", "Now I am visible", "bottom"),
        tooltip_button("btn4", "To the left", "Now I am visible", "left")
      ),
    ),


    # Accordion ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    div(
      title("Accordion"),
      see_also("See also:", "https://flowbite.com/docs/components/accordion/",
        class = "mb-2"
      ),
      flowbite_accordion(
        id = "accordion-open",
        "What is Flowbite?" = list(
          p(class = "mb-2 text-gray-500", paste(
            "Flowbite is an open-source library of interactive components built",
            "on top of Tailwind CSS including buttons, dropdowns, modals,",
            "navbars, and more."
          )),
          p(class = "text-gray-500", HTML(paste(
            "Check out this guide to learn how to ",
            "<a href=\"https://flowbite.com/docs/getting-started/introduction/\"",
            "class=\"text-blue-600 dark:text-blue-500 hover:underline\">",
            "get started</a> and start developing websites even faster with ",
            "components on top of Tailwind CSS."
          )))
        ),
        "What are the differences between Flowbite and Tailwind UI?" = list(
          p(class = "mb-2 text-gray-500", paste(
            "The main difference is that the core components from Flowbite are",
            "open source under the MIT license, whereas Tailwind UI is a paid",
            "product. Another difference is that Flowbite relies on smaller and",
            "standalone components, whereas Tailwind UI offers sections of pages."
          )),
          p(class = "text-gray-500", paste(
            "However, we actually recommend using both Flowbite, Flowbite Pro,",
            "and even Tailwind UI as there is no technical reason stopping you",
            "from using the best of two worlds."
          )),
          p(class = "text-gray-500", "Learn more about these technologies:"),
          tags$ul(
            class = "pl-5 list-disc text-gray-500 dark:text-gray-400",
            tags$li(a(
              href = "https://flowbite.com/pro/",
              class = "text-blue-600 hover:underline",
              "Flowbite Pro"
            )),
            tags$li(a(
              href = "https://tailwindui.com/",
              class = "text-blue-600 hover:underline",
              "Tailwind UI"
            ))
          )
        )
      )
    ),

    # Toast ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    div(
      title("Simple Toast"),
      see_also("See also:", "https://flowbite.com/docs/components/toast/",
        class = "mb-2"
      ),
      div(
        id = "toast-simple",
        class = paste(
          "flex items-center w-full max-w-xs p-4 space-x-4 text-gray-500 bg-white",
          "divide-x divide-gray-200 rounded-lg shadow space-x"
        ),
        role = "alert",
        tags$svg(
          class = "w-5 h-5 text-blue-600", "aria-hidden" = "true",
          focusable = "false", "data-prefix" = "fas",
          "data-icon" = "paper-plane", "role" = "img",
          xmlns = "http://www.w3.org/2000/svg", viewBox = "0 0 512 512",
          tags$path(fill = "currentColor", d = svg_plane)
        ),
        div(class = "pl-4 text-sm font-normal", "Message sent successfully")
      )
    )
  )
)

shiny::shinyApp(ui, function(input, output) {})
