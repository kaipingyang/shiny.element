# Element UI Badge

Wraps any content with a numeric badge or red dot in the top-right
corner. When used without content, renders a standalone badge element.

## Usage

``` r
el_badge(
  ...,
  value = NULL,
  max = NULL,
  is_dot = FALSE,
  hidden = FALSE,
  type = NULL
)
```

## Arguments

- ...:

  Content to wrap (e.g. a button or icon).

- value:

  Badge value: number or string. Ignored when `is_dot = TRUE`.

- max:

  Maximum numeric value to display. When `value > max` the badge shows
  `"<max>+"`. Only applies when `value` is numeric.

- is_dot:

  Show a small dot instead of a number. Default `FALSE`.

- hidden:

  Whether to hide the badge. Default `FALSE`.

- type:

  Badge colour type: `NULL` (red, default), `"primary"`, `"success"`,
  `"warning"`, `"info"`, `"danger"`.

## Value

An `htmltools` tag.

## Examples

``` r
el_badge(el_button("btn1", "Messages"), value = 5)
#> <div class="el-badge">
#>   <div id="btn1" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="btn1_container" style="display: contents">
#>   <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Messages","type":"default","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('btn1', this.count); } }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClick"]}</script>
#>   </div>
#>   <sup class="el-badge__content is-fixed">5</sup>
#> </div>
el_badge(el_button("btn2", "Alerts"),   value = 200, max = 99)
#> <div class="el-badge">
#>   <div id="btn2" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="btn2_container" style="display: contents">
#>   <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Alerts","type":"default","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('btn2', this.count); } }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClick"]}</script>
#>   </div>
#>   <sup class="el-badge__content is-fixed">99+</sup>
#> </div>
el_badge(el_button("btn3", "Updates"),  is_dot = TRUE)
#> <div class="el-badge">
#>   <div id="btn3" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="btn3_container" style="display: contents">
#>   <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Updates","type":"default","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('btn3', this.count); } }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClick"]}</script>
#>   </div>
#>   <sup class="el-badge__content is-fixed is-dot"></sup>
#> </div>
```
