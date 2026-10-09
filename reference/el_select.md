# Element Plus Select Component

Creates an Element Plus `<el-select>` component backed by a Vue
instance. Supports single and multiple selection, filtering, and all
standard Element Plus select props.

## Usage

``` r
el_select(
  id = NULL,
  choices = NULL,
  selected = NULL,
  multiple = FALSE,
  placeholder = NULL,
  disabled = FALSE,
  clearable = FALSE,
  filterable = FALSE,
  size = NULL,
  multiple_limit = 0,
  collapse_tags = FALSE,
  value_key = NULL,
  name = NULL,
  autocomplete = NULL,
  automatic_dropdown = NULL,
  allow_create = NULL,
  loading = NULL,
  loading_text = NULL,
  no_match_text = NULL,
  no_data_text = NULL,
  popper_class = NULL,
  reserve_keyword = NULL,
  default_first_option = NULL,
  remote = NULL,
  filter_method = NULL,
  remote_method = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  option_template = NULL,
  slots = NULL,
  value = NULL,
  options = NULL,
  append_to = NULL,
  aria_label = NULL,
  clear_icon = NULL,
  collapse_tags_tooltip = NULL,
  debounce = NULL,
  effect = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  fit_input_width = NULL,
  max_collapse_tags = NULL,
  offset = NULL,
  persistent = NULL,
  placement = NULL,
  popper_options = NULL,
  popper_style = NULL,
  remote_show_suffix = NULL,
  show_arrow = NULL,
  suffix_icon = NULL,
  suffix_transition = NULL,
  tabindex = NULL,
  tag_effect = NULL,
  tag_type = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  props = NULL,
  tag_tooltip = NULL,
  events = NULL,
  on = NULL,
  session = NULL
)

update_el_select(
  session = shiny::getDefaultReactiveDomain(),
  id,
  selected = NULL,
  choices = NULL,
  disabled = NULL,
  placeholder = NULL,
  clearable = NULL,
  filterable = NULL,
  multiple_limit = NULL,
  loading = NULL,
  loading_text = NULL,
  no_match_text = NULL,
  no_data_text = NULL,
  value = NULL,
  options = NULL,
  label = NULL,
  error = NULL,
  multiple = NULL,
  size = NULL,
  collapse_tags = NULL,
  value_key = NULL,
  name = NULL,
  autocomplete = NULL,
  automatic_dropdown = NULL,
  allow_create = NULL,
  popper_class = NULL,
  reserve_keyword = NULL,
  remote = NULL,
  filter_method = NULL,
  remote_method = NULL,
  append_to = NULL,
  aria_label = NULL,
  clear_icon = NULL,
  collapse_tags_tooltip = NULL,
  debounce = NULL,
  effect = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  fit_input_width = NULL,
  max_collapse_tags = NULL,
  offset = NULL,
  persistent = NULL,
  placement = NULL,
  popper_options = NULL,
  popper_style = NULL,
  remote_show_suffix = NULL,
  show_arrow = NULL,
  suffix_icon = NULL,
  suffix_transition = NULL,
  tabindex = NULL,
  tag_effect = NULL,
  tag_type = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  tag_tooltip = NULL
)
```

## Arguments

- id:

  Input ID. Auto-generated UUID if `NULL`.

- choices, options:

  The choices: a named character vector (`c(Label = value)`), a list of
  [`el_option()`](https://kaipingyang.github.io/shiny.element/reference/el_option.md)s
  (or of `list(value = ..., label = ...)`), or a list of
  [`el_option_group()`](https://kaipingyang.github.io/shiny.element/reference/el_option.md)s
  (or a named list of options) for option groups. Unnamed vectors are
  allowed; the element is used as both value and label. `choices` is
  Shiny's name for it, `options` Element's; give either. Empty by
  default, for a select whose options arrive later (`remote = TRUE`).

- selected, value:

  Initially selected value(s); a character vector for multiple
  selection. `selected` is Shiny's name, `value` Element's (its
  `v-model`); give either.

- multiple:

  Whether multiple items can be selected. Default `FALSE`.

- placeholder:

  Placeholder text shown when nothing is selected.

- disabled:

  Whether the select is disabled. Default `FALSE`.

- clearable:

  Whether to show a clear button. Default `FALSE`.

- filterable:

  Whether typing filters the options. Default `FALSE`.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- multiple_limit:

  Maximum number of items that can be selected when `multiple = TRUE`.
  `0` means unlimited. Default `0`.

- collapse_tags:

  Whether to collapse selected tags into a summary when
  `multiple = TRUE`. Default `FALSE`.

- value_key:

  Key that identifies an option when values are objects. Default
  `"value"`.

- name:

  Native `name` attribute.

- autocomplete:

  Native `autocomplete` attribute. Default `"off"`.

- automatic_dropdown:

  Whether a filterable select opens its menu on focus.

- allow_create:

  Whether the user may create options not in the list. Needs
  `filterable = TRUE`.

- loading:

  Whether to show the loading state while options are being fetched.

- loading_text:

  Text shown while loading. Default `"Loading"`.

- no_match_text:

  Text shown when filtering matches nothing.

- no_data_text:

  Text shown when there are no options at all.

- popper_class:

  Extra class name for the dropdown panel.

- reserve_keyword:

  Whether a multiple filterable select keeps the search term after
  selecting.

- default_first_option:

  Whether Enter picks the first matching option.

- remote:

  Whether options are fetched from the server as the user types. Needs
  `filterable = TRUE`; see "Shiny inputs".

- filter_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function filtering the options as the user types.

- remote_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function fetching options in the browser instead of from the server.
  Needs `remote = TRUE`.

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

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

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- option_template:

  Markup drawn inside each option, in place of its label – Element's
  "custom template". The option is in reach as `opt`, with any field its
  choice carries – `{{ opt.label }}`, `{{ opt.code }}` – for choices
  given as `list(value =, label =, code =)`. See the example.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- append_to:

  Which element the select dropdown appends to. Element Plus's
  `append-to` (CSSSelector / HTMLElement).

- aria_label:

  Same as `aria-label` in native input. Element Plus's `aria-label`
  (string).

- clear_icon:

  Custom clear icon component. Element Plus's `clear-icon` (string /
  Component). An icon's name, such as `"Search"`.

- collapse_tags_tooltip:

  Whether show all selected tags when mouse hover text of collapse-tags.
  To use this, `collapse-tags` must be true. Element Plus's
  `collapse-tags-tooltip` (boolean).

- debounce:

  Debounce delay during remote search, in milliseconds. Element Plus's
  `debounce` (number).

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- empty_values:

  Empty values of component, see config-provider. Element Plus's
  `empty-values` (array).

- fallback_placements:

  List of possible positions for dropdown popper.js. Element Plus's
  `fallback-placements` (`Placement[]`).

- fit_input_width:

  Whether the width of the dropdown is the same as the input. Element
  Plus's `fit-input-width` (boolean).

- max_collapse_tags:

  The max tags number to be shown. To use this, `collapse-tags` must be
  true. Element Plus's `max-collapse-tags` (number).

- offset:

  Offset of the dropdown. Element Plus's `offset` (number).

- persistent:

  When select dropdown is inactive and `persistent` is `false`, select
  dropdown will be destroyed. Element Plus's `persistent` (boolean).

- placement:

  Position of dropdown. Element Plus's `placement` (enum).

- popper_options:

  Popper.js parameters. Element Plus's `popper-options` (object).

- popper_style:

  Custom style for Select's dropdown and tags' tooltip. Element Plus's
  `popper-style` (string / object).

- remote_show_suffix:

  In remote search method show suffix icon. Element Plus's
  `remote-show-suffix` (boolean).

- show_arrow:

  Whether the dropdown has an arrow. Element Plus's `show-arrow`
  (boolean).

- suffix_icon:

  Custom suffix icon component. Element Plus's `suffix-icon` (string /
  Component). An icon's name, such as `"Search"`.

- suffix_transition:

  Animation when dropdown appears/disappears icon. Element Plus's
  `suffix-transition` (boolean).

- tabindex:

  Tabindex for input. Element Plus's `tabindex` (string / number).

- tag_effect:

  Tag effect. Element Plus's `tag-effect` (” \| 'light' \| 'dark' \|
  'plain').

- tag_type:

  Tag type. Element Plus's `tag-type` (” \| 'success' \| 'info' \|
  'warning' \| 'danger').

- teleported:

  Whether select dropdown is teleported, if `true` it will be teleported
  to where `append-to` sets. Element Plus's `teleported` (boolean).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- value_on_clear:

  Clear return value, see config-provider. Element Plus's
  `value-on-clear` (string / number / boolean / Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- props:

  Which field of an option holds what, when the options are records
  named otherwise: `list(value =, label =, disabled =, options =)`,
  Element Plus's `props`.

- tag_tooltip:

  Settings for the tooltip listing collapsed tags, with `collapse_tags`
  and `collapse_tags_tooltip`: a named list of tooltip attributes
  (`placement`, `effect`, ...). Element Plus's `tag-tooltip`.

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

  In `el_select()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_select()`, the Shiny session, the
  current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList containing the Vue-managed select component.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

- `blur()` – Blur the Input component, and hide the dropdown

- `focus()` – Focus the Input component

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the value, several with `multiple` |
| `input$<id>_query` | unasked | with `remote = TRUE`, the text typed; answer with `update_el_select(choices =)` |
| `input$<id>_visible_change` | `events = "visible_change"` | triggers when the dropdown appears/disappears |
| `input$<id>_remove_tag` | `events = "remove_tag"` | triggers when a tag is removed in multiple mode |
| `input$<id>_clear` | `events = "clear"` | triggers when the clear icon is clicked in a clearable Select |
| `input$<id>_blur` | `events = "blur"` | triggers when Input blurs |
| `input$<id>_focus` | `events = "focus"` | triggers when Input focuses |
| `input$<id>_end_reached` | unasked | triggers when dropdown scroll reaches an end |
| `input$<id>_popup_scroll` | `events = "popup_scroll"` | `list(scroll_left, scroll_top)`, at most every 200 ms |

The same list as `el_events("el_select")`, which says how an event's
arguments travel.

With `remote = TRUE`, `filterable = TRUE` and no `remote_method` of your
own, the server does the search, as
[`selectizeInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html)'s
server mode does: `input$<id>_query` is the text typed, and
`update_el_select()` with the matching `choices` answers it – the select
shows Element's loading text until then, or for 30 seconds at most.

## Updating from the server

Server-side update for `el_select()`. Sends a custom message to update
reactive fields on the underlying Vue instance.

Every other argument of `el_select()` that can change once it is drawn
is an argument here too, under the same name. One left `NULL` stays as
it is; `NA` returns it to Element's default.

`update_el_select()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
# Each option drawn with a second field beside its label
el_select(
  "city",
  choices = list(
    list(value = "bj", label = "Beijing", code = "PEK"),
    list(value = "sh", label = "Shanghai", code = "SHA")
  ),
  option_template = htmltools::tagList(
    htmltools::tags$span(style = "float: left", "{{ opt.label }}"),
    htmltools::tags$span(
      style = "float: right; color: #8492a6",
      "{{ opt.code }}"
    )
  )
)
#> <div id="city" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="city_container" style="display: contents">
#>   <el-select v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :size="size === null ? undefined : size" :value-key="valueKey === null ? undefined : valueKey" :name="name === null ? undefined : name" :autocomplete="autocomplete === null ? undefined : autocomplete" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :allow-create="allowCreate === null ? undefined : allowCreate" :loading="loading === null ? undefined : loading" :loading-text="loadingText === null ? undefined : loadingText" :no-match-text="noMatchText === null ? undefined : noMatchText" :no-data-text="noDataText === null ? undefined : noDataText" :popper-class="popperClass === null ? undefined : popperClass" :reserve-keyword="reserveKeyword === null ? undefined : reserveKeyword" :default-first-option="defaultFirstOption === null ? undefined : defaultFirstOption" :remote="remote === null ? undefined : remote" :filter-method="filterMethod === null ? undefined : filterMethod" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @end-reached="svEmitEndReached" :append-to="appendTo === null ? undefined : appendTo" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :collapse-tags-tooltip="collapseTagsTooltip === null ? undefined : collapseTagsTooltip" :debounce="debounce === null ? undefined : debounce" :effect="effect === null ? undefined : effect" :empty-values="emptyValues === null ? undefined : emptyValues" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :fit-input-width="fitInputWidth === null ? undefined : fitInputWidth" :max-collapse-tags="maxCollapseTags === null ? undefined : maxCollapseTags" :offset="offset === null ? undefined : offset" :persistent="persistent === null ? undefined : persistent" :placement="placement === null ? undefined : placement" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :remote-show-suffix="remoteShowSuffix === null ? undefined : remoteShowSuffix" :show-arrow="showArrow === null ? undefined : showArrow" :suffix-icon="suffixIcon === null ? undefined : suffixIcon" :suffix-transition="suffixTransition === null ? undefined : suffixTransition" :tabindex="tabindex === null ? undefined : tabindex" :tag-effect="tagEffect === null ? undefined : tagEffect" :tag-type="tagType === null ? undefined : tagType" :tag-tooltip="tagTooltip === null ? undefined : tagTooltip" :teleported="teleported === null ? undefined : teleported" :validate-event="validateEvent === null ? undefined : validateEvent" :value-on-clear="valueOnClear === null ? undefined : valueOnClear">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled">
#>       <span style="float: left">{{ opt.label }}</span>
#>       <span style="float: right; color: #8492a6">{{ opt.code }}</span>
#>     </el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled">
#>         <span style="float: left">{{ opt.label }}</span>
#>         <span style="float: right; color: #8492a6">{{ opt.code }}</span>
#>       </el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","options":[{"value":"bj","label":"Beijing","code":"PEK"},{"value":"sh","label":"Shanghai","code":"SHA"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"remoteMethod":null,"appendTo":null,"ariaLabel":null,"clearIcon":null,"collapseTagsTooltip":null,"debounce":null,"effect":null,"emptyValues":null,"fallbackPlacements":null,"fitInputWidth":null,"maxCollapseTags":null,"offset":null,"persistent":null,"placement":null,"popperOptions":null,"popperStyle":null,"remoteShowSuffix":null,"showArrow":null,"suffixIcon":null,"suffixTransition":null,"tabindex":null,"tagEffect":null,"tagType":null,"tagTooltip":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"svEmitEndReached":"function() { window.shinyVue.emit('city', 'end_reached', arguments); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n  this.loading = true;\n  clearTimeout(this._elQueryTimer);\n  this._elQueryTimer = setTimeout(function() {\n    if (self._elQueryN !== n || !self.loading) return;\n    self.loading = false;\n    console.warn('[shiny.element] no answer to input$city_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n  }, window.shinyVue.askTimeout);\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('city_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }","shinyVueReceive":"function(d) { var multiple = 'multiple' in d ? d.multiple : this.multiple; if ('value' in d && multiple && d.value !== null && !Array.isArray(d.value)) d.value = [d.value]; return d; }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitEndReached","options.methods.elRemoteQuery","options.methods.handleChange","options.methods.shinyVueReceive"]}</script>
#> </div>

# Single-select from a named vector
el_select(
  "sel1",
  choices = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
  selected = "banana"
)
#> <div id="sel1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="sel1_container" style="display: contents">
#>   <el-select v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :size="size === null ? undefined : size" :value-key="valueKey === null ? undefined : valueKey" :name="name === null ? undefined : name" :autocomplete="autocomplete === null ? undefined : autocomplete" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :allow-create="allowCreate === null ? undefined : allowCreate" :loading="loading === null ? undefined : loading" :loading-text="loadingText === null ? undefined : loadingText" :no-match-text="noMatchText === null ? undefined : noMatchText" :no-data-text="noDataText === null ? undefined : noDataText" :popper-class="popperClass === null ? undefined : popperClass" :reserve-keyword="reserveKeyword === null ? undefined : reserveKeyword" :default-first-option="defaultFirstOption === null ? undefined : defaultFirstOption" :remote="remote === null ? undefined : remote" :filter-method="filterMethod === null ? undefined : filterMethod" :remote-method="remoteMethod === null ? elRemoteQuery : remoteMethod" @end-reached="svEmitEndReached" :append-to="appendTo === null ? undefined : appendTo" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :collapse-tags-tooltip="collapseTagsTooltip === null ? undefined : collapseTagsTooltip" :debounce="debounce === null ? undefined : debounce" :effect="effect === null ? undefined : effect" :empty-values="emptyValues === null ? undefined : emptyValues" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :fit-input-width="fitInputWidth === null ? undefined : fitInputWidth" :max-collapse-tags="maxCollapseTags === null ? undefined : maxCollapseTags" :offset="offset === null ? undefined : offset" :persistent="persistent === null ? undefined : persistent" :placement="placement === null ? undefined : placement" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :remote-show-suffix="remoteShowSuffix === null ? undefined : remoteShowSuffix" :show-arrow="showArrow === null ? undefined : showArrow" :suffix-icon="suffixIcon === null ? undefined : suffixIcon" :suffix-transition="suffixTransition === null ? undefined : suffixTransition" :tabindex="tabindex === null ? undefined : tabindex" :tag-effect="tagEffect === null ? undefined : tagEffect" :tag-type="tagType === null ? undefined : tagType" :tag-tooltip="tagTooltip === null ? undefined : tagTooltip" :teleported="teleported === null ? undefined : teleported" :validate-event="validateEvent === null ? undefined : validateEvent" :value-on-clear="valueOnClear === null ? undefined : valueOnClear">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"banana","options":[{"value":"apple","label":"Apple"},{"value":"banana","label":"Banana"},{"value":"cherry","label":"Cherry"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"remoteMethod":null,"appendTo":null,"ariaLabel":null,"clearIcon":null,"collapseTagsTooltip":null,"debounce":null,"effect":null,"emptyValues":null,"fallbackPlacements":null,"fitInputWidth":null,"maxCollapseTags":null,"offset":null,"persistent":null,"placement":null,"popperOptions":null,"popperStyle":null,"remoteShowSuffix":null,"showArrow":null,"suffixIcon":null,"suffixTransition":null,"tabindex":null,"tagEffect":null,"tagType":null,"tagTooltip":null,"teleported":null,"validateEvent":null,"valueOnClear":null},"methods":{"svEmitEndReached":"function() { window.shinyVue.emit('sel1', 'end_reached', arguments); }","elRemoteQuery":"function(query) {\n  if (!(window.Shiny && Shiny.setInputValue)) return;\n  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n  this.loading = true;\n  clearTimeout(this._elQueryTimer);\n  this._elQueryTimer = setTimeout(function() {\n    if (self._elQueryN !== n || !self.loading) return;\n    self.loading = false;\n    console.warn('[shiny.element] no answer to input$sel1_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n  }, window.shinyVue.askTimeout);\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('sel1_query', query, {priority: 'event'});\n}","handleChange":"function(value) { }","shinyVueReceive":"function(d) { var multiple = 'multiple' in d ? d.multiple : this.multiple; if ('value' in d && multiple && d.value !== null && !Array.isArray(d.value)) d.value = [d.value]; return d; }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitEndReached","options.methods.elRemoteQuery","options.methods.handleChange","options.methods.shinyVueReceive"]}</script>
#> </div>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_select(
      "fruit",
      choices = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
      selected = "apple",
      clearable = TRUE
    ),
    verbatimTextOutput("selected")
  )
  server <- function(input, output, session) {
    output$selected <- renderPrint(input$fruit)
  }
  shinyApp(ui, server)
}
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_select(session, "city", selected = "sh")
  })
}
```
