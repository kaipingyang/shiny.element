# A placeholder shape of [`el_skeleton()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_skeleton.md)'s template

Element Plus's `el-skeleton-item`, for the `template` slot of
[`el_skeleton()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_skeleton.md),
which draws a custom placeholder while loading.

## Usage

``` r
el_skeleton_item(variant = NULL, ...)
```

## Arguments

- variant:

  The shape: `"p"`, `"text"` (Element's default), `"h1"`, `"h3"`,
  `"caption"`, `"button"`, `"image"`, `"circle"` or `"rect"`.

- ...:

  Attributes for the tag, such as `style`.

## Value

A tag.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_dropdown_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_menu_item.md),
[`el_option()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_option.md),
[`el_step()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_step.md),
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tab_pane.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_column.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_v2_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tour_step.md)

## Examples

``` r
el_skeleton(
  slots = list(
    template = htmltools::tagList(
      el_skeleton_item("image", style = "width: 240px; height: 240px"),
      el_skeleton_item("p", style = "width: 50%")
    )
  )
)
#> <div id="el_skeleton_c7c96ce5-9fe8-40b1-b6d9-3125b9a2891b" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_skeleton_c7c96ce5-9fe8-40b1-b6d9-3125b9a2891b_container" style="display: contents">
#>   <el-skeleton v-bind="$optional(&#39;skeleton&#39;)" :loading="skLoading">
#>     <template v-slot:template>
#>       <el-skeleton-item variant="image" style="width: 240px; height: 240px"></el-skeleton-item>
#>       <el-skeleton-item variant="p" style="width: 50%"></el-skeleton-item>
#>     </template>
#>   </el-skeleton>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"skLoading":true,"skRows":null,"skAnimated":null,"skCount":null,"skThrottle":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"skeleton":{"rows":"skRows","animated":"skAnimated","count":"skCount","throttle":"skThrottle"}},"generated":true,"evals":[]}</script>
#> </div>
```
