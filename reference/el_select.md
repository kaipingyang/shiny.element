# Element UI Select Component

Creates an Element UI `<el-select>` component backed by a Vue instance.
Supports single and multiple selection, filtering, and all standard
Element UI select props.

## Usage

``` r
el_select(
  id = NULL,
  choices,
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
  popper_append_to_body = NULL,
  reserve_keyword = NULL,
  default_first_option = NULL,
  remote = NULL,
  filter_method = NULL,
  remote_method = NULL,
  width = NULL,
  slots = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Input ID. Auto-generated UUID if `NULL`.

- choices:

  Named character vector (`c(Label = value)`) or a list of
  `list(value = ..., label = ...)` items. Unnamed vectors are allowed;
  the element is used as both value and label.

- selected:

  Initial selected value(s). Use a character vector for multiple
  selection. Defaults to `""` (single) or
  [`list()`](https://rdrr.io/r/base/list.html) (multiple).

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

  Component size: `NULL`, `"medium"`, `"small"`, or `"mini"`.

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

- popper_append_to_body:

  Whether the dropdown is appended to `body`. Default `TRUE`.

- reserve_keyword:

  Whether a multiple filterable select keeps the search term after
  selecting.

- default_first_option:

  Whether Enter picks the first matching option.

- remote:

  Whether options are fetched from the server as the user types.

- filter_method:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function filtering the options as the user types.

- remote_method:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function fetching options from the server. Needs `remote = TRUE`.

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).
  number taken as pixels. Element's own markup carries it, so it behaves
  like the `width` argument of a Shiny input.

- session:

  Shiny session for module namespace support.

## Value

An `htmltools` tagList containing the Vue-managed select component.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `blur()` – Blur the Input component, and hide the dropdown

- `focus()` – Focus the Input component

## Shiny input

`input$<id>` — string (single) or character vector (multiple), updated
on each change.

## Examples

``` r
# Single-select from a named vector
el_select("sel1",
  choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
  selected = "banana"
)
#> <div id="sel1_container" style="display: contents">
#>   <el-select v-model="value" :multiple="multiple" :disabled="disabled" :clearable="clearable" :filterable="filterable" :multiple-limit="multipleLimit" :collapse-tags="collapseTags" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :size="size === null ? undefined : size" :value-key="valueKey === null ? undefined : valueKey" :name="name === null ? undefined : name" :autocomplete="autocomplete === null ? undefined : autocomplete" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :allow-create="allowCreate === null ? undefined : allowCreate" :loading="loading === null ? undefined : loading" :loading-text="loadingText === null ? undefined : loadingText" :no-match-text="noMatchText === null ? undefined : noMatchText" :no-data-text="noDataText === null ? undefined : noDataText" :popper-class="popperClass === null ? undefined : popperClass" :popper-append-to-body="popperAppendToBody === null ? undefined : popperAppendToBody" :reserve-keyword="reserveKeyword === null ? undefined : reserveKeyword" :default-first-option="defaultFirstOption === null ? undefined : defaultFirstOption" :remote="remote === null ? undefined : remote" :filter-method="filterMethod === null ? undefined : filterMethod" :remote-method="remoteMethod === null ? undefined : remoteMethod" @visible-change="elEmitVisibleChange" @remove-tag="elEmitRemoveTag" @clear="elEmitClear" @blur="elEmitBlur" @focus="elEmitFocus">
#>     <el-option v-for="opt in options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     <el-option-group v-for="g in groups" :key="g.label" :label="g.label" :disabled="g.disabled">
#>       <el-option v-for="opt in g.options" :key="opt.value" :value="opt.value" :label="opt.label" :disabled="opt.disabled"></el-option>
#>     </el-option-group>
#>   </el-select>
#> </div>
#> <div id="sel1" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="sel1">{"x":{"el":"#sel1_container","data":{"value":"banana","options":[{"value":"apple","label":"Apple"},{"value":"banana","label":"Banana"},{"value":"cherry","label":"Cherry"}],"groups":[],"multiple":false,"disabled":false,"clearable":false,"filterable":false,"multipleLimit":0,"collapseTags":false,"placeholder":null,"size":null,"valueKey":null,"name":null,"autocomplete":null,"automaticDropdown":null,"allowCreate":null,"loading":null,"loadingText":null,"noMatchText":null,"noDataText":null,"popperClass":null,"popperAppendToBody":null,"reserveKeyword":null,"defaultFirstOption":null,"remote":null,"filterMethod":null,"remoteMethod":null},"methods":{"elEmitVisibleChange":"function() { window.shinyElement.emit('sel1', 'visible_change', arguments); }","elEmitRemoveTag":"function() { window.shinyElement.emit('sel1', 'remove_tag', arguments); }","elEmitClear":"function() { window.shinyElement.emit('sel1', 'clear', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('sel1', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('sel1', 'focus', arguments); }","handleChange":"function(value) { Shiny.setInputValue('sel1', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"sel1\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitVisibleChange","methods.elEmitRemoveTag","methods.elEmitClear","methods.elEmitBlur","methods.elEmitFocus","methods.handleChange","mounted"],"jsHooks":[]}</script>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_select("fruit",
      choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
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
```
