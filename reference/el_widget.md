# Assemble a component: host, Vue instance, Shiny input binding

Every control in this package has the same shape, and this builds it: a
host element carrying the id, the Element markup inside it, and the Vue
options beside them, which the package's bridge script compiles in
place. The host is a Shiny input binding, so it *is* the component to
the rest of Shiny – `shinyjs::hide("id")` hides it, `removeUI("#id")`
removes it and destroys its Vue instance, and its value is `input$<id>`.

## Usage

``` r
el_widget(
  id,
  markup,
  data,
  methods = NULL,
  watch = NULL,
  mounted = NULL,
  computed = NULL,
  dependency = NULL,
  head = NULL,
  width = NULL,
  slots = NULL,
  report = NULL,
  rate = NULL,
  type = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE
)
```

## Arguments

- id:

  The element id – inside a module, wrapped in `ns()`. It is the input
  id of the value `report` names.

- markup:

  The Element markup to mount on, usually one
  [`htmltools::tag()`](https://rstudio.github.io/htmltools/reference/builder.html).

- data:

  The Vue instance's data. Every field that `update_el_*()` may set has
  to be declared here – Vue does not track one that is not.

- methods, watch, mounted, computed:

  Vue options, included when not `NULL`.

- dependency:

  htmlDependency objects to attach. Outside this package pass
  [`element_ui_dependency()`](https://kaipingyang.github.io/shiny.element/reference/element_ui_dependency.md),
  unless the page already loads it through
  [`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
  or
  [`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md).

- head:

  Tags to place before the host, such as a `<style>` block.

- width:

  Component width, as a CSS unit. Applied to the Element markup itself –
  the host carries `display: contents` and generates no box, so a width
  set on it would do nothing.

- slots:

  Named list of slot contents, one entry per Element slot:
  `list(title = tags$b("Bold"))` fills the `title` slot. A component
  given here is absorbed like any other
  ([`.el_absorb()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_absorb.md)).
  For a scoped slot, where Element hands the template its own data,
  write the template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md)
  and the value is used as it stands.

- report:

  Fields of `data` to report as Shiny inputs, as
  `c(<field> = <input id>)`. The field reported under the component's
  own `id` is its value: the Shiny binding reads it on load and on every
  change, and a test driver or `shinyjs` sees it. Fields reported under
  other ids – `c(value = id, open = paste0(id, "_open"))` – are sent on
  load and on every change too. An
  [`update_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/update_vue_data.md)
  from the server counts as a change. Inside a module, pass the
  namespaced ids.

- rate:

  How often the value is sent while it changes:
  `list(policy = "debounce", delay = 250)`, as Shiny's
  [`textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html) does, or
  `"throttle"`. `NULL`, the default, sends every change.

- type:

  An input type for
  [`shiny::registerInputHandler()`](https://rdrr.io/pkg/shiny/man/registerInputHandler.html),
  which converts the value on its way into R.

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

## Value

A Shiny UI element with its dependencies attached.

## Details

Reach for it to wrap an Element component this package does not cover,
or to build an input of your own from
[el](https://kaipingyang.github.io/shiny.element/reference/el.md) tags;
`report` names the value. It is what the package's own components are
made of.

The raw Element tags come from
[el](https://kaipingyang.github.io/shiny.element/reference/el.md), and
[`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md)
writes a slot.

## Examples

``` r
# Wrapping el-avatar, which this package does not provide
my_avatar <- function(id, src, size = 50) {
  el_widget(
    id     = id,
    markup = el$avatar(":src" = "src", ":size" = "size"),
    data   = list(src = src, size = size)
  )
}
my_avatar("face", "https://example.org/face.png")
#> <div id="face" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="face_container" style="display: contents">
#>   <el-avatar :src="src" :size="size"></el-avatar>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"https://example.org/face.png","size":50}},"input":null,"rate":null,"type":null,"evals":[]}</script>
#> </div>

# An input of your own: v-model keeps `value` in step with the control,
# and `report` makes it input$score -- on load, on change, and after
# update_vue_data(session, "score", list(value = 5)) from the server.
el_widget(
  id     = "score",
  markup = el$rate("v-model" = "value", ":max" = "max"),
  data   = list(value = 3, max = 5),
  report = c(value = "score")
)
#> <div id="score" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="score_container" style="display: contents">
#>   <el-rate v-model="value" :max="max"></el-rate>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":3,"max":5}},"input":"value","rate":null,"type":null,"evals":[]}</script>
#> </div>
```
