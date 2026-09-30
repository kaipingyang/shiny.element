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
  width = NULL,
  slots = NULL,
  session = shiny::getDefaultReactiveDomain()
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

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function `function(value)` returning the text to show, in place of
  Element's formatting.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `prefix`, `suffix`, `title`,
  `formatter`.

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `suspend()` – pause or resume a countdown

## Examples

``` r
el_statistic("users", value = 26048, title = "Active users",
             group_separator = ",")
#> <div id="users_container" style="display: contents">
#>   <el-statistic :value="value" :title="title === null ? undefined : title" :prefix="prefix === null ? undefined : prefix" :suffix="suffix === null ? undefined : suffix" :precision="precision === null ? undefined : precision" :decimal-separator="decimalSeparator === null ? undefined : decimalSeparator" :group-separator="groupSeparator === null ? undefined : groupSeparator" :rate="rate === null ? undefined : rate" :value-style="valueStyle === null ? undefined : valueStyle" :formatter="formatter === null ? undefined : formatter"></el-statistic>
#> </div>
#> <div id="users" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="users">{"x":{"el":"#users_container","data":{"value":26048,"title":"Active users","prefix":null,"suffix":null,"precision":null,"decimalSeparator":null,"groupSeparator":",","rate":null,"valueStyle":null,"formatter":null}},"evals":[],"jsHooks":[]}</script>
el_statistic("revenue", value = 1318.5, title = "Revenue", prefix = "$",
             precision = 2)
#> <div id="revenue_container" style="display: contents">
#>   <el-statistic :value="value" :title="title === null ? undefined : title" :prefix="prefix === null ? undefined : prefix" :suffix="suffix === null ? undefined : suffix" :precision="precision === null ? undefined : precision" :decimal-separator="decimalSeparator === null ? undefined : decimalSeparator" :group-separator="groupSeparator === null ? undefined : groupSeparator" :rate="rate === null ? undefined : rate" :value-style="valueStyle === null ? undefined : valueStyle" :formatter="formatter === null ? undefined : formatter"></el-statistic>
#> </div>
#> <div id="revenue" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="revenue">{"x":{"el":"#revenue_container","data":{"value":1318.5,"title":"Revenue","prefix":"$","suffix":null,"precision":2,"decimalSeparator":null,"groupSeparator":null,"rate":null,"valueStyle":null,"formatter":null}},"evals":[],"jsHooks":[]}</script>
```
