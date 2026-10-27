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
[`el_locales()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_locales.md)
lists them. The ones used most – English, Chinese, Japanese, Korean,
French, German, Spanish, Portuguese (Brazil), Russian – are files; the
others are packed in one archive and taken out the first time one is
used in a session. Codes are matched without regard to case, so Element
UI's `"zh-CN"` is Element Plus's `"zh-cn"`.

Dates follow the language too: Element Plus's date and time components
read the week's first day and the names of months and days from Day.js,
whose locale, as Element Plus's guide says, has to be loaded and set
apart from its own. The page's Day.js locale is set with it – a Chinese
calendar's week starts on Monday – from Day.js's own files, bundled the
same way. Day.js has a locale for all but Kurmanji (`"ku"`) and Malagasy
(`"mg"`), whose dates stay in English. Day.js has one locale for the
page, so a config provider's own `locale` changes Element's words only.

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
#>   <style>.shiny-html-output .el-page-loading { display: none !important; }</style>
#>   <div class="el-loading-mask is-fullscreen el-page-loading" style="z-index: 3000;" aria-busy="true">
#>     <div class="el-loading-spinner"><svg class="circular" viewBox="0 0 50 50"><circle class="path" cx="25" cy="25" r="20" fill="none"></circle></svg></div>
#>   </div>
#>   <script>(function() {
#>   var mask = document.currentScript && document.currentScript.previousElementSibling;
#>   if (document.readyState !== 'loading' || !mask || !mask.classList.contains('el-page-loading')) {
#>     // drawn later, by renderUI(): its components are drawn as it arrives
#>     document.querySelectorAll('.shiny-html-output .el-page-loading').forEach(function(m) { m.remove(); });
#>     if (mask && mask.classList.contains('el-page-loading')) mask.remove();
#>     return;
#>   }
#>   var done = false;
#>   function hide() {
#>     if (done) return;
#>     done = true;
#>     mask.style.opacity = '0';
#>     setTimeout(function() { mask.remove(); }, 300);
#>   }
#>   function ready() {
#>     var hosts = document.querySelectorAll('[data-shiny-vue]').length;
#>     var roots = document.querySelectorAll('[data-shiny-vue-root]').length;
#>     var shiny = !window.Shiny ||
#>       (Shiny.shinyapp && Shiny.shinyapp.isConnected && Shiny.shinyapp.isConnected());
#>     return roots >= hosts && shiny;
#>   }
#>   function poll() { if (done) return; if (ready()) hide(); else setTimeout(poll, 50); }
#>   setTimeout(hide, 10000);
#>   document.addEventListener('DOMContentLoaded', poll);
#> })();</script>
#>   <div id="city" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-select v-bind="$optional(&#39;select&#39;)" v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @end-reached="svEmitEndReached">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"Beijing","label":"Beijing"},{"value":"Shanghai","label":"Shanghai"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"remoteMethod":null,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"appendTo":null,"ariaLabel":null,"clearIcon":null,"collapseTagsTooltip":null,"debounce":null,"effect":null,"emptyValues":null,"fallbackPlacements":null,"fitInputWidth":null,"maxCollapseTags":null,"offset":null,"persistent":null,"placement":null,"popperOptions":null,"popperStyle":null,"remoteShowSuffix":null,"showArrow":null,"suffixIcon":null,"suffixTransition":null,"tabindex":null,"tagEffect":null,"tagType":null,"tagTooltip":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"svEmitEndReached":"function() { window.shinyVue.emit('city', 'end_reached', arguments); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n  this.loading = true;\n  clearTimeout(this._elQueryTimer);\n  this._elQueryTimer = setTimeout(function() {\n    if (self._elQueryN !== n || !self.loading) return;\n    self.loading = false;\n    console.warn('[shiny.element] no answer to input$city_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n  }, window.shinyVue.askTimeout);\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }","shinyVueReceive":"function(d) { var multiple = 'multiple' in d ? d.multiple : this.multiple; if ('value' in d && multiple && d.value !== null && !Array.isArray(d.value)) d.value = [d.value]; return d; }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"select":{"placeholder":"placeholder","size":"size","value-key":"valueKey","name":"name","autocomplete":"autocomplete","automatic-dropdown":"automaticDropdown","allow-create":"allowCreate","loading":"loading","loading-text":"loadingText","no-match-text":"noMatchText","no-data-text":"noDataText","popper-class":"popperClass","reserve-keyword":"reserveKeyword","default-first-option":"defaultFirstOption","remote":"remote","filter-method":"filterMethod","append-to":"appendTo","aria-label":"ariaLabel","clear-icon":"clearIcon","collapse-tags-tooltip":"collapseTagsTooltip","debounce":"debounce","effect":"effect","empty-values":"emptyValues","fallback-placements":"fallbackPlacements","fit-input-width":"fitInputWidth","max-collapse-tags":"maxCollapseTags","offset":"offset","persistent":"persistent","placement":"placement","popper-options":"popperOptions","popper-style":"popperStyle","remote-show-suffix":"remoteShowSuffix","show-arrow":"showArrow","suffix-icon":"suffixIcon","suffix-transition":"suffixTransition","tabindex":"tabindex","tag-effect":"tagEffect","tag-type":"tagType","tag-tooltip":"tagTooltip","teleported":"teleported","validate-event":"validateEvent","value-on-clear":"valueOnClear"}},"evals":["options.methods.svEmitEndReached","options.methods.elRemoteQuery","options.methods.handleChange","options.methods.shinyVueReceive"]}</script>
#>   </div>
#> </div>

# Anything Element Plus ships
el_page(locale = "ja", el_select("city", choices = c("Beijing", "Shanghai")))
#> <div class="container-fluid">
#>   <style>.shiny-html-output .el-page-loading { display: none !important; }</style>
#>   <div class="el-loading-mask is-fullscreen el-page-loading" style="z-index: 3000;" aria-busy="true">
#>     <div class="el-loading-spinner"><svg class="circular" viewBox="0 0 50 50"><circle class="path" cx="25" cy="25" r="20" fill="none"></circle></svg></div>
#>   </div>
#>   <script>(function() {
#>   var mask = document.currentScript && document.currentScript.previousElementSibling;
#>   if (document.readyState !== 'loading' || !mask || !mask.classList.contains('el-page-loading')) {
#>     // drawn later, by renderUI(): its components are drawn as it arrives
#>     document.querySelectorAll('.shiny-html-output .el-page-loading').forEach(function(m) { m.remove(); });
#>     if (mask && mask.classList.contains('el-page-loading')) mask.remove();
#>     return;
#>   }
#>   var done = false;
#>   function hide() {
#>     if (done) return;
#>     done = true;
#>     mask.style.opacity = '0';
#>     setTimeout(function() { mask.remove(); }, 300);
#>   }
#>   function ready() {
#>     var hosts = document.querySelectorAll('[data-shiny-vue]').length;
#>     var roots = document.querySelectorAll('[data-shiny-vue-root]').length;
#>     var shiny = !window.Shiny ||
#>       (Shiny.shinyapp && Shiny.shinyapp.isConnected && Shiny.shinyapp.isConnected());
#>     return roots >= hosts && shiny;
#>   }
#>   function poll() { if (done) return; if (ready()) hide(); else setTimeout(poll, 50); }
#>   setTimeout(hide, 10000);
#>   document.addEventListener('DOMContentLoaded', poll);
#> })();</script>
#>   <div id="city" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-select v-bind="$optional(&#39;select&#39;)" v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @end-reached="svEmitEndReached">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"Beijing","label":"Beijing"},{"value":"Shanghai","label":"Shanghai"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"remoteMethod":null,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"appendTo":null,"ariaLabel":null,"clearIcon":null,"collapseTagsTooltip":null,"debounce":null,"effect":null,"emptyValues":null,"fallbackPlacements":null,"fitInputWidth":null,"maxCollapseTags":null,"offset":null,"persistent":null,"placement":null,"popperOptions":null,"popperStyle":null,"remoteShowSuffix":null,"showArrow":null,"suffixIcon":null,"suffixTransition":null,"tabindex":null,"tagEffect":null,"tagType":null,"tagTooltip":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"svEmitEndReached":"function() { window.shinyVue.emit('city', 'end_reached', arguments); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n  this.loading = true;\n  clearTimeout(this._elQueryTimer);\n  this._elQueryTimer = setTimeout(function() {\n    if (self._elQueryN !== n || !self.loading) return;\n    self.loading = false;\n    console.warn('[shiny.element] no answer to input$city_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n  }, window.shinyVue.askTimeout);\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }","shinyVueReceive":"function(d) { var multiple = 'multiple' in d ? d.multiple : this.multiple; if ('value' in d && multiple && d.value !== null && !Array.isArray(d.value)) d.value = [d.value]; return d; }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"select":{"placeholder":"placeholder","size":"size","value-key":"valueKey","name":"name","autocomplete":"autocomplete","automatic-dropdown":"automaticDropdown","allow-create":"allowCreate","loading":"loading","loading-text":"loadingText","no-match-text":"noMatchText","no-data-text":"noDataText","popper-class":"popperClass","reserve-keyword":"reserveKeyword","default-first-option":"defaultFirstOption","remote":"remote","filter-method":"filterMethod","append-to":"appendTo","aria-label":"ariaLabel","clear-icon":"clearIcon","collapse-tags-tooltip":"collapseTagsTooltip","debounce":"debounce","effect":"effect","empty-values":"emptyValues","fallback-placements":"fallbackPlacements","fit-input-width":"fitInputWidth","max-collapse-tags":"maxCollapseTags","offset":"offset","persistent":"persistent","placement":"placement","popper-options":"popperOptions","popper-style":"popperStyle","remote-show-suffix":"remoteShowSuffix","show-arrow":"showArrow","suffix-icon":"suffixIcon","suffix-transition":"suffixTransition","tabindex":"tabindex","tag-effect":"tagEffect","tag-type":"tagType","tag-tooltip":"tagTooltip","teleported":"teleported","validate-event":"validateEvent","value-on-clear":"valueOnClear"}},"evals":["options.methods.svEmitEndReached","options.methods.elRemoteQuery","options.methods.handleChange","options.methods.shinyVueReceive"]}</script>
#>   </div>
#> </div>

# Or set it for the whole session, here undone afterwards
old <- options(shiny.element.locale = "zh-cn")
el_page(el_select("city", choices = c("Beijing", "Shanghai")))
#> <div class="container-fluid">
#>   <style>.shiny-html-output .el-page-loading { display: none !important; }</style>
#>   <div class="el-loading-mask is-fullscreen el-page-loading" style="z-index: 3000;" aria-busy="true">
#>     <div class="el-loading-spinner"><svg class="circular" viewBox="0 0 50 50"><circle class="path" cx="25" cy="25" r="20" fill="none"></circle></svg></div>
#>   </div>
#>   <script>(function() {
#>   var mask = document.currentScript && document.currentScript.previousElementSibling;
#>   if (document.readyState !== 'loading' || !mask || !mask.classList.contains('el-page-loading')) {
#>     // drawn later, by renderUI(): its components are drawn as it arrives
#>     document.querySelectorAll('.shiny-html-output .el-page-loading').forEach(function(m) { m.remove(); });
#>     if (mask && mask.classList.contains('el-page-loading')) mask.remove();
#>     return;
#>   }
#>   var done = false;
#>   function hide() {
#>     if (done) return;
#>     done = true;
#>     mask.style.opacity = '0';
#>     setTimeout(function() { mask.remove(); }, 300);
#>   }
#>   function ready() {
#>     var hosts = document.querySelectorAll('[data-shiny-vue]').length;
#>     var roots = document.querySelectorAll('[data-shiny-vue-root]').length;
#>     var shiny = !window.Shiny ||
#>       (Shiny.shinyapp && Shiny.shinyapp.isConnected && Shiny.shinyapp.isConnected());
#>     return roots >= hosts && shiny;
#>   }
#>   function poll() { if (done) return; if (ready()) hide(); else setTimeout(poll, 50); }
#>   setTimeout(hide, 10000);
#>   document.addEventListener('DOMContentLoaded', poll);
#> })();</script>
#>   <div id="city" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-select v-bind="$optional(&#39;select&#39;)" v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @end-reached="svEmitEndReached">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"Beijing","label":"Beijing"},{"value":"Shanghai","label":"Shanghai"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"remoteMethod":null,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"appendTo":null,"ariaLabel":null,"clearIcon":null,"collapseTagsTooltip":null,"debounce":null,"effect":null,"emptyValues":null,"fallbackPlacements":null,"fitInputWidth":null,"maxCollapseTags":null,"offset":null,"persistent":null,"placement":null,"popperOptions":null,"popperStyle":null,"remoteShowSuffix":null,"showArrow":null,"suffixIcon":null,"suffixTransition":null,"tabindex":null,"tagEffect":null,"tagType":null,"tagTooltip":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"svEmitEndReached":"function() { window.shinyVue.emit('city', 'end_reached', arguments); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n  this.loading = true;\n  clearTimeout(this._elQueryTimer);\n  this._elQueryTimer = setTimeout(function() {\n    if (self._elQueryN !== n || !self.loading) return;\n    self.loading = false;\n    console.warn('[shiny.element] no answer to input$city_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n  }, window.shinyVue.askTimeout);\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }","shinyVueReceive":"function(d) { var multiple = 'multiple' in d ? d.multiple : this.multiple; if ('value' in d && multiple && d.value !== null && !Array.isArray(d.value)) d.value = [d.value]; return d; }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"select":{"placeholder":"placeholder","size":"size","value-key":"valueKey","name":"name","autocomplete":"autocomplete","automatic-dropdown":"automaticDropdown","allow-create":"allowCreate","loading":"loading","loading-text":"loadingText","no-match-text":"noMatchText","no-data-text":"noDataText","popper-class":"popperClass","reserve-keyword":"reserveKeyword","default-first-option":"defaultFirstOption","remote":"remote","filter-method":"filterMethod","append-to":"appendTo","aria-label":"ariaLabel","clear-icon":"clearIcon","collapse-tags-tooltip":"collapseTagsTooltip","debounce":"debounce","effect":"effect","empty-values":"emptyValues","fallback-placements":"fallbackPlacements","fit-input-width":"fitInputWidth","max-collapse-tags":"maxCollapseTags","offset":"offset","persistent":"persistent","placement":"placement","popper-options":"popperOptions","popper-style":"popperStyle","remote-show-suffix":"remoteShowSuffix","show-arrow":"showArrow","suffix-icon":"suffixIcon","suffix-transition":"suffixTransition","tabindex":"tabindex","tag-effect":"tagEffect","tag-type":"tagType","tag-tooltip":"tagTooltip","teleported":"teleported","validate-event":"validateEvent","value-on-clear":"valueOnClear"}},"evals":["options.methods.svEmitEndReached","options.methods.elRemoteQuery","options.methods.handleChange","options.methods.shinyVueReceive"]}</script>
#>   </div>
#> </div>
options(old)
```
