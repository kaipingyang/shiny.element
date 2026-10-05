# A step of [`el_breadcrumb()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb.md)

Element Plus's `el-breadcrumb-item`, for `el_breadcrumb(items =)`.

## Usage

``` r
el_breadcrumb_item(label, to = NULL, replace = NULL)
```

## Arguments

- label:

  The step's text.

- to:

  Where the step links to; the last step usually has none.

- replace:

  Navigate without leaving a history record.

## Value

A step, for `el_breadcrumb(items =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
[`el_option()`](https://kaipingyang.github.io/shiny.element/reference/el_option.md),
[`el_skeleton_item()`](https://kaipingyang.github.io/shiny.element/reference/el_skeleton_item.md),
[`el_step()`](https://kaipingyang.github.io/shiny.element/reference/el_step.md),
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_column.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/reference/el_tour_step.md)

## Examples

``` r
el_breadcrumb(
  "bc",
  items = list(
    el_breadcrumb_item("Home", to = "/"),
    el_breadcrumb_item("Promotion list")
  )
)
#> <div id="bc" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="bc_container" style="display: contents">
#>   <el-breadcrumb :separator="separator === null ? undefined : separator" :separator-icon="separatorIcon === null ? undefined : separatorIcon">
#>     <el-breadcrumb-item v-for="(item, index) in items" :key="index" :to="item.to" :replace="item.replace" @click="handleClick(item)">{{item.label}}</el-breadcrumb-item>
#>   </el-breadcrumb>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"items":[{"label":"Home","to":"/"},{"label":"Promotion list"}],"separator":null,"separatorIcon":null},"methods":{"handleClick":"function(item) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('bc', item.label, {priority: 'event'}); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
#> </div>
```
