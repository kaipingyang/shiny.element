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
#>   <div id="refresh" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="refresh_container" style="display: contents">
#>   <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Refresh","type":"default","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","evals":["options.methods.handleClick"]}</script>
#>   </div>
#> </div>
```
