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

  The element the tooltip describes. Markup only – raw Element tags from
  [el](https://kaipingyang.github.io/shiny.element/reference/el.md), or
  ordinary Shiny UI. It cannot be another shiny.element component: the
  tooltip compiles this into its own Vue instance, which would discard a
  mounted one. Use `el$button(type = "primary", "Save")` rather than
  [`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md).

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

## Examples

``` r
el_tooltip("hint", el$button(type = "primary", "Save"),
           content = "Writes to disk")
#> <div id="hint_container" style="display: contents">
#>   <el-tooltip v-model="value" :content="content === null ? undefined : content" :placement="placement === null ? undefined : placement" :effect="effect === null ? undefined : effect" :disabled="disabled === null ? undefined : disabled" :offset="offset === null ? undefined : offset" :open-delay="openDelay === null ? undefined : openDelay" :hide-after="hideAfter === null ? undefined : hideAfter" :enterable="enterable === null ? undefined : enterable" :visible-arrow="visibleArrow === null ? undefined : visibleArrow" :transition="transition === null ? undefined : transition" :popper-class="popperClass === null ? undefined : popperClass" :popper-options="popperOptions === null ? undefined : popperOptions" :manual="manual === null ? undefined : manual" :tabindex="tabindex === null ? undefined : tabindex">
#>     <el-button type="primary">Save</el-button>
#>   </el-tooltip>
#> </div>
#> <div id="hint" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="hint">{"x":{"el":"#hint_container","data":{"value":false,"content":"Writes to disk","placement":null,"effect":null,"disabled":null,"offset":null,"openDelay":null,"hideAfter":null,"enterable":null,"visibleArrow":null,"transition":null,"popperClass":null,"popperOptions":null,"manual":null,"tabindex":null}},"evals":[],"jsHooks":[]}</script>

el_tooltip("hint",
  trigger = el$button(type = "danger", "Delete"),
  content = "This cannot be undone",
  placement = "right", effect = "light"
)
#> <div id="hint_container" style="display: contents">
#>   <el-tooltip v-model="value" :content="content === null ? undefined : content" :placement="placement === null ? undefined : placement" :effect="effect === null ? undefined : effect" :disabled="disabled === null ? undefined : disabled" :offset="offset === null ? undefined : offset" :open-delay="openDelay === null ? undefined : openDelay" :hide-after="hideAfter === null ? undefined : hideAfter" :enterable="enterable === null ? undefined : enterable" :visible-arrow="visibleArrow === null ? undefined : visibleArrow" :transition="transition === null ? undefined : transition" :popper-class="popperClass === null ? undefined : popperClass" :popper-options="popperOptions === null ? undefined : popperOptions" :manual="manual === null ? undefined : manual" :tabindex="tabindex === null ? undefined : tabindex">
#>     <el-button type="danger">Delete</el-button>
#>   </el-tooltip>
#> </div>
#> <div id="hint" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="hint">{"x":{"el":"#hint_container","data":{"value":false,"content":"This cannot be undone","placement":"right","effect":"light","disabled":null,"offset":null,"openDelay":null,"hideAfter":null,"enterable":null,"visibleArrow":null,"transition":null,"popperClass":null,"popperOptions":null,"manual":null,"tabindex":null}},"evals":[],"jsHooks":[]}</script>
```
