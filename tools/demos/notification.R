## basic
#' In the browser, Element's own service, `$notify()`, in an `on` handler.
#' From the server it is `el_notification(session, ...)`, with the same
#' options in snake_case: see In Shiny below.
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
el_button(
  "show",
  "Closes automatically",
  plain = TRUE,
  on = list(
    click = "$notify({ title: 'Title', message: 'This is a reminder' })"
  )
)

## different-types
#| shot_js = "document.querySelectorAll('#shot button').forEach(function(b){ b.click(); })", shot_sel = ".el-notification", shot_wait = 1
types <- c("primary", "success", "warning", "info", "error")
tagList(lapply(types, function(t) {
  el_button(
    paste0("n_", t),
    tools::toTitleCase(t),
    plain = TRUE,
    on = list(
      click = sprintf(
        "$notify({ title: '%s', message: 'This is a %s message', type: '%s' })",
        tools::toTitleCase(t),
        t,
        t
      )
    )
  )
}))

## positioning
#| shot_js = "document.querySelectorAll('#shot button').forEach(function(b){ b.click(); })", shot_sel = ".el-notification", shot_wait = 1
pos <- c("top-right", "bottom-right", "bottom-left", "top-left")
tagList(lapply(pos, function(p) {
  el_button(
    paste0("n_", gsub("-", "_", p)),
    p,
    plain = TRUE,
    on = list(
      click = sprintf(
        "$notify({ title: 'Custom Position', message: \"I'm at the %s corner\", position: '%s' })",
        p,
        p
      )
    )
  )
}))

## offsetting
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
el_button(
  "show",
  "Notification with offset",
  plain = TRUE,
  on = list(
    click = "$notify({ title: 'Success', message: 'This is a success message', offset: 100 })"
  )
)

## raw-html
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
el_button(
  "show",
  "Use HTML String",
  plain = TRUE,
  on = list(
    click = "$notify({ title: 'HTML String', dangerouslyUseHTMLString: true, message: '<strong>This is <i>HTML</i> string</strong>' })"
  )
)

## use-vnode
#' A message can be a VNode, built with `Vue.h()`; one whose props change is
#' a function returning it. A `JS()` handler, which can reach `Vue`, runs
#' with the button as `this`.
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-notification", shot_wait = 1
el_button(
  "open",
  "Common VNode",
  plain = TRUE,
  on = list(
    click = JS(
      "function() {
        this.$notify({
          title: 'Use Vnode',
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
        this.$notify({
          title: 'Use Vnode',
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

## progress-bar
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
el_button(
  "show",
  "With progress bar",
  plain = TRUE,
  on = list(
    click = "$notify({ title: 'Progress', message: 'Closes when the bar runs out', progress: true, duration: 5000 })"
  )
)

## no-close
#| shot_js = "document.querySelector('#show_container button').click()", shot_sel = ".el-notification", shot_wait = 1
el_button(
  "show",
  "Hide close button",
  plain = TRUE,
  on = list(
    click = "$notify({ title: 'Info', message: 'This is a message without close button', type: 'info', showClose: false })"
  )
)

## in-shiny
#' From the server, `el_notification(session, ...)` tells of what the
#' server did, with Element's options in snake_case. Given an `id`,
#' `input$<id>_click` and `input$<id>_close` report it clicked and closed,
#' and `el_notification_close()` closes it.
#| shot_js = "document.querySelector('#run_container button').click()", shot_sel = ".el-notification", shot_wait = 1.5
ui <- el_page(el_button("run", "Run the report", type = "primary"))
server <- function(input, output, session) {
  observeEvent(input$run, {
    # ... the server's work ...
    el_notification(
      session,
      title = "Report ready",
      message = "12 rows written.",
      type = "success",
      id = "done"
    )
  })
  observeEvent(input$done_click, el_message(session, "Opening the report"))
}
shinyApp(ui, server)
