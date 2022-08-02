################################################################################
#' This app shows how we can create a simple form with multiple inputs using
#' tailwindcss styling.
#' The app shows two different styles, the second style shows you how we can
#' create a UI with components (ie functions to create the code for us), reducing
#' the repetitiveness of the tailwindcss classes.
################################################################################

library(shiny)
library(shiny.tailwind)

# Main container
rounded_container <- function(...) {
  div(
    class = "rounded-xl bg-gradient-to-r bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 p-2 sm:p-6 dark:bg-gray-800",
    ...
  )
}

# Form 1 ----
form1 <- rounded_container(
  div(class = "font-extrabold text-xl text-gray-900 mb-2", "Style 1 Inputs"),
  twTextInput(
    inputId = "email", label = "Your Email", placeholder = "me@example.com", type = "email",
    label_class = "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300",
    input_class = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
  ),
  twTextInput(
    inputId = "pw", label = "Your password", placeholder = "", type = "password",
    label_class = "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300",
    input_class = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
  ),
  twNumericInput(
    inputId = "number", label = "Pick a number", value = "",
    container_class = "mt-6", label_class = "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300",
    input_class = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
  ),
  twSelectInput(
    inputId = "countries",label = "Select your country",
    choices = c("United States", "Canada", "France", "Germany"),
    container_class = "mt-6", selectize = TRUE,
    label_class = "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-400",
    select_class = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
  ),
  twTextAreaInput(
    inputId = "message", label = "Your message", placeholder = "Your message...",
    rows = 4, resize = "vertical",
    container_class = "mt-6", label_class = "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-400",
    input_class = "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
  ),
  twCheckboxGroupInput(
    "remember2",
    label = "", choices = c("Rememer Me" = "a", "Send Ads!" = "b"),
    inline = TRUE,
    container_class = "items-center h-5 mt-6 mx-2",
    label_class = "ml-2 text-sm font-medium text-gray-900 dark:text-gray-300",
    inner_container_class = "mx-2",
    input_class = "w-4 h-4 border border-gray-300 rounded bg-gray-50 focus:ring-3 focus:ring-blue-300 dark:bg-gray-700 dark:border-gray-600 dark:focus:ring-blue-600 dark:ring-offset-gray-800"
  ),
  tags$button(type = "submit", class = "mt-6 text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800", "Submit")
)

# Form 2 Floating Input Fields ----

# small helper to create floating text inputs
floating_input <- function(inputId, label, type = "text", ...) {
  ll <- list(
    inputId = inputId, label = label, placeholder = "", type = type,
    label_after_input = TRUE,
    ...,
    container_class = "relative z-0 w-full mt-6 group",
    input_class = "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer",
    label_class = "peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6"
  )

  if(type == "numeric") {
    ll$type <- NULL
    do.call(twNumericInput, ll)
  } else if(type == "area") {
    ll$type <- NULL
    do.call(twTextAreaInput, ll)
  } else {
    do.call(twTextInput, ll)
  }
}

form2 <- rounded_container(
  div(class = "font-extrabold text-xl text-gray-900 mb-2", "Floating Inputs"),
  floating_input("floating_email", "Email address", type = "email"),
  floating_input("floating_number", "Pick a number", type = "numeric", value = ""),
  div(
    class = "grid xl:grid-cols-2 xl:gap-6",
    floating_input("floating_first_name", "First name"),
    floating_input("floating_last_name", "Last name")
  ),
  div(
    class = "grid xl:grid-cols-2 xl:gap-6",
    # note the pattern = "[0-9]{3}-[0-9]{3}-[0-9]{4}" is currently not supported
    floating_input("floating_phone", "Phone number (123-456-7890)", type = "tel"),
    floating_input("floating_company", "Company (Ex. Google)")
  ),
  floating_input("floating_yourself", "Describe yourself",
    type = "area",
    resize = "vertical"
  )
)


# Combine the main UI elements and define server ----
ui <- div(
  class = "max-w-[80%] mx-auto my-24 grid grid-cols-1 xl:grid-cols-2 xl:gap-4",
  shiny.tailwind::use_tailwind(),
  form1,
  form2
)


server <- function(input, output) {}


shiny::shinyApp(ui = ui, server = server)
