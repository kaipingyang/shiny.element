## basic-usage
#' The dialog's `visible` follows a store's field, [v_model()]: the button
#' sets it, and closing the dialog -- its cross, Escape, the mask, a button
#' in its footer -- sets it back, in the browser. `before_close`, a `JS()`
#' function, may hold the close back. In an app the server opens it too,
#' `update_el_dialog(visible = TRUE)`, and `input$<id>` is whether it is
#' open.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5, shot_expect = "document.getElementById('tips').style.display !== 'none'"
vue_store("basic", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open the Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.basic.visible = true")
)
el_dialog(
  "tips",
  title = "Tips",
  width = "500px",
  visible = v_model("$vueStore.basic.visible"),
  content = tags$span("This is a message"),
  before_close = JS(
    "function(done) { if (confirm('Are you sure to close this dialog?')) done(); }"
  ),
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$vueStore.basic.visible = false")
    ),
    el_button(
      "confirm",
      "Confirm",
      type = "primary",
      on = list(click = "$vueStore.basic.visible = false")
    )
  )
)

## customization-content
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
vue_store("form_dialog", state = list(visible = FALSE))
el_button(
  "open",
  "Open a Form nested Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.form_dialog.visible = true")
)
el_dialog(
  "shipping",
  title = "Shipping address",
  width = "500px",
  visible = v_model("$vueStore.form_dialog.visible"),
  content = tagList(
    el_input(
      "name",
      label = "Promotion name",
      label_position = "left",
      label_width = "140px"
    ),
    el_select(
      "zone",
      choices = c("Zone No.1" = "shanghai", "Zone No.2" = "beijing"),
      placeholder = "Please select a zone",
      label = "Zones",
      label_position = "left",
      label_width = "140px"
    )
  ),
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$vueStore.form_dialog.visible = false")
    ),
    el_button(
      "confirm",
      "Confirm",
      type = "primary",
      on = list(click = "$vueStore.form_dialog.visible = false")
    )
  )
)

## customization-header
#' The title takes markup: a header of your own.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
vue_store("header_dialog", state = list(visible = FALSE))
el_button(
  "open",
  "Open Dialog with customized header",
  plain = TRUE,
  on = list(click = "$vueStore.header_dialog.visible = true")
)
el_dialog(
  "custom",
  show_close = FALSE,
  width = "500px",
  visible = v_model("$vueStore.header_dialog.visible"),
  title = tags$div(
    style = "display: flex; justify-content: space-between; align-items: center",
    tags$h4("This is a custom header!"),
    el_button(
      "close",
      "Close",
      type = "danger",
      icon = "CircleCloseFilled",
      on = list(click = "$vueStore.header_dialog.visible = false")
    )
  ),
  content = "This is dialog content."
)

## nested-dialog
#| shot_js = "document.querySelector('#open_container button').click(); setTimeout(function(){ document.querySelector('#inner_open_container button').click(); }, 800);", shot_sel = ".el-dialog", shot_wait = 2
vue_store("nested", state = list(outer = FALSE, inner = FALSE))
el_button(
  "open",
  "Open the outer Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.nested.outer = true")
)
el_dialog(
  "outer",
  title = "Outer Dialog",
  width = "800px",
  visible = v_model("$vueStore.nested.outer"),
  content = tagList(
    tags$span("This is the outer Dialog"),
    el_dialog(
      "inner",
      title = "Inner Dialog",
      width = "500px",
      append_to_body = TRUE,
      visible = v_model("$vueStore.nested.inner"),
      content = "This is the inner Dialog"
    )
  ),
  footer = el_button(
    "inner_open",
    "Open the inner Dialog",
    type = "primary",
    on = list(click = "$vueStore.nested.inner = true")
  )
)

## centered-content
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
vue_store("centered", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open the Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.centered.visible = true")
)
el_dialog(
  "warn",
  title = "Warning",
  width = "500px",
  center = TRUE,
  visible = v_model("$vueStore.centered.visible"),
  content = "It should be noted that the content will not be aligned in center by default",
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$vueStore.centered.visible = false")
    ),
    el_button(
      "confirm",
      "Confirm",
      type = "primary",
      on = list(click = "$vueStore.centered.visible = false")
    )
  )
)

## align-center
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
vue_store("aligned", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open the Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.aligned.visible = true")
)
el_dialog(
  "warn",
  title = "Warning",
  width = "500px",
  align_center = TRUE,
  visible = v_model("$vueStore.aligned.visible"),
  content = "Open the dialog from the center from the screen",
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$vueStore.aligned.visible = false")
    ),
    el_button(
      "confirm",
      "Confirm",
      type = "primary",
      on = list(click = "$vueStore.aligned.visible = false")
    )
  )
)

## destroy-on-close
#' Its content made again each time it opens: inputs inside start fresh.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
vue_store("notice_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.notice_ui.visible = true")
)
el_dialog(
  "notice",
  title = "Notice",
  width = "500px",
  destroy_on_close = TRUE,
  center = TRUE,
  visible = v_model("$vueStore.notice_ui.visible"),
  content = tagList(
    tags$p(
      "Notice: before dialog gets opened for the first time this node and the one below will not be rendered"
    ),
    el_input("note", placeholder = "starts empty each time")
  )
)

## draggable-dialog
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
vue_store("drag_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.drag_ui.visible = true")
)
el_dialog(
  "drag",
  title = "Tips",
  width = "500px",
  draggable = TRUE,
  visible = v_model("$vueStore.drag_ui.visible"),
  content = "It's a draggable Dialog"
)

## fullscreen
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
vue_store("full_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Open the fullscreen Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.full_ui.visible = true")
)
el_dialog(
  "full",
  title = "Tips",
  fullscreen = TRUE,
  visible = v_model("$vueStore.full_ui.visible"),
  content = "It's a fullscreen Dialog"
)

## modal
#' Without a backdrop the page beneath stays in view, and with
#' `modal_penetrable` it can be used too.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
vue_store("nomodal_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Open the modal-less Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.nomodal_ui.visible = true")
)
el_dialog(
  "nomodal",
  title = "Tips",
  width = "500px",
  modal = FALSE,
  modal_penetrable = TRUE,
  visible = v_model("$vueStore.nomodal_ui.visible"),
  content = "It's a modal-less Dialog"
)

## custom-animation
#' `transition` names a CSS animation of your own, as Element Plus's does.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
tags$style(".dialog-bounce-enter-active { animation: dialog-fade-in .5s; }")
vue_store("anim_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Open the Dialog",
  plain = TRUE,
  on = list(click = "$vueStore.anim_ui.visible = true")
)
el_dialog(
  "anim",
  title = "Custom animation",
  width = "500px",
  transition = "dialog-bounce",
  visible = v_model("$vueStore.anim_ui.visible"),
  content = "This dialog plays an animation of its own."
)

## events
#' `input$<id>_closed` is reported unasked; `_open`, `_opened`, `_close`,
#' `_open_auto_focus` and `_close_auto_focus` when asked for, with
#' `events`.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Open the Dialog", plain = TRUE),
  el_dialog(
    "ev",
    title = "Events",
    width = "500px",
    events = c("open", "opened", "close"),
    content = verbatimTextOutput("log")
  )
)
server <- function(input, output, session) {
  seen <- reactiveVal(character())
  for (e in c("open", "opened", "close", "closed")) {
    local({
      e <- e
      observeEvent(input[[paste0("ev_", e)]], seen(c(seen(), e)))
    })
  }
  output$log <- renderText(paste(seen(), collapse = "\n"))
  observeEvent(input$open, update_el_dialog(id = "ev", visible = TRUE))
}
shinyApp(ui, server)

## in-shiny
#' From the server, `update_el_dialog(visible = TRUE)` opens a dialog after
#' the server's work -- here, once a row is picked to edit -- and
#' `input$<id>` is whether it is open, closed by its user or by the server.
#| shot_js = "document.querySelector('#edit_container button').click()", shot_sel = ".el-dialog", shot_wait = 1.5
ui <- el_page(
  el_button("edit", "Edit the record", type = "primary"),
  el_dialog(
    "editor",
    title = "Edit",
    width = "500px",
    content = el_input("record", label = "Name"),
    footer = el_button("save", "Save", type = "primary")
  ),
  verbatimTextOutput("open_seen")
)
server <- function(input, output, session) {
  observeEvent(input$edit, {
    update_el_input(session, "record", value = "Tom") # read from the data
    update_el_dialog(session, "editor", visible = TRUE)
  })
  observeEvent(input$save, {
    # ... saved by the server ...
    update_el_dialog(session, "editor", visible = FALSE)
    el_message(session, paste("Saved", input$record), type = "success")
  })
  output$open_seen <- renderPrint(input$editor)
}
shinyApp(ui, server)
