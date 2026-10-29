## alert
#' In the browser, Element's own services, `$alert()`, `$confirm()`,
#' `$prompt()` and `$msgbox()`, each a promise of the answer. From the
#' server it is `el_message_box(session, id, ...)`, the answer arriving as
#' `input$<id>`: see In Shiny below.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open the Message Box",
  plain = TRUE,
  on = list(
    click = "$alert('This is a message', 'Title', { confirmButtonText: 'OK', callback: (action) => $message({ type: 'info', message: 'action: ' + action }) })"
  )
)

## confirm
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open the Message Box",
  plain = TRUE,
  on = list(
    click = "$confirm('proxy will permanently delete the file. Continue?', 'Warning', { confirmButtonText: 'OK', cancelButtonText: 'Cancel', type: 'warning' }).then(() => $message({ type: 'success', message: 'Delete completed' })).catch(() => $message({ type: 'info', message: 'Delete canceled' }))"
  )
)

## prompt
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open Message Box",
  plain = TRUE,
  on = list(
    click = JS(
      "function() {
        var self = this;
        this.$prompt('Please input your e-mail', 'Tip', {
          confirmButtonText: 'OK',
          cancelButtonText: 'Cancel',
          inputPattern: /[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?/,
          inputErrorMessage: 'Invalid Email'
        }).then(function(r) {
          self.$message({ type: 'success', message: 'Your email is:' + r.value });
        }).catch(function() {
          self.$message({ type: 'info', message: 'Input canceled' });
        });
      }"
    )
  )
)

## use-vnode
#' A message can be a VNode, built with `Vue.h()`; one with props that
#' change -- the switch -- is a function returning the VNode, as upstream
#' says. A `JS()` handler, which can reach `Vue`, runs with the button as
#' `this`.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Common VNode",
  plain = TRUE,
  on = list(
    click = JS(
      "function() {
        this.$msgbox({
          title: 'Message',
          message: Vue.h('p', null, [
            Vue.h('span', null, 'Message can be '),
            Vue.h('i', { style: 'color: teal' }, 'VNode')
          ])
        });
      }"
    )
  )
)
el_button(
  "open1",
  "Dynamic props",
  plain = TRUE,
  on = list(
    click = JS(
      "function() {
        var checked = Vue.ref(false);
        this.$msgbox({
          title: 'Message',
          message: function() {
            return Vue.h(ElementPlus.ElSwitch, {
              modelValue: checked.value,
              'onUpdate:modelValue': function(v) { checked.value = v; }
            });
          }
        });
      }"
    )
  )
)

## use-vnode-with-action-handlers
#' A function message is handed the box's own actions, `confirm`, `cancel`
#' and `close`, for buttons of its own.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open Message Box",
  plain = TRUE,
  on = list(
    click = JS(
      "function() {
        var self = this;
        var button = function(props, text) {
          return Vue.h(ElementPlus.ElButton, props, function() { return text; });
        };
        this.$msgbox({
          title: 'Message',
          showConfirmButton: false,
          showCancelButton: false,
          distinguishCancelAndClose: true,
          message: function(actions) {
            return Vue.h('div', [
              Vue.h('p', { style: 'margin-bottom: 8px' },
                'Custom buttons with MessageBox action handlers'),
              button({ type: 'primary', onClick: function() { actions.confirm(); } }, 'Resolve'),
              button({ type: 'danger', onClick: function() { actions.cancel(); } }, 'Reject'),
              button({ onClick: function() { actions.close(); } }, 'Close')
            ]);
          }
        }).then(function(action) {
          self.$message({ type: 'info', message: 'action: ' + action });
        }).catch(function(action) {
          self.$message({ type: 'info', message: 'action: ' + action });
        });
      }"
    )
  )
)

## customization
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open Message Box",
  plain = TRUE,
  on = list(
    click = "$confirm('This is a message', 'Title', { showCancelButton: true, confirmButtonText: 'OK', cancelButtonText: 'Cancel', confirmButtonType: 'danger', buttonSize: 'small' })"
  )
)

## use-html
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open Message Box",
  plain = TRUE,
  on = list(
    click = "$alert('<strong>proxy is <i>HTML</i> string</strong>', 'HTML String', { dangerouslyUseHTMLString: true })"
  )
)

## distinguishable-close-cancel
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open Message Box",
  plain = TRUE,
  on = list(
    click = "$confirm('You have unsaved changes, save and proceed?', 'Confirm', { distinguishCancelAndClose: true, confirmButtonText: 'Save', cancelButtonText: 'Discard Changes' }).then(() => $message({ type: 'info', message: 'Changes saved. Proceeding to a new route.' })).catch((action) => $message({ type: 'info', message: action === 'cancel' ? 'Changes discarded. Proceeding to a new route.' : 'Stay in the current route' }))"
  )
)

## centered-content
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open Message Box",
  plain = TRUE,
  on = list(
    click = "$confirm('proxy will permanently delete the file. Continue?', 'Warning', { confirmButtonText: 'OK', cancelButtonText: 'Cancel', type: 'warning', center: true })"
  )
)

## customized-icon
#' An icon component as the box's icon: in the browser, Element's icons
#' are `ElementPlusIconsVue`, reached from a `JS()` handler.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open Message Box",
  plain = TRUE,
  on = list(
    click = JS(
      "function() {
        this.$confirm('Are you sure to delete this?', 'Warning', {
          type: 'warning',
          icon: Vue.markRaw(ElementPlusIconsVue.Delete),
          confirmButtonText: 'OK',
          cancelButtonText: 'Cancel'
        });
      }"
    )
  )
)

## draggable
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
el_button(
  "open",
  "Click to open Message Box",
  plain = TRUE,
  on = list(
    click = "$confirm('proxy will permanently delete the file. Continue?', 'Warning', { confirmButtonText: 'OK', cancelButtonText: 'Cancel', type: 'warning', draggable: true })"
  )
)

## in-shiny
#' From the server, `el_message_box(session, id, ...)` asks the user, with
#' Element's options in snake_case; the answer is `input$<id>`:
#' `"confirm"`, `"cancel"` or `"close"`, and for a prompt
#' `list(action, value)`.
#| shot_js = "document.querySelector('#delete_container button').click()", shot_sel = ".el-message-box", shot_wait = 1
ui <- el_page(
  el_button("delete", "Delete the file", type = "danger", plain = TRUE),
  verbatimTextOutput("answer_seen")
)
server <- function(input, output, session) {
  observeEvent(input$delete, {
    el_message_box(
      session,
      "answer",
      "proxy will permanently delete the file. Continue?",
      title = "Warning",
      type = "warning",
      confirm_button_text = "OK",
      cancel_button_text = "Cancel"
    )
  })
  output$answer_seen <- renderPrint(input$answer)
}
shinyApp(ui, server)
