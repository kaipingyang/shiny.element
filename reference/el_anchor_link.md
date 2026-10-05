# A link of [`el_anchor()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor.md)

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
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
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
#>   <el-anchor @change="handleChange" @click="elEmitClick" :container="container === null ? undefined : container" :offset="offset === null ? undefined : offset" :bound="bound === null ? undefined : bound" :duration="duration === null ? undefined : duration" :marker="marker === null ? undefined : marker" :type="type === null ? undefined : type" :direction="direction === null ? undefined : direction" :select-scroll-top="selectScrollTop === null ? undefined : selectScrollTop">
#>     <el-anchor-link title="Basic Usage" href="#basic-usage"></el-anchor-link>
#>     <el-anchor-link title="API" href="#api">
#>       <template v-slot:sub-link>
#>         <el-anchor-link title="Attributes" href="#attributes"></el-anchor-link>
#>         <el-anchor-link title="Events" href="#events"></el-anchor-link>
#>       </template>
#>     </el-anchor-link>
#>   </el-anchor>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"container":null,"offset":null,"bound":null,"duration":null,"marker":null,"type":null,"direction":null,"selectScrollTop":null},"methods":{"elEmitClick":"function() { var shape = function(e, href) { return href; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('an', 'click', [v]); }","handleChange":"function(href) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('an', href); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitClick","options.methods.handleChange"]}</script>
#> </div>
```
