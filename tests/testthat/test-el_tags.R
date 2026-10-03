render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# `el` is a list of bare tag generators, built once at build time from a list
# of Element UI tag names. They render markup only -- no Vue instance, no
# Shiny binding -- so they are for composing inside a component that already
# provides one.

test_that("el: is a named list of functions", {
  expect_type(el, "list")
  expect_true(length(el) > 50)
  expect_true(all(vapply(el, is.function, logical(1))))
  expect_false(any(names(el) == ""))
})

test_that("el: generators emit the matching el- tag", {
  expect_match(render_html(el$button("Submit")), "^<el-button>")
  expect_match(render_html(el$row()), "^<el-row>")
  expect_match(render_html(el$dialog()), "^<el-dialog>")
})

test_that("el: hyphenated tags are reachable through underscored names", {
  # `el$table-column` is not valid R, so the names are underscored while the
  # rendered tag keeps its hyphen.
  expect_match(render_html(el$table_column(prop = "name")), "^<el-table-column")
  expect_match(render_html(el$form_item()), "^<el-form-item>")
  expect_match(render_html(el$menu_item_group()), "^<el-menu-item-group>")
})

test_that("el: attributes and children pass through", {
  html <- render_html(el$button("Submit", type = "primary"))
  expect_match(html, 'type="primary"')
  expect_match(html, ">Submit<")
})

test_that("el: tags nest", {
  html <- render_html(el$table(
    el$table_column(prop = "name", label = "Name"),
    el$table_column(prop = "age", label = "Age")
  ))
  expect_match(html, "^<el-table>")
  expect_equal(
    lengths(regmatches(html, gregexpr("<el-table-column", html, fixed = TRUE)))[[1]],
    2L
  )
})

test_that("el$icon: is a special case emitting an i with the icon class", {
  # Element UI icons are a class on <i>, not an <el-icon> tag.
  html <- render_html(el$icon("star"))
  expect_match(html, '<i class="el-icon" data-el-icon="Star"', fixed = TRUE)
  expect_false(grepl("<el-icon", html, fixed = TRUE))
})

test_that("el$icon: extra attributes are kept", {
  expect_match(render_html(el$icon("star", style = "color:red")), "color:red")
})

test_that("el: covers each documented Element UI category", {
  for (nm in c("button", "link",                       # basic
               "container", "header", "row", "col",     # layout
               "form", "input", "select", "option",     # form
               "table", "tag", "pagination",            # data
               "menu", "tabs", "steps", "step",         # navigation
               "dialog", "alert", "tooltip")) {         # feedback
    expect_true(nm %in% names(el), info = sprintf("el$%s exists", nm))
  }
})

test_that("el: generators carry a descriptive comment attribute", {
  expect_match(attr(el$button, "comment"), "<el-button>", fixed = TRUE)
})

test_that("el: generators produce plain tags with no dependencies", {
  # Nothing here mounts Vue, so these must be composed inside something that
  # does -- otherwise the custom tag is never compiled.
  expect_null(htmltools::htmlDependencies(el$button("x")))
  expect_true(inherits(el$button("x"), "shiny.tag"))
})

test_that("el holds every component Element Plus registers, and nothing it does not", {
  # Element Plus 2.14.7's packages/element-plus/component.ts, the components
  # install() registers
  registered <- gsub("-", "_", c(
    "affix", "alert", "anchor", "anchor-link", "aside", "autocomplete",
    "auto-resizer", "avatar", "avatar-group", "backtop", "badge", "breadcrumb",
    "breadcrumb-item", "button", "button-group", "calendar", "card", "carousel",
    "carousel-item", "cascader", "cascader-panel", "checkbox", "checkbox-button",
    "checkbox-group", "check-tag", "col", "collapse", "collapse-item",
    "collapse-transition", "color-picker", "color-picker-panel", "config-provider",
    "container", "countdown", "date-picker", "date-picker-panel", "descriptions",
    "descriptions-item", "dialog", "divider", "drawer", "dropdown", "dropdown-item",
    "dropdown-menu", "empty", "footer", "form", "form-item", "header", "icon",
    "image", "image-viewer", "input", "input-number", "input-otp", "input-tag",
    "link", "main", "mention", "menu", "menu-item", "menu-item-group", "option",
    "option-group", "page-header", "pagination", "popconfirm", "popover",
    "progress", "radio", "radio-button", "radio-group", "rate", "result", "row",
    "scrollbar", "segmented", "select", "select-v2", "skeleton", "skeleton-item",
    "slider", "space", "splitter", "splitter-panel", "statistic", "step", "steps",
    "sub-menu", "switch", "table", "table-column", "table-v2", "tab-pane", "tabs",
    "tag", "text", "timeline", "timeline-item", "time-picker", "time-select",
    "tooltip", "tour", "tour-step", "transfer", "tree", "tree-select", "tree-v2",
    "upload", "watermark"))
  expect_setequal(names(el), registered)
})
