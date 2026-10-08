# Element Plus Tooltip

A hint shown when the pointer rests on something.

## Usage

``` r
el_tooltip(
  id = NULL,
  reference = NULL,
  content = NULL,
  trigger = NULL,
  placement = NULL,
  effect = NULL,
  disabled = NULL,
  offset = NULL,
  hide_after = NULL,
  enterable = NULL,
  transition = NULL,
  popper_class = NULL,
  popper_options = NULL,
  append_to = NULL,
  aria_label = NULL,
  arrow_offset = NULL,
  auto_close = NULL,
  fallback_placements = NULL,
  focus_on_target = NULL,
  persistent = NULL,
  popper_style = NULL,
  raw_content = NULL,
  show_after = NULL,
  show_arrow = NULL,
  teleported = NULL,
  trigger_keys = NULL,
  virtual_ref = NULL,
  virtual_triggering = NULL,
  visible = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

update_el_tooltip(
  session = shiny::getDefaultReactiveDomain(),
  id,
  content = NULL,
  disabled = NULL,
  visible = NULL,
  virtual_ref = NULL
)
```

## Arguments

- id:

  Tooltip ID. Auto-generated if `NULL`.

- reference:

  The element the tooltip describes. Any Shiny UI, including another
  shiny.element component – that component is folded into the tooltip's
  own Vue instance rather than nested inside it, so its inputs keep
  reporting. Its `update_el_*()` no longer reaches it, though; see
  Details.

- content:

  Text of the hint.

- trigger:

  How it opens: `"hover"` (default), `"click"`, `"focus"` or
  `"contextmenu"`, or several of them as a character vector. Element
  Plus's `trigger`.

- placement:

  Where the hint appears: `"top"` (default), `"bottom"`, `"left"`,
  `"right"`, each also with `-start` and `-end`.

- effect:

  `"dark"` (default) or `"light"`.

- disabled:

  Whether the hint is suppressed.

- offset:

  Offset from the trigger, in pixels.

- hide_after:

  Hide it automatically after this many milliseconds. `0` (the default)
  keeps it until the pointer leaves.

- enterable:

  Whether the pointer may move onto the hint itself.

- transition:

  Name of the transition to animate with.

- popper_class:

  Extra class name for the hint.

- popper_options:

  Additional Popper.js options, as a named list.

- append_to:

  Which element the tooltip CONTENT appends to. Element Plus's
  `append-to` (CSSSelector / HTMLElement).

- aria_label:

  Same as `aria-label`. Element Plus's `aria-label` (string).

- arrow_offset:

  Controls the offset (padding) of the tooltip's arrow relative to the
  popper. Element Plus's `arrow-offset` (number).

- auto_close:

  Timeout in milliseconds to hide tooltip, not valid in controlled mode.
  Element Plus's `auto-close` (number).

- fallback_placements:

  List of possible positions for Tooltip popper.js. Element Plus's
  `fallback-placements` (`Placement[]`).

- focus_on_target:

  When triggering tooltips through hover, whether to focus the trigger
  element, which improves accessibility. Element Plus's
  `focus-on-target` (boolean).

- persistent:

  When tooltip inactive and `persistent` is `false` , tooltip will be
  destroyed. Element Plus's `persistent` (boolean).

- popper_style:

  Custom style for Tooltip's popper. Element Plus's `popper-style`
  (string / object).

- raw_content:

  Whether `content` is treated as HTML string. Element Plus's
  `raw-content` (boolean).

- show_after:

  Delay of appearance, in millisecond, not valid in controlled mode.
  Element Plus's `show-after` (number).

- show_arrow:

  Whether the tooltip content has an arrow. Element Plus's `show-arrow`
  (boolean).

- teleported:

  Whether tooltip content is teleported, if `true` it will be teleported
  to where `append-to` sets. Element Plus's `teleported` (boolean).

- trigger_keys:

  When you click the mouse to focus on the trigger element, you can
  define a set of keyboard codes to control the display of tooltip
  through the keyboard, not valid in controlled mode. Element Plus's
  `trigger-keys` (Array).

- virtual_ref:

  A CSS selector, `"#help-icon"`, for an element elsewhere on the page
  that the tooltip is attached to, in place of a trigger of its own.
  Element Plus's `virtual-ref` takes the element itself; the selector is
  looked up in the browser.

- virtual_triggering:

  Whether virtual triggering is enabled. Element Plus's
  `virtual-triggering` (boolean); `TRUE` when `virtual_ref` is given.

- visible:

  Visibility of Tooltip. Element Plus's `visible` (boolean).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  In `el_tooltip()`, deprecated: inside a module, wrap `id` in `ns()`,
  as for any Shiny input; a session given here namespaces `id` once
  more, with a warning. In `update_el_tooltip()`, the Shiny session, the
  current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Details

A component passed as `reference` becomes part of the tooltip's Vue
instance rather than a separate one, which is what lets it survive being
compiled into the tooltip's markup. It reports its inputs as usual, but
it no longer has a host of its own, so its `update_el_*()` cannot find
it – drive it through
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
on the tooltip's id instead.

## Updating from the server

Server-side update for `el_tooltip()`. Setting `visible` shows or hides
the hint, which then stays as set: Element Plus's tooltip is controlled
by its `visible` once that is given.

`update_el_tooltip()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
# A plain tag as the reference
el_tooltip(
  "hint",
  el$button(type = "primary", "Save"),
  content = "Writes to disk"
)
#> <div id="hint" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="hint_container" style="display: contents">
#>   <el-tooltip :content="tipContent === null ? undefined : tipContent" :placement="tipPlacement === null ? undefined : tipPlacement" :effect="tipEffect === null ? undefined : tipEffect" :disabled="tipDisabled === null ? undefined : tipDisabled" :offset="tipOffset === null ? undefined : tipOffset" :hide-after="tipHideAfter === null ? undefined : tipHideAfter" :enterable="tipEnterable === null ? undefined : tipEnterable" :transition="tipTransition === null ? undefined : tipTransition" :popper-class="tipPopperClass === null ? undefined : tipPopperClass" :popper-options="tipPopperOptions === null ? undefined : tipPopperOptions" @show="elEmitShow" @hide="elEmitHide" @before-show="elEmitBeforeShow" @before-hide="elEmitBeforeHide" :append-to="tipAppendTo === null ? undefined : tipAppendTo" :aria-label="tipAriaLabel === null ? undefined : tipAriaLabel" :arrow-offset="tipArrowOffset === null ? undefined : tipArrowOffset" :auto-close="tipAutoClose === null ? undefined : tipAutoClose" :fallback-placements="tipFallbackPlacements === null ? undefined : tipFallbackPlacements" :focus-on-target="tipFocusOnTarget === null ? undefined : tipFocusOnTarget" :persistent="tipPersistent === null ? undefined : tipPersistent" :popper-style="tipPopperStyle === null ? undefined : tipPopperStyle" :raw-content="tipRawContent === null ? undefined : tipRawContent" :show-after="tipShowAfter === null ? undefined : tipShowAfter" :show-arrow="tipShowArrow === null ? undefined : tipShowArrow" :teleported="tipTeleported === null ? undefined : tipTeleported" :trigger="tipTrigger === null ? undefined : tipTrigger" :trigger-keys="tipTriggerKeys === null ? undefined : tipTriggerKeys" :virtual-ref="$elRef(tipVirtualRef)" :virtual-triggering="tipVirtualTriggering === null ? undefined : tipVirtualTriggering" :visible="tipVisible === null ? undefined : tipVisible">
#>     <el-button type="primary">Save</el-button>
#>   </el-tooltip>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tipContent":"Writes to disk","tipPlacement":null,"tipEffect":null,"tipDisabled":null,"tipOffset":null,"tipHideAfter":null,"tipEnterable":null,"tipTransition":null,"tipPopperClass":null,"tipPopperOptions":null,"tipAppendTo":null,"tipAriaLabel":null,"tipArrowOffset":null,"tipAutoClose":null,"tipFallbackPlacements":null,"tipFocusOnTarget":null,"tipPersistent":null,"tipPopperStyle":null,"tipRawContent":null,"tipShowAfter":null,"tipShowArrow":null,"tipTeleported":null,"tipTrigger":null,"tipTriggerKeys":null,"tipVirtualRef":null,"tipVirtualTriggering":null,"tipVisible":null},"methods":{"elEmitShow":"function() { window.shinyVue.emit('hint', 'show', arguments); }","elEmitHide":"function() { window.shinyVue.emit('hint', 'hide', arguments); }","elEmitBeforeShow":"function() { window.shinyVue.emit('hint', 'before_show', arguments); }","elEmitBeforeHide":"function() { window.shinyVue.emit('hint', 'before_hide', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitShow","options.methods.elEmitHide","options.methods.elEmitBeforeShow","options.methods.elEmitBeforeHide"]}</script>
#> </div>

# Or a component, which keeps working
el_tooltip("hint", el_button("save", "Save"), content = "Writes to disk")
#> <div id="hint" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="hint_container" style="display: contents">
#>   <el-tooltip :content="tipContent === null ? undefined : tipContent" :placement="tipPlacement === null ? undefined : tipPlacement" :effect="tipEffect === null ? undefined : tipEffect" :disabled="tipDisabled === null ? undefined : tipDisabled" :offset="tipOffset === null ? undefined : tipOffset" :hide-after="tipHideAfter === null ? undefined : tipHideAfter" :enterable="tipEnterable === null ? undefined : tipEnterable" :transition="tipTransition === null ? undefined : tipTransition" :popper-class="tipPopperClass === null ? undefined : tipPopperClass" :popper-options="tipPopperOptions === null ? undefined : tipPopperOptions" @show="elEmitShow" @hide="elEmitHide" @before-show="elEmitBeforeShow" @before-hide="elEmitBeforeHide" :append-to="tipAppendTo === null ? undefined : tipAppendTo" :aria-label="tipAriaLabel === null ? undefined : tipAriaLabel" :arrow-offset="tipArrowOffset === null ? undefined : tipArrowOffset" :auto-close="tipAutoClose === null ? undefined : tipAutoClose" :fallback-placements="tipFallbackPlacements === null ? undefined : tipFallbackPlacements" :focus-on-target="tipFocusOnTarget === null ? undefined : tipFocusOnTarget" :persistent="tipPersistent === null ? undefined : tipPersistent" :popper-style="tipPopperStyle === null ? undefined : tipPopperStyle" :raw-content="tipRawContent === null ? undefined : tipRawContent" :show-after="tipShowAfter === null ? undefined : tipShowAfter" :show-arrow="tipShowArrow === null ? undefined : tipShowArrow" :teleported="tipTeleported === null ? undefined : tipTeleported" :trigger="tipTrigger === null ? undefined : tipTrigger" :trigger-keys="tipTriggerKeys === null ? undefined : tipTriggerKeys" :virtual-ref="$elRef(tipVirtualRef)" :virtual-triggering="tipVirtualTriggering === null ? undefined : tipVirtualTriggering" :visible="tipVisible === null ? undefined : tipVisible">
#>     <el-button :type="type === null ? undefined : type" :plain="plain === null ? undefined : plain" :round="round === null ? undefined : round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text" ref="sv_save" id="save">{{label}}</el-button>
#>   </el-tooltip>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tipContent":"Writes to disk","tipPlacement":null,"tipEffect":null,"tipDisabled":null,"tipOffset":null,"tipHideAfter":null,"tipEnterable":null,"tipTransition":null,"tipPopperClass":null,"tipPopperOptions":null,"label":"Save","type":null,"size":null,"plain":null,"round":null,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null,"tipAppendTo":null,"tipAriaLabel":null,"tipArrowOffset":null,"tipAutoClose":null,"tipFallbackPlacements":null,"tipFocusOnTarget":null,"tipPersistent":null,"tipPopperStyle":null,"tipRawContent":null,"tipShowAfter":null,"tipShowArrow":null,"tipTeleported":null,"tipTrigger":null,"tipTriggerKeys":null,"tipVirtualRef":null,"tipVirtualTriggering":null,"tipVisible":null},"methods":{"elEmitShow":"function() { window.shinyVue.emit('hint', 'show', arguments); }","elEmitHide":"function() { window.shinyVue.emit('hint', 'hide', arguments); }","elEmitBeforeShow":"function() { window.shinyVue.emit('hint', 'before_show', arguments); }","elEmitBeforeHide":"function() { window.shinyVue.emit('hint', 'before_hide', arguments); }","handleClick":"function() { if (this.disabled || this.loading) return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('save:shiny.action', this.count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"save:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"absorbed":{"save":{"fields":{"label":"label","type":"type","size":"size","plain":"plain","round":"round","circle":"circle","loading":"loading","disabled":"disabled","native_type":"native_type","icon":"icon","count":"count","autofocus":"autofocus","autoInsertSpace":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loadingIcon":"loadingIcon","tag":"tag","text":"text","handleClick":"handleClick"},"ref":"sv_save"}},"evals":["options.methods.elEmitShow","options.methods.elEmitHide","options.methods.elEmitBeforeShow","options.methods.elEmitBeforeHide","options.methods.handleClick","options.mounted"]}</script>
#> </div>

el_tooltip(
  "hint",
  reference = el$button(type = "danger", "Delete"),
  content = "This cannot be undone",
  placement = "right",
  effect = "light"
)
#> <div id="hint" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="hint_container" style="display: contents">
#>   <el-tooltip :content="tipContent === null ? undefined : tipContent" :placement="tipPlacement === null ? undefined : tipPlacement" :effect="tipEffect === null ? undefined : tipEffect" :disabled="tipDisabled === null ? undefined : tipDisabled" :offset="tipOffset === null ? undefined : tipOffset" :hide-after="tipHideAfter === null ? undefined : tipHideAfter" :enterable="tipEnterable === null ? undefined : tipEnterable" :transition="tipTransition === null ? undefined : tipTransition" :popper-class="tipPopperClass === null ? undefined : tipPopperClass" :popper-options="tipPopperOptions === null ? undefined : tipPopperOptions" @show="elEmitShow" @hide="elEmitHide" @before-show="elEmitBeforeShow" @before-hide="elEmitBeforeHide" :append-to="tipAppendTo === null ? undefined : tipAppendTo" :aria-label="tipAriaLabel === null ? undefined : tipAriaLabel" :arrow-offset="tipArrowOffset === null ? undefined : tipArrowOffset" :auto-close="tipAutoClose === null ? undefined : tipAutoClose" :fallback-placements="tipFallbackPlacements === null ? undefined : tipFallbackPlacements" :focus-on-target="tipFocusOnTarget === null ? undefined : tipFocusOnTarget" :persistent="tipPersistent === null ? undefined : tipPersistent" :popper-style="tipPopperStyle === null ? undefined : tipPopperStyle" :raw-content="tipRawContent === null ? undefined : tipRawContent" :show-after="tipShowAfter === null ? undefined : tipShowAfter" :show-arrow="tipShowArrow === null ? undefined : tipShowArrow" :teleported="tipTeleported === null ? undefined : tipTeleported" :trigger="tipTrigger === null ? undefined : tipTrigger" :trigger-keys="tipTriggerKeys === null ? undefined : tipTriggerKeys" :virtual-ref="$elRef(tipVirtualRef)" :virtual-triggering="tipVirtualTriggering === null ? undefined : tipVirtualTriggering" :visible="tipVisible === null ? undefined : tipVisible">
#>     <el-button type="danger">Delete</el-button>
#>   </el-tooltip>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"tipContent":"This cannot be undone","tipPlacement":"right","tipEffect":"light","tipDisabled":null,"tipOffset":null,"tipHideAfter":null,"tipEnterable":null,"tipTransition":null,"tipPopperClass":null,"tipPopperOptions":null,"tipAppendTo":null,"tipAriaLabel":null,"tipArrowOffset":null,"tipAutoClose":null,"tipFallbackPlacements":null,"tipFocusOnTarget":null,"tipPersistent":null,"tipPopperStyle":null,"tipRawContent":null,"tipShowAfter":null,"tipShowArrow":null,"tipTeleported":null,"tipTrigger":null,"tipTriggerKeys":null,"tipVirtualRef":null,"tipVirtualTriggering":null,"tipVisible":null},"methods":{"elEmitShow":"function() { window.shinyVue.emit('hint', 'show', arguments); }","elEmitHide":"function() { window.shinyVue.emit('hint', 'hide', arguments); }","elEmitBeforeShow":"function() { window.shinyVue.emit('hint', 'before_show', arguments); }","elEmitBeforeHide":"function() { window.shinyVue.emit('hint', 'before_hide', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitShow","options.methods.elEmitHide","options.methods.elEmitBeforeShow","options.methods.elEmitBeforeHide"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$explain, {
    update_el_tooltip(session, "hint", content = why_disabled())
  })
}
```
