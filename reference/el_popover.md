# Element Plus Popover

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
  transition = NULL,
  popper_class = NULL,
  popper_options = NULL,
  tabindex = NULL,
  append_to = NULL,
  auto_close = NULL,
  effect = NULL,
  hide_after = NULL,
  persistent = NULL,
  popper_style = NULL,
  show_after = NULL,
  show_arrow = NULL,
  teleported = NULL,
  trigger_keys = NULL,
  virtual_ref = NULL,
  virtual_triggering = NULL,
  visible = NULL,
  ...,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
)

update_el_popover(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  content = NULL,
  disabled = NULL,
  visible = NULL
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

  How it opens: `"click"`, `"focus"`, `"hover"` (default) or
  `"contextmenu"`.

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

- transition:

  Name of the transition to animate with.

- popper_class:

  Extra class name for the card.

- popper_options:

  Additional Popper.js options, as a named list.

- tabindex:

  Tabindex of Popover. Element Plus's `tabindex` (number / string).

- append_to:

  Which element the popover CONTENT appends to. Element Plus's
  `append-to` (CSSSelector / HTMLElement).

- auto_close:

  Timeout in milliseconds to hide tooltip, not valid in controlled mode.
  Element Plus's `auto-close` (number).

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- hide_after:

  Delay of disappear, in millisecond, not valid in controlled mode.
  Element Plus's `hide-after` (number).

- persistent:

  When popover inactive and `persistent` is `false` , popover will be
  destroyed. Element Plus's `persistent` (boolean).

- popper_style:

  Custom style for popover. Element Plus's `popper-style` (string /
  object).

- show_after:

  Delay of appearance, in millisecond, not valid in controlled mode.
  Element Plus's `show-after` (number).

- show_arrow:

  Whether a tooltip arrow is displayed or not. For more info, please
  refer to ElPopper. Element Plus's `show-arrow` (boolean).

- teleported:

  Whether popover dropdown is teleported to the body. Element Plus's
  `teleported` (boolean).

- trigger_keys:

  When you click the mouse to focus on the trigger element, you can
  define a set of keyboard codes to control the display of popover
  through the keyboard, not valid in controlled mode. Element Plus's
  `trigger-keys` (Array).

- virtual_ref:

  A CSS selector, `"#help-icon"`, for an element elsewhere on the page
  that the popover is attached to, in place of a trigger of its own.
  Element Plus's `virtual-ref` takes the element itself; the selector is
  looked up in the browser.

- virtual_triggering:

  Whether virtual triggering is enabled. Element Plus's
  `virtual-triggering` (boolean); `TRUE` when `virtual_ref` is given.

- visible:

  Whether popover is visible. Element Plus's `visible` (boolean / null).

- ...:

  Any other attribute of Element Plus's tooltip, which the popover
  inherits, in snake_case: `enterable = FALSE`, `offset = 20`.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

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

  In `el_popover()`, deprecated: inside a module, wrap `id` in `ns()`,
  as for any Shiny input; a session given here namespaces `id` once
  more, with a warning. In `update_el_popover()`, the Shiny session, the
  current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>_show` | `events = "show"` | triggers when popover shows |
| `input$<id>_hide` | `events = "hide"` | triggers when popover hides |
| `input$<id>_after_enter` | `events = "after_enter"` | triggers when the entering transition ends |
| `input$<id>_after_leave` | `events = "after_leave"` | triggers when the leaving transition ends |
| `input$<id>_before_enter` | `events = "before_enter"` | triggers when the entering transition before |
| `input$<id>_before_leave` | `events = "before_leave"` | triggers when the leaving transition before |

The same list as `el_events("el_popover")`, which says how an event's
arguments travel.

## Updating from the server

Server-side update for `el_popover()`. Setting `visible` opens or closes
the card, which then stays as set: Element Plus's popover is controlled
by its `visible` once that is given.

`update_el_popover()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_popover(
  "info",
  reference = el$button("Details"),
  title = "March",
  content = "Revenue up 4% on February."
)
#> <div id="info" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="info_container" style="display: contents">
#>   <el-popover :title="popTitle === null ? undefined : popTitle" :content="popContent === null ? undefined : popContent" :trigger="popTrigger === null ? undefined : popTrigger" :placement="popPlacement === null ? undefined : popPlacement" :width="popPopoverWidth === null ? undefined : popPopoverWidth" :disabled="popDisabled === null ? undefined : popDisabled" :offset="popOffset === null ? undefined : popOffset" :transition="popTransition === null ? undefined : popTransition" :popper-class="popPopperClass === null ? undefined : popPopperClass" :popper-options="popPopperOptions === null ? undefined : popPopperOptions" :tabindex="popTabindex === null ? undefined : popTabindex" :append-to="popAppendTo === null ? undefined : popAppendTo" :auto-close="popAutoClose === null ? undefined : popAutoClose" :effect="popEffect === null ? undefined : popEffect" :hide-after="popHideAfter === null ? undefined : popHideAfter" :persistent="popPersistent === null ? undefined : popPersistent" :popper-style="popPopperStyle === null ? undefined : popPopperStyle" :show-after="popShowAfter === null ? undefined : popShowAfter" :show-arrow="popShowArrow === null ? undefined : popShowArrow" :teleported="popTeleported === null ? undefined : popTeleported" :trigger-keys="popTriggerKeys === null ? undefined : popTriggerKeys" :virtual-ref="$elRef(popVirtualRef)" :virtual-triggering="popVirtualTriggering === null ? undefined : popVirtualTriggering" :visible="popVisible === null ? undefined : popVisible">
#>     <template v-slot:reference>
#>       <span>
#>         <el-button>Details</el-button>
#>       </span>
#>     </template>
#>   </el-popover>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"popTitle":"March","popContent":"Revenue up 4% on February.","popTrigger":null,"popPlacement":null,"popPopoverWidth":null,"popDisabled":null,"popOffset":null,"popTransition":null,"popPopperClass":null,"popPopperOptions":null,"popTabindex":null,"popAppendTo":null,"popAutoClose":null,"popEffect":null,"popHideAfter":null,"popPersistent":null,"popPopperStyle":null,"popShowAfter":null,"popShowArrow":null,"popTeleported":null,"popTriggerKeys":null,"popVirtualRef":null,"popVirtualTriggering":null,"popVisible":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>

# Hover, with markup in the body
el_popover(
  "info",
  reference = el$button("Details"),
  body = shiny::tags$ul(shiny::tags$li("One"), shiny::tags$li("Two")),
  trigger = "hover",
  placement = "right"
)
#> <div id="info" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="info_container" style="display: contents">
#>   <el-popover :title="popTitle === null ? undefined : popTitle" :content="popContent === null ? undefined : popContent" :trigger="popTrigger === null ? undefined : popTrigger" :placement="popPlacement === null ? undefined : popPlacement" :width="popPopoverWidth === null ? undefined : popPopoverWidth" :disabled="popDisabled === null ? undefined : popDisabled" :offset="popOffset === null ? undefined : popOffset" :transition="popTransition === null ? undefined : popTransition" :popper-class="popPopperClass === null ? undefined : popPopperClass" :popper-options="popPopperOptions === null ? undefined : popPopperOptions" :tabindex="popTabindex === null ? undefined : popTabindex" :append-to="popAppendTo === null ? undefined : popAppendTo" :auto-close="popAutoClose === null ? undefined : popAutoClose" :effect="popEffect === null ? undefined : popEffect" :hide-after="popHideAfter === null ? undefined : popHideAfter" :persistent="popPersistent === null ? undefined : popPersistent" :popper-style="popPopperStyle === null ? undefined : popPopperStyle" :show-after="popShowAfter === null ? undefined : popShowAfter" :show-arrow="popShowArrow === null ? undefined : popShowArrow" :teleported="popTeleported === null ? undefined : popTeleported" :trigger-keys="popTriggerKeys === null ? undefined : popTriggerKeys" :virtual-ref="$elRef(popVirtualRef)" :virtual-triggering="popVirtualTriggering === null ? undefined : popVirtualTriggering" :visible="popVisible === null ? undefined : popVisible">
#>     <ul>
#>       <li>One</li>
#>       <li>Two</li>
#>     </ul>
#>     <template v-slot:reference>
#>       <span>
#>         <el-button>Details</el-button>
#>       </span>
#>     </template>
#>   </el-popover>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"popTitle":null,"popContent":null,"popTrigger":"hover","popPlacement":"right","popPopoverWidth":null,"popDisabled":null,"popOffset":null,"popTransition":null,"popPopperClass":null,"popPopperOptions":null,"popTabindex":null,"popAppendTo":null,"popAutoClose":null,"popEffect":null,"popHideAfter":null,"popPersistent":null,"popPopperStyle":null,"popShowAfter":null,"popShowArrow":null,"popTeleported":null,"popTriggerKeys":null,"popVirtualRef":null,"popVirtualTriggering":null,"popVisible":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$explain, {
    update_el_popover(session, "info", content = summary_text(), visible = TRUE)
  })
}
```
