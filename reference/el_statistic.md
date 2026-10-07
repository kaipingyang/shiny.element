# Element Plus Statistic

A headline number with a title, and an optional prefix and suffix.
`el_countdown()` counts down to a moment instead.

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
  value_style = NULL,
  formatter = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

el_countdown(
  id = NULL,
  value = 0,
  title = NULL,
  prefix = NULL,
  suffix = NULL,
  format = NULL,
  value_style = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

update_el_statistic(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  title = NULL,
  prefix = NULL,
  suffix = NULL,
  precision = NULL,
  decimal_separator = NULL,
  group_separator = NULL,
  value_style = NULL,
  formatter = NULL
)

update_el_countdown(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  title = NULL,
  prefix = NULL,
  suffix = NULL,
  format = NULL,
  value_style = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- value:

  The number; for `el_countdown()`, the moment to count down to, a
  `POSIXct` or milliseconds since the epoch.

- title:

  Label above it.

- prefix, suffix:

  Text before and after the number, such as a currency symbol or a unit.

- precision:

  Decimal places to show.

- decimal_separator:

  Decimal point. Default `"."`.

- group_separator:

  Separator between digit groups. Default `","`.

- value_style:

  CSS for the number, as a string or a named list.

- formatter:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(value)` returning the text to show, in place of
  Element's formatting.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `prefix`, `suffix`, `title`.

- session:

  In `el_statistic()`, deprecated: inside a module, wrap `id` in `ns()`,
  as for any Shiny input; a session given here namespaces `id` once
  more, with a warning. In `update_el_statistic()`, the Shiny session,
  the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- format:

  How a countdown is shown, in day.js's tokens, such as `"HH:mm:ss"`
  (the default) or `"DD [days] HH:mm:ss"`.

## Value

A Shiny UI element.

## Shiny inputs

For `el_countdown()`:

- `input$<id>_finish` – fires when the countdown reaches zero.

- `input$<id>_change` – the milliseconds left. Element raises this on
  every frame; it is sent at most once a second, which is as often as a
  server can usefully hear it.

## Updating from the server

Server-side update for `el_statistic()` and `el_countdown()`.

Every other argument of `el_statistic()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_statistic()` is called for its side effect and returns `NULL`
invisibly.

## Updating a countdown

`update_el_countdown()` changes the countdown from the server: every
argument of `el_countdown()` that can change once it is drawn, under the
same name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

`update_el_countdown()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_statistic("users", value = 26048, title = "Active users")
#> <div id="users" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="users_container" style="display: contents">
#>   <el-statistic :value="value" :title="title === null ? undefined : title" :prefix="prefix === null ? undefined : prefix" :suffix="suffix === null ? undefined : suffix" :precision="precision === null ? undefined : precision" :decimal-separator="decimalSeparator === null ? undefined : decimalSeparator" :group-separator="groupSeparator === null ? undefined : groupSeparator" :value-style="valueStyle === null ? undefined : valueStyle" :formatter="formatter === null ? undefined : formatter"></el-statistic>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":26048,"title":"Active users","prefix":null,"suffix":null,"precision":null,"decimalSeparator":null,"groupSeparator":null,"valueStyle":null,"formatter":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>
el_statistic(
  "revenue",
  value = 1318.5,
  title = "Revenue",
  prefix = "$",
  precision = 2
)
#> <div id="revenue" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="revenue_container" style="display: contents">
#>   <el-statistic :value="value" :title="title === null ? undefined : title" :prefix="prefix === null ? undefined : prefix" :suffix="suffix === null ? undefined : suffix" :precision="precision === null ? undefined : precision" :decimal-separator="decimalSeparator === null ? undefined : decimalSeparator" :group-separator="groupSeparator === null ? undefined : groupSeparator" :value-style="valueStyle === null ? undefined : valueStyle" :formatter="formatter === null ? undefined : formatter"></el-statistic>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":1318.5,"title":"Revenue","prefix":"$","suffix":null,"precision":2,"decimalSeparator":null,"groupSeparator":null,"valueStyle":null,"formatter":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>

# A countdown to an hour from now
el_countdown(
  "sale",
  title = "Sale ends in",
  value = Sys.time() + 3600,
  format = "HH:mm:ss"
)
#> <div id="sale" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="sale_container" style="display: contents">
#>   <el-countdown :value="value" @finish="elEmitFinish" @change="elEmitChange" :title="title === null ? undefined : title" :prefix="prefix === null ? undefined : prefix" :suffix="suffix === null ? undefined : suffix" :format="format === null ? undefined : format" :value-style="valueStyle === null ? undefined : valueStyle"></el-countdown>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":1791375538549.15,"title":"Sale ends in","prefix":null,"suffix":null,"format":"HH:mm:ss","valueStyle":null},"methods":{"elEmitFinish":"function() { var shape = function() { return true; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('sale', 'finish', [v]); }","elEmitChange":"function() { var shape = function(ms) { var now = Date.now(); if (this._elLastChange && now - this._elLastChange < 1000) return undefined; this._elLastChange = now; return ms; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('sale', 'change', [v]); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitFinish","options.methods.elEmitChange"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observe(update_el_statistic(session, "users", value = n_users()))
}
```
