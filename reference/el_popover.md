# Element UI Popover

A card shown on click or hover, with a title and body.

## Usage

``` r
el_popover(
  id = NULL,
  reference = NULL,
  title = NULL,
  content = NULL,
  body = NULL,
  trigger = NULL,
  placement = NULL,
  popover_width = NULL,
  disabled = NULL,
  offset = NULL,
  open_delay = NULL,
  close_delay = NULL,
  visible_arrow = NULL,
  transition = NULL,
  popper_class = NULL,
  popper_options = NULL,
  tabindex = NULL,
  width = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Popover ID. Auto-generated if `NULL`.

- reference:

  The element the popover hangs off. Markup only – raw Element tags from
  [el](https://kaipingyang.github.io/shiny.element/reference/el.md), or
  ordinary Shiny UI. It cannot be another shiny.element component: the
  popover compiles this into its own Vue instance, which would discard a
  mounted one.

- title:

  Title of the card.

- content:

  Body text. For richer content pass `body`.

- body:

  Body markup, used instead of `content`. Markup only, as above.

- trigger:

  How it opens: `"click"` (default), `"focus"`, `"hover"` or `"manual"`.

- placement:

  Where it appears: `"bottom"` (default), `"top"`, `"left"`, `"right"`,
  each also with `-start` and `-end`.

- popover_width:

  Width of the card, in pixels. Element's own `width` prop, named apart
  from `width` so the two are not confused.

- disabled:

  Whether the popover is suppressed.

- offset:

  Offset from the reference, in pixels.

- open_delay, close_delay:

  Delays in milliseconds, for `trigger = "hover"`.

- visible_arrow:

  Whether to draw the little arrow. Default `TRUE`.

- transition:

  Name of the transition to animate with.

- popper_class:

  Extra class name for the card.

- popper_options:

  Additional Popper.js options, as a named list.

- tabindex:

  Tab index of the reference.

- width:

  Component width, as a CSS unit.

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_show`, `input$<id>_hide` – fire as the card opens and
  closes.

- `input$<id>_after_enter`, `input$<id>_after_leave` – fire once the
  animation has finished.

## Examples

``` r
el_popover("info",
  reference = el$button("Details"),
  title = "March",
  content = "Revenue up 4% on February."
)
#> <div id="info_container" style="display: contents">
#>   <el-popover v-model="value" :title="title === null ? undefined : title" :content="content === null ? undefined : content" :trigger="trigger === null ? undefined : trigger" :placement="placement === null ? undefined : placement" :width="popoverWidth === null ? undefined : popoverWidth" :disabled="disabled === null ? undefined : disabled" :offset="offset === null ? undefined : offset" :open-delay="openDelay === null ? undefined : openDelay" :close-delay="closeDelay === null ? undefined : closeDelay" :visible-arrow="visibleArrow === null ? undefined : visibleArrow" :transition="transition === null ? undefined : transition" :popper-class="popperClass === null ? undefined : popperClass" :popper-options="popperOptions === null ? undefined : popperOptions" :tabindex="tabindex === null ? undefined : tabindex" @show="elEmitShow" @hide="elEmitHide" @after-enter="elEmitAfterEnter" @after-leave="elEmitAfterLeave">
#>     <span slot="reference">
#>       <el-button>Details</el-button>
#>     </span>
#>   </el-popover>
#> </div>
#> <div id="info" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="info">{"x":{"el":"#info_container","data":{"value":false,"title":"March","content":"Revenue up 4% on February.","trigger":null,"placement":null,"popoverWidth":null,"disabled":null,"offset":null,"openDelay":null,"closeDelay":null,"visibleArrow":null,"transition":null,"popperClass":null,"popperOptions":null,"tabindex":null},"methods":{"elEmitShow":"function() { window.shinyElement.emit('info', 'show', arguments); }","elEmitHide":"function() { window.shinyElement.emit('info', 'hide', arguments); }","elEmitAfterEnter":"function() { window.shinyElement.emit('info', 'after_enter', arguments); }","elEmitAfterLeave":"function() { window.shinyElement.emit('info', 'after_leave', arguments); }"}},"evals":["methods.elEmitShow","methods.elEmitHide","methods.elEmitAfterEnter","methods.elEmitAfterLeave"],"jsHooks":[]}</script>

# Hover, with markup in the body
el_popover("info",
  reference = el$button("Details"),
  body = shiny::tags$ul(shiny::tags$li("One"), shiny::tags$li("Two")),
  trigger = "hover", placement = "right"
)
#> <div id="info_container" style="display: contents">
#>   <el-popover v-model="value" :title="title === null ? undefined : title" :content="content === null ? undefined : content" :trigger="trigger === null ? undefined : trigger" :placement="placement === null ? undefined : placement" :width="popoverWidth === null ? undefined : popoverWidth" :disabled="disabled === null ? undefined : disabled" :offset="offset === null ? undefined : offset" :open-delay="openDelay === null ? undefined : openDelay" :close-delay="closeDelay === null ? undefined : closeDelay" :visible-arrow="visibleArrow === null ? undefined : visibleArrow" :transition="transition === null ? undefined : transition" :popper-class="popperClass === null ? undefined : popperClass" :popper-options="popperOptions === null ? undefined : popperOptions" :tabindex="tabindex === null ? undefined : tabindex" @show="elEmitShow" @hide="elEmitHide" @after-enter="elEmitAfterEnter" @after-leave="elEmitAfterLeave">
#>     <ul>
#>       <li>One</li>
#>       <li>Two</li>
#>     </ul>
#>     <span slot="reference">
#>       <el-button>Details</el-button>
#>     </span>
#>   </el-popover>
#> </div>
#> <div id="info" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="info">{"x":{"el":"#info_container","data":{"value":false,"title":null,"content":null,"trigger":"hover","placement":"right","popoverWidth":null,"disabled":null,"offset":null,"openDelay":null,"closeDelay":null,"visibleArrow":null,"transition":null,"popperClass":null,"popperOptions":null,"tabindex":null},"methods":{"elEmitShow":"function() { window.shinyElement.emit('info', 'show', arguments); }","elEmitHide":"function() { window.shinyElement.emit('info', 'hide', arguments); }","elEmitAfterEnter":"function() { window.shinyElement.emit('info', 'after_enter', arguments); }","elEmitAfterLeave":"function() { window.shinyElement.emit('info', 'after_leave', arguments); }"}},"evals":["methods.elEmitShow","methods.elEmitHide","methods.elEmitAfterEnter","methods.elEmitAfterLeave"],"jsHooks":[]}</script>
```
