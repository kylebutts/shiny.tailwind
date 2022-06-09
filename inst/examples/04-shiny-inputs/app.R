library(shiny)
library(shiny.tailwind)

rounded_container <- function(...) {
  div(
    class = "rounded-xl bg-gradient-to-r bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-700 p-2 sm:p-6 dark:bg-gray-800",
    ...
  )
}

form1 <- rounded_container(
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

  div(
    class = "mt-6",
    tags$label("for" = "number", class = "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-300", "Pick a number"),
    tags$input(type = "number", id = "number", class = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500")
  ),
  div(
    class = "mt-6",
    tags$label("for" = "countries", class = "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-400", "Select your country"),
    tags$select(
      id = "countries", class = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500",
      tags$option("United States"),
      tags$option("Canada"),
      tags$option("France"),
      tags$option("Germany")
    )
  ),
  div(
    class = "mt-6",
    tags$label("for" = "message", class = "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-400", "Your message"),
    tags$textarea(id = "message", rows = "4", class = "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500", placeholder = "Your message...")
  ),
  twCheckboxInput(
    "remember2", label = "Remember me",
    container_class = "flex items-center h-5 mt-6 mx-2",
    label_class = "ml-2 text-sm font-medium text-gray-900 dark:text-gray-300",
    input_class = "w-4 h-4 border border-gray-300 rounded bg-gray-50 focus:ring-3 focus:ring-blue-300 dark:bg-gray-700 dark:border-gray-600 dark:focus:ring-blue-600 dark:ring-offset-gray-800"
  ),
  tags$button(type = "submit", class = "mt-6 text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800", "Submit")
)





form2 <- rounded_container(
  div(
    class = "relative z-0 w-full mt-6 group",
    tags$input(type = "email", name = "floating_email", class = "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer", placeholder = " "),
    tags$label("for" = "floating_email", class = "peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6", "Email address")
  ),
  div(
    class = "relative z-0 w-full mt-6 group",
    tags$input(type = "number", name = "floating_number", id = "floating_password", class = "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer", placeholder = " "),
    tags$label("for" = "floating_number", class = "peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6", "Pick a Number")
  ),
  div(
    class = "grid xl:grid-cols-2 xl:gap-6",
    div(
      class = "relative z-0 w-full mt-6 group",
      tags$input(type = "text", name = "floating_first_name", id = "floating_first_name", class = "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer", placeholder = " "),
      tags$label("for" = "floating_first_name", class = "peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6", "First name")
    ),
    div(
      class = "relative z-0 w-full mt-6 group",
      tags$input(type = "text", name = "floating_last_name", id = "floating_last_name", class = "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer", placeholder = " "),
      tags$label("for" = "floating_last_name", class = "peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6", "Last name")
    ),
  ),
  div(
    class = "grid xl:grid-cols-2 xl:gap-6",
    div(
      class = "relative z-0 w-full mt-6 group",
      tags$input(type = "tel", pattern = "[0-9]{3}-[0-9]{3}-[0-9]{4}", name = "floating_phone", id = "floating_phone", class = "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer", placeholder = " "),
      tags$label("for" = "floating_phone", class = "peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6", "Phone number (123-456-7890)")
    ),
    div(
      class = "relative z-0 w-full mt-6 group",
      tags$input(type = "text", name = "floating_company", id = "floating_company", class = "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer", placeholder = " "),
      tags$label("for" = "floating_company", class = "peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6", "Company (Ex. Google)")
    ),
  ),
  div(
    class = "relative z-0 w-full mt-6 group",
    tags$textarea(name = "floating_textarea", id = "floating_company", class = "block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer", placeholder = " "),
    tags$label("for" = "floating_company", class = "peer-focus:font-medium absolute text-sm text-gray-500 dark:text-gray-400 duration-300 transform -translate-y-6 scale-75 top-3 -z-10 origin-[0] peer-focus:left-0 peer-focus:text-blue-600 peer-focus:dark:text-blue-500 peer-placeholder-shown:scale-100 peer-placeholder-shown:translate-y-0 peer-focus:scale-75 peer-focus:-translate-y-6", "Describe yourself")
  )
)



ui <- div(
  class = "max-w-[80%] mx-auto my-24 grid grid-cols-1 xl:grid-cols-2 xl:gap-4",
  shiny.tailwind::use_tailwind(),
  form1,
  form2
)


server <- function(input, output) {}


shiny::shinyApp(ui, server)
