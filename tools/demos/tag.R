## basic
types <- c("primary", "success", "info", "warning", "danger")
tagList(lapply(types, function(t) {
  el_tag(paste0("t_", t), paste("Tag", match(t, types)), type = t)
}))

## removable
types <- c("primary", "success", "info", "warning", "danger")
tagList(lapply(types, function(t) {
  el_tag(
    paste0("r_", t),
    paste("Tag", match(t, types)),
    type = t,
    closable = TRUE
  )
}))

## editable
#' Tags the user adds and removes, as upstream's: `el$tag()` in a
#' [vue_app()], a `v_for()` over its list, the input shown in the button's
#' place with `v_if()` and `v_else()`.
#| shot_js = "document.querySelector('#tags_edit .button-new-tag').click(); setTimeout(function(){ var i = document.querySelector('#tags_edit input'); i.value = 'Tag 4'; i.dispatchEvent(new Event('input')); i.dispatchEvent(new KeyboardEvent('keyup', {key: 'Enter', bubbles: true})); }, 400);", shot_wait = 2
vue_app(
  "tags_edit",
  tags$div(
    class = "flex gap-2",
    style = "display: flex; gap: 8px",
    el$tag(
      v_for("tag in dynamicTags", key = "tag"),
      closable = NA,
      `:disable-transitions` = "false",
      v_on(close = "handleClose(tag)"),
      "{{ tag }}"
    ),
    el$input(
      v_if("inputVisible"),
      ref = "InputRef",
      v_model("inputValue"),
      style = "width: 80px",
      size = "small",
      v_on("keyup.enter" = "handleInputConfirm", blur = "handleInputConfirm")
    ),
    el$button(
      v_else(),
      class = "button-new-tag",
      size = "small",
      v_on(click = "showInput"),
      "+ New Tag"
    )
  ),
  data = list(
    inputValue = "",
    dynamicTags = list("Tag 1", "Tag 2", "Tag 3"),
    inputVisible = FALSE
  ),
  methods = list(
    handleClose = JS(
      "function(tag) { this.dynamicTags.splice(this.dynamicTags.indexOf(tag), 1); }"
    ),
    showInput = JS(
      "function() {",
      "  var self = this;",
      "  this.inputVisible = true;",
      "  this.$nextTick(function() { self.$refs.InputRef.input.focus(); });",
      "}"
    ),
    handleInputConfirm = JS(
      "function() {",
      "  if (this.inputValue) this.dynamicTags.push(this.inputValue);",
      "  this.inputVisible = false;",
      "  this.inputValue = '';",
      "}"
    )
  ),
  use = "shinyElement.plugin"
)

## sizes
tagList(
  el_tag("s1", "Large", size = "large"),
  el_tag("s2", "Default"),
  el_tag("s3", "Small", size = "small"),
  tags$br(),
  tags$br(),
  el_tag("s4", "Large", size = "large", closable = TRUE),
  el_tag("s5", "Default", closable = TRUE),
  el_tag("s6", "Small", size = "small", closable = TRUE)
)

## theme
#' `effect` is `"dark"`, `"light"` (the default) or `"plain"`.
types <- c("primary", "success", "info", "warning", "danger")
tagList(lapply(c("dark", "light", "plain"), function(e) {
  tags$div(
    style = "margin-bottom: 10px",
    tags$span(style = "display: inline-block; width: 50px", e),
    lapply(types, function(t) el_tag(paste0(e, t), t, type = t, effect = e))
  )
}))

## rounded
types <- c("primary", "success", "info", "warning", "danger")
tagList(lapply(c("dark", "light", "plain"), function(e) {
  tags$div(
    style = "margin-bottom: 10px",
    lapply(types, function(t) {
      el_tag(paste0("rd", e, t), t, type = t, effect = e, round = TRUE)
    })
  )
}))

## checkable
#' A tag that toggles, like a checkbox, is `el_check_tag()`; it reports
#' `input$<id>` as `TRUE` or `FALSE`.
tagList(
  el_check_tag("ct1", "Checked", value = TRUE),
  el_check_tag("ct2", "Toggle me"),
  el_check_tag("ct3", "Disabled", disabled = TRUE),
  tags$br(),
  tags$br(),
  lapply(c("primary", "success", "info", "warning", "danger"), function(t) {
    el_check_tag(paste0("ctt", t), t, type = t, value = TRUE)
  })
)
