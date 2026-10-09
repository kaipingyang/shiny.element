# Element Plus Anchor

Links to sections of the page, the one in view marked as the page
scrolls.

## Usage

``` r
el_anchor(
  id = NULL,
  links = list(),
  container = NULL,
  offset = NULL,
  bound = NULL,
  duration = NULL,
  marker = NULL,
  type = NULL,
  direction = NULL,
  select_scroll_top = NULL,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL
)

update_el_anchor(
  session = shiny::getDefaultReactiveDomain(),
  id,
  offset = NULL,
  bound = NULL,
  duration = NULL,
  marker = NULL,
  type = NULL,
  direction = NULL,
  select_scroll_top = NULL,
  container = NULL
)
```

## Arguments

- id:

  Anchor ID. Auto-generated if `NULL`.

- links:

  The links, each an
  [`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md)
  – or a `list(title =, href = "#section")`, each with optional
  `children`, a list of links one level down.

- container:

  A CSS selector for the element that scrolls, when it is not the page.

- offset:

  Offset of the scroll position, in pixels.

- bound:

  Distance from the top at which a section counts as reached, in pixels.
  Default `15`.

- duration:

  Duration of the scroll, in milliseconds. Default `300`.

- marker:

  Whether to show the marker beside the current link.

- type:

  `"default"` or `"underline"`.

- direction:

  `"vertical"` (the default) or `"horizontal"`.

- select_scroll_top:

  Whether a link counts as current once its section is scrolled to the
  top.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents.

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the `href` of the current link, as the page scrolls |
| `input$<id>_click` | `events = "click"` | the `href` of the link clicked |

The same list as `el_events("el_anchor")`, which says how an event's
arguments travel.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
`scrollTo(href)`.

## Updating from the server

`update_el_anchor()` changes the component from the server: every
argument of `el_anchor()` that can change once it is drawn, under the
same name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

`update_el_anchor()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_anchor(
  "toc",
  links = list(
    list(title = "Basic usage", href = "#basic"),
    list(
      title = "API",
      href = "#api",
      children = list(
        list(title = "Attributes", href = "#attributes")
      )
    )
  )
)
#> <div id="toc" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="toc_container" style="display: contents">
#>   <el-anchor @change="handleChange" :container="container === null ? undefined : container" :offset="offset === null ? undefined : offset" :bound="bound === null ? undefined : bound" :duration="duration === null ? undefined : duration" :marker="marker === null ? undefined : marker" :type="type === null ? undefined : type" :direction="direction === null ? undefined : direction" :select-scroll-top="selectScrollTop === null ? undefined : selectScrollTop">
#>     <el-anchor-link title="Basic usage" href="#basic"></el-anchor-link>
#>     <el-anchor-link title="API" href="#api">
#>       <template v-slot:sub-link>
#>         <el-anchor-link title="Attributes" href="#attributes"></el-anchor-link>
#>       </template>
#>     </el-anchor-link>
#>   </el-anchor>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"container":null,"offset":null,"bound":null,"duration":null,"marker":null,"type":null,"direction":null,"selectScrollTop":null},"methods":{"handleChange":"function(href) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('toc', href); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>
```
