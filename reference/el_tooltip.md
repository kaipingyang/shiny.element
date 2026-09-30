# Element UI Tooltip

A hint shown when the pointer rests on something.

## Usage

``` r
el_tooltip(
  id = NULL,
  trigger = NULL,
  content = NULL,
  placement = NULL,
  effect = NULL,
  disabled = NULL,
  offset = NULL,
  open_delay = NULL,
  hide_after = NULL,
  enterable = NULL,
  visible_arrow = NULL,
  transition = NULL,
  popper_class = NULL,
  popper_options = NULL,
  manual = NULL,
  tabindex = NULL,
  width = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Tooltip ID. Auto-generated if `NULL`.

- trigger:

  The element the tooltip describes. Any Shiny UI, including another
  shiny.element component – that component is folded into the tooltip's
  own Vue instance rather than nested inside it, so its inputs keep
  reporting. Its `update_el_*()` no longer reaches it, though; see
  Details.

- content:

  Text of the hint.

- placement:

  Where the hint appears: `"top"` (default), `"bottom"`, `"left"`,
  `"right"`, each also with `-start` and `-end`.

- effect:

  `"dark"` (default) or `"light"`.

- disabled:

  Whether the hint is suppressed.

- offset:

  Offset from the trigger, in pixels.

- open_delay:

  Delay before it appears, in milliseconds.

- hide_after:

  Hide it automatically after this many milliseconds. `0` (the default)
  keeps it until the pointer leaves.

- enterable:

  Whether the pointer may move onto the hint itself.

- visible_arrow:

  Whether to draw the little arrow. Default `TRUE`.

- transition:

  Name of the transition to animate with.

- popper_class:

  Extra class name for the hint.

- popper_options:

  Additional Popper.js options, as a named list.

- manual:

  Whether to control visibility yourself through
  [`update_el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/update_el_tooltip.md)
  rather than on hover.

- tabindex:

  Tab index of the trigger.

- width:

  Component width, as a CSS unit.

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Details

A component passed as `trigger` becomes part of the tooltip's Vue
instance rather than a separate one, which is what lets it survive being
compiled into the tooltip's markup. It reports its inputs as usual, but
it no longer has a widget of its own, so its `update_el_*()` cannot find
it – drive it through
[`update_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/update_vue_data.md)
on the tooltip's id instead.

## Examples

``` r
# A plain tag as the trigger
el_tooltip("hint", el$button(type = "primary", "Save"),
           content = "Writes to disk")
#> <div id="hint_container" style="display: contents">
#>   <el-tooltip v-model="tipValue" :content="tipContent === null ? undefined : tipContent" :placement="tipPlacement === null ? undefined : tipPlacement" :effect="tipEffect === null ? undefined : tipEffect" :disabled="tipDisabled === null ? undefined : tipDisabled" :offset="tipOffset === null ? undefined : tipOffset" :open-delay="tipOpenDelay === null ? undefined : tipOpenDelay" :hide-after="tipHideAfter === null ? undefined : tipHideAfter" :enterable="tipEnterable === null ? undefined : tipEnterable" :visible-arrow="tipVisibleArrow === null ? undefined : tipVisibleArrow" :transition="tipTransition === null ? undefined : tipTransition" :popper-class="tipPopperClass === null ? undefined : tipPopperClass" :popper-options="tipPopperOptions === null ? undefined : tipPopperOptions" :manual="tipManual === null ? undefined : tipManual" :tabindex="tipTabindex === null ? undefined : tipTabindex">
#>     <el-button type="primary">Save</el-button>
#>   </el-tooltip>
#> </div>
#> <div id="hint" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="hint">{"x":{"el":"#hint_container","data":{"tipValue":false,"tipContent":"Writes to disk","tipPlacement":null,"tipEffect":null,"tipDisabled":null,"tipOffset":null,"tipOpenDelay":null,"tipHideAfter":null,"tipEnterable":null,"tipVisibleArrow":null,"tipTransition":null,"tipPopperClass":null,"tipPopperOptions":null,"tipManual":null,"tipTabindex":null}},"evals":[],"jsHooks":[]}</script>

# Or a component, which keeps working
el_tooltip("hint", el_button("save", "Save"), content = "Writes to disk")
#> <div id="hint_container" style="display: contents">
#>   <el-tooltip v-model="tipValue" :content="tipContent === null ? undefined : tipContent" :placement="tipPlacement === null ? undefined : tipPlacement" :effect="tipEffect === null ? undefined : tipEffect" :disabled="tipDisabled === null ? undefined : tipDisabled" :offset="tipOffset === null ? undefined : tipOffset" :open-delay="tipOpenDelay === null ? undefined : tipOpenDelay" :hide-after="tipHideAfter === null ? undefined : tipHideAfter" :enterable="tipEnterable === null ? undefined : tipEnterable" :visible-arrow="tipVisibleArrow === null ? undefined : tipVisibleArrow" :transition="tipTransition === null ? undefined : tipTransition" :popper-class="tipPopperClass === null ? undefined : tipPopperClass" :popper-options="tipPopperOptions === null ? undefined : tipPopperOptions" :manual="tipManual === null ? undefined : tipManual" :tabindex="tipTabindex === null ? undefined : tipTabindex">
#>     <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#>   </el-tooltip>
#> </div>
#> <div id="hint" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="hint">{"x":{"el":"#hint_container","data":{"tipValue":false,"tipContent":"Writes to disk","tipPlacement":null,"tipEffect":null,"tipDisabled":null,"tipOffset":null,"tipOpenDelay":null,"tipHideAfter":null,"tipEnterable":null,"tipVisibleArrow":null,"tipTransition":null,"tipPopperClass":null,"tipPopperOptions":null,"tipManual":null,"tipTabindex":null,"label":"Save","type":"default","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('save', this.count); } }"}},"evals":["methods.handleClick"],"jsHooks":[]}</script>

el_tooltip("hint",
  trigger = el$button(type = "danger", "Delete"),
  content = "This cannot be undone",
  placement = "right", effect = "light"
)
#> <div id="hint_container" style="display: contents">
#>   <el-tooltip v-model="tipValue" :content="tipContent === null ? undefined : tipContent" :placement="tipPlacement === null ? undefined : tipPlacement" :effect="tipEffect === null ? undefined : tipEffect" :disabled="tipDisabled === null ? undefined : tipDisabled" :offset="tipOffset === null ? undefined : tipOffset" :open-delay="tipOpenDelay === null ? undefined : tipOpenDelay" :hide-after="tipHideAfter === null ? undefined : tipHideAfter" :enterable="tipEnterable === null ? undefined : tipEnterable" :visible-arrow="tipVisibleArrow === null ? undefined : tipVisibleArrow" :transition="tipTransition === null ? undefined : tipTransition" :popper-class="tipPopperClass === null ? undefined : tipPopperClass" :popper-options="tipPopperOptions === null ? undefined : tipPopperOptions" :manual="tipManual === null ? undefined : tipManual" :tabindex="tipTabindex === null ? undefined : tipTabindex">
#>     <el-button type="danger">Delete</el-button>
#>   </el-tooltip>
#> </div>
#> <div id="hint" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="hint">{"x":{"el":"#hint_container","data":{"tipValue":false,"tipContent":"This cannot be undone","tipPlacement":"right","tipEffect":"light","tipDisabled":null,"tipOffset":null,"tipOpenDelay":null,"tipHideAfter":null,"tipEnterable":null,"tipVisibleArrow":null,"tipTransition":null,"tipPopperClass":null,"tipPopperOptions":null,"tipManual":null,"tipTabindex":null}},"evals":[],"jsHooks":[]}</script>
```
