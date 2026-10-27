# A choice of a select, a radio group, a checkbox group

Element Plus's `el-option` and `el-option-group`, for the `choices` of
[`el_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select.md)
and the other choice components – where a named vector cannot say that
one choice is disabled, or that choices come in groups.

## Usage

``` r
el_option(label, value = label, disabled = NULL)

el_option_group(label, ..., disabled = NULL)
```

## Arguments

- label:

  The text shown.

- value:

  The value reported when it is chosen. Defaults to `label`.

- disabled:

  Whether it can be chosen; for a group, whether any of its choices can.

- ...:

  The group's choices, each an `el_option()`.

## Value

A choice, or a group of them, for `choices =`.

## See also

Other items:
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_dropdown_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_menu_item.md),
[`el_skeleton_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_skeleton_item.md),
[`el_step()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_step.md),
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tab_pane.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_column.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_v2_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tour_step.md)

## Examples

``` r
el_select(
  "city",
  choices = list(
    el_option_group(
      "Popular cities",
      el_option("Shanghai"),
      el_option("Beijing", disabled = TRUE)
    ),
    el_option_group("City name", el_option("Chengdu"), el_option("Dalian"))
  )
)
#> <div id="city" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-select v-bind="$optional(&#39;select&#39;)" v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @end-reached="svEmitEndReached">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[],"groups":[{"label":"Popular cities","disabled":false,"options":[{"value":"Shanghai","label":"Shanghai"},{"value":"Beijing","label":"Beijing","disabled":true}]},{"label":"City name","disabled":false,"options":[{"value":"Chengdu","label":"Chengdu"},{"value":"Dalian","label":"Dalian"}]}],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"remoteMethod":null,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"appendTo":null,"ariaLabel":null,"clearIcon":null,"collapseTagsTooltip":null,"debounce":null,"effect":null,"emptyValues":null,"fallbackPlacements":null,"fitInputWidth":null,"maxCollapseTags":null,"offset":null,"persistent":null,"placement":null,"popperOptions":null,"popperStyle":null,"remoteShowSuffix":null,"showArrow":null,"suffixIcon":null,"suffixTransition":null,"tabindex":null,"tagEffect":null,"tagType":null,"tagTooltip":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"svEmitEndReached":"function() { window.shinyVue.emit('city', 'end_reached', arguments); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n  this.loading = true;\n  clearTimeout(this._elQueryTimer);\n  this._elQueryTimer = setTimeout(function() {\n    if (self._elQueryN !== n || !self.loading) return;\n    self.loading = false;\n    console.warn('[shiny.element] no answer to input$city_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n  }, window.shinyVue.askTimeout);\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }","shinyVueReceive":"function(d) { var multiple = 'multiple' in d ? d.multiple : this.multiple; if ('value' in d && multiple && d.value !== null && !Array.isArray(d.value)) d.value = [d.value]; return d; }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"select":{"placeholder":"placeholder","size":"size","value-key":"valueKey","name":"name","autocomplete":"autocomplete","automatic-dropdown":"automaticDropdown","allow-create":"allowCreate","loading":"loading","loading-text":"loadingText","no-match-text":"noMatchText","no-data-text":"noDataText","popper-class":"popperClass","reserve-keyword":"reserveKeyword","default-first-option":"defaultFirstOption","remote":"remote","filter-method":"filterMethod","append-to":"appendTo","aria-label":"ariaLabel","clear-icon":"clearIcon","collapse-tags-tooltip":"collapseTagsTooltip","debounce":"debounce","effect":"effect","empty-values":"emptyValues","fallback-placements":"fallbackPlacements","fit-input-width":"fitInputWidth","max-collapse-tags":"maxCollapseTags","offset":"offset","persistent":"persistent","placement":"placement","popper-options":"popperOptions","popper-style":"popperStyle","remote-show-suffix":"remoteShowSuffix","show-arrow":"showArrow","suffix-icon":"suffixIcon","suffix-transition":"suffixTransition","tabindex":"tabindex","tag-effect":"tagEffect","tag-type":"tagType","tag-tooltip":"tagTooltip","teleported":"teleported","validate-event":"validateEvent","value-on-clear":"valueOnClear"}},"evals":["options.methods.svEmitEndReached","options.methods.elRemoteQuery","options.methods.handleChange","options.methods.shinyVueReceive"]}</script>
#> </div>
```
