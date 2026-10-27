# A link of [`el_anchor()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_anchor.md)

Element Plus's `el-anchor-link`, for `el_anchor(links =)`.

## Usage

``` r
el_anchor_link(title, href, ...)
```

## Arguments

- title:

  The link's text.

- href:

  Where it points: `"#section"`.

- ...:

  Links one level down, each an `el_anchor_link()`.

## Value

A link, for `el_anchor(links =)`.

## See also

Other items:
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_dropdown_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_menu_item.md),
[`el_option()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_option.md),
[`el_skeleton_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_skeleton_item.md),
[`el_step()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_step.md),
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tab_pane.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_column.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_v2_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tour_step.md)

## Examples

``` r
el_anchor(
  "an",
  links = list(
    el_anchor_link("Basic Usage", "#basic-usage"),
    el_anchor_link(
      "API",
      "#api",
      el_anchor_link("Attributes", "#attributes"),
      el_anchor_link("Events", "#events")
    )
  )
)
#> <div id="an" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="an_container" style="display: contents">
#>   <el-anchor v-bind="$optional(&#39;anchor&#39;)" @change="handleChange">
#>     <el-anchor-link title="Basic Usage" href="#basic-usage"></el-anchor-link>
#>     <el-anchor-link title="API" href="#api">
#>       <template v-slot:sub-link>
#>         <el-anchor-link title="Attributes" href="#attributes"></el-anchor-link>
#>         <el-anchor-link title="Events" href="#events"></el-anchor-link>
#>       </template>
#>     </el-anchor-link>
#>   </el-anchor>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"container":null,"offset":null,"bound":null,"duration":null,"marker":null,"type":null,"direction":null,"selectScrollTop":null},"methods":{"handleChange":"function(href) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('an', href); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"anchor":{"container":"container","offset":"offset","bound":"bound","duration":"duration","marker":"marker","type":"type","direction":"direction","select-scroll-top":"selectScrollTop"}},"evals":["options.methods.handleChange"]}</script>
#> </div>
```
