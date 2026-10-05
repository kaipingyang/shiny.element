# Element Plus Tour

A guided tour: a card pointing at one element of the page after another,
with the rest of the page dimmed.

## Usage

``` r
el_tour(
  id = NULL,
  steps = list(),
  open = FALSE,
  current = NULL,
  show_arrow = NULL,
  placement = NULL,
  content_style = NULL,
  mask = NULL,
  gap = NULL,
  type = NULL,
  scroll_into_view_options = NULL,
  z_index = NULL,
  show_close = NULL,
  close_icon = NULL,
  close_on_press_escape = NULL,
  target_area_clickable = NULL,
  append_to = NULL,
  width = NULL,
  slots = NULL
)
```

## Arguments

- id:

  Tour ID. Auto-generated if `NULL`.

- steps:

  The steps, each an
  [`el_tour_step()`](https://kaipingyang.github.io/shiny.element/reference/el_tour_step.md)
  – or a `list(target = "#css-selector", title =, description =)`, each
  with Element Plus's other step props if wanted – `placement`, `mask`,
  `type`, `show_arrow`, `show_close`, `content_style`,
  `scroll_into_view_options`, and `header`, markup in place of the
  title. A step without a `target` shows in the middle of the screen.

- open:

  Whether it starts open: Element Plus's `model-value`. Open it later
  with
  [`update_el_tour()`](https://kaipingyang.github.io/shiny.element/reference/update_el_tour.md).

- current:

  The step it starts on, from 0.

- show_arrow, placement, content_style, mask, gap, type,
  scroll_into_view_options, z_index, show_close, close_icon,
  close_on_press_escape, target_area_clickable, append_to:

  Element Plus's tour props of those names: the defaults for every step.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `indicators`.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – whether it is open.

- `input$<id>_change` – the step, from 0, as it changes.

- `input$<id>_close` – the step it was closed on.

- `input$<id>_finish` – fires when the last step is done.

## Examples

``` r
el_tour(
  "intro",
  open = TRUE,
  steps = list(
    list(
      target = "#upload",
      title = "Upload",
      description = "Put your file here."
    ),
    list(target = "#run", title = "Run", description = "Then press this.")
  )
)
#> <div id="intro" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="intro_container" style="display: contents">
#>   <el-tour v-model="open" v-model:current="current" @close="handleClose" @change="elEmitChange" @finish="elEmitFinish" :show-arrow="showArrow === null ? undefined : showArrow" :placement="placement === null ? undefined : placement" :content-style="contentStyle === null ? undefined : contentStyle" :mask="mask === null ? undefined : mask" :gap="gap === null ? undefined : gap" :type="type === null ? undefined : type" :scroll-into-view-options="scrollIntoViewOptions === null ? undefined : scrollIntoViewOptions" :z-index="zIndex === null ? undefined : zIndex" :show-close="showClose === null ? undefined : showClose" :close-icon="closeIcon === null ? undefined : closeIcon" :close-on-press-escape="closeOnPressEscape === null ? undefined : closeOnPressEscape" :target-area-clickable="targetAreaClickable === null ? undefined : targetAreaClickable" :append-to="appendTo === null ? undefined : appendTo">
#>     <el-tour-step :target="&quot;#upload&quot;" :title="&quot;Upload&quot;" :description="&quot;Put your file here.&quot;"></el-tour-step>
#>     <el-tour-step :target="&quot;#run&quot;" :title="&quot;Run&quot;" :description="&quot;Then press this.&quot;"></el-tour-step>
#>   </el-tour>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"open":true,"current":0,"showArrow":null,"placement":null,"contentStyle":null,"mask":null,"gap":null,"type":null,"scrollIntoViewOptions":null,"zIndex":null,"showClose":null,"closeIcon":null,"closeOnPressEscape":null,"targetAreaClickable":null,"appendTo":null},"methods":{"elEmitChange":"function() { window.shinyVue.emit('intro', 'change', arguments); }","elEmitFinish":"function() { window.shinyVue.emit('intro', 'finish', arguments); }","handleClose":"function(step) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('intro_close', step, {priority: 'event'}); }"},"watch":{"open":"function(v) { }"}},"input":"open","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitChange","options.methods.elEmitFinish","options.methods.handleClose","options.watch.open"]}</script>
#> </div>
```
