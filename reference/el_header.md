# Element UI Header

Element UI Header

## Usage

``` r
el_header(..., height = "60px", style = NULL, class = NULL)
```

## Arguments

- ...:

  Content.

- height:

  Header height. Defaults to `"60px"`, as in Element UI, which sets it
  inline rather than through the stylesheet.

- style:

  Extra inline style.

- class:

  Extra CSS classes.

## Value

A Shiny UI element.

## Examples

``` r
el_header("Dashboard")
#> <div class="el-header" style="height:60px">Dashboard</div>
el_header(height = "80px", el_button("refresh", "Refresh"))
#> <div class="el-header" style="height:80px">
#>   <div id="refresh_container" style="display: contents">
#>     <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size">{{label}}</el-button>
#>   </div>
#>   <div id="refresh" style="width:0px;height:0px;" class="vue html-widget"></div>
#>   <script type="application/json" data-for="refresh">{"x":{"el":"#refresh_container","data":{"label":"Refresh","type":"default","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","count":0},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('refresh', this.count); } }"}},"evals":["methods.handleClick"],"jsHooks":[]}</script>
#> </div>
```
