# A field of [`el_descriptions()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions.md)

Element Plus's `el-descriptions-item`, for `el_descriptions(items =)`.

## Usage

``` r
el_descriptions_item(
  label,
  ...,
  span = NULL,
  rowspan = NULL,
  width = NULL,
  min_width = NULL,
  label_width = NULL,
  align = NULL,
  label_align = NULL,
  class_name = NULL,
  label_class_name = NULL
)
```

## Arguments

- label:

  Label text, or markup for the item's label slot.

- ...:

  The field's content: text, tags, this package's components.

- span:

  Number of columns the field spans.

- rowspan:

  Number of rows the field spans.

- width:

  Column width; the widest in a column wins. Without a border it
  includes the label.

- min_width:

  Minimum column width; columns with `width` keep it, the others share
  the rest in proportion.

- label_width:

  Width of the label, over the descriptions' own.

- align:

  Content alignment: `"left"`, `"center"` or `"right"`.

- label_align:

  Label alignment, `align`'s when not given.

- class_name:

  Class of the content cell.

- label_class_name:

  Class of the label cell.

## Value

A field, for `el_descriptions(items =)`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md),
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
el_descriptions(
  "d",
  items = list(
    el_descriptions_item("Username", "kooriookami"),
    el_descriptions_item("Address", "No.1188, Wuzhong Avenue", span = 2)
  )
)
#> <div id="d" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="d_container" style="display: contents">
#>   <el-descriptions :title="dTitle === null ? undefined : dTitle" :extra="dExtra === null ? undefined : dExtra" :column="dColumn === null ? undefined : dColumn" :direction="dDirection === null ? undefined : dDirection" :border="dBorder === null ? undefined : dBorder" :size="dSize === null ? undefined : dSize" :label-width="dLabelWidth === null ? undefined : dLabelWidth">
#>     <el-descriptions-item label="Username">kooriookami</el-descriptions-item>
#>     <el-descriptions-item label="Address" :span="2">No.1188, Wuzhong Avenue</el-descriptions-item>
#>   </el-descriptions>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"dTitle":null,"dExtra":null,"dColumn":null,"dDirection":null,"dBorder":null,"dSize":null,"dLabelWidth":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>
```
