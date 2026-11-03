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
#' A store keeps the options and whether they are loading; its `search`
#' action, the mention's `search` handler as upstream's `handleSearch`, looks
#' for a moment, then gives them.
#| shot_js = "var i = document.querySelector('#mention_load input'); i.focus(); i.value = '@ab'; i.dispatchEvent(new Event('input', {bubbles: true}));"
#| shot_wait = 3
#| shot_sel = ".el-mention-dropdown"
#| shot_expect = "document.querySelector('.el-mention-dropdown').innerText.indexOf('abFuphoenixes') >= 0"
vue_store(
  "mention_load_data",
  state = list(options = list(), loading = FALSE),
  actions = list(
    search = JS(
      "function(pattern) {",
      "  var self = this;",
      "  clearTimeout(this.timer);",
      "  this.loading = true;",
      "  this.timer = setTimeout(function() {",
      "    self.options = ['Fuphoenixes', 'kooriookami', 'Jeremy', 'btea'].map(",
      "      function(item) { return { label: pattern + item, value: pattern + item }; }",
      "    );",
      "    self.loading = false;",
      "  }, 1500);",
      "}"
    )
  )
)
el_mention(
  "mention_load",
  width = "320px",
  placeholder = "Please input",
  options = v_bind("$vueStore.mention_load_data.options"),
  loading = v_bind("$vueStore.mention_load_data.loading"),
  on = list(search = "$vueStore.mention_load_data.search")
)

## prefix
#' Which list the options are depends on the prefix typed: the store's
#' `search` action is called with the pattern and the prefix, as
#' upstream's `handleSearch`.
#| shot_js = "var i = document.querySelector('#mention_prefix input'); i.focus(); i.value = '#'; i.dispatchEvent(new Event('input', {bubbles: true}));"
#| shot_wait = 2
#| shot_sel = ".el-mention-dropdown"
#| shot_expect = "document.querySelector('.el-mention-dropdown').innerText.indexOf('2.0') >= 0"
vue_store(
  "mention_prefix_data",
  state = list(
    options = list(),
    mock = list(
      "@" = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"),
      "#" = c("1.0", "2.0", "3.0")
    )
  ),
  actions = list(
    search = JS(
      "function(_, prefix) {",
      "  this.options = (this.mock[prefix] || []).map(function(value) { return { value: value }; });",
      "}"
    )
  )
)
el_mention(
  "mention_prefix",
  width = "320px",
  prefix = c("@", "#"),
  placeholder = "input @ to mention people, # to mention tag",
  options = v_bind("$vueStore.mention_prefix_data.options"),
  on = list(search = "$vueStore.mention_prefix_data.search")
)

## whole
#' With `whole = TRUE` a backspace deletes a mention whole; the second
#' input's `check_is_whole` decides what counts as one, and its options
#' follow the prefix typed, as the one above.
#| shot_js = c("var i = document.querySelector('#mention_whole input'); i.focus(); i.value = '@Fuphoenixes '; i.dispatchEvent(new Event('input', {bubbles: true}));", "document.querySelector('#mention_whole input').dispatchEvent(new KeyboardEvent('keydown', {key: 'Backspace', code: 'Backspace', bubbles: true}));")
#| shot_expect = "document.querySelector('#mention_whole input').value === ''"
mock <- list(
  "@" = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"),
  "#" = c("1.0", "2.0", "3.0")
)
vue_store(
  "mention_whole_data",
  state = list(options = list(), mock = mock),
  actions = list(
    search = JS(
      "function(_, prefix) {",
      "  this.options = (this.mock[prefix] || []).map(function(value) { return { value: value }; });",
      "}"
    )
  )
)
el_mention(
  "mention_whole",
  whole = TRUE,
  width = "320px",
  placeholder = "Please input",
  options = mock[["@"]]
)
el_divider()
el_mention(
  "mention_whole2",
  prefix = c("@", "#"),
  whole = TRUE,
  width = "320px",
  placeholder = "input @ to mention people, # to mention tag",
  options = v_bind("$vueStore.mention_whole_data.options"),
  check_is_whole = JS(sprintf(
    "function(pattern, prefix) { return (%s[prefix] || []).indexOf(pattern) >= 0; }",
    jsonlite::toJSON(mock)
  )),
  on = list(search = "$vueStore.mention_whole_data.search")
)

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
