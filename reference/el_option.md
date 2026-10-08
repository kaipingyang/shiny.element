# A choice of a select, a radio group, a checkbox group

Element Plus's `el-option` and `el-option-group`, for the `choices` of
[`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md)
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
[`el_anchor_link()`](https://kaipingyang.github.io/shiny.element/reference/el_anchor_link.md),
[`el_breadcrumb_item()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb_item.md),
[`el_carousel_item()`](https://kaipingyang.github.io/shiny.element/reference/el_carousel_item.md),
[`el_collapse_item()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse_item.md),
[`el_descriptions_item()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions_item.md),
[`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown_item.md),
[`el_menu_item()`](https://kaipingyang.github.io/shiny.element/reference/el_menu_item.md),
[`el_skeleton_item()`](https://kaipingyang.github.io/shiny.element/reference/el_skeleton_item.md),
[`el_step()`](https://kaipingyang.github.io/shiny.element/reference/el_step.md),
[`el_tab_pane()`](https://kaipingyang.github.io/shiny.element/reference/el_tab_pane.md),
[`el_table_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_column.md),
[`el_table_v2_column()`](https://kaipingyang.github.io/shiny.element/reference/el_table_v2_column.md),
[`el_timeline_item()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline_item.md),
[`el_tour_step()`](https://kaipingyang.github.io/shiny.element/reference/el_tour_step.md)

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
#>   <el-select v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :size="size === null ? undefined : size" :value-key="valueKey === null ? undefined : valueKey" :name="name === null ? undefined : name" :autocomplete="autocomplete === null ? undefined : autocomplete" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :allow-create="allowCreate === null ? undefined : allowCreate" :loading="loading === null ? undefined : loading" :loading-text="loadingText === null ? undefined : loadingText" :no-match-text="noMatchText === null ? undefined : noMatchText" :no-data-text="noDataText === null ? undefined : noDataText" :popper-class="popperClass === null ? undefined : popperClass" :reserve-keyword="reserveKeyword === null ? undefined : reserveKeyword" :default-first-option="defaultFirstOption === null ? undefined : defaultFirstOption" :remote="remote === null ? undefined : remote" :filter-method="filterMethod === null ? undefined : filterMethod" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @visible-change="elEmitVisibleChange" @remove-tag="elEmitRemoveTag" @clear="elEmitClear" @blur="elEmitBlur" @focus="elEmitFocus" @end-reached="elEmitEndReached" @popup-scroll="elEmitPopupScroll" :append-to="appendTo === null ? undefined : appendTo" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :collapse-tags-tooltip="collapseTagsTooltip === null ? undefined : collapseTagsTooltip" :debounce="debounce === null ? undefined : debounce" :effect="effect === null ? undefined : effect" :empty-values="emptyValues === null ? undefined : emptyValues" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :fit-input-width="fitInputWidth === null ? undefined : fitInputWidth" :max-collapse-tags="maxCollapseTags === null ? undefined : maxCollapseTags" :offset="offset === null ? undefined : offset" :persistent="persistent === null ? undefined : persistent" :placement="placement === null ? undefined : placement" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :remote-show-suffix="remoteShowSuffix === null ? undefined : remoteShowSuffix" :show-arrow="showArrow === null ? undefined : showArrow" :suffix-icon="suffixIcon === null ? undefined : suffixIcon" :suffix-transition="suffixTransition === null ? undefined : suffixTransition" :tabindex="tabindex === null ? undefined : tabindex" :tag-effect="tagEffect === null ? undefined : tagEffect" :tag-type="tagType === null ? undefined : tagType" :tag-tooltip="tagTooltip === null ? undefined : tagTooltip" :teleported="teleported === null ? undefined : teleported" :validate-event="validateEvent === null ? undefined : validateEvent" :value-on-clear="valueOnClear === null ? undefined : valueOnClear">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[],"groups":[{"label":"Popular cities","disabled":false,"options":[{"value":"Shanghai","label":"Shanghai"},{"value":"Beijing","label":"Beijing","disabled":true}]},{"label":"City name","disabled":false,"options":[{"value":"Chengdu","label":"Chengdu"},{"value":"Dalian","label":"Dalian"}]}],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"remoteMethod":null,"appendTo":null,"ariaLabel":null,"clearIcon":null,"collapseTagsTooltip":null,"debounce":null,"effect":null,"emptyValues":null,"fallbackPlacements":null,"fitInputWidth":null,"maxCollapseTags":null,"offset":null,"persistent":null,"placement":null,"popperOptions":null,"popperStyle":null,"remoteShowSuffix":null,"showArrow":null,"suffixIcon":null,"suffixTransition":null,"tabindex":null,"tagEffect":null,"tagType":null,"tagTooltip":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"elEmitVisibleChange":"function() { window.shinyVue.emit('city', 'visible_change', arguments); }","elEmitRemoveTag":"function() { window.shinyVue.emit('city', 'remove_tag', arguments); }","elEmitClear":"function() { window.shinyVue.emit('city', 'clear', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('city', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('city', 'focus', arguments); }","elEmitEndReached":"function() { window.shinyVue.emit('city', 'end_reached', arguments); }","elEmitPopupScroll":"function() { var shape = function(e) { return {scroll_left: e.scrollLeft, scroll_top: e.scrollTop}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('city', 'popup_scroll', [v], 200); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n  this.loading = true;\n  clearTimeout(this._elQueryTimer);\n  this._elQueryTimer = setTimeout(function() {\n    if (self._elQueryN !== n || !self.loading) return;\n    self.loading = false;\n    console.warn('[shiny.element] no answer to input$city_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n  }, window.shinyVue.askTimeout);\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }","shinyVueReceive":"function(d) { var multiple = 'multiple' in d ? d.multiple : this.multiple; if ('value' in d && multiple && d.value !== null && !Array.isArray(d.value)) d.value = [d.value]; return d; }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitVisibleChange","options.methods.elEmitRemoveTag","options.methods.elEmitClear","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitEndReached","options.methods.elEmitPopupScroll","options.methods.elRemoteQuery","options.methods.handleChange","options.methods.shinyVueReceive"]}</script>
#> </div>
```
