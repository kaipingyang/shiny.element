# Element UI Autocomplete

A text input that suggests as you type.

## Usage

``` r
el_autocomplete(
  id = NULL,
  value = "",
  suggestions = NULL,
  fetch_suggestions = NULL,
  placeholder = NULL,
  clearable = NULL,
  disabled = NULL,
  value_key = NULL,
  debounce = NULL,
  placement = NULL,
  trigger_on_focus = NULL,
  select_when_unmatched = NULL,
  highlight_first_item = NULL,
  hide_loading = NULL,
  icon = NULL,
  prefix_icon = NULL,
  suffix_icon = NULL,
  label = NULL,
  name = NULL,
  popper_class = NULL,
  popper_append_to_body = NULL,
  width = NULL,
  slots = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Input ID. Auto-generated if `NULL`.

- value:

  Initial text.

- suggestions:

  Suggestions to offer, as a character vector or a list of
  `list(value =, ...)`. Filtered in the browser on what has been typed.
  For suggestions that come from the server, leave this empty and use
  `fetch_suggestions`.

- fetch_suggestions:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function `function(queryString, callback)` that calls
  `callback(results)`. Use it when the list cannot be sent up front.

- placeholder:

  Placeholder text.

- clearable:

  Whether to show a clear button.

- disabled:

  Whether the input is disabled.

- value_key:

  Field of a suggestion object to display. Default `"value"`.

- debounce:

  Debounce while typing, in milliseconds. Default `300`.

- placement:

  Where the list appears: `"bottom-start"` (default), `"bottom-end"`,
  `"top-start"`, `"top-end"`.

- trigger_on_focus:

  Whether to suggest as soon as the input is focused. Default `TRUE`.

- select_when_unmatched:

  Whether to fire `select` when nothing matched.

- highlight_first_item:

  Whether to preselect the first suggestion.

- hide_loading:

  Whether to hide the loading spinner.

- icon, prefix_icon, suffix_icon:

  Icon classes.

- label:

  Accessible label.

- name:

  Native `name` attribute.

- popper_class:

  Extra class name for the suggestion list.

- popper_append_to_body:

  Whether the list is appended to `body`.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the current text.

- `input$<id>_select` – the suggestion just picked.

- `input$<id>_change` – fires when the text changes.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `focus()` – focus the input

## Examples

``` r
el_autocomplete("city", suggestions = c("Beijing", "Shanghai", "Shenzhen"))
#> <div id="city_container" style="display: contents">
#>   <el-autocomplete v-model="value" :fetch-suggestions="fetchSuggestions" :placeholder="placeholder === null ? undefined : placeholder" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :value-key="valueKey === null ? undefined : valueKey" :debounce="debounce === null ? undefined : debounce" :placement="placement === null ? undefined : placement" :trigger-on-focus="triggerOnFocus === null ? undefined : triggerOnFocus" :select-when-unmatched="selectWhenUnmatched === null ? undefined : selectWhenUnmatched" :highlight-first-item="highlightFirstItem === null ? undefined : highlightFirstItem" :hide-loading="hideLoading === null ? undefined : hideLoading" :icon="icon === null ? undefined : icon" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :suffix-icon="suffixIcon === null ? undefined : suffixIcon" :label="label === null ? undefined : label" :name="name === null ? undefined : name" :popper-class="popperClass === null ? undefined : popperClass" :popper-append-to-body="popperAppendToBody === null ? undefined : popperAppendToBody" @select="elEmitSelect" @change="elEmitChange"></el-autocomplete>
#> </div>
#> <div id="city" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="city">{"x":{"el":"#city_container","data":{"value":"","suggestions":[{"value":"Beijing"},{"value":"Shanghai"},{"value":"Shenzhen"}],"placeholder":null,"clearable":null,"disabled":null,"valueKey":null,"debounce":null,"placement":null,"triggerOnFocus":null,"selectWhenUnmatched":null,"highlightFirstItem":null,"hideLoading":null,"icon":null,"prefixIcon":null,"suffixIcon":null,"label":null,"name":null,"popperClass":null,"popperAppendToBody":null},"methods":{"elEmitSelect":"function() { window.shinyElement.emit('city', 'select', arguments); }","elEmitChange":"function() { window.shinyElement.emit('city', 'change', arguments); }","fetchSuggestions":"function(queryString, callback) {\n  var all = this.suggestions || [];\n  var q = (queryString || '').toLowerCase();\n  callback(q ? all.filter(function(s) {\n    return String(s.value).toLowerCase().indexOf(q) === 0;\n  }) : all);\n}","handleInput":"function(v) { Shiny.setInputValue('city', v); }"},"watch":{"value":"function(newVal) { Shiny.setInputValue('city', newVal); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"city\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.elEmitSelect","methods.elEmitChange","methods.fetchSuggestions","methods.handleInput","watch.value","mounted"],"jsHooks":[]}</script>

el_autocomplete("city",
  suggestions = c("Beijing", "Shanghai"),
  placeholder = "Where to?", clearable = TRUE, width = 260
)
#> <div id="city_container" style="display: contents">
#>   <el-autocomplete v-model="value" :fetch-suggestions="fetchSuggestions" :placeholder="placeholder === null ? undefined : placeholder" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :value-key="valueKey === null ? undefined : valueKey" :debounce="debounce === null ? undefined : debounce" :placement="placement === null ? undefined : placement" :trigger-on-focus="triggerOnFocus === null ? undefined : triggerOnFocus" :select-when-unmatched="selectWhenUnmatched === null ? undefined : selectWhenUnmatched" :highlight-first-item="highlightFirstItem === null ? undefined : highlightFirstItem" :hide-loading="hideLoading === null ? undefined : hideLoading" :icon="icon === null ? undefined : icon" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :suffix-icon="suffixIcon === null ? undefined : suffixIcon" :label="label === null ? undefined : label" :name="name === null ? undefined : name" :popper-class="popperClass === null ? undefined : popperClass" :popper-append-to-body="popperAppendToBody === null ? undefined : popperAppendToBody" @select="elEmitSelect" @change="elEmitChange" style="width: 260px"></el-autocomplete>
#> </div>
#> <div id="city" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="city">{"x":{"el":"#city_container","data":{"value":"","suggestions":[{"value":"Beijing"},{"value":"Shanghai"}],"placeholder":"Where to?","clearable":true,"disabled":null,"valueKey":null,"debounce":null,"placement":null,"triggerOnFocus":null,"selectWhenUnmatched":null,"highlightFirstItem":null,"hideLoading":null,"icon":null,"prefixIcon":null,"suffixIcon":null,"label":null,"name":null,"popperClass":null,"popperAppendToBody":null},"methods":{"elEmitSelect":"function() { window.shinyElement.emit('city', 'select', arguments); }","elEmitChange":"function() { window.shinyElement.emit('city', 'change', arguments); }","fetchSuggestions":"function(queryString, callback) {\n  var all = this.suggestions || [];\n  var q = (queryString || '').toLowerCase();\n  callback(q ? all.filter(function(s) {\n    return String(s.value).toLowerCase().indexOf(q) === 0;\n  }) : all);\n}","handleInput":"function(v) { Shiny.setInputValue('city', v); }"},"watch":{"value":"function(newVal) { Shiny.setInputValue('city', newVal); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"city\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.elEmitSelect","methods.elEmitChange","methods.fetchSuggestions","methods.handleInput","watch.value","mounted"],"jsHooks":[]}</script>
```
