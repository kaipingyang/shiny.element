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
  width = NULL
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

# Reporting to Shiny works as it does inside the package: a method that
# calls Shiny.setInputValue().
el_widget(
  id      = "score",
  markup  = el$rate("v-model" = "value", "@change" = "handleChange"),
  data    = list(value = 3),
  methods = list(
    handleChange = htmlwidgets::JS(
      "function(v) { Shiny.setInputValue('score', v); }"
    )
  )
)
#> <div id="score_container" style="display: contents">
#>   <el-rate v-model="value" @change="handleChange"></el-rate>
#> </div>
#> <div id="score" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="score">{"x":{"el":"#score_container","data":{"value":3},"methods":{"handleChange":"function(v) { Shiny.setInputValue('score', v); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>
```
