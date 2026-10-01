# Element UI Transfer

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

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
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

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  render function for an item.

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
el_transfer("cols",
  data = data.frame(key = names(iris), label = names(iris)),
  value = c("Species")
)
#> <div id="cols_container" style="display: contents">
#>   <el-transfer v-model="value" :data="data" :titles="titles === null ? undefined : titles" :button-texts="buttonTexts === null ? undefined : buttonTexts" :filterable="filterable === null ? undefined : filterable" :filter-placeholder="filterPlaceholder === null ? undefined : filterPlaceholder" :filter-method="filterMethod === null ? undefined : filterMethod" :target-order="targetOrder === null ? undefined : targetOrder" :format="format === null ? undefined : format" :props="props === null ? undefined : props" :left-default-checked="leftDefaultChecked === null ? undefined : leftDefaultChecked" :right-default-checked="rightDefaultChecked === null ? undefined : rightDefaultChecked" :render-content="renderContent === null ? undefined : renderContent" @change="elEmitChange" @left-check-change="elEmitLeftCheckChange" @right-check-change="elEmitRightCheckChange"></el-transfer>
#> </div>
#> <div id="cols" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="cols">{"x":{"el":"#cols_container","data":{"value":["Species"],"data":[{"key":"Sepal.Length","label":"Sepal.Length"},{"key":"Sepal.Width","label":"Sepal.Width"},{"key":"Petal.Length","label":"Petal.Length"},{"key":"Petal.Width","label":"Petal.Width"},{"key":"Species","label":"Species"}],"titles":null,"buttonTexts":null,"filterable":null,"filterPlaceholder":null,"filterMethod":null,"targetOrder":null,"format":null,"props":null,"leftDefaultChecked":null,"rightDefaultChecked":null,"renderContent":null},"methods":{"elEmitChange":"function() { var shape = function(value, direction, moved) { return {value: value, direction: direction, moved: moved}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('cols', 'change', [v]); }","elEmitLeftCheckChange":"function() { var shape = function(checked, changed) { return {checked: checked, changed: changed}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('cols', 'left_check_change', [v]); }","elEmitRightCheckChange":"function() { var shape = function(checked, changed) { return {checked: checked, changed: changed}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('cols', 'right_check_change', [v]); }"},"watch":{"value":"function(newVal) { window.Shiny && Shiny.setInputValue('cols', newVal); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue(\"cols\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitChange","methods.elEmitLeftCheckChange","methods.elEmitRightCheckChange","watch.value","mounted"],"jsHooks":[]}</script>

el_transfer("cols",
  data = data.frame(key = names(mtcars), label = names(mtcars)),
  titles = c("Available", "Chosen"),
  filterable = TRUE, width = "100%"
)
#> <div id="cols_container" style="display: contents">
#>   <el-transfer v-model="value" :data="data" :titles="titles === null ? undefined : titles" :button-texts="buttonTexts === null ? undefined : buttonTexts" :filterable="filterable === null ? undefined : filterable" :filter-placeholder="filterPlaceholder === null ? undefined : filterPlaceholder" :filter-method="filterMethod === null ? undefined : filterMethod" :target-order="targetOrder === null ? undefined : targetOrder" :format="format === null ? undefined : format" :props="props === null ? undefined : props" :left-default-checked="leftDefaultChecked === null ? undefined : leftDefaultChecked" :right-default-checked="rightDefaultChecked === null ? undefined : rightDefaultChecked" :render-content="renderContent === null ? undefined : renderContent" @change="elEmitChange" @left-check-change="elEmitLeftCheckChange" @right-check-change="elEmitRightCheckChange" style="width: 100%"></el-transfer>
#> </div>
#> <div id="cols" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="cols">{"x":{"el":"#cols_container","data":{"value":[],"data":[{"key":"mpg","label":"mpg"},{"key":"cyl","label":"cyl"},{"key":"disp","label":"disp"},{"key":"hp","label":"hp"},{"key":"drat","label":"drat"},{"key":"wt","label":"wt"},{"key":"qsec","label":"qsec"},{"key":"vs","label":"vs"},{"key":"am","label":"am"},{"key":"gear","label":"gear"},{"key":"carb","label":"carb"}],"titles":["Available","Chosen"],"buttonTexts":null,"filterable":true,"filterPlaceholder":null,"filterMethod":null,"targetOrder":null,"format":null,"props":null,"leftDefaultChecked":null,"rightDefaultChecked":null,"renderContent":null},"methods":{"elEmitChange":"function() { var shape = function(value, direction, moved) { return {value: value, direction: direction, moved: moved}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('cols', 'change', [v]); }","elEmitLeftCheckChange":"function() { var shape = function(checked, changed) { return {checked: checked, changed: changed}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('cols', 'left_check_change', [v]); }","elEmitRightCheckChange":"function() { var shape = function(checked, changed) { return {checked: checked, changed: changed}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyElement.emit('cols', 'right_check_change', [v]); }"},"watch":{"value":"function(newVal) { window.Shiny && Shiny.setInputValue('cols', newVal); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue(\"cols\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitChange","methods.elEmitLeftCheckChange","methods.elEmitRightCheckChange","watch.value","mounted"],"jsHooks":[]}</script>
```
