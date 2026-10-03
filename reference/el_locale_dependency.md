# Element Plus Locale Dependency

Element Plus's own build is in English: a pagination control's total, a
date picker's buttons, a select's placeholder, a table's empty message.
Loading a locale file and handing it to Element Plus, as
`app.use(ElementPlus, {locale})` does, switches all of it.

## Usage

``` r
el_locale_dependency(locale = NULL)
```

## Arguments

- locale:

  Language to switch to, such as `"fr"`, `"zh-cn"` or `"pt-br"`. `NULL`
  or `"en"` leaves Element Plus's built-in English.

## Value

A list of htmlDependency objects, or `NULL` for the built-in locale.

## Details

All 67 of Element Plus's locales are bundled;
[`el_locales()`](https://kaipingyang.github.io/shiny.element/reference/el_locales.md)
lists them. Codes are matched without regard to case, so Element UI's
`"zh-CN"` is Element Plus's `"zh-cn"`.

## Examples

``` r
el_locales()
#>  [1] "af"    "ar"    "ar-eg" "az"    "bg"    "bn"    "ca"    "ckb"   "cs"   
#> [10] "da"    "de"    "el"    "en"    "eo"    "es"    "et"    "eu"    "fa"   
#> [19] "fi"    "fr"    "he"    "hi"    "hr"    "hu"    "hy-am" "id"    "it"   
#> [28] "ja"    "kk"    "km"    "ko"    "ku"    "ky"    "lo"    "lt"    "lv"   
#> [37] "mg"    "mn"    "ms"    "my"    "nb-no" "nl"    "no"    "pa"    "pl"   
#> [46] "pt"    "pt-br" "ro"    "ru"    "sk"    "sl"    "sr"    "sv"    "sw"   
#> [55] "ta"    "te"    "th"    "tk"    "tr"    "ug-cn" "uk"    "uz-uz" "vi"   
#> [64] "zh-cn" "zh-hk" "zh-mo" "zh-tw"

# English is Element Plus's own
el_page(el_select("city", choices = c("Beijing", "Shanghai")))
#> <div class="container-fluid">
#>   <div id="city" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-select v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :size="size === null ? undefined : size" :value-key="valueKey === null ? undefined : valueKey" :name="name === null ? undefined : name" :autocomplete="autocomplete === null ? undefined : autocomplete" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :allow-create="allowCreate === null ? undefined : allowCreate" :loading="loading === null ? undefined : loading" :loading-text="loadingText === null ? undefined : loadingText" :no-match-text="noMatchText === null ? undefined : noMatchText" :no-data-text="noDataText === null ? undefined : noDataText" :popper-class="popperClass === null ? undefined : popperClass" :reserve-keyword="reserveKeyword === null ? undefined : reserveKeyword" :default-first-option="defaultFirstOption === null ? undefined : defaultFirstOption" :remote="remote === null ? undefined : remote" :filter-method="filterMethod === null ? undefined : filterMethod" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @visible-change="elEmitVisibleChange" @remove-tag="elEmitRemoveTag" @clear="elEmitClear" @blur="elEmitBlur" @focus="elEmitFocus" @end-reached="elEmitEndReached" @popup-scroll="elEmitPopupScroll" :append-to="appendTo === null ? undefined : appendTo" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :collapse-tags-tooltip="collapseTagsTooltip === null ? undefined : collapseTagsTooltip" :debounce="debounce === null ? undefined : debounce" :effect="effect === null ? undefined : effect" :empty-values="emptyValues === null ? undefined : emptyValues" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :fit-input-width="fitInputWidth === null ? undefined : fitInputWidth" :max-collapse-tags="maxCollapseTags === null ? undefined : maxCollapseTags" :offset="offset === null ? undefined : offset" :persistent="persistent === null ? undefined : persistent" :placement="placement === null ? undefined : placement" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :remote-show-suffix="remoteShowSuffix === null ? undefined : remoteShowSuffix" :show-arrow="showArrow === null ? undefined : showArrow" :suffix-icon="suffixIcon === null ? undefined : suffixIcon" :suffix-transition="suffixTransition === null ? undefined : suffixTransition" :tabindex="tabindex === null ? undefined : tabindex" :tag-effect="tagEffect === null ? undefined : tagEffect" :tag-type="tagType === null ? undefined : tagType" :tag-tooltip="tagTooltip === null ? undefined : tagTooltip" :teleported="teleported === null ? undefined : teleported" :validate-event="validateEvent === null ? undefined : validateEvent" :value-on-clear="valueOnClear === null ? undefined : valueOnClear">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"Beijing","label":"Beijing"},{"value":"Shanghai","label":"Shanghai"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"remoteMethod":null,"appendTo":null,"ariaLabel":null,"clearIcon":null,"collapseTagsTooltip":null,"debounce":null,"effect":null,"emptyValues":null,"fallbackPlacements":null,"fitInputWidth":null,"maxCollapseTags":null,"offset":null,"persistent":null,"placement":null,"popperOptions":null,"popperStyle":null,"remoteShowSuffix":null,"showArrow":null,"suffixIcon":null,"suffixTransition":null,"tabindex":null,"tagEffect":null,"tagType":null,"tagTooltip":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"elEmitVisibleChange":"function() { window.shinyVue.emit('city', 'visible_change', arguments); }","elEmitRemoveTag":"function() { window.shinyVue.emit('city', 'remove_tag', arguments); }","elEmitClear":"function() { window.shinyVue.emit('city', 'clear', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('city', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('city', 'focus', arguments); }","elEmitEndReached":"function() { window.shinyVue.emit('city', 'end_reached', arguments); }","elEmitPopupScroll":"function() { var shape = function(e) { var now = Date.now(); if (this._elLastScroll && now - this._elLastScroll < 200) return undefined; this._elLastScroll = now; return {scroll_left: e.scrollLeft, scroll_top: e.scrollTop}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('city', 'popup_scroll', [v]); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n  this.loading = true;\n  clearTimeout(this._elQueryTimer);\n  this._elQueryTimer = setTimeout(function() {\n    if (self._elQueryN !== n || !self.loading) return;\n    self.loading = false;\n    console.warn('[shiny.element] no answer to input$city_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n  }, window.shinyVue.askTimeout);\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitVisibleChange","options.methods.elEmitRemoveTag","options.methods.elEmitClear","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitEndReached","options.methods.elEmitPopupScroll","options.methods.elRemoteQuery","options.methods.handleChange"]}</script>
#>   </div>
#> </div>

# Anything Element Plus ships
el_page(locale = "ja", el_select("city", choices = c("Beijing", "Shanghai")))
#> <div class="container-fluid">
#>   <div id="city" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-select v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :size="size === null ? undefined : size" :value-key="valueKey === null ? undefined : valueKey" :name="name === null ? undefined : name" :autocomplete="autocomplete === null ? undefined : autocomplete" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :allow-create="allowCreate === null ? undefined : allowCreate" :loading="loading === null ? undefined : loading" :loading-text="loadingText === null ? undefined : loadingText" :no-match-text="noMatchText === null ? undefined : noMatchText" :no-data-text="noDataText === null ? undefined : noDataText" :popper-class="popperClass === null ? undefined : popperClass" :reserve-keyword="reserveKeyword === null ? undefined : reserveKeyword" :default-first-option="defaultFirstOption === null ? undefined : defaultFirstOption" :remote="remote === null ? undefined : remote" :filter-method="filterMethod === null ? undefined : filterMethod" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @visible-change="elEmitVisibleChange" @remove-tag="elEmitRemoveTag" @clear="elEmitClear" @blur="elEmitBlur" @focus="elEmitFocus" @end-reached="elEmitEndReached" @popup-scroll="elEmitPopupScroll" :append-to="appendTo === null ? undefined : appendTo" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :collapse-tags-tooltip="collapseTagsTooltip === null ? undefined : collapseTagsTooltip" :debounce="debounce === null ? undefined : debounce" :effect="effect === null ? undefined : effect" :empty-values="emptyValues === null ? undefined : emptyValues" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :fit-input-width="fitInputWidth === null ? undefined : fitInputWidth" :max-collapse-tags="maxCollapseTags === null ? undefined : maxCollapseTags" :offset="offset === null ? undefined : offset" :persistent="persistent === null ? undefined : persistent" :placement="placement === null ? undefined : placement" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :remote-show-suffix="remoteShowSuffix === null ? undefined : remoteShowSuffix" :show-arrow="showArrow === null ? undefined : showArrow" :suffix-icon="suffixIcon === null ? undefined : suffixIcon" :suffix-transition="suffixTransition === null ? undefined : suffixTransition" :tabindex="tabindex === null ? undefined : tabindex" :tag-effect="tagEffect === null ? undefined : tagEffect" :tag-type="tagType === null ? undefined : tagType" :tag-tooltip="tagTooltip === null ? undefined : tagTooltip" :teleported="teleported === null ? undefined : teleported" :validate-event="validateEvent === null ? undefined : validateEvent" :value-on-clear="valueOnClear === null ? undefined : valueOnClear">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"Beijing","label":"Beijing"},{"value":"Shanghai","label":"Shanghai"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"remoteMethod":null,"appendTo":null,"ariaLabel":null,"clearIcon":null,"collapseTagsTooltip":null,"debounce":null,"effect":null,"emptyValues":null,"fallbackPlacements":null,"fitInputWidth":null,"maxCollapseTags":null,"offset":null,"persistent":null,"placement":null,"popperOptions":null,"popperStyle":null,"remoteShowSuffix":null,"showArrow":null,"suffixIcon":null,"suffixTransition":null,"tabindex":null,"tagEffect":null,"tagType":null,"tagTooltip":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"elEmitVisibleChange":"function() { window.shinyVue.emit('city', 'visible_change', arguments); }","elEmitRemoveTag":"function() { window.shinyVue.emit('city', 'remove_tag', arguments); }","elEmitClear":"function() { window.shinyVue.emit('city', 'clear', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('city', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('city', 'focus', arguments); }","elEmitEndReached":"function() { window.shinyVue.emit('city', 'end_reached', arguments); }","elEmitPopupScroll":"function() { var shape = function(e) { var now = Date.now(); if (this._elLastScroll && now - this._elLastScroll < 200) return undefined; this._elLastScroll = now; return {scroll_left: e.scrollLeft, scroll_top: e.scrollTop}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('city', 'popup_scroll', [v]); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n  this.loading = true;\n  clearTimeout(this._elQueryTimer);\n  this._elQueryTimer = setTimeout(function() {\n    if (self._elQueryN !== n || !self.loading) return;\n    self.loading = false;\n    console.warn('[shiny.element] no answer to input$city_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n  }, window.shinyVue.askTimeout);\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitVisibleChange","options.methods.elEmitRemoveTag","options.methods.elEmitClear","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitEndReached","options.methods.elEmitPopupScroll","options.methods.elRemoteQuery","options.methods.handleChange"]}</script>
#>   </div>
#> </div>

# Or set it for the whole session
options(shiny.element.locale = "zh-cn")
```
