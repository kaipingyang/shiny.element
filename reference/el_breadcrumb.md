# Element Plus Breadcrumb

A trail of links showing where a page sits.

## Usage

``` r
el_breadcrumb(
  id = NULL,
  items = list(),
  separator = NULL,
  separator_icon = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Breadcrumb ID. Auto-generated if `NULL`.

- items:

  The trail, as a list of `list(label =, to =)`. `to` is optional and
  makes that step a link; the last step is usually plain text.

- separator:

  Separator character. Default `"/"`.

- separator_icon:

  Icon component of icon separator. Element Plus's `separator-icon`
  (string / Component). An icon's name, such as `"Search"`.

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

- `input$<id>` – the `label` of the step last clicked. Steps without a
  `to` are still reported, so a breadcrumb can drive navigation inside a
  Shiny app without any routing.

## Examples

``` r
el_breadcrumb(
  "trail",
  items = list(
    list(label = "Home"),
    list(label = "Reports"),
    list(label = "March")
  )
)
#> <div id="trail" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="trail_container" style="display: contents">
#>   <el-breadcrumb :separator="separator === null ? undefined : separator" :separator-icon="separatorIcon === null ? undefined : separatorIcon">
#>     <el-breadcrumb-item v-for="(item, index) in items" :key="index" :to="item.to" :replace="item.replace" @click="handleClick(item)">{{item.label}}</el-breadcrumb-item>
#>   </el-breadcrumb>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"items":[{"label":"Home"},{"label":"Reports"},{"label":"March"}],"separator":null,"separatorIcon":null},"methods":{"handleClick":"function(item) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('trail', item.label, {priority: 'event'}); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
#> </div>

# An arrow instead of a slash
el_breadcrumb(
  "trail",
  items = list(list(label = "Home"), list(label = "Detail")),
  separator_icon = "ArrowRight"
)
#> <div id="trail" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="trail_container" style="display: contents">
#>   <el-breadcrumb :separator="separator === null ? undefined : separator" :separator-icon="separatorIcon === null ? undefined : separatorIcon">
#>     <el-breadcrumb-item v-for="(item, index) in items" :key="index" :to="item.to" :replace="item.replace" @click="handleClick(item)">{{item.label}}</el-breadcrumb-item>
#>   </el-breadcrumb>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"items":[{"label":"Home"},{"label":"Detail"}],"separator":null,"separatorIcon":"ArrowRight"},"methods":{"handleClick":"function(item) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('trail', item.label, {priority: 'event'}); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
#> </div>
```
