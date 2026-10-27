# Element Plus Header

Element Plus Header

## Usage

``` r
el_header(..., height = "60px", style = NULL, class = NULL)
```

## Arguments

- ...:

  Content.

- height:

  Header height. Defaults to `"60px"`, as in Element Plus, which sets it
  as the CSS variable `--el-<part>-<size>`.

- style:

  Extra inline style.

- class:

  Extra CSS classes.

## Value

A Shiny UI element.

## Examples

``` r
el_header("Dashboard")
#> <header class="el-header" style="--el-header-height:60px">Dashboard</header>
el_header(height = "80px", el_button("refresh", "Refresh"))
#> <header class="el-header" style="--el-header-height:80px">
#>   <div id="refresh" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="refresh_container" style="display: contents">
#>   <el-button v-bind="$optional(&#39;button&#39;)" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Refresh","circle":false,"loading":false,"disabled":false,"native_type":"button","count":0,"state":"ready","size":null,"icon":null,"autofocus":false,"type":null,"plain":null,"round":null,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"optional":{"button":{"size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","auto-insert-space":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loading-icon":"loadingIcon","tag":"tag","text":"text"}},"evals":["options.methods.handleClick"]}</script>
#>   </div>
#> </header>
```
