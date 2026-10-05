# Element Plus Checkbox

One box, ticked or not – Shiny's
[`shiny::checkboxInput()`](https://rdrr.io/pkg/shiny/man/checkboxInput.html),
drawn by Element. For several choices,
[`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md).

## Usage

``` r
el_checkbox(
  id = NULL,
  label = NULL,
  value = FALSE,
  indeterminate = NULL,
  disabled = NULL,
  border = NULL,
  size = NULL,
  true_label = NULL,
  false_label = NULL,
  name = NULL,
  checked = NULL,
  aria_controls = NULL,
  aria_label = NULL,
  controls = NULL,
  false_value = NULL,
  tabindex = NULL,
  true_value = NULL,
  validate_event = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

update_el_checkbox(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  label = NULL,
  indeterminate = NULL,
  disabled = NULL,
  border = NULL,
  size = NULL,
  true_label = NULL,
  false_label = NULL,
  name = NULL,
  checked = NULL,
  aria_controls = NULL,
  aria_label = NULL,
  controls = NULL,
  false_value = NULL,
  tabindex = NULL,
  true_value = NULL,
  validate_event = NULL
)
```

## Arguments

- id:

  Checkbox ID. Auto-generated if `NULL`.

- label:

  The box's text, as for
  [`shiny::checkboxInput()`](https://rdrr.io/pkg/shiny/man/checkboxInput.html).

- value:

  Whether the box starts ticked. Default `FALSE`.

- indeterminate:

  Show the box half-ticked – the "check all" box above a partly checked
  group. Only the look: `value` is unchanged.

- disabled:

  Whether the box is disabled.

- border:

  Draw the box with a border.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- true_label, false_label:

  Values to report instead of `TRUE` and `FALSE`.

- name:

  Native `name` attribute.

- checked:

  Element's `checked`: tick the box when it is created, whatever `value`
  says. The same as `value = TRUE`, kept for code written from Element's
  documentation.

- aria_controls:

  Same as aria-controls, takes effect when `indeterminate` is `true`.
  Element Plus's `aria-controls` (string).

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- controls:

  Same as aria-controls, takes effect when `indeterminate` is `true`.
  Element Plus's `controls` (string).

- false_value:

  Value of the Checkbox if it's not checked. Element Plus's
  `false-value` (string / number).

- tabindex:

  Input tabindex. Element Plus's `tabindex` (string / number).

- true_value:

  Value of the Checkbox if it's checked. Element Plus's `true-value`
  (string / number).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents; the default slot replaces
  `label`.

- session:

  In `el_checkbox()`, deprecated: inside a module, wrap `id` in `ns()`,
  as for any Shiny input; a session given here namespaces `id` once
  more, with a warning. In `update_el_checkbox()`, the Shiny session,
  the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – `TRUE` or `FALSE` (or `true_label` and `false_label`),
  on load and on change.

## Updating from the server

Server-side update for `el_checkbox()`.

Every other argument of `el_checkbox()` that can change once it is drawn
is an argument here too, under the same name. One left `NULL` stays as
it is; `NA` returns it to Element's default.

`update_el_checkbox()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_checkbox("agree", "I agree to the terms")
#> <div id="agree" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="agree_container" style="display: contents">
#>   <el-checkbox v-model="value" :label="text" @change="handleChange" :indeterminate="indeterminate === null ? undefined : indeterminate" :disabled="disabled === null ? undefined : disabled" :border="border === null ? undefined : border" :size="size === null ? undefined : size" :true-label="trueLabel === null ? undefined : trueLabel" :false-label="falseLabel === null ? undefined : falseLabel" :name="name === null ? undefined : name" :checked="checked === null ? undefined : checked" :aria-controls="ariaControls === null ? undefined : ariaControls" :aria-label="ariaLabel === null ? undefined : ariaLabel" :controls="controls === null ? undefined : controls" :false-value="falseValue === null ? undefined : falseValue" :tabindex="tabindex === null ? undefined : tabindex" :true-value="trueValue === null ? undefined : trueValue" :validate-event="validateEvent === null ? undefined : validateEvent"></el-checkbox>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":false,"text":"I agree to the terms","indeterminate":null,"disabled":null,"border":null,"size":null,"trueLabel":null,"falseLabel":null,"name":null,"checked":null,"ariaControls":null,"ariaLabel":null,"controls":null,"falseValue":null,"tabindex":null,"trueValue":null,"validateEvent":null},"methods":{"handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>

# The "check all" box above a group
el_checkbox("all", "Check all", indeterminate = TRUE)
#> <div id="all" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="all_container" style="display: contents">
#>   <el-checkbox v-model="value" :label="text" @change="handleChange" :indeterminate="indeterminate === null ? undefined : indeterminate" :disabled="disabled === null ? undefined : disabled" :border="border === null ? undefined : border" :size="size === null ? undefined : size" :true-label="trueLabel === null ? undefined : trueLabel" :false-label="falseLabel === null ? undefined : falseLabel" :name="name === null ? undefined : name" :checked="checked === null ? undefined : checked" :aria-controls="ariaControls === null ? undefined : ariaControls" :aria-label="ariaLabel === null ? undefined : ariaLabel" :controls="controls === null ? undefined : controls" :false-value="falseValue === null ? undefined : falseValue" :tabindex="tabindex === null ? undefined : tabindex" :true-value="trueValue === null ? undefined : trueValue" :validate-event="validateEvent === null ? undefined : validateEvent"></el-checkbox>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":false,"text":"Check all","indeterminate":true,"disabled":null,"border":null,"size":null,"trueLabel":null,"falseLabel":null,"name":null,"checked":null,"ariaControls":null,"ariaLabel":null,"controls":null,"falseValue":null,"tabindex":null,"trueValue":null,"validateEvent":null},"methods":{"handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>

el_checkbox("remember", "Remember me", value = TRUE, border = TRUE)
#> <div id="remember" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="remember_container" style="display: contents">
#>   <el-checkbox v-model="value" :label="text" @change="handleChange" :indeterminate="indeterminate === null ? undefined : indeterminate" :disabled="disabled === null ? undefined : disabled" :border="border === null ? undefined : border" :size="size === null ? undefined : size" :true-label="trueLabel === null ? undefined : trueLabel" :false-label="falseLabel === null ? undefined : falseLabel" :name="name === null ? undefined : name" :checked="checked === null ? undefined : checked" :aria-controls="ariaControls === null ? undefined : ariaControls" :aria-label="ariaLabel === null ? undefined : ariaLabel" :controls="controls === null ? undefined : controls" :false-value="falseValue === null ? undefined : falseValue" :tabindex="tabindex === null ? undefined : tabindex" :true-value="trueValue === null ? undefined : trueValue" :validate-event="validateEvent === null ? undefined : validateEvent"></el-checkbox>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":true,"text":"Remember me","indeterminate":null,"disabled":null,"border":true,"size":null,"trueLabel":null,"falseLabel":null,"name":null,"checked":null,"ariaControls":null,"ariaLabel":null,"controls":null,"falseValue":null,"tabindex":null,"trueValue":null,"validateEvent":null},"methods":{"handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>
if (interactive()) {
  # inside a server function: the "check all" box follows the group
  observeEvent(
    input$cities,
    {
      n <- length(input$cities)
      update_el_checkbox(
        session,
        "all",
        value = n == 4,
        indeterminate = n > 0 && n < 4
      )
    },
    ignoreNULL = FALSE
  )
}
```
