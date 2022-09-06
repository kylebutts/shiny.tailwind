
#' Creates a button to open a Modal Dialog
#'
#' @param btn_id ID of the button
#' @param btn_label Label for the button
#' @param btn_class Classes to style the button
#' @param icon an optional icon for the button
#' @param modal_id ID of the modal, make sure that the IDs are identical to the
#' one used in [twModalDialog()]
#'
#' @return a HTML element
#' @export
#'
#' @examples
#' ui <- div(
#'   use_tailwind(),
#'   class = "h-screen bg-stone-100 p-10",
#'   twBtnOpenModal(
#'     "open_modal", "Show Modal",
#'     btn_class = "px-5 py-2 bg-rose-500 hover:bg-rose-700 text-white cursor-pointer rounded-md"
#'   ),
#'   twModalDialog(p("Hello World"), )
#' )
#'
#' server <- function(input, output, session) {
#'    observeEvent(input$open_modal, {
#'     print("Modal Opened")
#'   })
#'   observeEvent(input$submit, {
#'     print("Modal Closed - Submitted")
#'   })
#'   observeEvent(input$close, {
#'     print("Modal Closed - Closed")
#'   })
#' }
#' if (interactive()) shinyApp(ui, server)
twBtnOpenModal <- function(btn_id, btn_label, btn_class = NULL, icon = NULL, modal_id = "shiny-modal") {
  shiny::HTML(glue::glue('
<button id="{btn_id}" class="action-button {btn_class}"
  onclick="document.getElementById(\'{modal_id}\').classList.remove(\'hidden\')">
  {tagList(icon, btn_label)}
</button>'))
}


#' Creates a Modal Dialog
#'
#' @param ui UI of the modal
#' @param close_id ID for the close button
#' @param close_label Label for the close button, can be a tagList of an icon
#' and the label
#' @param submit_id ID for the submit button
#' @param submit_label Label for the submit button, can be a tagList of an icon
#' and the label
#' @param title title of the modal
#' @param modal_id id of the modal, make sure the ID is identical to the one
#' used in twBtnOpenModal
#' @param modal_width optional class to define the modal width, eg `max-w-4xl`
#' for a wider modal
#'
#' @return a HTML element
#' @export
#'
#' @examples
#' ui <- div(
#'   use_tailwind(),
#'   class = "h-screen bg-stone-100 p-10",
#'   twBtnOpenModal(
#'     "open_modal", "Show Modal",
#'     btn_class = "px-5 py-2 bg-rose-500 hover:bg-rose-700 text-white cursor-pointer rounded-md"
#'   ),
#'   twModalDialog(p("Hello World"))
#' )
#'
#' server <- function(input, output, session) {
#'    observeEvent(input$open_modal, {
#'     print("Modal Opened")
#'   })
#'   observeEvent(input$submit, {
#'     print("Modal Closed - Submitted")
#'   })
#'   observeEvent(input$close, {
#'     print("Modal Closed - Closed")
#'   })
#' }
#' if (interactive()) shinyApp(ui, server)
twModalDialog <- function(ui, close_id = "close", close_label = "Close",
                          submit_id = "submit", submit_label = "Submit",
                          title = "Title of Modal", modal_id = "shiny-modal",
                          modal_width = "max-w-lg") {
  div(
    class = "relative z-50 hidden", id = modal_id,
    "aria-labelledby" = "modal-title", role = "dialog", "aria-modal" = "true",
    div(class = "fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"),

    div(
      class="fixed z-10 inset-0 overflow-y-auto",
      div(
        class = "flex items-end sm:items-center justify-center min-h-full p-4 text-center p-0",
        div(
          class = paste("relative bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all my-8 max-w-lg",
                        modal_width) ,
          div(
            class = "bg-white px-4 pt-5 pb-4 p-6 pb-4",
            div(
              class = "flex items-start",
              div(
                class = "mt-3 text-center mt-0 ml-4 text-left",
                h3(class = "text-lg leading-6 font-medium text-gray-900",
                   id = paste0(modal_id, "-title"), title),
                ui
              )
            )
          ),
          div(
            class = "bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse",
            HTML(glue::glue('
<button type="button" id={submit_id} onclick="document.getElementById(\'{modal_id}\').classList.add(\'hidden\')"
  class = "action-button w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 ml-3 w-auto text-sm">
  {submit_label}
</button>')),
            HTML(glue::glue('
<button type="button" id={close_id} onclick="document.getElementById(\'{modal_id}\').classList.add(\'hidden\')"
  class = "action-button mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 mt-0 ml-3 w-auto text-sm">
  {close_label}
</button>'))
          )
        )
      )
    )
  )
}
