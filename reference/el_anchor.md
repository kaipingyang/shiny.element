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
  slots = NULL
)
```

## Arguments

- id:

  Anchor ID. Auto-generated if `NULL`.

- links:

  The links: a list of `list(title =, href = "#section")`, each with
  optional `children`, a list of links one level down.

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

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the `href` of the current link, as the page scrolls.

- `input$<id>_click` – the `href` of a link the user clicked.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):
`scrollTo(href)`.

## Examples

``` r
el_anchor("toc", links = list(
  list(title = "Basic usage", href = "#basic"),
  list(title = "API", href = "#api", children = list(
    list(title = "Attributes", href = "#attributes")))))
#> <div id="toc" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="toc_container" style="display: contents">
#>   <el-anchor @change="handleChange" @click="elEmitClick" :container="container === null ? undefined : container" :offset="offset === null ? undefined : offset" :bound="bound === null ? undefined : bound" :duration="duration === null ? undefined : duration" :marker="marker === null ? undefined : marker" :type="type === null ? undefined : type" :direction="direction === null ? undefined : direction" :select-scroll-top="selectScrollTop === null ? undefined : selectScrollTop">
#>     <el-anchor-link title="Basic usage" href="#basic"></el-anchor-link>
#>     <el-anchor-link title="API" href="#api">
#>       <template v-slot:sub-link>
#>         <el-anchor-link title="Attributes" href="#attributes"></el-anchor-link>
#>       </template>
#>     </el-anchor-link>
#>   </el-anchor>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"container":null,"offset":null,"bound":null,"duration":null,"marker":null,"type":null,"direction":null,"selectScrollTop":null},"methods":{"elEmitClick":"function() { var shape = function(e, href) { return href; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('toc', 'click', [v]); }","handleChange":"function(href) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('toc', href); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitClick","options.methods.handleChange"]}</script>
#> </div>
```
