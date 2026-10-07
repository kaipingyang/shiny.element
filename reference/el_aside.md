# Element Plus Aside

Element Plus Aside

## Usage

``` r
el_aside(..., width = "300px", style = NULL, class = NULL)
```

## Arguments

- ...:

  Content.

- width:

  Aside width. Defaults to `"300px"`, as in Element Plus, which sets it
  as the CSS variable `--el-<part>-<size>`.

- style:

  Extra inline style.

- class:

  Extra CSS classes.

## Value

A Shiny UI element.

## Examples

``` r
el_aside("Navigation")
#> <aside class="el-aside" style="--el-aside-width:300px">Navigation</aside>
el_aside(width = "200px", el_radio_group("nav", choices = c(Home = "h")))
#> <aside class="el-aside" style="--el-aside-width:200px">
#>   <div id="nav" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="nav_container" style="display: contents">
#>   <el-radio-group v-model="value" :disabled="disabled" @change="handleChange" :size="size === null ? undefined : size" :fill="fill === null ? undefined : fill" :text-color="textColor === null ? undefined : textColor" :aria-label="ariaLabel === null ? undefined : ariaLabel" :props="props === null ? undefined : props" :type="type === null ? undefined : type" :validate-event="validateEvent === null ? undefined : validateEvent">
#>     <el-radio :label="opt.value" v-for="opt in options" :key="opt.value" :disabled="opt.disabled" :border="opt.border" :name="opt.name" @change="handleItemChange(opt, $event)">{{opt.label}}</el-radio>
#>   </el-radio-group>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"h","label":"Home"}],"disabled":false,"size":null,"fill":null,"textColor":null,"ariaLabel":null,"props":null,"type":null,"validateEvent":null},"methods":{"handleItemChange":"function(opt, checked) { window.shinyVue.emit('nav', 'item_change', [{value: opt.value, label: opt.label, checked: checked}]); }","handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleItemChange","options.methods.handleChange"]}</script>
#>   </div>
#> </aside>
```
