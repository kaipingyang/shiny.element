# Element UI Statistic

A headline number with a title, and an optional prefix and suffix.

## Usage

``` r
el_statistic(
  id = NULL,
  value = 0,
  title = NULL,
  prefix = NULL,
  suffix = NULL,
  precision = NULL,
  decimal_separator = NULL,
  group_separator = NULL,
  rate = NULL,
  value_style = NULL,
  formatter = NULL,
  time_indices = FALSE,
  format = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- value:

  The number.

- title:

  Label above it.

- prefix, suffix:

  Text before and after the number, such as a currency symbol or a unit.

- precision:

  Decimal places to show.

- decimal_separator:

  Decimal point. Default `"."`.

- group_separator:

  Separator between digit groups, such as `","`. Element's default is
  none, so `26048` shows as it is.

- rate:

  How the digits are grouped, as a power of ten: `1000` (the default)
  makes groups of three, `10000` groups of four. It only has an effect
  with a `group_separator`.

- value_style:

  CSS for the number, as a string or a named list.

- formatter:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(value)` returning the text to show, in place of
  Element's formatting.

- time_indices:

  Count down to `value` rather than show it. `value` is then the moment
  to count down to, a `POSIXct` or milliseconds since the epoch.

- format:

  How a countdown is shown, such as `"HH:mm:ss"`. Default
  `"HH:mm:ss:SSS"`.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `prefix`, `suffix`, `title`,
  `formatter`.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Shiny inputs

With `time_indices = TRUE`:

- `input$<id>_finish` – fires when the countdown reaches zero.

- `input$<id>_change` – the milliseconds left. Element raises this on
  every frame; it is sent at most once a second, which is as often as a
  server can usefully hear it.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `suspend()` – pause or resume a countdown

## Examples

``` r
el_statistic("users", value = 26048, title = "Active users",
             group_separator = ",")
#> <div id="users" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="users_container" style="display: contents">
#>   <el-statistic :value="value" :title="title === null ? undefined : title" :prefix="prefix === null ? undefined : prefix" :suffix="suffix === null ? undefined : suffix" :precision="precision === null ? undefined : precision" :decimal-separator="decimalSeparator === null ? undefined : decimalSeparator" :group-separator="groupSeparator === null ? undefined : groupSeparator" :rate="rate === null ? undefined : rate" :value-style="valueStyle === null ? undefined : valueStyle" :formatter="formatter === null ? undefined : formatter" :time-indices="timeIndices" :format="format === null ? undefined : format" @finish="elEmitFinish" @change="elEmitChange"></el-statistic>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":26048,"title":"Active users","prefix":null,"suffix":null,"precision":null,"decimalSeparator":null,"groupSeparator":",","rate":null,"valueStyle":null,"formatter":null,"timeIndices":false,"format":null},"methods":{"elEmitFinish":"function() { var shape = function() { return true; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('users', 'finish', [v]); }","elEmitChange":"function() { var shape = function(ms) { var now = Date.now(); if (this._elLastChange && now - this._elLastChange < 1000) return undefined; this._elLastChange = now; return ms; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('users', 'change', [v]); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitFinish","options.methods.elEmitChange"]}</script>
#> </div>
el_statistic("revenue", value = 1318.5, title = "Revenue", prefix = "$",
             precision = 2)
#> <div id="revenue" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="revenue_container" style="display: contents">
#>   <el-statistic :value="value" :title="title === null ? undefined : title" :prefix="prefix === null ? undefined : prefix" :suffix="suffix === null ? undefined : suffix" :precision="precision === null ? undefined : precision" :decimal-separator="decimalSeparator === null ? undefined : decimalSeparator" :group-separator="groupSeparator === null ? undefined : groupSeparator" :rate="rate === null ? undefined : rate" :value-style="valueStyle === null ? undefined : valueStyle" :formatter="formatter === null ? undefined : formatter" :time-indices="timeIndices" :format="format === null ? undefined : format" @finish="elEmitFinish" @change="elEmitChange"></el-statistic>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":1318.5,"title":"Revenue","prefix":"$","suffix":null,"precision":2,"decimalSeparator":null,"groupSeparator":null,"rate":null,"valueStyle":null,"formatter":null,"timeIndices":false,"format":null},"methods":{"elEmitFinish":"function() { var shape = function() { return true; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('revenue', 'finish', [v]); }","elEmitChange":"function() { var shape = function(ms) { var now = Date.now(); if (this._elLastChange && now - this._elLastChange < 1000) return undefined; this._elLastChange = now; return ms; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('revenue', 'change', [v]); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitFinish","options.methods.elEmitChange"]}</script>
#> </div>

# A countdown to an hour from now
el_statistic("sale", title = "Sale ends in", time_indices = TRUE,
             value = Sys.time() + 3600, format = "HH:mm:ss")
#> <div id="sale" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="sale_container" style="display: contents">
#>   <el-statistic :value="value" :title="title === null ? undefined : title" :prefix="prefix === null ? undefined : prefix" :suffix="suffix === null ? undefined : suffix" :precision="precision === null ? undefined : precision" :decimal-separator="decimalSeparator === null ? undefined : decimalSeparator" :group-separator="groupSeparator === null ? undefined : groupSeparator" :rate="rate === null ? undefined : rate" :value-style="valueStyle === null ? undefined : valueStyle" :formatter="formatter === null ? undefined : formatter" :time-indices="timeIndices" :format="format === null ? undefined : format" @finish="elEmitFinish" @change="elEmitChange"></el-statistic>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":1790974001814.24,"title":"Sale ends in","prefix":null,"suffix":null,"precision":null,"decimalSeparator":null,"groupSeparator":null,"rate":null,"valueStyle":null,"formatter":null,"timeIndices":true,"format":"HH:mm:ss"},"methods":{"elEmitFinish":"function() { var shape = function() { return true; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('sale', 'finish', [v]); }","elEmitChange":"function() { var shape = function(ms) { var now = Date.now(); if (this._elLastChange && now - this._elLastChange < 1000) return undefined; this._elLastChange = now; return ms; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('sale', 'change', [v]); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitFinish","options.methods.elEmitChange"]}</script>
#> </div>
```
