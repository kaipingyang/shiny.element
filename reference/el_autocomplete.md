# Element Plus Autocomplete

A text input that suggests as you type.

## Usage

``` r
el_autocomplete(
  id = NULL,
  value = "",
  suggestions = NULL,
  remote = FALSE,
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
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  append_to = NULL,
  aria_label = NULL,
  fit_input_width = NULL,
  loop_navigation = NULL,
  popper_options = NULL,
  popper_style = NULL,
  show_arrow = NULL,
  teleported = NULL,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
)

update_el_autocomplete(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  suggestions = NULL,
  placeholder = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  clearable = NULL,
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
  name = NULL,
  popper_class = NULL,
  append_to = NULL,
  aria_label = NULL,
  fit_input_width = NULL,
  loop_navigation = NULL,
  popper_options = NULL,
  popper_style = NULL,
  show_arrow = NULL,
  teleported = NULL
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
  For suggestions that come from the server, use `remote = TRUE`.

- remote:

  Ask the server for suggestions as the user types, as Element's
  `fetch-suggestions` asks a function: the text arrives as
  `input$<id>_query`, and `update_el_autocomplete()` with `suggestions`
  answers it – the list shows what the server sent.

- fetch_suggestions:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(queryString, callback)` that calls
  `callback(results)`, to fetch in the browser instead.

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

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- name:

  Native `name` attribute.

- popper_class:

  Extra class name for the suggestion list.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

- append_to:

  Which select dropdown appends to. Element Plus's `append-to`
  (CSSSelector / HTMLElement).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- fit_input_width:

  Whether the width of the dropdown is the same as the input. Element
  Plus's `fit-input-width` (boolean).

- loop_navigation:

  Whether keyboard navigation loops from end to start. Element Plus's
  `loop-navigation` (boolean).

- popper_options:

  Popper.js parameters. Element Plus's `popper-options` (object).

- popper_style:

  Custom style for autocomplete's dropdown. Element Plus's
  `popper-style` (string / object).

- show_arrow:

  Whether the dropdown has an arrow. Element Plus's `show-arrow`
  (boolean).

- teleported:

  Whether select dropdown is teleported to the body. Element Plus's
  `teleported` (boolean).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_autocomplete()`, deprecated: inside a module, wrap `id` in
  `ns()`, as for any Shiny input; a session given here namespaces `id`
  once more, with a warning. In `update_el_autocomplete()`, the Shiny
  session, the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the current text |
| `input$<id>_query` | unasked | with `remote = TRUE`, the text to suggest for; answer with `update_el_autocomplete()` |
| `input$<id>_select` | unasked | triggers when a suggestion is clicked |
| `input$<id>_change` | `events = "change"` | triggers when the icon inside Input value change |
| `input$<id>_blur` | `events = "blur"` | triggers when Input blurs |
| `input$<id>_clear` | `events = "clear"` | triggers when the Input is cleared by clicking the clear button |
| `input$<id>_focus` | `events = "focus"` | triggers when Input focuses |
| `input$<id>_input` | `events = "input"` | triggers when the Input value change |

The same list as `el_events("el_autocomplete")`, which says how an
event's arguments travel.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

- `focus()` – focus the input

## Updating from the server

Server-side update for `el_autocomplete()`.

Every other argument of `el_autocomplete()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_autocomplete()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
el_autocomplete("city", suggestions = c("Beijing", "Shanghai", "Shenzhen"))
#> <div id="city" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-autocomplete v-model="value" :fetch-suggestions="fetchSuggestions" :placeholder="placeholder === null ? undefined : placeholder" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :value-key="valueKey === null ? undefined : valueKey" :debounce="debounce === null ? undefined : debounce" :placement="placement === null ? undefined : placement" :trigger-on-focus="triggerOnFocus === null ? undefined : triggerOnFocus" :select-when-unmatched="selectWhenUnmatched === null ? undefined : selectWhenUnmatched" :highlight-first-item="highlightFirstItem === null ? undefined : highlightFirstItem" :hide-loading="hideLoading === null ? undefined : hideLoading" :icon="icon === null ? undefined : icon" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :suffix-icon="suffixIcon === null ? undefined : suffixIcon" :label="label === null ? undefined : label" :name="name === null ? undefined : name" :popper-class="popperClass === null ? undefined : popperClass" @select="elEmitSelect" :append-to="appendTo === null ? undefined : appendTo" :aria-label="ariaLabel === null ? undefined : ariaLabel" :fit-input-width="fitInputWidth === null ? undefined : fitInputWidth" :loop-navigation="loopNavigation === null ? undefined : loopNavigation" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :show-arrow="showArrow === null ? undefined : showArrow" :teleported="teleported === null ? undefined : teleported"></el-autocomplete>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","suggestions":[{"value":"Beijing"},{"value":"Shanghai"},{"value":"Shenzhen"}],"placeholder":null,"clearable":null,"disabled":null,"valueKey":null,"debounce":null,"placement":null,"triggerOnFocus":null,"selectWhenUnmatched":null,"highlightFirstItem":null,"hideLoading":null,"icon":null,"prefixIcon":null,"suffixIcon":null,"label":null,"name":null,"popperClass":null,"appendTo":null,"ariaLabel":null,"fitInputWidth":null,"loopNavigation":null,"popperOptions":null,"popperStyle":null,"showArrow":null,"teleported":null},"methods":{"elEmitSelect":"function() { window.shinyVue.emit('city', 'select', arguments); }","fetchSuggestions":"function(queryString, callback) {\n  var all = this.suggestions || [];\n  var q = (queryString || '').toLowerCase();\n  callback(q ? all.filter(function(s) {\n    return String(s.value).toLowerCase().indexOf(q) === 0;\n  }) : all);\n}"},"watch":{"value":"function(newVal) { }","suggestions":"function(v) { var cb = this._elPending; if (!cb) return; clearTimeout(this._elQueryTimer); this._elAnswered = (this._elAnswered || 0) + 1; if (this._elAnswered >= this._elAsked) this._elPending = null; cb(v); }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitSelect","options.methods.fetchSuggestions","options.watch.value","options.watch.suggestions"]}</script>
#> </div>

el_autocomplete(
  "city",
  suggestions = c("Beijing", "Shanghai"),
  placeholder = "Where to?",
  clearable = TRUE,
  width = 260
)
#> <div id="city" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-autocomplete v-model="value" :fetch-suggestions="fetchSuggestions" :placeholder="placeholder === null ? undefined : placeholder" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :value-key="valueKey === null ? undefined : valueKey" :debounce="debounce === null ? undefined : debounce" :placement="placement === null ? undefined : placement" :trigger-on-focus="triggerOnFocus === null ? undefined : triggerOnFocus" :select-when-unmatched="selectWhenUnmatched === null ? undefined : selectWhenUnmatched" :highlight-first-item="highlightFirstItem === null ? undefined : highlightFirstItem" :hide-loading="hideLoading === null ? undefined : hideLoading" :icon="icon === null ? undefined : icon" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :suffix-icon="suffixIcon === null ? undefined : suffixIcon" :label="label === null ? undefined : label" :name="name === null ? undefined : name" :popper-class="popperClass === null ? undefined : popperClass" @select="elEmitSelect" :append-to="appendTo === null ? undefined : appendTo" :aria-label="ariaLabel === null ? undefined : ariaLabel" :fit-input-width="fitInputWidth === null ? undefined : fitInputWidth" :loop-navigation="loopNavigation === null ? undefined : loopNavigation" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :show-arrow="showArrow === null ? undefined : showArrow" :teleported="teleported === null ? undefined : teleported" style="width: 260px"></el-autocomplete>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","suggestions":[{"value":"Beijing"},{"value":"Shanghai"}],"placeholder":"Where to?","clearable":true,"disabled":null,"valueKey":null,"debounce":null,"placement":null,"triggerOnFocus":null,"selectWhenUnmatched":null,"highlightFirstItem":null,"hideLoading":null,"icon":null,"prefixIcon":null,"suffixIcon":null,"label":null,"name":null,"popperClass":null,"appendTo":null,"ariaLabel":null,"fitInputWidth":null,"loopNavigation":null,"popperOptions":null,"popperStyle":null,"showArrow":null,"teleported":null},"methods":{"elEmitSelect":"function() { window.shinyVue.emit('city', 'select', arguments); }","fetchSuggestions":"function(queryString, callback) {\n  var all = this.suggestions || [];\n  var q = (queryString || '').toLowerCase();\n  callback(q ? all.filter(function(s) {\n    return String(s.value).toLowerCase().indexOf(q) === 0;\n  }) : all);\n}"},"watch":{"value":"function(newVal) { }","suggestions":"function(v) { var cb = this._elPending; if (!cb) return; clearTimeout(this._elQueryTimer); this._elAnswered = (this._elAnswered || 0) + 1; if (this._elAnswered >= this._elAsked) this._elPending = null; cb(v); }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitSelect","options.methods.fetchSuggestions","options.watch.value","options.watch.suggestions"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$country, {
    update_el_autocomplete(
      session,
      "city",
      suggestions = cities_of(input$country)
    )
  })
}
```
