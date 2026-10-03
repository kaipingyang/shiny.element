## alert
#' The answer is `input$<id>`: `"confirm"`, `"cancel"` or `"close"`.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open the Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$open,
    el_message_box(
      session,
      "answer",
      "This is a message",
      title = "Title",
      box_type = "alert",
      confirm_button_text = "OK"
    )
  )
}
shinyApp(ui, server)

## confirm
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open the Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$open,
    el_message_box(
      session,
      "answer",
      "proxy will permanently delete the file. Continue?",
      title = "Warning",
      type = "warning",
      confirm_button_text = "OK",
      cancel_button_text = "Cancel"
    )
  )
  observeEvent(
    input$answer,
    el_message(session, paste("Answer:", input$answer))
  )
}
shinyApp(ui, server)

## prompt
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$open,
    el_message_box(
      session,
      "email",
      "Please input your e-mail",
      title = "Tip",
      box_type = "prompt",
      confirm_button_text = "OK",
      cancel_button_text = "Cancel",
      input_pattern = "[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?",
      input_error_message = "Invalid Email"
    )
  )
}
shinyApp(ui, server)

## use-vnode
#' A message can be a VNode, built in the browser: give it as `JS()` code
#' calling `Vue.h()`. One with props that change -- the switch -- is a
#' function returning the VNode, as upstream says.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(
  el_button("open", "Common VNode", plain = TRUE),
  el_button("open1", "Dynamic props", plain = TRUE)
)
server <- function(input, output, session) {
  observeEvent(input$open, {
    el_message_box(
      session,
      "vn",
      JS(
        "Vue.h('p', null, [
          Vue.h('span', null, 'Message can be '),
          Vue.h('i', { style: 'color: teal' }, 'VNode')
        ])"
      ),
      title = "Message",
      box_type = "alert"
    )
  })
  observeEvent(input$open1, {
    el_message_box(
      session,
      "vn1",
      JS(
        "(function() {
          var checked = Vue.ref(false);
          return function() {
            return Vue.h(ElementPlus.ElSwitch, {
              modelValue: checked.value,
              'onUpdate:modelValue': function(v) { checked.value = v; }
            });
          };
        })()"
      ),
      title = "Message",
      box_type = "alert"
    )
  })
}
shinyApp(ui, server)

## use-vnode-with-action-handlers
#' A function message is handed the box's own actions, `confirm`, `cancel`
#' and `close`, for buttons of its own. The answer reaches the server as
#' `input$handled`, as for any message box.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(input$open, {
    el_message_box(
      session,
      "handled",
      JS(
        "function({ confirm, cancel, close }) {
          var button = function(props, text) {
            return Vue.h(ElementPlus.ElButton, props, function() { return text; });
          };
          return Vue.h('div', [
            Vue.h('p', { style: 'margin-bottom: 8px' },
              'Custom buttons with MessageBox action handlers'),
            button({ type: 'primary', onClick: function() { confirm(); } }, 'Resolve'),
            button({ type: 'danger', onClick: function() { cancel(); } }, 'Reject'),
            button({ onClick: function() { close(); } }, 'Close')
          ]);
        }"
      ),
      title = "Message",
      show_confirm_button = FALSE,
      show_cancel_button = FALSE,
      distinguish_cancel_and_close = TRUE
    )
  })
  observeEvent(
    input$handled,
    el_message(session, paste("Answer:", input$handled))
  )
}
shinyApp(ui, server)

## customization
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$open,
    el_message_box(
      session,
      "answer",
      "This is a message",
      title = "Title",
      show_cancel_button = TRUE,
      confirm_button_text = "OK",
      cancel_button_text = "Cancel",
      confirm_button_type = "danger",
      button_size = "small"
    )
  )
}
shinyApp(ui, server)

## use-html
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$open,
    el_message_box(
      session,
      "answer",
      "<strong>proxy is <i>HTML</i> string</strong>",
      title = "HTML String",
      box_type = "alert",
      dangerously_use_html_string = TRUE
    )
  )
}
shinyApp(ui, server)

## distinguishable-close-cancel
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$open,
    el_message_box(
      session,
      "answer",
      "You have unsaved changes, save and proceed?",
      title = "Confirm",
      distinguish_cancel_and_close = TRUE,
      confirm_button_text = "Save",
      cancel_button_text = "Discard Changes"
    )
  )
}
shinyApp(ui, server)

## centered-content
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$open,
    el_message_box(
      session,
      "answer",
      "proxy will permanently delete the file. Continue?",
      title = "Warning",
      type = "warning",
      center = TRUE,
      confirm_button_text = "OK",
      cancel_button_text = "Cancel"
    )
  )
}
shinyApp(ui, server)

## customized-icon
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$open,
    el_message_box(
      session,
      "answer",
      "Are you sure to delete this?",
      title = "Warning",
      type = "warning",
      icon = "Delete",
      confirm_button_text = "OK",
      cancel_button_text = "Cancel"
    )
  )
}
shinyApp(ui, server)

## draggable
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(el_button("open", "Click to open Message Box", plain = TRUE))
server <- function(input, output, session) {
  observeEvent(
    input$open,
    el_message_box(
      session,
      "answer",
      "proxy will permanently delete the file. Continue?",
      title = "Warning",
      type = "warning",
      draggable = TRUE,
      confirm_button_text = "OK",
      cancel_button_text = "Cancel"
    )
  )
}
shinyApp(ui, server)
