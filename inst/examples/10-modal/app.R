################################################################################
#' This example app shows how modals can be created
#'
#' First, we create a twBtnOpenModal button which will open the modal.
#' Then we create the contents/UI of the modal, which is then in the third and
#' final step included in the twModalDialog.
#'
################################################################################

library(shiny)
library(shiny.tailwind)
library(fontawesome)

# 1) Define the open modal button ----
modal_btn <- twBtnOpenModal(
  "open_modal", "Show Modal to Delete Account",
  btn_class = "px-5 py-2 bg-rose-500 hover:bg-rose-700 text-white cursor-pointer rounded-md",
  icon = icon("check")
)

# 2) Define the content of the modal ----
# note that we could have shiny inputs/outputs here as well
modal_ui <- div(
  class = "mt-2",
  p(class = "text-sm text-gray-500",
    paste("Are you sure you want to deactivate your account?",
          "All of your data will be permanently removed.",
          "This action cannot be undone.")
  )
)

# 3) Define the full modal dialog ----
modal <- twModalDialog(
  ui = modal_ui, title = "Delete Account",
  close_id = "close_modal", close_label = tagList(icon("times", class = "px-1"), "Close"),
  submit_id = "submit_modal", submit_label = tagList(icon("trash", class = "px-1"), "Delete"),
)


# 4) Bring the UI elements together for the shiny ui ----
ui <- div(
  class = "h-screen p-20 bg-stone-100",
  use_tailwind(),
  fa_html_dependency(),
  modal_btn,
  modal
)


# 5) Define the server functionality ----
server <- function(input, output, session) {
  observeEvent(input$open_modal, {
    print("Modal Opened")
  })
  observeEvent(input$submit_modal, {
    print("Modal Closed - Submitted; Delete Account")
  })
  observeEvent(input$close_modal, {
    print("Modal Closed - Closed")
  })
}


# 6) Run the application ----
shinyApp(ui, server)
