# Every input takes a label, as Shiny's do: shown above the component by
# default or beside it, and tied to it for assistive technology.

template_of <- function(ui) {
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  sub("</script>.*$", "", sub("^.*?data-shiny-vue-template>", "", html))
}

inputs <- list(
  el_input = quote(el_input("x", label = "L")),
  el_input_number = quote(el_input_number("x", label = "L")),
  el_autocomplete = quote(el_autocomplete("x", label = "L")),
  el_select = quote(el_select("x", choices = "a", label = "L")),
  el_radio_group = quote(el_radio_group("x", choices = "a", label = "L")),
  el_checkbox_group = quote(el_checkbox_group("x", choices = "a", label = "L")),
  el_switch = quote(el_switch("x", label = "L")),
  el_slider = quote(el_slider("x", label = "L")),
  el_rate = quote(el_rate("x", label = "L")),
  el_date_picker = quote(el_date_picker("x", label = "L")),
  el_time_picker = quote(el_time_picker("x", label = "L")),
  el_time_select = quote(el_time_select("x", label = "L")),
  el_color_picker = quote(el_color_picker("x", label = "L")),
  el_cascader = quote(el_cascader("x", options = list(), label = "L")),
  el_cascader_panel = quote(el_cascader_panel("x", label = "L")),
  el_transfer = quote(el_transfer("x", label = "L")),
  el_upload = quote(el_upload("x", label = "L")),
  el_tree = quote(el_tree("x", data = list(), label = "L")),
  el_calendar = quote(el_calendar("x", label = "L"))
)

test_that("every input shows its label, tied to the component", {
  for (nm in names(inputs)) {
    tpl <- template_of(eval(inputs[[nm]]))
    expect_match(tpl, '<label id="x-label" for="x-input" class="el-form-item__label"',
                 fixed = TRUE, info = nm)
    expect_true(grepl('id="x-input"', tpl, fixed = TRUE) ||
                grepl('aria-labelledby="x-label"', tpl, fixed = TRUE), info = nm)
  }
})

test_that("no label, no form item: the component is as it was", {
  tpl <- template_of(el_input("x"))
  expect_false(grepl("el-form-item", tpl, fixed = TRUE))
  expect_match(tpl, '<div id="x_container" style="display: contents">', fixed = TRUE)
})

test_that("label_position puts the label above or beside", {
  top  <- template_of(el_select("x", choices = "a", label = "L"))
  left <- template_of(el_select("x", choices = "a", label = "L", label_position = "left"))
  expect_match(top, "el-form-item--label-top", fixed = TRUE)
  expect_match(left, "el-form-item--label-left", fixed = TRUE)
  expect_match(left, "display: flex", fixed = TRUE)
  expect_error(el_input("x", label = "L", label_position = "under"), "should be one of")
})

test_that("a label is also the accessible name Element's own prop carries", {
  expect_equal(vue_data_of(el_input("x", label = "Name"))$label, "Name")
})

test_that("el_upload's trigger text is button_label, as fileInput's buttonLabel", {
  d <- vue_data_of(el_upload("x", label = "Documents", button_label = "Browse"))
  expect_equal(d$buttonLabel, "Browse")
  expect_match(template_of(el_upload("x", label = "Documents")), ">Documents</label>",
               fixed = TRUE)
})

# el-form-item's own props, for the one input it holds

test_that("label_width sets the width of a label beside the component", {
  tpl <- template_of(el_input("x", label = "L", label_position = "right",
                              label_width = 110))
  expect_match(tpl, "text-align: right; width: 110px;", fixed = TRUE)
  expect_match(tpl, "el-form-item--label-right", fixed = TRUE)
})

test_that("label_suffix follows the label with no space, as Element writes it", {
  expect_match(template_of(el_input("x", label = "Name", label_suffix = ":")),
               ">Name:</label>", fixed = TRUE)
  expect_match(template_of(el_input("x", label = htmltools::tags$b("Name"),
                                    label_suffix = ":")),
               "<b>Name</b><span>:</span></label>", fixed = TRUE)
})

test_that("required marks the label with Element's asterisk class", {
  expect_match(template_of(el_input("x", label = "L", required = TRUE)),
               'class="el-form-item el-form-item--label-top is-required"', fixed = TRUE)
  expect_false(grepl("is-required", template_of(el_input("x", label = "L")), fixed = TRUE))
})

test_that("error draws Element's error state, under the control or beside it", {
  under <- template_of(el_input("x", label = "L", label_position = "left",
                                error = "Taken"))
  expect_match(under, "is-error", fixed = TRUE)
  expect_match(under, '<div class="el-form-item__error" style="position: static; display: block',
               fixed = TRUE)
  # In the content, under the control -- not a third item in the row
  expect_match(under, "el-form-item__content.*el-form-item__error.*</div>\\s*</div>\\s*</div>$")

  beside <- template_of(el_input("x", label = "L", error = "Short",
                                 inline_message = TRUE))
  expect_match(beside, 'class="el-form-item__error el-form-item__error--inline"',
               fixed = TRUE)

  quiet <- template_of(el_input("x", label = "L", error = "Taken",
                                show_message = FALSE))
  expect_match(quiet, "is-error", fixed = TRUE)
  expect_false(grepl("el-form-item__error", quiet, fixed = TRUE))
})

test_that("the component's size sizes the form item, so a label lines up", {
  # bound to the size field, falling back to the page's size, which the
  # bridge gives every app as $ELEMENT
  tpl <- template_of(el_input("x", label = "L", size = "small"))
  expect_match(tpl, ":class=\"(size || ($ELEMENT &amp;&amp; $ELEMENT.size)) ? &#39;el-form-item--&#39; +",
               fixed = TRUE)
  # a component with no size of its own takes only the global one
  expect_match(template_of(el_color_picker_panel("x", label = "L")),
               ":class=\"($ELEMENT &amp;&amp; $ELEMENT.size) ? &#39;el-form-item--&#39; +", fixed = TRUE)
})

test_that("a label beside the component sits on the control's first line", {
  tpl <- template_of(el_input("x", label = "L", label_position = "left"))
  expect_match(tpl, "align-items: flex-start", fixed = TRUE)
  # Element's own label line height is left alone
  expect_false(grepl("float: none; flex: none; padding: 0 12px 0 0; line-height",
                     tpl, fixed = TRUE))
})

test_that("a rate beside its label is padded to the label's line", {
  expect_match(template_of(el_rate("x", label = "L", label_position = "left")),
               '<el-rate[^>]*style="padding: 10px 0"')
  expect_false(grepl("padding: 10px 0", template_of(el_rate("x", label = "L")), fixed = TRUE))
})
