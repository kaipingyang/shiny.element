## basic
el_mention(
  "mention",
  value = "@",
  width = "320px",
  placeholder = "Please input",
  options = c("Fuphoenixes", "kooriookami", "Jeremy", "btea")
)

## props
el_mention(
  "mention_props",
  value = "@",
  width = "320px",
  placeholder = "Please input",
  props = list(label = "name", value = "id", disabled = "unable"),
  options = list(
    list(name = "Fuphoenixes", id = "Fuphoenixes", unable = TRUE),
    list(name = "kooriookami", id = "kooriookami"),
    list(name = "Jeremy", id = "Jeremy", unable = TRUE),
    list(name = "btea", id = "btea")
  )
)

## textarea
el_mention(
  "mention_area",
  type = "textarea",
  width = "320px",
  placeholder = "Please input",
  options = c("Fuphoenixes", "kooriookami", "Jeremy", "btea")
)

## label
#| shot_js = "var i = document.querySelector('#mention_label input'); i.focus(); i.value = '@'; i.dispatchEvent(new Event('input', {bubbles: true}));"
#| shot_sel = ".el-mention-dropdown"
#| shot_expect = "document.querySelectorAll('.el-mention-dropdown .el-avatar').length === 4"
avatars <- c(
  Fuphoenixes = "https://avatars.githubusercontent.com/u/27912232",
  kooriookami = "https://avatars.githubusercontent.com/u/38392315",
  Jeremy = "https://avatars.githubusercontent.com/u/15975785",
  btea = "https://avatars.githubusercontent.com/u/24516654"
)
el_mention(
  "mention_label",
  width = "320px",
  placeholder = "Please input",
  options = unname(Map(
    function(value, avatar) list(value = value, avatar = avatar),
    names(avatars),
    avatars
  )),
  slots = list(
    label = template(
      slot = "label",
      scope = "{ item }",
      htmltools::HTML(paste0(
        "<div style=\"display: flex; align-items: center\">",
        "<el-avatar :size=\"24\" :src=\"item.avatar\" />",
        "<span style=\"margin-left: 6px\">{{ item.value }}</span></div>"
      ))
    )
  )
)

## loading
#' `input$<id>_search` is the text after the prefix, as it is typed; the
#' server shows `loading` while it looks, then answers with the options.
#| shot_js = "var i = document.querySelector('#mention_load input'); i.focus(); i.value = '@ab'; i.dispatchEvent(new Event('input', {bubbles: true}));"
#| shot_wait = 3
#| shot_sel = ".el-mention-dropdown"
#| shot_expect = "document.querySelector('.el-mention-dropdown').innerText.indexOf('abFuphoenixes') >= 0"
ui <- el_page(
  el_mention("mention_load", width = "320px", placeholder = "Please input")
)
server <- function(input, output, session) {
  observeEvent(input$mention_load_search, {
    pattern <- input$mention_load_search$pattern
    update_el_mention(session, "mention_load", loading = TRUE)
    later::later(
      function() {
        names <- paste0(
          pattern,
          c("Fuphoenixes", "kooriookami", "Jeremy", "btea")
        )
        update_el_mention(
          session,
          "mention_load",
          options = stats::setNames(names, names),
          loading = FALSE
        )
      },
      1.5
    )
  })
}
shinyApp(ui, server)

## prefix
#' Which list the server answers with depends on the prefix typed.
#| shot_js = "var i = document.querySelector('#mention_prefix input'); i.focus(); i.value = '#'; i.dispatchEvent(new Event('input', {bubbles: true}));"
#| shot_wait = 2
#| shot_sel = ".el-mention-dropdown"
#| shot_expect = "document.querySelector('.el-mention-dropdown').innerText.indexOf('2.0') >= 0"
mock <- list(
  "@" = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"),
  "#" = c("1.0", "2.0", "3.0")
)
ui <- el_page(
  el_mention(
    "mention_prefix",
    width = "320px",
    prefix = c("@", "#"),
    placeholder = "input @ to mention people, # to mention tag"
  )
)
server <- function(input, output, session) {
  observeEvent(input$mention_prefix_search, {
    update_el_mention(
      session,
      "mention_prefix",
      options = mock[[input$mention_prefix_search$prefix]] %||% character()
    )
  })
}
shinyApp(ui, server)

## whole
#' With `whole = TRUE` a backspace deletes a mention whole; the second
#' input's `check_is_whole` decides what counts as one.
#| shot_js = c("var i = document.querySelector('#mention_whole input'); i.focus(); i.value = '@Fuphoenixes '; i.dispatchEvent(new Event('input', {bubbles: true}));", "document.querySelector('#mention_whole input').dispatchEvent(new KeyboardEvent('keydown', {key: 'Backspace', code: 'Backspace', bubbles: true}));")
#| shot_expect = "document.querySelector('#mention_whole input').value === ''"
mock <- list(
  "@" = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"),
  "#" = c("1.0", "2.0", "3.0")
)
ui <- el_page(
  el_mention(
    "mention_whole",
    whole = TRUE,
    width = "320px",
    placeholder = "Please input",
    options = mock[["@"]]
  ),
  el_divider(),
  el_mention(
    "mention_whole2",
    prefix = c("@", "#"),
    whole = TRUE,
    width = "320px",
    placeholder = "input @ to mention people, # to mention tag",
    check_is_whole = JS(sprintf(
      "function(pattern, prefix) { return (%s[prefix] || []).indexOf(pattern) >= 0; }",
      jsonlite::toJSON(mock)
    ))
  )
)
server <- function(input, output, session) {
  observeEvent(input$mention_whole2_search, {
    update_el_mention(
      session,
      "mention_whole2",
      options = mock[[input$mention_whole2_search$prefix]] %||% character()
    )
  })
}
shinyApp(ui, server)

## form
#| shot_js = "document.querySelector('#mention_form .el-button--primary').click()"
#| shot_expect = "document.querySelectorAll('#mention_form .el-form-item__error').length === 2"
people <- c("Fuphoenixes", "kooriookami", "Jeremy", "btea")
el_form(
  id = "mention_form",
  label_width = NULL,
  width = "600px",
  submit_label = "Submit",
  reset_label = "Reset",
  el_form_field(
    "name",
    "mention",
    label = "name",
    choices = people,
    rules = el_rule(required = TRUE, message = "Please input name")
  ),
  el_form_field(
    "desc",
    "mention-textarea",
    label = "desc",
    choices = people,
    rules = el_rule(required = TRUE, message = "Please input desc")
  )
)
