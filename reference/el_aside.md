# Element UI Aside

Element UI Aside

## Usage

``` r
el_aside(..., width = "300px", style = NULL, class = NULL)
```

## Arguments

- ...:

  Content.

- width:

  Aside width. Defaults to `"300px"`, as in Element UI, which sets it
  inline rather than through the stylesheet.

- style:

  Extra inline style.

- class:

  Extra CSS classes.

## Value

A Shiny UI element.

## Examples

``` r
el_aside("Navigation")
#> <div class="el-aside" style="width:300px">Navigation</div>
el_aside(width = "200px", el_radio_group("nav", choices = c(Home = "h")))
#> <div class="el-aside" style="width:200px">
#>   <div id="nav" data-el-vue-host style="display: contents">
#>     <div id="nav_container" data-el-mount style="display: contents">
#>       <el-radio-group v-model="value" :disabled="disabled" @change="handleChange" :size="size === null ? undefined : size" :fill="fill === null ? undefined : fill" :text-color="textColor === null ? undefined : textColor">
#>         <el-radio :label="opt.value" v-for="opt in options" :key="opt.value" :disabled="opt.disabled" :border="opt.border" :name="opt.name" @change="handleItemChange(opt, $event)">{{opt.label}}</el-radio>
#>       </el-radio-group>
#>     </div>
#>     <script type="application/json" data-el-vue>{"options":{"data":{"value":"","options":[{"value":"h","label":"Home"}],"disabled":false,"size":null,"fill":null,"textColor":null},"methods":{"handleItemChange":"function(opt, checked) { window.shinyElement.emit('nav', 'item_change', [{value: opt.value, label: opt.label, checked: checked}]); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('nav', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleItemChange","options.methods.handleChange"]}</script>
#>   </div>
#> </div>
```
