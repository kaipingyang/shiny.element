## basic-form
#' `el_form_item()` puts the date and the time under one label, in columns.
#| shot_expect = c("document.querySelectorAll('#activity .el-form-item .el-form-item').length === 2", "document.querySelectorAll('#activity .el-checkbox').length === 4")
el_form(
  id = "activity",
  label_width = "auto",
  width = "600px",
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
  el_form_item(
    "Activity time",
    el_form_field(
      "date1",
      "date-picker",
      placeholder = "Pick a date",
      style = "width: 100%"
    ),
    "-",
    el_form_field(
      "date2",
      "time-picker",
      placeholder = "Pick a time",
      style = "width: 100%"
    )
  ),
  el_form_field("delivery", "switch", label = "Instant delivery"),
  el_form_field(
    "type",
    "checkbox-group",
    label = "Activity type",
    choices = c(
      "Online activities",
      "Promotion activities",
      "Offline activities",
      "Simple brand exposure"
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
  label_width = NULL,
  submit_label = "Query",
  el_form_field(
    "user",
    "input",
    label = "Approved by",
    placeholder = "Approved by",
    clearable = TRUE
  ),
  el_form_field(
    "region",
    "select",
    label = "Activity zone",
    choices = c("Zone one" = "shanghai", "Zone two" = "beijing"),
    placeholder = "Activity zone",
    clearable = TRUE
  ),
  el_form_field(
    "date",
    "date-picker",
    label = "Activity time",
    placeholder = "Pick a date",
    clearable = TRUE
  )
)

## alignment
#' The two radio groups are fields with `report = TRUE`: they report as
#' `input$align_position` and `input$align_item_position` as they change,
#' and the server moves the labels -- the form's with
#' `update_el_form(label_position =)`, the fields' by giving the fields
#' again with their own `label_position`.
#| shot_js = c("document.querySelectorAll('#align .el-radio-button')[2].click()", "document.querySelectorAll('#align .el-radio-group')[1].querySelectorAll('.el-radio-button')[1].click()")
#| shot_expect = c("document.querySelector('#align .el-form').classList.contains('el-form--label-top')", "document.querySelectorAll('#align .el-form-item.el-form-item--label-left').length === 3")
positions <- c(Left = "left", Right = "right", Top = "top")
fields <- function(item_position = "") {
  list(
    el_form_field(
      "position",
      "radio-group",
      label = "Form Align",
      label_position = "right",
      choices = positions,
      value = "right",
      button = TRUE,
      report = TRUE
    ),
    el_form_field(
      "item_position",
      "radio-group",
      label = "Form Item Align",
      label_position = "right",
      choices = c(Empty = "", positions),
      value = item_position,
      button = TRUE,
      report = TRUE
    ),
    el_form_field(
      "name",
      "input",
      label = "Name",
      label_position = item_position
    ),
    el_form_field(
      "region",
      "input",
      label = "Activity zone",
      label_position = item_position
    ),
    el_form_field(
      "type",
      "input",
      label = "Activity form",
      label_position = item_position
    )
  )
}
ui <- el_page(
  do.call(
    el_form,
    c(
      list(
        id = "align",
        label_position = "right",
        label_width = "auto",
        width = "600px",
        submit_label = NULL
      ),
      fields()
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$align_position, ignoreInit = TRUE, {
    update_el_form(session, "align", label_position = input$align_position)
  })
  observeEvent(input$align_item_position, ignoreInit = TRUE, {
    update_el_form(
      session,
      "align",
      fields = fields(input$align_item_position)
    )
  })
}
shinyApp(ui, server)

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
        "function(rule, value, callback, source) {",
        "  if (!value) return callback(new Error('Please input the password again'));",
        "  value !== source.pass ? callback(new Error(\"Two inputs don't match!\")) : callback();",
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
#' The radio buttons set the form's `size` and `label_position` with
#' `update_el_form()`.
#| shot_js = c("document.querySelectorAll('#form_size .el-radio-button')[2].click()", "document.querySelectorAll('#form_position .el-radio-button')[2].click()")
#| shot_expect = c("document.querySelector('#sized .el-form').classList.contains('el-form--small')", "document.querySelector('#sized .el-form').classList.contains('el-form--label-top')", "document.querySelectorAll('#sized .el-checkbox-button').length === 2", "document.querySelectorAll('#sized .el-radio.is-bordered').length === 2")
ui <- el_page(
  tags$div(
    el_radio_group(
      "form_size",
      choices = c("large", "default", "small"),
      selected = "default",
      button = TRUE
    ),
    el_radio_group(
      "form_position",
      choices = c(Left = "left", Right = "right", Top = "top"),
      selected = "right",
      button = TRUE
    )
  ),
  tags$br(),
  el_form(
    id = "sized",
    label_width = "auto",
    label_position = "right",
    width = "600px",
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
    el_form_item(
      "Activity time",
      el_form_field(
        "date1",
        "date-picker",
        placeholder = "Pick a date",
        style = "width: 100%"
      ),
      "-",
      el_form_field(
        "date2",
        "time-picker",
        placeholder = "Pick a time",
        style = "width: 100%"
      )
    ),
    el_form_field(
      "type",
      "checkbox-group",
      label = "Activity type",
      choices = c("Online activities", "Promotion activities"),
      button = TRUE
    ),
    el_form_field(
      "resource",
      "radio-group",
      label = "Resources",
      choices = c("Sponsor", "Venue"),
      border = TRUE
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$form_size, ignoreInit = TRUE, {
    update_el_form(session, "sized", size = input$form_size)
  })
  observeEvent(input$form_position, ignoreInit = TRUE, {
    update_el_form(session, "sized", label_position = input$form_position)
  })
}
shinyApp(ui, server)

## accessibility
#' A field's label is tied to its control, so a screen reader announces it.
#' Under a label for a group, each control needs a label of its own:
#' `aria_label`. The notes are beside the forms here, a form holding only
#' fields.
#| shot_expect = c("document.querySelector('.el-space .el-form label').getAttribute('for') === document.querySelector('.el-space .el-form input').id", "document.querySelectorAll('.el-space .el-form')[1].querySelectorAll('input[aria-label]').length === 2")
el_space(
  fill = TRUE,
  direction = "vertical",
  width = "600px",
  el_alert(
    type = "info",
    show_icon = TRUE,
    closable = FALSE,
    title = '"Full Name" label is automatically attached to the input:'
  ),
  el_form(
    id = "a11y_name",
    label_position = "left",
    label_width = "140px",
    submit_label = NULL,
    el_form_field("full_name", "input", label = "Full Name")
  ),
  el_alert(
    type = "info",
    show_icon = TRUE,
    closable = FALSE,
    title = paste(
      '"Your Information" serves as a label for the group of inputs.',
      "You must specify labels on the individal inputs. Placeholders are",
      'not replacements for using the "label" attribute.'
    )
  ),
  el_form(
    id = "a11y_group",
    label_position = "left",
    label_width = "140px",
    submit_label = NULL,
    el_form_item(
      "Your Information",
      el_form_field(
        "first_name",
        "input",
        aria_label = "First Name",
        placeholder = "First Name"
      ),
      el_form_field(
        "last_name",
        "input",
        aria_label = "Last Name",
        placeholder = "Last Name"
      ),
      gutter = 20
    )
  )
)
