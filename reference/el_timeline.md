# Element Plus Timeline

A vertical sequence of events.

## Usage

``` r
el_timeline(
  id = NULL,
  items = list(),
  reverse = FALSE,
  html = FALSE,
  mode = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Timeline ID (auto-generated if NULL).

- items:

  A list of entries, each an
  [`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline_item.md)
  – or a list with the same fields: `content` and optionally
  `timestamp`, `type` (`"primary"`, `"success"`, `"warning"`, `"danger"`
  or `"info"`), `color`, `size` (`"normal"` or `"large"`),
  `hide_timestamp`, `icon` (an icon's name), `placement` (`"bottom"` or
  `"top"`, where the timestamp goes), `center` (centre the dot against
  the content) and `hollow` (draw the dot hollow).

- reverse:

  Show the entries newest first.

- html:

  Render each entry's `content` as HTML rather than text – a string of
  markup, or tags. Only use it with content you control: it goes through
  `v-html`, which does not escape anything.

- mode:

  Relative position of timeline and content. Element Plus's `mode`
  ('start' \| 'alternate' \| 'alternate-reverse' \| 'end').

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

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

## Details

Entries are rendered with `v-for` from a data field, so
[`update_el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/update_el_timeline.md)
can replace them – useful for a log that grows. Their content is
therefore a string rather than markup; pass `html = TRUE` to render it
as HTML.

## Examples

``` r
el_timeline(
  id = "log",
  items = list(
    list(content = "Order placed", timestamp = "2026-03-01", type = "primary"),
    list(
      content = "Order shipped",
      timestamp = "2026-03-02",
      type = "success",
      icon = "el-icon-check",
      size = "large"
    ),
    list(content = "Delivered", timestamp = "2026-03-04", color = "#0bbd87")
  )
)
#> <div id="log" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="log_container" style="display: contents">
#>   <el-timeline :reverse="reverse" :mode="mode === null ? undefined : mode">
#>     <el-timeline-item v-for="(item, index) in items" :key="index" :timestamp="item.timestamp" :type="item.type" :color="item.color" :size="item.size" :icon="item.icon" :placement="item.placement" :center="item.center" :hollow="item.hollow" :hide-timestamp="item.hide_timestamp != null ? item.hide_timestamp : !item.timestamp">{{ item.content }}</el-timeline-item>
#>   </el-timeline>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"items":[{"content":"Order placed","timestamp":"2026-03-01","type":"primary"},{"content":"Order shipped","timestamp":"2026-03-02","type":"success","size":"large","icon":"el-icon-check"},{"content":"Delivered","timestamp":"2026-03-04","color":"#0bbd87"}],"reverse":false,"mode":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>

# Newest first, timestamps above each entry
el_timeline(
  id = "log",
  reverse = TRUE,
  items = list(
    list(content = "Second", timestamp = "10:30", placement = "top"),
    list(content = "First", timestamp = "09:15", placement = "top")
  )
)
#> <div id="log" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="log_container" style="display: contents">
#>   <el-timeline :reverse="reverse" :mode="mode === null ? undefined : mode">
#>     <el-timeline-item v-for="(item, index) in items" :key="index" :timestamp="item.timestamp" :type="item.type" :color="item.color" :size="item.size" :icon="item.icon" :placement="item.placement" :center="item.center" :hollow="item.hollow" :hide-timestamp="item.hide_timestamp != null ? item.hide_timestamp : !item.timestamp">{{ item.content }}</el-timeline-item>
#>   </el-timeline>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"items":[{"content":"Second","timestamp":"10:30","placement":"top"},{"content":"First","timestamp":"09:15","placement":"top"}],"reverse":true,"mode":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>
```
