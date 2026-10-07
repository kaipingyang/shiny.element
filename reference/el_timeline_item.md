# An entry of [`el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline.md)

Element Plus's `el-timeline-item`, for `el_timeline(items =)`.

## Usage

``` r
el_timeline_item(
  content,
  timestamp = NULL,
  hide_timestamp = NULL,
  center = NULL,
  placement = NULL,
  type = NULL,
  color = NULL,
  size = NULL,
  icon = NULL,
  hollow = NULL
)
```

## Arguments

- content:

  The entry's text (markup with `el_timeline(html = TRUE)`).

- timestamp:

  Timestamp text.

- hide_timestamp:

  Whether to hide the timestamp. By default it is hidden when there is
  none.

- center:

  Whether to centre the node vertically.

- placement:

  Where the timestamp goes: `"bottom"` (Element's default) or `"top"`.

- type:

  Node type: `"primary"`, `"success"`, `"warning"`, `"danger"` or
  `"info"`.

- color:

  Background colour of the node.

- size:

  Node size: `"normal"` or `"large"`.

- icon:

  Icon of the node, by name.

- hollow:

  Whether the node is hollow.

## Value

An entry, for `el_timeline(items =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
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
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/reference/el_tour_step.md)

## Examples

``` r
el_timeline(
  "tl",
  items = list(
    el_timeline_item("Event start", timestamp = "2018-04-15"),
    el_timeline_item("Approved", timestamp = "2018-04-13", type = "success")
  )
)
#> <div id="tl" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="tl_container" style="display: contents">
#>   <el-timeline :reverse="reverse" :mode="mode === null ? undefined : mode">
#>     <el-timeline-item v-for="(item, index) in items" :key="index" :timestamp="item.timestamp" :type="item.type" :color="item.color" :size="item.size" :icon="item.icon" :placement="item.placement" :center="item.center" :hollow="item.hollow" :hide-timestamp="item.hide_timestamp != null ? item.hide_timestamp : !item.timestamp"><span v-if="item.contentHtml" v-html="item.content"></span><template v-else>{{ item.content }}</template></el-timeline-item>
#>   </el-timeline>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"items":[{"content":"Event start","timestamp":"2018-04-15"},{"content":"Approved","timestamp":"2018-04-13","type":"success"}],"reverse":false,"mode":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>
```
