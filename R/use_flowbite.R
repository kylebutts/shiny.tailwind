#' Allows you to use flowbite components
#'
#' See also: <https://flowbite.com/> and <https://flowbite.com/#components>
#'
#' @param version the version of flowbite to use, default is 1.4.7
#'
#' @return the required HTML-HEAD tags
#' @export
#'
#' @examples
#' asd
use_flowbite <- function(version = "1.4.7") {
  min_css <- sprintf("https://unpkg.com/flowbite@%s/dist/flowbite.min.css", version)
  js <- sprintf("https://unpkg.com/flowbite@%s/dist/flowbite.js", version)

  shiny::tagList(
    shiny::tags$head(shiny::tags$link(rel = "stylesheet", href = min_css)),
    shiny::tags$script(src = js)
  )
}


library(shiny)

ui <- div(
  class = "border rounded-md bg-stone-100",
  use_flowbite(),
  HTML('
       <div class="mb-6">
  <label for="success" class="block mb-2 text-sm font-medium text-green-700 dark:text-green-500">Your name</label>
  <input type="text" id="success" class="bg-green-50 border border-green-500 text-green-900 dark:text-green-400 placeholder-green-700 dark:placeholder-green-500 text-sm rounded-lg focus:ring-green-500 focus:border-green-500 block w-full p-2.5 dark:bg-gray-700 dark:border-green-500" placeholder="Success input">
  <p class="mt-2 text-sm text-green-600 dark:text-green-500"><span class="font-medium">Well done!</span> Some success messsage.</p>
</div>
<div>
  <label for="error" class="block mb-2 text-sm font-medium text-red-700 dark:text-red-500">Your name</label>
  <input type="text" id="error" class="bg-red-50 border border-red-500 text-red-900 placeholder-red-700 text-sm rounded-lg focus:ring-red-500 dark:bg-gray-700 focus:border-red-500 block w-full p-2.5 dark:text-red-500 dark:placeholder-red-500 dark:border-red-500" placeholder="Error input">
  <p class="mt-2 text-sm text-red-600 dark:text-red-500"><span class="font-medium">Oh, snapp!</span> Some error message.</p>
</div>
       '))



if (interactive()) shinyApp(ui, function(input, output, session) {})
