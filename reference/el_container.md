# Element UI Container

Emits `<div class="el-container">` directly.

## Usage

``` r
el_container(
  ...,
  id = NULL,
  direction = NULL,
  style = NULL,
  class = NULL,
  session = NULL
)
```

## Arguments

- ...:

  Child components, typically
  [`el_header()`](https://kaipingyang.github.io/shiny.element/reference/el_header.md),
  [`el_aside()`](https://kaipingyang.github.io/shiny.element/reference/el_aside.md),
  [`el_main()`](https://kaipingyang.github.io/shiny.element/reference/el_main.md)
  and
  [`el_footer()`](https://kaipingyang.github.io/shiny.element/reference/el_footer.md).

- id:

  Optional container id.

- direction:

  `"horizontal"` or `"vertical"`. Defaults to vertical when a direct
  child is a header or footer, matching Element UI.

- style:

  Extra inline style.

- class:

  Extra CSS classes.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Details

The previous implementation mounted a Vue instance and passed the
rendered children in as a `template` string. That silently dropped every
nested component: serialising the children flattened each htmlwidget's
`<script type="application/json">` into the template, and Vue's compiler
rejects `<script>` tags — with no message, because `vue.min.js` is a
production build that strips its warnings. The container simply rendered
nothing. Element UI's container styles are plain CSS, so no Vue instance
is needed and nested widgets initialise normally.

## Examples

``` r
# Header above a sidebar and main area
el_container(
  el_header("Title"),
  el_container(
    el_aside(width = "200px", "Sidebar"),
    el_main("Content")
  )
)
#> <div class="el-container is-vertical">
#>   <div class="el-header" style="height:60px">Title</div>
#>   <div class="el-container">
#>     <div class="el-aside" style="width:200px">Sidebar</div>
#>     <div class="el-main">Content</div>
#>   </div>
#> </div>

# Nested inputs work, unlike with the previous Vue template approach
el_container(
  el_header(el_switch("dark_mode", value = FALSE)),
  el_main(el_slider("amount", value = 50))
)
#> <div class="el-container is-vertical">
#>   <div class="el-header" style="height:60px">
#>     <div id="dark_mode_container" style="display: contents">
#>       <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :active-icon-class="activeIconClass === null ? undefined : activeIconClass" :inactive-icon-class="inactiveIconClass === null ? undefined : inactiveIconClass" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent"></el-switch>
#>     </div>
#>     <div id="dark_mode" style="width:0px;height:0px;" class="vue html-widget"></div>
#>     <script type="application/json" data-for="dark_mode">{"x":{"el":"#dark_mode_container","data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"activeIconClass":null,"inactiveIconClass":null,"name":null,"validateEvent":null},"methods":{"handleChange":"function(value) { window.Shiny && Shiny.setInputValue('dark_mode', value); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue(\"dark_mode\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>   </div>
#>   <div class="el-main">
#>     <div id="amount_container" style="display: contents">
#>       <el-slider v-model="value" :min="min" :max="max" :step="step" :range="range" :disabled="disabled" :show-input="showInput" :show-stops="showStops" :show-tooltip="showTooltip" :vertical="vertical" @change="handleChange" :height="height === null ? undefined : height" :marks="marks === null ? undefined : marks" :label="label === null ? undefined : label" :debounce="debounce === null ? undefined : debounce" :input-size="inputSize === null ? undefined : inputSize" :show-input-controls="showInputControls === null ? undefined : showInputControls" :tooltip-class="tooltipClass === null ? undefined : tooltipClass" :format-tooltip="formatTooltip === null ? undefined : formatTooltip" @input="elEmitInput"></el-slider>
#>     </div>
#>     <div id="amount" style="width:0px;height:0px;" class="vue html-widget"></div>
#>     <script type="application/json" data-for="amount">{"x":{"el":"#amount_container","data":{"value":50,"min":0,"max":100,"step":1,"range":false,"disabled":false,"showInput":false,"showStops":false,"showTooltip":true,"vertical":false,"height":null,"marks":null,"label":null,"debounce":null,"inputSize":null,"showInputControls":null,"tooltipClass":null,"formatTooltip":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('amount', 'input', arguments); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue('amount', value); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue(\"amount\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitInput","methods.handleChange","mounted"],"jsHooks":[]}</script>
#>   </div>
#> </div>
```
