# Element UI Locale Dependency

Element UI's own build defaults to Simplified Chinese for every
component's built-in text – a pagination control's total, a date
picker's buttons, a select's placeholder, a table's empty message.
Loading a locale file and calling `ELEMENT.locale()` switches all of it.

## Usage

``` r
el_locale_dependency(locale = NULL)
```

## Arguments

- locale:

  Language to switch to, such as `"en"`, `"fr"` or `"zh-TW"`. `NULL` or
  `"zh-CN"` leaves Element's built-in Simplified Chinese.

## Value

A list of htmlDependency objects, or `NULL` for the built-in locale.

## Details

[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
and
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
ask for English unless told otherwise, so a page built from this
package's English documentation reads in English. All 59 of Element's
locales are bundled;
[`el_locales()`](https://kaipingyang.github.io/shiny.element/reference/el_locales.md)
lists them.

## Examples

``` r
el_locales()
#>  [1] "af-ZA"   "ar"      "az"      "bg"      "bn"      "ca"      "cs-CZ"  
#>  [8] "da"      "de"      "ee"      "el"      "en"      "eo"      "es"     
#> [15] "eu"      "fa"      "fi"      "fr"      "he"      "hr"      "hu"     
#> [22] "hy-AM"   "id"      "is"      "it"      "ja"      "kg"      "km"     
#> [29] "ko"      "ku"      "kz"      "lt"      "lv"      "mn"      "ms"     
#> [36] "nb-NO"   "nl"      "pl"      "pt"      "pt-br"   "ro"      "ru-RU"  
#> [43] "si"      "sk"      "sl"      "sr"      "sr-Latn" "sv-SE"   "sw"     
#> [50] "ta"      "th"      "tk"      "tr-TR"   "ua"      "ug-CN"   "uz-UZ"  
#> [57] "vi"      "zh-CN"   "zh-TW"  

# English is the default
el_page(el_select("city", choices = c("Beijing", "Shanghai")))
#> <div class="container-fluid">
#>   <div id="city" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-select v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :size="size === null ? undefined : size" :value-key="valueKey === null ? undefined : valueKey" :name="name === null ? undefined : name" :autocomplete="autocomplete === null ? undefined : autocomplete" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :allow-create="allowCreate === null ? undefined : allowCreate" :loading="loading === null ? undefined : loading" :loading-text="loadingText === null ? undefined : loadingText" :no-match-text="noMatchText === null ? undefined : noMatchText" :no-data-text="noDataText === null ? undefined : noDataText" :popper-class="popperClass === null ? undefined : popperClass" :popper-append-to-body="popperAppendToBody === null ? undefined : popperAppendToBody" :reserve-keyword="reserveKeyword === null ? undefined : reserveKeyword" :default-first-option="defaultFirstOption === null ? undefined : defaultFirstOption" :remote="remote === null ? undefined : remote" :filter-method="filterMethod === null ? undefined : filterMethod" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @visible-change="elEmitVisibleChange" @remove-tag="elEmitRemoveTag" @clear="elEmitClear" @blur="elEmitBlur" @focus="elEmitFocus">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"Beijing","label":"Beijing"},{"value":"Shanghai","label":"Shanghai"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"popperAppendToBody":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"remoteMethod":null},"methods":{"elEmitVisibleChange":"function() { window.shinyVue.emit('city', 'visible_change', arguments); }","elEmitRemoveTag":"function() { window.shinyVue.emit('city', 'remove_tag', arguments); }","elEmitClear":"function() { window.shinyVue.emit('city', 'clear', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('city', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('city', 'focus', arguments); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  this.loading = true;\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitVisibleChange","options.methods.elEmitRemoveTag","options.methods.elEmitClear","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elRemoteQuery","options.methods.handleChange"]}</script>
#>   </div>
#> </div>

# Anything Element ships
el_page(locale = "ja", el_select("city", choices = c("Beijing", "Shanghai")))
#> <div class="container-fluid">
#>   <div id="city" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-select v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :size="size === null ? undefined : size" :value-key="valueKey === null ? undefined : valueKey" :name="name === null ? undefined : name" :autocomplete="autocomplete === null ? undefined : autocomplete" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :allow-create="allowCreate === null ? undefined : allowCreate" :loading="loading === null ? undefined : loading" :loading-text="loadingText === null ? undefined : loadingText" :no-match-text="noMatchText === null ? undefined : noMatchText" :no-data-text="noDataText === null ? undefined : noDataText" :popper-class="popperClass === null ? undefined : popperClass" :popper-append-to-body="popperAppendToBody === null ? undefined : popperAppendToBody" :reserve-keyword="reserveKeyword === null ? undefined : reserveKeyword" :default-first-option="defaultFirstOption === null ? undefined : defaultFirstOption" :remote="remote === null ? undefined : remote" :filter-method="filterMethod === null ? undefined : filterMethod" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @visible-change="elEmitVisibleChange" @remove-tag="elEmitRemoveTag" @clear="elEmitClear" @blur="elEmitBlur" @focus="elEmitFocus">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"Beijing","label":"Beijing"},{"value":"Shanghai","label":"Shanghai"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"popperAppendToBody":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"remoteMethod":null},"methods":{"elEmitVisibleChange":"function() { window.shinyVue.emit('city', 'visible_change', arguments); }","elEmitRemoveTag":"function() { window.shinyVue.emit('city', 'remove_tag', arguments); }","elEmitClear":"function() { window.shinyVue.emit('city', 'clear', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('city', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('city', 'focus', arguments); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  this.loading = true;\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitVisibleChange","options.methods.elEmitRemoveTag","options.methods.elEmitClear","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elRemoteQuery","options.methods.handleChange"]}</script>
#>   </div>
#> </div>

# Or set it for the whole session
options(shiny.element.locale = "zh-CN")
```
