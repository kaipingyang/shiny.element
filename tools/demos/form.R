## basic-form
el_form(
  id = "activity",
  label_width = "120px",
  submit_label = "Create",
  reset_label = "Cancel",
  el_form_field("name", "input", label = "Activity name"),
  el_form_field(
    "region",
    "select",
    label = "Activity zone",
    choices = c("Zone one" = "shanghai", "Zone two" = "beijing"),
    placeholder = "please select your zone"
  ),
  el_form_field(
    "date",
    "date-picker",
    label = "Activity time",
    placeholder = "Pick a date"
  ),
  el_form_field("delivery", "switch", label = "Instant delivery"),
  el_form_field(
    "type",
    "checkbox-group",
    label = "Activity type",
    choices = c(
      "Online activities",
      "Promotion activities",
      "Offline activities"
    )
  ),
  el_form_field(
    "resource",
    "radio-group",
    label = "Resources",
    choices = c("Sponsor", "Venue")
  ),
  el_form_field("desc", "textarea", label = "Activity form")
)

## inline-form
el_form(
  id = "search",
  inline = TRUE,
  submit_label = "Query",
  el_form_field(
    "user",
    "input",
    label = "Approved by",
    placeholder = "Approved by"
  ),
  el_form_field(
    "region",
    "select",
    label = "Activity zone",
    choices = c("Zone one" = "shanghai", "Zone two" = "beijing")
  )
)

## alignment
#' `label_position` puts the labels `"right"` (the default), `"left"` or on
#' `"top"`; a field's own `label_position` overrides it.
el_form(
  id = "aligned",
  label_position = "top",
  submit_label = NULL,
  width = "360px",
  el_form_field("name", "input", label = "Name"),
  el_form_field(
    "region",
    "input",
    label = "Activity zone",
    label_position = "right"
  ),
  el_form_field("type", "input", label = "Activity form")
)

## validation
#| shot_js = "document.querySelector('#shot .el-button--primary').click()"
ui <- el_page(
  el_form(
    id = "rules",
    label_width = "120px",
    submit_label = "Create",
    reset_label = "Reset",
    el_form_field(
      "name",
      "input",
      label = "Activity name",
      rules = list(
        el_rule(required = TRUE, message = "Please input Activity name"),
        el_rule(min = 3, max = 5, message = "Length should be 3 to 5")
      )
    ),
    el_form_field(
      "region",
      "select",
      label = "Activity zone",
      choices = c("Zone one" = "shanghai", "Zone two" = "beijing"),
      rules = el_rule(
        required = TRUE,
        message = "Please select Activity zone",
        trigger = "change"
      )
    ),
    el_form_field(
      "type",
      "checkbox-group",
      label = "Activity type",
      choices = c("Online activities", "Promotion activities"),
      rules = el_rule(
        type = "array",
        required = TRUE,
        trigger = "change",
        message = "Please select at least one activity type"
      )
    )
  ),
  verbatimTextOutput("verdict")
)

server <- function(input, output, session) {
  output$verdict <- renderPrint({
    req(input$rules_submit)
    input$rules_valid
  })
}

shinyApp(ui, server)

## custom-validation
#| shot_js = "var i = document.querySelectorAll('#shot input')[2]; i.value = '17'; i.dispatchEvent(new Event('input')); document.querySelector('#shot .el-button--primary').click();"
#| shot_wait = 2
ui <- el_page(el_form(
  id = "account",
  status_icon = TRUE,
  label_width = "120px",
  submit_label = "Submit",
  width = "480px",
  el_form_field(
    "pass",
    "password",
    label = "Password",
    rules = el_rule(required = TRUE, message = "Please input the password")
  ),
  el_form_field(
    "check",
    "password",
    label = "Confirm",
    rules = el_rule(
      trigger = "blur",
      validator = JS(
        "function(rule, value, callback) {",
        "  value ? callback() : callback(new Error('Please input the password again'));",
        "}"
      )
    )
  ),
  el_form_field(
    "age",
    "input",
    label = "Age",
    rules = el_rule(
      trigger = "blur",
      validator = JS(
        "function(rule, value, callback) {",
        "  var n = Number(value);",
        "  if (!value) return callback(new Error('Please input the age'));",
        "  if (isNaN(n)) return callback(new Error('Please input digits'));",
        "  n < 18 ? callback(new Error('Age must be greater than 18')) : callback();",
        "}"
      )
    )
  )
))

shinyApp(ui, function(input, output, session) {})

## form-items
#| shot_js = "document.querySelector('#more_container button').click()"
#| shot_wait = 1.5
domain <- function(i) {
  el_form_field(
    paste0("domain", i),
    "input",
    label = paste("Domain", i),
    rules = el_rule(required = TRUE, message = "Domain can not be null")
  )
}

ui <- el_page(
  el_form(
    id = "domains",
    submit_label = NULL,
    label_width = "100px",
    width = "480px",
    el_form_field(
      "email",
      "input",
      label = "Email",
      rules = el_rule(type = "email", message = "Please input a correct email")
    ),
    domain(1)
  ),
  el_button("more", "New domain"),
  el_button("fewer", "Remove last")
)

server <- function(input, output, session) {
  n <- reactiveVal(1)
  redraw <- function() {
    update_el_form(
      id = "domains",
      fields = c(
        list(el_form_field("email", "input", label = "Email")),
        lapply(seq_len(n()), domain)
      )
    )
  }
  observeEvent(input$more, {
    n(n() + 1)
    redraw()
  })
  observeEvent(input$fewer, {
    n(max(1, n() - 1))
    redraw()
  })
}

shinyApp(ui, server)

## number-validate
#| shot_js = "var i = document.querySelector('#shot input'); i.value = 'abc'; i.dispatchEvent(new Event('input')); document.querySelector('#shot .el-button--primary').click();"
#| shot_wait = 2
ui <- el_page(el_form(
  id = "aged",
  submit_label = "Submit",
  label_width = "100px",
  width = "420px",
  el_form_field(
    "age",
    "input",
    label = "Age",
    rules = list(
      el_rule(required = TRUE, message = "Age is required"),
      el_rule(
        type = "number",
        message = "Age must be a number",
        transform = JS("function(v) { return Number(v); }")
      )
    )
  )
))

shinyApp(ui, function(input, output, session) {})

## size-control
el_form(
  id = "small",
  size = "small",
  label_width = "120px",
  submit_label = "Create",
  width = "480px",
  el_form_field("name", "input", label = "Activity name"),
  el_form_field(
    "region",
    "select",
    label = "Activity zone",
    choices = c("Zone one" = "shanghai", "Zone two" = "beijing")
  ),
  el_form_field(
    "resource",
    "radio-group",
    label = "Resources",
    choices = c("Sponsor", "Venue")
  )
)

## accessibility
#' Each field's label is tied to its control, so a screen reader announces
#' it; a field with no label of its own takes `aria_label`.
el_form(
  id = "a11y",
  label_width = "auto",
  submit_label = NULL,
  width = "480px",
  el_form_field(
    "fullname",
    "input",
    label = "Full name",
    placeholder = "First and last name"
  ),
  el_form_field("email", "input", label = "Email", aria_label = "Email address")
)
