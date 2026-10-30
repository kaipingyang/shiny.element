## basic-usage
#' The radios set the edge it slides from, the drawers' `direction`
#' following them with [v_bind()]; each opens from a store's field,
#' [v_model()],
#' and closing the first asks first, through `before_close`.
#| shot_js = c("Array.from(document.querySelectorAll('#direction .el-radio')).find(function(r){ return r.innerText.indexOf('top to bottom') >= 0; }).click()", "document.querySelector('#open_container button').click()")
#| shot_sel = ".el-drawer"
#| shot_wait = 1.5
#| shot_expect = "document.querySelector('#drw .el-drawer.ttb')"
vue_store(
  "drawers",
  state = list(first = FALSE, second = FALSE, choice = "Option 1")
)
el_radio_group(
  "direction",
  choices = c(
    "left to right" = "ltr",
    "right to left" = "rtl",
    "top to bottom" = "ttb",
    "bottom to top" = "btt"
  ),
  value = "rtl"
)
el_button(
  "open",
  "open",
  type = "primary",
  on = list(click = "$vueStore.drawers.first = true")
)
el_button(
  "open2",
  "with footer",
  type = "primary",
  on = list(click = "$vueStore.drawers.second = true")
)
el_drawer(
  "drw",
  title = "I am the title",
  visible = v_model("$vueStore.drawers.first"),
  direction = v_bind("$inputs.direction"),
  before_close = JS(
    "function(done) { if (confirm('Are you sure you want to close this?')) done(); }"
  ),
  content = tags$span("Hi, there!")
)
el_drawer(
  "drw2",
  title = tags$h4("set title by slot"),
  visible = v_model("$vueStore.drawers.second"),
  direction = v_bind("$inputs.direction"),
  content = el_radio_group(
    "radio1",
    choices = c("Option 1", "Option 2"),
    value = v_model("$vueStore.drawers.choice"),
    size = "large"
  ),
  footer = tags$div(
    style = "flex: auto",
    el_button(
      "cancel",
      "cancel",
      on = list(click = "$vueStore.drawers.second = false")
    ),
    el_button(
      "confirm",
      "confirm",
      type = "primary",
      on = list(
        click = "$vueStore.drawers.second = false; $message('You chose ' + $vueStore.drawers.choice)"
      )
    )
  )
)

## no-title
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-drawer", shot_wait = 1.5
vue_store("untitled", state = list(visible = FALSE))
el_button(
  "open",
  "open",
  type = "primary",
  on = list(click = "$vueStore.untitled.visible = true")
)
el_drawer(
  "drw",
  title = "I am the title",
  with_header = FALSE,
  visible = v_model("$vueStore.untitled.visible"),
  content = tags$span("Hi there!")
)

## customization-content
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-drawer", shot_wait = 1.5
vue_store("form_drawer", state = list(visible = FALSE))
el_button(
  "open",
  "Open Drawer with nested form",
  text = TRUE,
  on = list(click = "$vueStore.form_drawer.visible = true")
)
el_drawer(
  "drw",
  title = "I have a nested form inside!",
  direction = "ltr",
  size = "40%",
  visible = v_model("$vueStore.form_drawer.visible"),
  content = tagList(
    el_input(
      "name",
      label = "Name",
      label_position = "left",
      label_width = "80px"
    ),
    el_select(
      "area",
      choices = c("Area1" = "shanghai", "Area2" = "beijing"),
      label = "Area",
      label_position = "left",
      label_width = "80px"
    )
  ),
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$vueStore.form_drawer.visible = false")
    ),
    el_button(
      "submit",
      "Submit",
      type = "primary",
      on = list(click = "$vueStore.form_drawer.visible = false")
    )
  )
)

## customization-header
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-drawer", shot_wait = 1.5
vue_store("header_drawer", state = list(visible = FALSE))
el_button(
  "open",
  "Open Drawer with customized header",
  on = list(click = "$vueStore.header_drawer.visible = true")
)
el_drawer(
  "drw",
  show_close = FALSE,
  visible = v_model("$vueStore.header_drawer.visible"),
  content = "This is drawer content.",
  title = tags$div(
    style = "display: flex; justify-content: space-between; align-items: center",
    tags$h4("This is a custom header!"),
    el_button(
      "close",
      "Close",
      type = "danger",
      icon = "CircleCloseFilled",
      on = list(click = "$vueStore.header_drawer.visible = false")
    )
  )
)

## resizable
#' Picking an edge opens it there; dragging its inner edge resizes it,
#' reported as `input$<id>_resize`.
#| shot_js = "Array.from(document.querySelectorAll('#direction .el-radio-button')).find(function(r){ return r.innerText.trim() === 'bottom'; }).click()"
#| shot_sel = ".el-drawer"
#| shot_wait = 1.5
#| shot_expect = c("document.querySelector('#drw .el-drawer.btt')", "getComputedStyle(document.getElementById('drw')).display !== 'none'")
vue_store("resizing", state = list(visible = FALSE))
el_radio_group(
  "direction",
  choices = c(top = "ttb", right = "rtl", bottom = "btt", left = "ltr"),
  value = "rtl",
  button = TRUE,
  on = list(change = "$vueStore.resizing.visible = true")
)
el_drawer(
  "drw",
  direction = v_bind("$inputs.direction"),
  visible = v_model("$vueStore.resizing.visible"),
  resizable = TRUE,
  content = "This is drawer content."
)

## nested-drawer
#| shot_js = "document.querySelector('#open_container button').click(); setTimeout(function(){ document.querySelector('#inner_open_container button').click(); }, 800);", shot_sel = ".el-drawer", shot_wait = 2
vue_store("nested_drawers", state = list(outer = FALSE, inner = FALSE))
el_button(
  "open",
  "open",
  type = "primary",
  on = list(click = "$vueStore.nested_drawers.outer = true")
)
el_drawer(
  "outer",
  title = "I'm outer Drawer",
  size = "50%",
  visible = v_model("$vueStore.nested_drawers.outer"),
  content = tagList(
    el_button(
      "inner_open",
      "Click me!",
      on = list(click = "$vueStore.nested_drawers.inner = true")
    ),
    el_drawer(
      "inner",
      title = "I'm inner Drawer",
      append_to_body = TRUE,
      visible = v_model("$vueStore.nested_drawers.inner"),
      content = tags$p("_(:з)∠)_")
    )
  )
)

## modal
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-drawer", shot_wait = 1.5
vue_store("modal_drawer", state = list(visible = FALSE))
el_button(
  "open",
  "Open the modal Drawer",
  plain = TRUE,
  on = list(click = "$vueStore.modal_drawer.visible = true")
)
el_drawer(
  "drw",
  modal = FALSE,
  modal_penetrable = TRUE,
  visible = v_model("$vueStore.modal_drawer.visible"),
  content = tags$span("It's a modal Drawer"),
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$vueStore.modal_drawer.visible = false")
    ),
    el_button(
      "confirm",
      "Confirm",
      type = "primary",
      on = list(click = "$vueStore.modal_drawer.visible = false")
    )
  )
)
