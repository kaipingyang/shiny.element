# Element Plus Transfer

Two lists side by side, for moving items from one to the other.

## Usage

``` r
el_transfer(
  id = NULL,
  data = list(),
  value = NULL,
  titles = NULL,
  button_texts = NULL,
  filterable = NULL,
  filter_placeholder = NULL,
  filter_method = NULL,
  target_order = NULL,
  format = NULL,
  props = NULL,
  left_default_checked = NULL,
  right_default_checked = NULL,
  render_content = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  item_size = NULL,
  validate_event = NULL,
  virtual_scroll = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Transfer ID. Auto-generated if `NULL`.

- data:

  The items to choose from, as a data.frame with columns `key` and
  `label` (and optionally `disabled`), or a list of
  `list(key =, label =, disabled =)`.

- value:

  Keys that start out on the right.

- titles:

  Headings of the two panels, as a length-2 character vector. Default
  `c("List 1", "List 2")`.

- button_texts:

  Labels of the two buttons, as a length-2 character vector. Default is
  arrows only.

- filterable:

  Whether each panel gets a search box.

- filter_placeholder:

  Placeholder of the search boxes.

- filter_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(query, item)` returning whether an item survives
  the search.

- target_order:

  Order of the right-hand panel: `"original"` (default), `"push"` or
  `"unshift"`.

- format:

  Counts shown in each heading, as `list(noChecked =, hasChecked =)`,
  for example
  `list(noChecked = "${total}", hasChecked = "${checked}/${total}")`.

- props:

  Field names when `data` uses other ones, as
  `list(key =, label =, disabled =)`.

- left_default_checked, right_default_checked:

  Keys ticked at the start.

- render_content:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  render function for an item.

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

- item_size:

  Item height for virtual scrolling. Element Plus's `item-size`
  (number).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- virtual_scroll:

  Whether to enable virtual scrolling. Element Plus's `virtual-scroll`
  (boolean).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – keys currently on the right.

- `input$<id>_change` – fires on each move.

- `input$<id>_left_check_change`, `input$<id>_right_check_change` – fire
  as items are ticked.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `clearQuery()` – clear one panel's search box; pass `"left"` or
  `"right"`

## Examples

``` r
el_transfer(
  "cols",
  data = data.frame(key = names(iris), label = names(iris)),
  value = c("Species")
)
#> <div id="cols" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cols_container" style="display: contents">
#>   <el-transfer v-model="value" :data="data" :titles="titles === null ? undefined : titles" :button-texts="buttonTexts === null ? undefined : buttonTexts" :filterable="filterable === null ? undefined : filterable" :filter-placeholder="filterPlaceholder === null ? undefined : filterPlaceholder" :filter-method="filterMethod === null ? undefined : filterMethod" :target-order="targetOrder === null ? undefined : targetOrder" :format="format === null ? undefined : format" :props="props === null ? undefined : props" :left-default-checked="leftDefaultChecked === null ? undefined : leftDefaultChecked" :right-default-checked="rightDefaultChecked === null ? undefined : rightDefaultChecked" :render-content="renderContent === null ? undefined : renderContent" @change="elEmitChange" @left-check-change="elEmitLeftCheckChange" @right-check-change="elEmitRightCheckChange" :item-size="itemSize === null ? undefined : itemSize" :validate-event="validateEvent === null ? undefined : validateEvent" :virtual-scroll="virtualScroll === null ? undefined : virtualScroll"></el-transfer>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":["Species"],"data":[{"key":"Sepal.Length","label":"Sepal.Length"},{"key":"Sepal.Width","label":"Sepal.Width"},{"key":"Petal.Length","label":"Petal.Length"},{"key":"Petal.Width","label":"Petal.Width"},{"key":"Species","label":"Species"}],"titles":null,"buttonTexts":null,"filterable":null,"filterPlaceholder":null,"filterMethod":null,"targetOrder":null,"format":null,"props":null,"leftDefaultChecked":null,"rightDefaultChecked":null,"renderContent":null,"itemSize":null,"validateEvent":null,"virtualScroll":null},"methods":{"elEmitChange":"function() { var shape = function(value, direction, moved) { return {value: value, direction: direction, moved: moved}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('cols', 'change', [v]); }","elEmitLeftCheckChange":"function() { var shape = function(checked, changed) { return {checked: checked, changed: changed}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('cols', 'left_check_change', [v]); }","elEmitRightCheckChange":"function() { var shape = function(checked, changed) { return {checked: checked, changed: changed}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('cols', 'right_check_change', [v]); }"},"watch":{"value":"function(newVal) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitChange","options.methods.elEmitLeftCheckChange","options.methods.elEmitRightCheckChange","options.watch.value"]}</script>
#> </div>

el_transfer(
  "cols",
  data = data.frame(key = names(mtcars), label = names(mtcars)),
  titles = c("Available", "Chosen"),
  filterable = TRUE,
  width = "100%"
)
#> <div id="cols" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="cols_container" style="display: contents">
#>   <el-transfer v-model="value" :data="data" :titles="titles === null ? undefined : titles" :button-texts="buttonTexts === null ? undefined : buttonTexts" :filterable="filterable === null ? undefined : filterable" :filter-placeholder="filterPlaceholder === null ? undefined : filterPlaceholder" :filter-method="filterMethod === null ? undefined : filterMethod" :target-order="targetOrder === null ? undefined : targetOrder" :format="format === null ? undefined : format" :props="props === null ? undefined : props" :left-default-checked="leftDefaultChecked === null ? undefined : leftDefaultChecked" :right-default-checked="rightDefaultChecked === null ? undefined : rightDefaultChecked" :render-content="renderContent === null ? undefined : renderContent" @change="elEmitChange" @left-check-change="elEmitLeftCheckChange" @right-check-change="elEmitRightCheckChange" :item-size="itemSize === null ? undefined : itemSize" :validate-event="validateEvent === null ? undefined : validateEvent" :virtual-scroll="virtualScroll === null ? undefined : virtualScroll" style="width: 100%"></el-transfer>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":[],"data":[{"key":"mpg","label":"mpg"},{"key":"cyl","label":"cyl"},{"key":"disp","label":"disp"},{"key":"hp","label":"hp"},{"key":"drat","label":"drat"},{"key":"wt","label":"wt"},{"key":"qsec","label":"qsec"},{"key":"vs","label":"vs"},{"key":"am","label":"am"},{"key":"gear","label":"gear"},{"key":"carb","label":"carb"}],"titles":["Available","Chosen"],"buttonTexts":null,"filterable":true,"filterPlaceholder":null,"filterMethod":null,"targetOrder":null,"format":null,"props":null,"leftDefaultChecked":null,"rightDefaultChecked":null,"renderContent":null,"itemSize":null,"validateEvent":null,"virtualScroll":null},"methods":{"elEmitChange":"function() { var shape = function(value, direction, moved) { return {value: value, direction: direction, moved: moved}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('cols', 'change', [v]); }","elEmitLeftCheckChange":"function() { var shape = function(checked, changed) { return {checked: checked, changed: changed}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('cols', 'left_check_change', [v]); }","elEmitRightCheckChange":"function() { var shape = function(checked, changed) { return {checked: checked, changed: changed}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('cols', 'right_check_change', [v]); }"},"watch":{"value":"function(newVal) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitChange","options.methods.elEmitLeftCheckChange","options.methods.elEmitRightCheckChange","options.watch.value"]}</script>
#> </div>
```
