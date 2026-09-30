# Element UI Form

A form that owns its state, the way Element UI intends: one Vue instance
holding a `model` of all field values plus the validation rules, with
async-validator running them on blur or change.

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
  session = shiny::getDefaultReactiveDomain()
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

  Control size: `"medium"`, `"small"` or `"mini"`.

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

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Details

Fields are declared with
[`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md)
rather than composed from the package's standalone input components.
Those are each their own Vue instance, which puts them outside the
form-item's component tree, where Element's event chain and shared model
cannot reach them.

## Server inputs

`input$<id>` holds the whole model as a list, reported once on load and
again on every submit. `input$<id>_valid` is `TRUE` when the last submit
passed validation, and `input$<id>_submit` is a submit counter to
trigger on. The model is deliberately *not* sent on every keystroke:
that is the point of the form owning its state rather than each field
reporting separately.

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
#> <div id="signup_container" style="display: contents">
#>   <el-form :model="model" :rules="rules" ref="form" :label-width="labelWidth" :label-position="labelPosition" :inline="inline" :size="size === null ? undefined : size" :disabled="disabled === null ? undefined : disabled" :show-message="showMessage === null ? undefined : showMessage" :inline-message="inlineMessage === null ? undefined : inlineMessage" :status-icon="statusIcon === null ? undefined : statusIcon" :hide-required-asterisk="hideRequiredAsterisk === null ? undefined : hideRequiredAsterisk" :label-suffix="labelSuffix === null ? undefined : labelSuffix" :validate-on-rule-change="validateOnRuleChange === null ? undefined : validateOnRuleChange">
#>     <el-form-item v-for="f in fields" :key="f.prop" :prop="f.prop" :label="f.label" :required="f.required" :rules="f.rules" :error="f.error" :label-width="f.labelWidth" :size="f.size" :inline-message="f.inlineMessage" :show-message="f.showMessage"><component :is="f.tag" v-model="model[f.prop]" v-bind="f.props"><component v-for="o in (f.options || [])" :is="f.optionTag" :key="o.label" :label="o.label" :value="o.value">{{ o.text }}</component></component></el-form-item>
#>     <el-form-item><el-button type="primary" @click="handleSubmit">{{ submitLabel }}</el-button></el-form-item>
#>   </el-form>
#> </div>
#> <div id="signup" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="signup">{"x":{"el":"#signup_container","data":{"model":{"name":"","age":18,"city":""},"rules":{"name":[{"required":true,"message":"Name is required","trigger":"blur"}],"city":[{"required":true,"message":"Pick a city","trigger":"change"}]},"fields":[{"prop":"name","label":"Name","tag":"el-input","props":[]},{"prop":"age","label":"Age","tag":"el-input-number","props":{"min":0,"max":150}},{"prop":"city","label":"City","tag":"el-select","props":[],"optionTag":"el-option","options":[{"label":"Beijing","value":"bj","text":""},{"label":"Shanghai","value":"sh","text":""}]}],"labelWidth":"100px","labelPosition":"right","inline":false,"submitLabel":"Submit","resetLabel":"","submitCount":0,"valid":false,"size":null,"disabled":null,"showMessage":null,"inlineMessage":null,"statusIcon":null,"hideRequiredAsterisk":null,"labelSuffix":null,"validateOnRuleChange":null},"methods":{"handleSubmit":"function() { var self = this; this.$refs.form.validate(function(ok) { self.submitCount++; self.valid = ok; Shiny.setInputValue(\"signup\", self.model); Shiny.setInputValue(\"signup\" + '_valid', ok); Shiny.setInputValue(\"signup\" + '_submit', self.submitCount); }); }","handleReset":"function() { this.$refs.form.resetFields(); Shiny.setInputValue(\"signup\", this.model); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"signup\", self.model); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleSubmit","methods.handleReset","mounted"],"jsHooks":[]}</script>

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
