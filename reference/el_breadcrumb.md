# Element UI Breadcrumb

A trail of links showing where a page sits.

## Usage

``` r
el_breadcrumb(
  id = NULL,
  items = list(),
  separator = NULL,
  separator_class = NULL,
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

- separator_class:

  Icon class to use as the separator instead of a character, such as
  `"el-icon-arrow-right"`.

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
el_breadcrumb("trail", items = list(
  list(label = "Home"),
  list(label = "Reports"),
  list(label = "March")
))
#> <div id="trail" data-el-vue-host style="display: contents">
#>   <div id="trail_container" data-el-mount style="display: contents">
#>     <el-breadcrumb :separator="separator === null ? undefined : separator" :separator-class="separatorClass === null ? undefined : separatorClass">
#>       <el-breadcrumb-item v-for="(item, index) in items" :key="index" :to="item.to" :replace="item.replace" @click.native="handleClick(item)">{{item.label}}</el-breadcrumb-item>
#>     </el-breadcrumb>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"items":[{"label":"Home"},{"label":"Reports"},{"label":"March"}],"separator":null,"separatorClass":null},"methods":{"handleClick":"function(item) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('trail', item.label, {priority: 'event'}); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClick"]}</script>
#> </div>

# An arrow instead of a slash
el_breadcrumb("trail",
  items = list(list(label = "Home"), list(label = "Detail")),
  separator_class = "el-icon-arrow-right"
)
#> <div id="trail" data-el-vue-host style="display: contents">
#>   <div id="trail_container" data-el-mount style="display: contents">
#>     <el-breadcrumb :separator="separator === null ? undefined : separator" :separator-class="separatorClass === null ? undefined : separatorClass">
#>       <el-breadcrumb-item v-for="(item, index) in items" :key="index" :to="item.to" :replace="item.replace" @click.native="handleClick(item)">{{item.label}}</el-breadcrumb-item>
#>     </el-breadcrumb>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"items":[{"label":"Home"},{"label":"Detail"}],"separator":null,"separatorClass":"el-icon-arrow-right"},"methods":{"handleClick":"function(item) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('trail', item.label, {priority: 'event'}); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClick"]}</script>
#> </div>
```
