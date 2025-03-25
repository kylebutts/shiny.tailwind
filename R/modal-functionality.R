#' Creates a button to open a Modal Dialog
#'
#' @param btn_id ID of the button
#' @param btn_label Label for the button
#' @param btn_class Classes to style the button
#' @param icon an optional icon for the button
#' @param modal_id ID of the modal, make sure that the IDs are identical to the
#' one used in [twModalDialog()]
#'
#' @return a list with a `shiny.tag` class
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
twBtnOpenModal <- function(
  btn_id,
  btn_label,
  btn_class = NULL,
  icon = NULL,
  modal_id = "shiny-modal"
) {
  close_script <- sprintf(
    "document.getElementById('%s').classList.remove('hidden')",
    modal_id
  )

  if (is.null(btn_class)) {
    btn_class <- ""
  }

  shiny::tags$button(
    id = btn_id,
    class = c("action-button", btn_class),
    onclick = close_script,
    shiny::tagList(icon, btn_label)
  )
}


#' Creates a Modal Dialog
#'
#' @param ui UI of the modal
#' @param close_id ID for the close button
#' @param close_label Label for the close button, can be a tagList of an icon
#' and the label
#' @param close_class classes for the close button, if NA default values will
#' be used
#' @param submit_id ID for the submit button
#' @param submit_label Label for the submit button, can be a tagList of an icon
#' and the label
#' @param submit_class classes for the submit button, if NA default values will
#' be used
#' @param title title of the modal
#' @param modal_id id of the modal, make sure the ID is identical to the one
#' used in twBtnOpenModal
#' @param modal_width optional class to define the modal width, eg `max-w-4xl`
#' for a wider modal
#'
#' @return a list with a `shiny.tag` class
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
twModalDialog <- function(
  ui,
  close_id = "close",
  close_label = "Close",
  close_class = NA,
  submit_id = "submit",
  submit_label = "Submit",
  submit_class = NA,
  title = "Title of Modal",
  modal_id = "shiny-modal",
  modal_width = "max-w-lg"
) {
  if (!is.null(close_class) && is.na(close_class)) {
    close_class <- paste(
      "mt-3 w-full justify-center rounded-md border border-gray-300 shadow-sm",
      "px-4 py-2 bg-white text-base font-bold text-gray-700 hover:bg-gray-50",
      "mt-0 ml-3 w-auto text-sm place-items-center"
    )
  }
  if (!is.null(submit_class) && is.na(submit_class)) {
    submit_class <- paste(
      "w-full justify-center rounded-md border border-transparent shadow-sm",
      "px-4 py-2 bg-blue-600 text-base font-bold text-white hover:bg-blue-800",
      "ml-3 w-auto text-sm place-items-center"
    )
  }

  div(
    class = "relative z-50 hidden",
    id = modal_id,
    "aria-labelledby " = "modal-title",
    role = "dialog",
    "aria-modal" = "true",
    div(class = "fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"),

    div(
      class = "fixed z-10 inset-0 overflow-y-auto",
      div(
        class = "flex items-end sm:items-center justify-center min-h-full p-4 text-center p-0",
        div(
          class = paste(
            "relative bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all my-8 w-full",
            modal_width
          ),
          div(
            class = "bg-white px-4 pt-5 pb-4 p-6 pb-4",
            div(
              class = "flex items-start",
              div(
                class = "mt-3 text-center mt-0 ml-4 text-left",
                h3(
                  class = "font-extrabold mb-2 text-xl leading-6 text-gray-900",
                  id = paste0(modal_id, "-title"),
                  title
                ),
                ui
              )
            )
          ),
          div(
            class = "bg-gray-50 px-4 py-3 px-6 flex flex-row-reverse",
            shiny::tags$button(
              id = submit_id,
              type = "button",
              class = c("action-button", submit_class),
              onclick = sprintf(
                "document.getElementById('%s').classList.add('hidden')",
                modal_id
              ),
              submit_label
            ),

            shiny::tags$button(
              id = close_id,
              type = "button",
              class = c("action-button", close_class),
              onclick = sprintf(
                "document.getElementById('%s').classList.add('hidden')",
                modal_id
              ),
              close_label
            )
          )
        )
      )
    )
  )
}
