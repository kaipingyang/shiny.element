# Assemble a component: mount point, Vue instance, dependencies

Every control in this package has the same shape: a host `div` holding
the Element markup, a Vue instance mounted on it, and the scripts that
let `update_el_*()` and
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md)
reach it. This builds that shape, and is what the package's own
components are made of.

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
  report = NULL
)
```

## Arguments

- id:

  The namespaced element id.

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
  `c(<field> = <input id>)`: `report = c(value = id)` makes
  `input[[id]]` the `value` field. Each is reported on load, on every
  change – the user's, or an
  [`update_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/update_vue_data.md)
  from the server – and needs no JavaScript of your own. Inside a
  module, pass the namespaced id.

## Value

A Shiny UI element with its dependencies attached.

## Details

Reach for it to wrap an Element component this package does not cover,
or to build one that behaves differently from the wrapper here. Calling
[`vueR::vue()`](https://rdrr.io/pkg/vueR/man/vue.html) yourself works
too – nothing stops you – but then three things are yours to remember,
each of which is here because of a bug:

- `display: contents` on the host, or every component starts its own
  line;

- `width = 0, height = 0` on the widget, or it holds open a 960x500
  empty box until its script runs, and the page jumps when it does;

- the `el` selector pointing at the host, which Vue compiles in place.

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
#> <div id="face_container" style="display: contents">
#>   <el-avatar :src="src" :size="size"></el-avatar>
#> </div>
#> <div id="face" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="face">{"x":{"el":"#face_container","data":{"src":"https://example.org/face.png","size":50}},"evals":[],"jsHooks":[]}</script>

# An input of your own: v-model keeps `value` in step with the control,
# and `report` makes it input$score -- on load, on change, and after
# update_vue_data(session, "score", list(value = 5)) from the server.
el_widget(
  id     = "score",
  markup = el$rate("v-model" = "value", ":max" = "max"),
  data   = list(value = 3, max = 5),
  report = c(value = "score")
)
#> <div id="score_container" style="display: contents">
#>   <el-rate v-model="value" :max="max"></el-rate>
#> </div>
#> <div id="score" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="score">{"x":{"el":"#score_container","data":{"value":3,"max":5},"watch":{"value":"{handler: function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"score\", v); }, deep: true}"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"score\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["watch.value","mounted"],"jsHooks":[]}</script>
```
