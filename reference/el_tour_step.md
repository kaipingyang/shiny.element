# A step of [`el_tour()`](https://kaipingyang.github.io/shiny.element/reference/el_tour.md)

Element Plus's `el-tour-step`, for `el_tour(steps =)`.

## Usage

``` r
el_tour_step(
  target = NULL,
  title = NULL,
  description = NULL,
  header = NULL,
  show_arrow = NULL,
  placement = NULL,
  content_style = NULL,
  mask = NULL,
  type = NULL,
  next_button_props = NULL,
  prev_button_props = NULL,
  scroll_into_view_options = NULL,
  show_close = NULL,
  close_icon = NULL
)
```

## Arguments

- target:

  The element the step points at, as a CSS selector. `NULL` shows the
  step in the middle of the screen.

- title, description:

  The step's title and text.

- header:

  Markup in place of the title.

- show_arrow:

  Whether to show the arrow.

- placement:

  Where the card goes, relative to the target: `"top"`, `"bottom"`
  (Element's default), `"left"`, `"right"`, each also with `"-start"` or
  `"-end"`.

- content_style:

  Style of the content, a list of CSS properties.

- mask:

  Whether to mask the page, or the mask's `list(style =, color =)`.

- type:

  `"default"` or `"primary"`: the card's colours.

- next_button_props, prev_button_props:

  The Next and Previous buttons' properties: `list(children = "Go on")`.

- scroll_into_view_options:

  Whether to scroll the target into view, or the options for
  `scrollIntoView()`.

- show_close:

  Whether to show a close button.

- close_icon:

  The close button's icon, by name.

## Value

A step, for `el_tour(steps =)`.

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
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline_item.md)

## Examples

``` r
el_tour(
  "tour",
  steps = list(
    el_tour_step("#upload", "Upload File", "Put your files here."),
    el_tour_step(title = "Done", description = "That is all.")
  )
)
#> <div id="tour" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="tour_container" style="display: contents">
#>   <el-tour v-model="open" v-model:current="current" @close="handleClose" @change="svEmitChange" @finish="svEmitFinish" :show-arrow="showArrow === null ? undefined : showArrow" :placement="placement === null ? undefined : placement" :content-style="contentStyle === null ? undefined : contentStyle" :mask="mask === null ? undefined : mask" :gap="gap === null ? undefined : gap" :type="type === null ? undefined : type" :scroll-into-view-options="scrollIntoViewOptions === null ? undefined : scrollIntoViewOptions" :z-index="zIndex === null ? undefined : zIndex" :show-close="showClose === null ? undefined : showClose" :close-icon="closeIcon === null ? undefined : closeIcon" :close-on-press-escape="closeOnPressEscape === null ? undefined : closeOnPressEscape" :target-area-clickable="targetAreaClickable === null ? undefined : targetAreaClickable" :append-to="appendTo === null ? undefined : appendTo">
#>     <el-tour-step :target="&quot;#upload&quot;" :title="&quot;Upload File&quot;" :description="&quot;Put your files here.&quot;"></el-tour-step>
#>     <el-tour-step :title="&quot;Done&quot;" :description="&quot;That is all.&quot;"></el-tour-step>
#>   </el-tour>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"open":false,"current":0,"showArrow":null,"placement":null,"contentStyle":null,"mask":null,"gap":null,"type":null,"scrollIntoViewOptions":null,"zIndex":null,"showClose":null,"closeIcon":null,"closeOnPressEscape":null,"targetAreaClickable":null,"appendTo":null},"methods":{"svEmitChange":"function() { window.shinyVue.emit('tour', 'change', arguments); }","svEmitFinish":"function() { window.shinyVue.emit('tour', 'finish', arguments); }","handleClose":"function(step) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('tour_close', step, {priority: 'event'}); }"},"watch":{"open":"function(v) { }"}},"input":"open","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitChange","options.methods.svEmitFinish","options.methods.handleClose","options.watch.open"]}</script>
#> </div>
```
