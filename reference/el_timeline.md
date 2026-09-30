# Element UI Timeline

A vertical sequence of events.

## Usage

``` r
el_timeline(
  id = NULL,
  items = list(),
  reverse = FALSE,
  html = FALSE,
  width = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Timeline ID (auto-generated if NULL).

- items:

  A list of entries. Each is a list with `content` and optionally
  `timestamp`, `type` (`"primary"`, `"success"`, `"warning"`, `"danger"`
  or `"info"`), `color`, `size` (`"normal"` or `"large"`), `icon` (an
  Element icon class) and `placement` (`"bottom"` or `"top"`, where the
  timestamp goes).

- reverse:

  Show the entries newest first.

- html:

  Render each entry's `content` as HTML rather than text. Only use it
  with content you control: it goes through `v-html`, which does not
  escape anything.

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- session:

  Shiny session for module support.

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
    list(content = "Order placed",  timestamp = "2026-03-01", type = "primary"),
    list(content = "Order shipped", timestamp = "2026-03-02", type = "success",
         icon = "el-icon-check", size = "large"),
    list(content = "Delivered",     timestamp = "2026-03-04", color = "#0bbd87")
  )
)
#> <div id="log_container" style="display: contents">
#>   <el-timeline :reverse="reverse">
#>     <el-timeline-item v-for="(item, index) in items" :key="index" :timestamp="item.timestamp" :type="item.type" :color="item.color" :size="item.size" :icon="item.icon" :placement="item.placement" :hide-timestamp="!item.timestamp">{{ item.content }}</el-timeline-item>
#>   </el-timeline>
#> </div>
#> <div id="log" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="log">{"x":{"el":"#log_container","data":{"items":[{"content":"Order placed","timestamp":"2026-03-01","type":"primary"},{"content":"Order shipped","timestamp":"2026-03-02","type":"success","size":"large","icon":"el-icon-check"},{"content":"Delivered","timestamp":"2026-03-04","color":"#0bbd87"}],"reverse":false}},"evals":[],"jsHooks":[]}</script>

# Newest first, timestamps above each entry
el_timeline(
  id = "log", reverse = TRUE,
  items = list(
    list(content = "Second", timestamp = "10:30", placement = "top"),
    list(content = "First",  timestamp = "09:15", placement = "top")
  )
)
#> <div id="log_container" style="display: contents">
#>   <el-timeline :reverse="reverse">
#>     <el-timeline-item v-for="(item, index) in items" :key="index" :timestamp="item.timestamp" :type="item.type" :color="item.color" :size="item.size" :icon="item.icon" :placement="item.placement" :hide-timestamp="!item.timestamp">{{ item.content }}</el-timeline-item>
#>   </el-timeline>
#> </div>
#> <div id="log" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="log">{"x":{"el":"#log_container","data":{"items":[{"content":"Second","timestamp":"10:30","placement":"top"},{"content":"First","timestamp":"09:15","placement":"top"}],"reverse":true}},"evals":[],"jsHooks":[]}</script>
```
