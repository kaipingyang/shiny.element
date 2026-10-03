# Element Plus Form

A form that owns its state, the way Element Plus intends: one Vue
instance holding a `model` of all field values plus the validation
rules, with async-validator running them on blur or change.

## Usage

``` r
el_form(
  ...,
  id = NULL,
  label_width = "100px",
  label_position = "right",
  inline = FALSE,
  size = NULL,
  submit_label = "Submit",
  reset_label = NULL,
  disabled = NULL,
  show_message = NULL,
  inline_message = NULL,
  status_icon = NULL,
  hide_required_asterisk = NULL,
  label_suffix = NULL,
  validate_on_rule_change = NULL,
  require_asterisk_position = NULL,
  scroll_into_view_options = NULL,
  scroll_to_error = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- ...:

  Fields, from
  [`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md).

- id:

  Form ID (auto-generated if NULL).

- label_width:

  Label column width, e.g. `"100px"`.

- label_position:

  `"right"` (default), `"left"` or `"top"`.

- inline:

  Lay the fields out in a row.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- submit_label:

  Submit button text. `NULL` renders no button, in which case drive the
  form with
  [`el_form_validate()`](https://kaipingyang.github.io/shiny.element/reference/el_form_validate.md).

- reset_label:

  Reset button text. `NULL` renders no button.

- disabled:

  Whether every control in the form is disabled.

- show_message:

  Whether to show validation messages. Default `TRUE`.

- inline_message:

  Whether to show validation messages inline.

- status_icon:

  Whether to show a validation status icon in each field.

- hide_required_asterisk:

  Whether to hide the asterisk next to required fields' labels.

- label_suffix:

  Suffix appended to every label.

- validate_on_rule_change:

  Whether changing the rules triggers validation immediately.

- require_asterisk_position:

  Position of asterisk. Element Plus's `require-asterisk-position`
  ('left' \| 'right').

- scroll_into_view_options:

  When validation fails, it scrolls to the first error item based on the
  scrollIntoView option. scrollIntoView. Element Plus's
  `scroll-into-view-options` (ScrollIntoViewOptions / boolean).

- scroll_to_error:

  When validation fails, scroll to the first error form entry. Element
  Plus's `scroll-to-error` (boolean).

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

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

## Details

Fields are declared with
[`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md)
rather than composed from the package's standalone input components.
Those are each their own Vue instance, which puts them outside the
form-item's component tree, where Element's event chain and shared model
cannot reach them.

## Shiny inputs

`input$<id>` holds the whole model as a list, reported once on load and
again on every submit. `input$<id>_valid` is `TRUE` when the last submit
passed validation, and `input$<id>_submit` is a submit counter to
trigger on. The model is deliberately *not* sent on every keystroke:
that is the point of the form owning its state rather than each field
reporting separately.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `clearValidate()` – Clear validation message for certain fields. The
  parameter is prop name or an array of prop names of the...

- `clearValidate()` – Remove validation status of the field

- `resetField()` – Reset current field and remove validation result

- `resetFields()` – Reset all the fields and remove validation result

- [`validate()`](https://rdrr.io/pkg/shiny/man/validate.html) – Validate
  the whole form. Takes a callback as a param. After validation, the
  callback will be executed with...

- `validateField()` – Validate one or several form items

## Examples

``` r
el_form(
  id = "signup",
  label_width = "100px",
  el_form_field("name", "input", label = "Name",
                rules = el_rule(required = TRUE, message = "Name is required")),
  el_form_field("age", "input-number", label = "Age", value = 18,
                min = 0, max = 150),
  el_form_field("city", "select", label = "City",
                choices = c(Beijing = "bj", Shanghai = "sh"),
                rules = el_rule(required = TRUE, message = "Pick a city",
                                trigger = "change"))
)
#> <div id="signup" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="signup_container" style="display: contents">
#>   <el-form :model="model" :rules="rules" ref="form" :label-width="labelWidth" :label-position="labelPosition" :inline="inline" :size="size === null ? undefined : size" :disabled="disabled === null ? undefined : disabled" :show-message="showMessage === null ? undefined : showMessage" :inline-message="inlineMessage === null ? undefined : inlineMessage" :status-icon="statusIcon === null ? undefined : statusIcon" :hide-required-asterisk="hideRequiredAsterisk === null ? undefined : hideRequiredAsterisk" :label-suffix="labelSuffix === null ? undefined : labelSuffix" :validate-on-rule-change="validateOnRuleChange === null ? undefined : validateOnRuleChange" @validate="elEmitValidate" :require-asterisk-position="requireAsteriskPosition === null ? undefined : requireAsteriskPosition" :scroll-into-view-options="scrollIntoViewOptions === null ? undefined : scrollIntoViewOptions" :scroll-to-error="scrollToError === null ? undefined : scrollToError">
#>     <el-form-item v-for="f in fields" :key="f.prop" :prop="f.prop" :label="f.label" :required="f.required" :rules="f.rules" :error="f.error" :label-width="f.labelWidth" :size="f.size" :inline-message="f.inlineMessage" :show-message="f.showMessage" :label-position="f.labelPosition" :validate-status="f.validateStatus" :for="f.for"><template v-slot:label><span v-if="f.labelHtml" v-html="f.labelHtml"></span><span v-else>{{f.label}}</span></template><template v-slot:error="scope"><div class="el-form-item__error"><span v-if="f.errorHtml" v-html="f.errorHtml"></span><span v-else>{{scope.error}}</span></div></template><component :is="f.tag" v-model="model[f.prop]" v-bind="f.props"><template v-if="f.text">{{ f.text }}</template><component v-for="o in (f.options || [])" :is="f.optionTag" :key="o.label" :label="o.label" :value="o.value">{{ o.text }}</component></component></el-form-item>
#>     <el-form-item><el-button type="primary" @click="handleSubmit">{{ submitLabel }}</el-button></el-form-item>
#>   </el-form>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"model":{"name":"","age":18,"city":""},"rules":{"name":[{"required":true,"message":"Name is required","trigger":"blur"}],"city":[{"required":true,"message":"Pick a city","trigger":"change"}]},"fields":[{"prop":"name","label":"Name","tag":"el-input","props":[]},{"prop":"age","label":"Age","tag":"el-input-number","props":{"min":0,"max":150}},{"prop":"city","label":"City","tag":"el-select","props":[],"optionTag":"el-option","options":[{"label":"Beijing","value":"bj","text":""},{"label":"Shanghai","value":"sh","text":""}]}],"labelWidth":"100px","labelPosition":"right","inline":false,"submitLabel":"Submit","resetLabel":"","submitCount":0,"valid":false,"size":null,"disabled":null,"showMessage":null,"inlineMessage":null,"statusIcon":null,"hideRequiredAsterisk":null,"labelSuffix":null,"validateOnRuleChange":null,"requireAsteriskPosition":null,"scrollIntoViewOptions":null,"scrollToError":null},"methods":{"elEmitValidate":"function() { window.shinyVue.emit('signup', 'validate', arguments); }","handleSubmit":"function() { var self = this; this.$refs.form.validate(function(ok) { self.submitCount++; self.valid = ok; window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"signup\" + '_valid', ok); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"signup\" + '_submit', self.submitCount); }); }","shinyVueReceive":"function(d) { var self = this, action = d['.action']; delete d['.action']; if (d.model) { Object.keys(d.model).forEach(function(k) { self.model[k] = d.model[k]; }); delete d.model; } if (d['.fields']) { var model = {}, rules = {}; d['.fields'].forEach(function(f) { model[f.prop] = Object.prototype.hasOwnProperty.call(self.model, f.prop) ? self.model[f.prop] : f.value; if (f.rules) rules[f.prop] = f.rules; delete f.value; delete f.rules; }); self.model = model; self.rules = rules; self.fields = d['.fields']; delete d['.fields']; } if (d['.errors']) { Object.keys(d['.errors']).forEach(function(k) { self.fields.forEach(function(f, i) { if (f.prop === k) self.fields[i].error = d['.errors'][k] || ''; }); }); delete d['.errors']; } if (action === 'validate') self.handleSubmit(); else if (action === 'reset') self.handleReset(); else if (action === 'clearValidate') { if (self.$refs.form) self.$refs.form.clearValidate(d.props || undefined); delete d.props; } return d; }","handleReset":"function() { this.$refs.form.resetFields(); }"}},"input":"model","rate":null,"type":null,"evals":["options.methods.elEmitValidate","options.methods.handleSubmit","options.methods.shinyVueReceive","options.methods.handleReset"]}</script>
#> </div>

if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_form(
      id = "signup", label_width = "100px", reset_label = "Reset",
      el_form_field("name", "input", label = "Name",
                    rules = el_rule(required = TRUE, message = "Required")),
      el_form_field("email", "input", label = "Email",
                    rules = el_rule(type = "email", message = "Invalid email"))
    ),
    verbatimTextOutput("out")
  )
  server <- function(input, output, session) {
    output$out <- renderPrint({
      req(input$signup_submit)
      if (!isTRUE(input$signup_valid)) return("Please fix the errors above")
      input$signup
    })
  }
  shinyApp(ui, server)
}
```
