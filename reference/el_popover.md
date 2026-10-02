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
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Popover ID. Auto-generated if `NULL`.

- reference:

  The element the popover hangs off. Any Shiny UI, including another
  shiny.element component – that component is folded into the popover's
  Vue instance rather than nested inside it, so its inputs keep
  reporting. Its `update_el_*()` no longer reaches it.

- title:

  Title of the card.

- content:

  Body text. For richer content pass `body`.

- body:

  Body markup, used instead of `content`. Components are absorbed here
  too.

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
#> <div id="info" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="info_container" style="display: contents">
#>   <el-popover v-model="popValue" :title="popTitle === null ? undefined : popTitle" :content="popContent === null ? undefined : popContent" :trigger="popTrigger === null ? undefined : popTrigger" :placement="popPlacement === null ? undefined : popPlacement" :width="popPopoverWidth === null ? undefined : popPopoverWidth" :disabled="popDisabled === null ? undefined : popDisabled" :offset="popOffset === null ? undefined : popOffset" :open-delay="popOpenDelay === null ? undefined : popOpenDelay" :close-delay="popCloseDelay === null ? undefined : popCloseDelay" :visible-arrow="popVisibleArrow === null ? undefined : popVisibleArrow" :transition="popTransition === null ? undefined : popTransition" :popper-class="popPopperClass === null ? undefined : popPopperClass" :popper-options="popPopperOptions === null ? undefined : popPopperOptions" :tabindex="popTabindex === null ? undefined : popTabindex" @show="elEmitShow" @hide="elEmitHide" @after-enter="elEmitAfterEnter" @after-leave="elEmitAfterLeave">
#>     <span slot="reference">
#>       <el-button>Details</el-button>
#>     </span>
#>   </el-popover>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"popValue":false,"popTitle":"March","popContent":"Revenue up 4% on February.","popTrigger":null,"popPlacement":null,"popPopoverWidth":null,"popDisabled":null,"popOffset":null,"popOpenDelay":null,"popCloseDelay":null,"popVisibleArrow":null,"popTransition":null,"popPopperClass":null,"popPopperOptions":null,"popTabindex":null},"methods":{"elEmitShow":"function() { window.shinyVue.emit('info', 'show', arguments); }","elEmitHide":"function() { window.shinyVue.emit('info', 'hide', arguments); }","elEmitAfterEnter":"function() { window.shinyVue.emit('info', 'after_enter', arguments); }","elEmitAfterLeave":"function() { window.shinyVue.emit('info', 'after_leave', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitShow","options.methods.elEmitHide","options.methods.elEmitAfterEnter","options.methods.elEmitAfterLeave"]}</script>
#> </div>

# Hover, with markup in the body
el_popover("info",
  reference = el$button("Details"),
  body = shiny::tags$ul(shiny::tags$li("One"), shiny::tags$li("Two")),
  trigger = "hover", placement = "right"
)
#> <div id="info" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="info_container" style="display: contents">
#>   <el-popover v-model="popValue" :title="popTitle === null ? undefined : popTitle" :content="popContent === null ? undefined : popContent" :trigger="popTrigger === null ? undefined : popTrigger" :placement="popPlacement === null ? undefined : popPlacement" :width="popPopoverWidth === null ? undefined : popPopoverWidth" :disabled="popDisabled === null ? undefined : popDisabled" :offset="popOffset === null ? undefined : popOffset" :open-delay="popOpenDelay === null ? undefined : popOpenDelay" :close-delay="popCloseDelay === null ? undefined : popCloseDelay" :visible-arrow="popVisibleArrow === null ? undefined : popVisibleArrow" :transition="popTransition === null ? undefined : popTransition" :popper-class="popPopperClass === null ? undefined : popPopperClass" :popper-options="popPopperOptions === null ? undefined : popPopperOptions" :tabindex="popTabindex === null ? undefined : popTabindex" @show="elEmitShow" @hide="elEmitHide" @after-enter="elEmitAfterEnter" @after-leave="elEmitAfterLeave">
#>     <ul>
#>       <li>One</li>
#>       <li>Two</li>
#>     </ul>
#>     <span slot="reference">
#>       <el-button>Details</el-button>
#>     </span>
#>   </el-popover>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"popValue":false,"popTitle":null,"popContent":null,"popTrigger":"hover","popPlacement":"right","popPopoverWidth":null,"popDisabled":null,"popOffset":null,"popOpenDelay":null,"popCloseDelay":null,"popVisibleArrow":null,"popTransition":null,"popPopperClass":null,"popPopperOptions":null,"popTabindex":null},"methods":{"elEmitShow":"function() { window.shinyVue.emit('info', 'show', arguments); }","elEmitHide":"function() { window.shinyVue.emit('info', 'hide', arguments); }","elEmitAfterEnter":"function() { window.shinyVue.emit('info', 'after_enter', arguments); }","elEmitAfterLeave":"function() { window.shinyVue.emit('info', 'after_leave', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitShow","options.methods.elEmitHide","options.methods.elEmitAfterEnter","options.methods.elEmitAfterLeave"]}</script>
#> </div>
```
