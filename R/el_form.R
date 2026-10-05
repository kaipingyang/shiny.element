# Element Plus's form owns its state: el-form holds a `model` object, each
# el-form-item's `prop` points into it, and validation rules are declared on the
# form and run by async-validator on blur/change. That machinery only works
# inside one component tree -- el-form-item finds its control through Vue's
# child chain and listens for events dispatched up it.
#
# So el_form() renders its own fields rather than accepting the package's
# standalone input components. Each of those is a separate Vue instance with its
# own `value`; dropped into a form its control is not in the form-item's
# $children, the event chain is broken, and the form's model never sees the
# value. That was measured: a form-item holding an independently mounted input
# reports $children of 1 against 2 for a native one, and validate() fails a
# field the user has visibly filled in.

#' Element Plus control tags by field type
#'
#' `option` is the child tag for the choice-based controls.
#' @keywords internal
.el_form_tags <- list(
  "input" = list(tag = "el-input"),
  # el-input's own `type`, which el_form_field()'s `type` cannot carry
  "textarea" = list(tag = "el-input", props = list(type = "textarea")),
  "password" = list(
    tag = "el-input",
    props = list(type = "password", showPassword = TRUE)
  ),
  "input-number" = list(tag = "el-input-number"),
  "select" = list(tag = "el-select", option = "el-option"),
  "radio-group" = list(tag = "el-radio-group", option = "el-radio"),
  "checkbox-group" = list(tag = "el-checkbox-group", option = "el-checkbox"),
  "switch" = list(tag = "el-switch"),
  "slider" = list(tag = "el-slider"),
  "date-picker" = list(tag = "el-date-picker"),
  "time-picker" = list(tag = "el-time-picker"),
  "rate" = list(tag = "el-rate"),
  "cascader" = list(tag = "el-cascader"),
  "cascader-panel" = list(tag = "el-cascader-panel"),
  "color-picker" = list(tag = "el-color-picker"),
  "time-select" = list(tag = "el-time-select"),
  "autocomplete" = list(tag = "el-autocomplete"),
  "transfer" = list(tag = "el-transfer"),
  # One box, true or false -- "I agree to the terms"
  "checkbox" = list(tag = "el-checkbox")
)

#' Empty value for a field type
#'
#' Picked so the initial model round-trips as the right JSON type, and so
#' `resetFields()` has something sensible to reset to.
#' @param type A field type from [.el_form_tags].
#' @return The type's empty value.
#' @keywords internal
.el_form_empty_value <- function(type) {
  switch(
    type,
    "input-number" = 0,
    "slider" = 0,
    "rate" = 0,
    "switch" = FALSE,
    "checkbox" = FALSE,
    "checkbox-group" = list(),
    "cascader" = list(),
    "cascader-panel" = list(),
    "transfer" = list(),
    ""
  )
}

#' Convert snake_case argument names to the camelCase Vue expects
#'
#' @param x A character vector of names.
#' @return The names in camelCase.
#' @keywords internal
.el_camel <- function(x) {
  gsub("_(.)", "\\U\\1", x, perl = TRUE)
}

#' Shape choices for a control's option tag
#'
#' `el-option` takes the display text as its `label` attribute, while
#' `el-radio` and `el-checkbox` use `label` as the *value* and take the display
#' text as their default slot. Normalising here keeps one template able to
#' render all three.
#'
#' @param choices Anything [.el_normalize_choices()] accepts.
#' @param option_tag The child tag this control uses.
#' @return A list of `list(label=, value=, text=)` items.
#' @keywords internal
.el_form_options <- function(choices, option_tag) {
  if (is.null(choices)) {
    return(NULL)
  }

  lapply(.el_normalize_choices(choices), function(opt) {
    if (identical(option_tag, "el-option")) {
      list(label = opt$label, value = opt$value, text = "")
    } else {
      list(label = opt$value, text = opt$label)
    }
  })
}

#' Normalise one or several validation rules into a list of rules
#'
#' @param rules A single [el_rule()], a list of them, or `NULL`.
#' @return An unnamed list of rules, or `NULL`.
#' @keywords internal
.el_normalize_rules <- function(rules) {
  if (is.null(rules) || !length(rules)) {
    return(NULL)
  }
  # A single el_rule() is a named list; several are an unnamed list of them.
  if (!is.null(names(rules)) && any(nzchar(names(rules)))) {
    list(rules)
  } else {
    rules
  }
}

#' Declare a validation rule
#'
#' Builds one async-validator rule, the format Element Plus's form expects.
#'
#' @param required Whether the field must be filled.
#' @param min,max Minimum and maximum: length for strings, value for numbers.
#' @param len Exact length.
#' @param pattern A regular expression the value must match.
#' @param type Value type to check: `"string"`, `"number"`, `"boolean"`,
#'   `"integer"`, `"float"`, `"array"`, `"object"`, `"enum"`, `"date"`,
#'   `"url"`, `"hex"`, `"email"` or `"any"`.
#' @param enum Allowed values, with `type = "enum"`.
#' @param whitespace Whether a value of only whitespace counts as empty, with
#'   `required = TRUE`.
#' @param validator A [JS()] function `function(rule, value, callback)` that
#'   calls `callback()` when the value is valid and `callback(new
#'   Error("message"))` when it is not -- Element's custom rule. A check only
#'   the server can make goes through [update_el_form()]'s `errors` instead.
#' @param transform A [JS()] function turning the value into what the rule
#'   checks, such as `function(v) { return v.trim(); }`.
#' @param message Text shown when the rule fails.
#' @param trigger When to run the rule: `"blur"`, `"change"`, or both as
#'   `c("blur", "change")`.
#' @return A rule, for [el_form_field()]'s `rules` argument.
#' @export
#' @examples
#' el_rule(required = TRUE, message = "Please enter your name")
#' el_rule(type = "email", message = "Not a valid email", trigger = "blur")
#' el_rule(type = "enum", enum = c("a", "b"), message = "a or b")
#' # Element's custom validator
#' el_rule(
#'   validator = JS(
#'     "function(rule, value, callback) {",
#'     "  value % 2 === 0 ? callback() : callback(new Error('An even number'));",
#'     "}"
#'   ),
#'   trigger = "change"
#' )
el_rule <- function(
  required = NULL,
  min = NULL,
  max = NULL,
  len = NULL,
  pattern = NULL,
  type = NULL,
  message = NULL,
  trigger = "blur",
  enum = NULL,
  whitespace = NULL,
  validator = NULL,
  transform = NULL
) {
  if (!is.null(type)) {
    type <- match.arg(
      type,
      c(
        "string",
        "number",
        "boolean",
        "method",
        "regexp",
        "integer",
        "float",
        "array",
        "object",
        "enum",
        "date",
        "url",
        "hex",
        "email",
        "any"
      )
    )
  }
  rule <- list(
    required = required,
    min = min,
    max = max,
    len = len,
    pattern = pattern,
    type = type,
    enum = if (!is.null(enum)) as.list(enum),
    whitespace = whitespace,
    validator = validator,
    transform = transform,
    message = message,
    trigger = if (length(trigger) > 1) as.list(trigger) else trigger
  )
  rule[!vapply(rule, is.null, logical(1))]
}

#' Declare a form field
#'
#' @param prop Field name. Keys the form's model and is what
#'   [el_rule()]s and validation messages refer to.
#' @param type Control type: one of `"input"`, `"textarea"`, `"password"`,
#'   `"input-number"`, `"select"`,
#'   `"radio-group"`, `"checkbox-group"`, `"checkbox"` (one box, `TRUE` or
#'   `FALSE`), `"switch"`, `"slider"`, `"date-picker"`, `"time-picker"`,
#'   `"time-select"`, `"rate"`, `"cascader"`, `"cascader-panel"`,
#'   `"color-picker"`, `"autocomplete"` or `"transfer"`. Their props go in
#'   `...`: a cascader's `options`, a transfer's `data`.
#' @param label Label text.
#' @param value Initial value. Defaults to the type's empty value, which is also
#'   what `resetFields()` restores.
#' @param choices Options for `"select"`, `"radio-group"` and
#'   `"checkbox-group"`; suggestions for `"autocomplete"`, filtered as the
#'   user types. A named vector `c(Label = value)` or a list of
#'   `list(value=, label=)`. For `"checkbox"`, the box's text is `label`.
#' @param rules A single [el_rule()] or a list of them.
#' @param ... Further props. Element's form-item props -- `required`,
#'   `error`, `label_width`, `label_position`, `size`, `show_message`,
#'   `inline_message`, `validate_status`, `for`, and
#'   `label_html`/`error_html` for markup of your own, a string or
#'   htmltools tags -- go on the field's
#'   form item; anything else on the control, e.g. `placeholder`, `min`,
#'   `max`, `disabled`. Names are converted to camelCase.
#' @return A field declaration, for [el_form()].
#' @export
#' @examples
#' el_form_field(
#'   "name",
#'   "input",
#'   label = "Name",
#'   rules = el_rule(required = TRUE, message = "Required")
#' )
#' el_form_field(
#'   "age",
#'   "input-number",
#'   label = "Age",
#'   value = 18,
#'   min = 0,
#'   max = 150
#' )
#' el_form_field(
#'   "city",
#'   "select",
#'   label = "City",
#'   choices = c(Beijing = "bj", Shanghai = "sh")
#' )
el_form_field <- function(
  prop,
  type = "input",
  label = NULL,
  value = NULL,
  choices = NULL,
  rules = NULL,
  ...
) {
  spec <- .el_form_tags[[type]]
  if (is.null(spec)) {
    stop(
      "Unknown field type: ",
      type,
      ". One of: ",
      paste(names(.el_form_tags), collapse = ", "),
      call. = FALSE
    )
  }

  props <- list(...)
  if (length(props)) {
    names(props) <- .el_camel(names(props))
  }
  # el-form-item's own props go on the item, not the control: the template
  # reads f.required, f.error, ... off the field
  item_props <- c(
    "required",
    "error",
    "labelWidth",
    "size",
    "inlineMessage",
    "showMessage",
    "labelHtml",
    "errorHtml",
    "labelPosition",
    "validateStatus",
    "for"
  )
  item <- props[intersect(names(props), item_props)]
  props <- props[setdiff(names(props), item_props)]
  # v-html takes a string: a tag would arrive as its JSON and show as text
  for (key in intersect(names(item), c("labelHtml", "errorHtml"))) {
    item[[key]] <- .el_html_string(item[[key]], .el_snake_case(key))
  }
  if (!is.null(spec$props)) {
    props <- utils::modifyList(spec$props, props)
  }
  if (identical(type, "autocomplete") && is.null(props$fetchSuggestions)) {
    # Element's autocomplete asks a function for its suggestions; this one
    # filters the choices, as el_autocomplete() does
    words <- vapply(
      .el_normalize_choices(choices),
      function(o) as.character(o$value),
      ""
    )
    props$fetchSuggestions <- JS(sprintf(
      paste0(
        "function(q, cb) { var all = %s; q = (q || '').toLowerCase(); ",
        "cb(all.filter(function(w) { return !q || w.toLowerCase().indexOf(q) === 0; })",
        ".map(function(w) { return {value: w}; })); }"
      ),
      jsonlite::toJSON(unname(words))
    ))
    choices <- NULL
  }

  field <- c(
    list(
      prop = prop,
      label = label,
      tag = spec$tag,
      props = props
    ),
    item,
    list(
      value = if (is.null(value)) .el_form_empty_value(type) else value,
      rules = .el_normalize_rules(rules)
    )
  )
  if (identical(type, "checkbox")) {
    # One box: Shiny's checkboxInput() label is the box's own text
    field$text <- label
    field$label <- NULL
  }
  if (!is.null(spec$option)) {
    field$optionTag <- spec$option
    field$options <- .el_form_options(choices, spec$option)
  }
  field
}

#' Element Plus Form
#'
#' A form that owns its state, the way Element Plus intends: one Vue instance
#' holding a `model` of all field values plus the validation rules, with
#' async-validator running them on blur or change.
#'
#' Fields are declared with [el_form_field()] rather than composed from the
#' package's standalone input components. Those are each their own Vue
#' instance, which puts them outside the form-item's component tree, where
#' Element's event chain and shared model cannot reach them.
#'
#' @param ... Fields, from [el_form_field()].
#' @param id Form ID (auto-generated if NULL).
#' @param label_width Label column width, e.g. `"100px"`.
#' @param label_position `"right"` (default), `"left"` or `"top"`.
#' @param inline Lay the fields out in a row.
#' @param size Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or the page.
#' @param submit_label Submit button text. `NULL` renders no button, in which
#'   case drive the form with [el_form_validate()].
#' @param reset_label Reset button text. `NULL` renders no button.
#' @param require_asterisk_position Position of asterisk. Element Plus's
#'   `require-asterisk-position` ('left' | 'right').
#' @param scroll_into_view_options When validation fails, it scrolls to the
#'   first error item based on the scrollIntoView option. scrollIntoView.
#'   Element Plus's `scroll-into-view-options` (ScrollIntoViewOptions /
#'   boolean).
#' @param scroll_to_error When validation fails, scroll to the first error
#'   form entry. Element Plus's `scroll-to-error` (boolean).
#' @param session In `el_form()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_form()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param disabled Whether every control in the form is disabled.
#' @param show_message Whether to show validation messages. Default `TRUE`.
#' @param inline_message Whether to show validation messages inline.
#' @param status_icon Whether to show a validation status icon in each field.
#' @param hide_required_asterisk Whether to hide the asterisk next to required fields' labels.
#' @param label_suffix Suffix appended to every label.
#' @param validate_on_rule_change Whether changing the rules triggers validation immediately.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Shiny inputs:
#' `input$<id>` holds the whole model as a list, reported once on load and
#' again on every submit. `input$<id>_valid` is `TRUE` when the last submit
#' passed validation, and `input$<id>_submit` is a submit counter to trigger on.
#' The model is deliberately *not* sent on every keystroke: that is the point of
#' the form owning its state rather than each field reporting separately.
#'
#' @section Element methods:
#' Callable with [call_el()]:
#'
#' - `clearValidate()` -- Clear validation message for certain fields. The parameter is prop name or an array of prop names of the...
#' - `clearValidate()` -- Remove validation status of the field
#' - `resetField()` -- Reset current field and remove validation result
#' - `resetFields()` -- Reset all the fields and remove validation result
#' - `validate()` -- Validate the whole form. Takes a callback as a param. After validation, the callback will be executed with...
#' - `validateField()` -- Validate one or several form items
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_form(
#'   id = "signup",
#'   label_width = "100px",
#'   el_form_field(
#'     "name",
#'     "input",
#'     label = "Name",
#'     rules = el_rule(required = TRUE, message = "Name is required")
#'   ),
#'   el_form_field(
#'     "age",
#'     "input-number",
#'     label = "Age",
#'     value = 18,
#'     min = 0,
#'     max = 150
#'   ),
#'   el_form_field(
#'     "city",
#'     "select",
#'     label = "City",
#'     choices = c(Beijing = "bj", Shanghai = "sh"),
#'     rules = el_rule(
#'       required = TRUE,
#'       message = "Pick a city",
#'       trigger = "change"
#'     )
#'   )
#' )
#'
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_form(
#'       id = "signup",
#'       label_width = "100px",
#'       reset_label = "Reset",
#'       el_form_field(
#'         "name",
#'         "input",
#'         label = "Name",
#'         rules = el_rule(required = TRUE, message = "Required")
#'       ),
#'       el_form_field(
#'         "email",
#'         "input",
#'         label = "Email",
#'         rules = el_rule(type = "email", message = "Invalid email")
#'       )
#'     ),
#'     verbatimTextOutput("out")
#'   )
#'   server <- function(input, output, session) {
#'     output$out <- renderPrint({
#'       req(input$signup_submit)
#'       if (!isTRUE(input$signup_valid)) {
#'         return("Please fix the errors above")
#'       }
#'       input$signup
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
el_form <- function(
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
) {
  .el_check_choices("el_form", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_form")
  }
  ns_id <- .el_ui_id(id, session)

  fields <- list(...)
  if (!length(fields)) {
    fields <- list()
  }

  model <- stats::setNames(
    lapply(fields, function(f) f$value),
    vapply(fields, function(f) f$prop, character(1))
  )
  rules <- Filter(
    Negate(is.null),
    stats::setNames(
      lapply(fields, function(f) f$rules),
      vapply(fields, function(f) f$prop, character(1))
    )
  )
  # `value` and `rules` live on the form, not on the control.
  fields <- lapply(fields, function(f) {
    f$value <- NULL
    f$rules <- NULL
    f
  })

  form_attrs <- list(
    ":model" = "model",
    ":rules" = "rules",
    ref = "form",
    ":label-width" = "labelWidth",
    ":label-position" = "labelPosition",
    ":inline" = "inline"
  )
  form_attrs[[":size"]] <- .el_optional_bind("size")
  form_attrs[[":disabled"]] <- .el_optional_bind("disabled")
  form_attrs[[":show-message"]] <- .el_optional_bind("showMessage")
  form_attrs[[":inline-message"]] <- .el_optional_bind("inlineMessage")
  form_attrs[[":status-icon"]] <- .el_optional_bind("statusIcon")
  form_attrs[[":hide-required-asterisk"]] <- .el_optional_bind(
    "hideRequiredAsterisk"
  )
  form_attrs[[":label-suffix"]] <- .el_optional_bind("labelSuffix")
  form_attrs[[":validate-on-rule-change"]] <- .el_optional_bind(
    "validateOnRuleChange"
  )

  # Forwarded to input$<id>_validate as list(prop, valid, message).
  events <- .el_event_bindings(ns_id, "validate")
  form_attrs <- c(form_attrs, events$attrs)
  # One template for every control type. `component :is` dispatches on the tag
  # name, so adding a type means adding a row to .el_form_tags, not a branch.
  field_items <- htmltools::HTML(paste0(
    paste0(
      '<el-form-item v-for="f in fields" :key="f.prop" :prop="f.prop" ',
      # Per-field props read off the field object: a field may carry
      # required, rules, error, label-width or size of its own.
      ':label="f.label" :required="f.required" :rules="f.rules" ',
      ':error="f.error" :label-width="f.labelWidth" :size="f.size" ',
      ':inline-message="f.inlineMessage" :show-message="f.showMessage" ',
      ':label-position="f.labelPosition" :validate-status="f.validateStatus" ',
      ':for="f.for">',
      # A field may render its own label and error, from label_html and
      # error_html in its definition. Inserted as markup, so pass only
      # what you control.
      '<template v-slot:label><span v-if="f.labelHtml" v-html="f.labelHtml">',
      '</span><span v-else>{{f.label}}</span></template>',
      # Element's own error slot renders a div.el-form-item__error, and
      # filling the slot replaces it -- so keep the class, or the message
      # loses its styling and anything looking for it stops finding it.
      '<template v-slot:error="scope">',
      '<div class="el-form-item__error">',
      '<span v-if="f.errorHtml" v-html="f.errorHtml"></span>',
      '<span v-else>{{scope.error}}</span>',
      '</div></template>'
    ),
    '<component :is="f.tag" v-model="model[f.prop]" v-bind="f.props">',
    '<template v-if="f.text">{{ f.text }}</template>',
    '<component v-for="o in (f.options || [])" :is="f.optionTag" :key="o.label" ',
    # An el-option draws its label itself; filling its slot with the empty
    # text would replace it with nothing (Vue 3 draws a slot given only an
    # empty string), so the slot is filled only when there is text
    ':label="o.label" :value="o.value"><template v-if="o.text">{{ o.text }}</template></component>',
    '</component>',
    '</el-form-item>'
  ))

  buttons <- if (!is.null(submit_label) || !is.null(reset_label)) {
    htmltools::HTML(paste0(
      '<el-form-item>',
      if (!is.null(submit_label)) {
        '<el-button type="primary" @click="handleSubmit">{{ submitLabel }}</el-button>'
      } else {
        ""
      },
      if (!is.null(reset_label)) {
        '<el-button @click="handleReset">{{ resetLabel }}</el-button>'
      } else {
        ""
      },
      '</el-form-item>'
    ))
  }

  vue_data <- list(
    model = model,
    rules = rules,
    fields = fields,
    labelWidth = label_width,
    labelPosition = label_position,
    inline = inline,
    submitLabel = if (is.null(submit_label)) "" else submit_label,
    resetLabel = if (is.null(reset_label)) "" else reset_label,
    submitCount = 0L,
    valid = FALSE
  )
  vue_data$size <- .el_or_na(size)
  vue_data$disabled <- .el_or_na(disabled)
  vue_data$showMessage <- .el_or_na(show_message)
  vue_data$inlineMessage <- .el_or_na(inline_message)
  vue_data$statusIcon <- .el_or_na(status_icon)
  vue_data$hideRequiredAsterisk <- .el_or_na(hide_required_asterisk)
  vue_data$labelSuffix <- .el_or_na(label_suffix)
  vue_data$validateOnRuleChange <- .el_or_na(validate_on_rule_change)
  js_id <- as.character(jsonlite::toJSON(ns_id, auto_unbox = TRUE))

  el_widget(
    props = .el_props(list(
      require_asterisk_position = require_asterisk_position,
      scroll_into_view_options = scroll_into_view_options,
      scroll_to_error = scroll_to_error
    )),
    id = ns_id,
    markup = htmltools::tag(
      "el-form",
      c(form_attrs, list(field_items, buttons))
    ),
    data = vue_data,
    methods = c(
      events$methods,
      list(
        handleSubmit = JS(sprintf(
          paste0(
            "function() { var self = this; ",
            "this.$refs.form.validate(function(ok) { ",
            "self.submitCount++; self.valid = ok; ",
            # The model and the verdict are set before the counter, so an
            # observeEvent on the counter sees this submit's values.
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue(%1$s, self.model); ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue(%1$s + '_valid', ok); ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue(%1$s + '_submit', self.submitCount); ",
            "}); }"
          ),
          js_id
        )),
        # update_el_form() and el_form_validate()/_reset()/_clear_validate()
        shinyVueReceive = JS(paste0(
          "function(d) { var self = this, action = d['.action']; delete d['.action']; ",
          # merged key by key, so fields not mentioned keep their values
          "if (d.model) { Object.keys(d.model).forEach(function(k) { ",
          "self.model[k] = d.model[k]; }); delete d.model; } ",
          # The whole field list: kept values stay, new fields start from
          # their own, removed ones leave the model, rules travel with fields
          "if (d['.fields']) { var model = {}, rules = {}; ",
          "d['.fields'].forEach(function(f) { ",
          "model[f.prop] = Object.prototype.hasOwnProperty.call(self.model, f.prop) ? ",
          "self.model[f.prop] : f.value; if (f.rules) rules[f.prop] = f.rules; ",
          "delete f.value; delete f.rules; }); ",
          "self.model = model; self.rules = rules; self.fields = d['.fields']; ",
          "delete d['.fields']; } ",
          # Element's error prop on each field: the form item shows it at once
          "if (d['.errors']) { Object.keys(d['.errors']).forEach(function(k) { ",
          "self.fields.forEach(function(f, i) { if (f.prop === k) ",
          "self.fields[i].error = d['.errors'][k] || ''; }); }); ",
          "delete d['.errors']; } ",
          "if (action === 'validate') self.handleSubmit(); ",
          "else if (action === 'reset') self.handleReset(); ",
          "else if (action === 'clearValidate') { ",
          "if (self.$refs.form) self.$refs.form.clearValidate(d.props || undefined); ",
          "delete d.props; } ",
          "return d; }"
        )),
        handleReset = JS(sprintf(
          paste0(
            "function() { this.$refs.form.resetFields(); ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue(%1$s, this.model); }"
          ),
          js_id
        ))
      )
    ),
    mounted = .el_mounted_init(stats::setNames("model", ns_id)),
    width = width,
    slots = slots
  )
}

#' @rdname el_form
#' @section Updating from the server:
#' `update_el_form()` changes the component from the server.
#'
#' Every other argument of [el_form()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_form()` is called for its side effect and returns `NULL` invisibly.
#' @param model New field values. Merged into the existing model, so a partial
#'   list only changes the fields it names.
#' @param rules New validation rules, as a named list of [el_rule()] lists
#'   keyed by `prop`. Replaces the rule set.
#' @param fields The form's fields, as [el_form_field()]s -- the whole list,
#'   in order, so a field can be added, removed or moved: Element's "add or
#'   delete form items dynamically". A field already in the form keeps what
#'   was entered; a new one starts from its `value`; a removed one leaves the
#'   model. Each field's rules come with it.
#' @param errors Error messages from the server, as a named list keyed by
#'   `prop` -- `list(email = "That address is taken")` -- shown on the field
#'   as Element's `error` shows them. `""` clears one.
#' @examples
#' if (interactive()) {
#'   # Prefill the form from the server
#'   update_el_form(session, "signup", model = list(name = "Ada", age = 36))
#'
#'   # A check only the server can make
#'   update_el_form(
#'     session,
#'     "signup",
#'     errors = list(email = "That address is taken")
#'   )
#' }
#' @export
update_el_form <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  model = NULL,
  rules = NULL,
  label_width = NULL,
  fields = NULL,
  errors = NULL,
  inline = NULL,
  size = NULL,
  submit_label = NULL,
  reset_label = NULL,
  disabled = NULL,
  status_icon = NULL,
  hide_required_asterisk = NULL,
  validate_on_rule_change = NULL,
  require_asterisk_position = NULL,
  scroll_into_view_options = NULL,
  scroll_to_error = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)

  if (!is.null(model)) {
    msg$model <- model
  }
  if (!is.null(rules)) {
    msg$rules <- lapply(rules, .el_normalize_rules)
  }
  if (!is.null(label_width)) {
    msg$labelWidth <- label_width
  }
  if (!is.null(fields)) {
    msg$.fields <- unname(fields)
  }
  if (!is.null(errors)) {
    msg$.errors <- as.list(errors)
  }

  msg <- c(
    msg,
    .el_update_props(
      "el_form",
      Filter(
        Negate(is.null),
        list(
          inline = inline,
          size = size,
          submit_label = submit_label,
          reset_label = reset_label,
          disabled = disabled,
          status_icon = status_icon,
          hide_required_asterisk = hide_required_asterisk,
          validate_on_rule_change = validate_on_rule_change,
          require_asterisk_position = require_asterisk_position,
          scroll_into_view_options = scroll_into_view_options,
          scroll_to_error = scroll_to_error
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}

#' Validate an Element Plus Form from the server
#'
#' Runs the form's rules and reports the outcome the same way a submit does,
#' so the same `observeEvent` handles both. Use it when the form has no submit
#' button of its own (`submit_label = NULL`).
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Form ID (un-namespaced).
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     el_form_validate(session, "signup")
#'   })
#' }
#' @export
el_form_validate <- function(session = shiny::getDefaultReactiveDomain(), id) {
  .el_check_session(session)
  .el_send_update(session, list(id = session$ns(id), .action = "validate"))
  invisible(NULL)
}

#' Reset an Element Plus Form
#'
#' Restores every field to the `value` it was declared with and clears the
#' validation state. Note this is Element Plus's `resetFields()`: it restores the
#' *initial* values, not empty ones, so a field declared with `value = 18`
#' resets to 18.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Form ID (un-namespaced).
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     el_form_reset(session, "signup")
#'   })
#' }
#' @export
el_form_reset <- function(session = shiny::getDefaultReactiveDomain(), id) {
  .el_check_session(session)
  .el_send_update(session, list(id = session$ns(id), .action = "reset"))
  invisible(NULL)
}

#' Clear an Element Plus Form's validation messages
#'
#' Leaves the values alone and only removes the error state.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Form ID (un-namespaced).
#' @param props Fields to clear. `NULL` clears all of them.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     el_form_clear_validate(session, "signup")
#'   })
#' }
#' @export
el_form_clear_validate <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  props = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(props)) {
    msg$props <- as.list(props)
  }
  msg$.action <- "clearValidate"
  .el_send_update(session, msg)
  invisible(NULL)
}
