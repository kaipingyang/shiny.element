# Element Plus Back to Top

A button that appears once the page has been scrolled down, and returns
it to the top when clicked.

## Usage

``` r
el_backtop(
  id = NULL,
  content = NULL,
  target = NULL,
  visibility_height = NULL,
  right = NULL,
  bottom = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Button ID. Auto-generated if `NULL`.

- content:

  Contents of the button. `NULL` for Element's own arrow icon.

- target:

  CSS selector of the element that scrolls. `NULL` for the page.

- visibility_height:

  Scroll distance in pixels before the button appears. Default `200`.

- right:

  Distance from the right edge, in pixels. Default `40`.

- bottom:

  Distance from the bottom edge, in pixels. Default `40`.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_click` – fires each time the button is clicked.

## Examples

``` r
el_backtop("top")
#> <div id="top" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="top_container" style="display: contents">
#>   <el-backtop :target="target === null ? undefined : target" :visibility-height="visibilityHeight === null ? undefined : visibilityHeight" :right="right === null ? undefined : right" :bottom="bottom === null ? undefined : bottom" @click="elEmitClick"></el-backtop>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"target":null,"visibilityHeight":null,"right":null,"bottom":null},"methods":{"elEmitClick":"function() { window.shinyVue.emit('top', 'click', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitClick"]}</script>
#> </div>
el_backtop("top", visibility_height = 100, right = 20, bottom = 20)
#> <div id="top" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="top_container" style="display: contents">
#>   <el-backtop :target="target === null ? undefined : target" :visibility-height="visibilityHeight === null ? undefined : visibilityHeight" :right="right === null ? undefined : right" :bottom="bottom === null ? undefined : bottom" @click="elEmitClick"></el-backtop>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"target":null,"visibilityHeight":100,"right":20,"bottom":20},"methods":{"elEmitClick":"function() { window.shinyVue.emit('top', 'click', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitClick"]}</script>
#> </div>

# Scrolling a panel rather than the page
el_backtop("panel_top", target = "#report")
#> <div id="panel_top" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="panel_top_container" style="display: contents">
#>   <el-backtop :target="target === null ? undefined : target" :visibility-height="visibilityHeight === null ? undefined : visibilityHeight" :right="right === null ? undefined : right" :bottom="bottom === null ? undefined : bottom" @click="elEmitClick"></el-backtop>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"target":"#report","visibilityHeight":null,"right":null,"bottom":null},"methods":{"elEmitClick":"function() { window.shinyVue.emit('panel_top', 'click', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitClick"]}</script>
#> </div>
```
