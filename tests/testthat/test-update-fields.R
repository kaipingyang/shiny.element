# Every update_*() message field has to name a field that really exists in the
# component's Vue data.
#
# The shared updater in el-update.js assigns by key, so a mismatch is refused
# and warned about rather than silently doing nothing -- but it is better to
# catch it here. Two mismatches were shipped before this check existed:
# update_el_table() sent `data` while the Vue field is `tableData`, and nine
# fields across six components were only added to the Vue data when the user
# passed them at construction time, leaving the corresponding update argument
# inert for everyone else.

vue_data_keys <- function(tag) {
  html <- paste(as.character(htmltools::renderTags(tag)$html), collapse = "")
  m <- regmatches(
    html,
    regexpr('application/json"[^>]*>.*?</script>', html, perl = TRUE)
  )
  if (!length(m)) {
    return(character(0))
  }
  json <- sub("</script>$", "", sub('^application/json"[^>]*>', "", m))
  names(jsonlite::fromJSON(json, simplifyVector = FALSE)$options$data)
}

capture_update <- function(fn, args) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- msg
  )
  do.call(fn, c(list(session = session, id = "x"), args))
  setdiff(names(captured), "id")
}

# Each entry: the update function, a UI call, and the arguments to fill in.
# NULL args means "pass 1 for every optional argument".
#
# el_collapse, el_tabs, el_dialog and el_drawer are absent on purpose: they are
# rendered as markup driven by Shiny input bindings, not Vue instances, so they
# have no Vue data to check against. Their update functions send input messages
# and are covered in their own test files.
cases <- list(
  list("update_el_input", quote(el_input("x"))),
  list("update_el_select", quote(el_select("x", choices = c(A = "a")))),
  list("update_el_switch", quote(el_switch("x"))),
  list("update_el_slider", quote(el_slider("x"))),
  list("update_el_rate", quote(el_rate("x"))),
  list(
    "update_el_radio_group",
    quote(el_radio_group("x", choices = c(A = "a")))
  ),
  list(
    "update_el_checkbox_group",
    quote(el_checkbox_group("x", choices = c(A = "a")))
  ),
  list("update_el_input_number", quote(el_input_number("x"))),
  list("update_el_date_picker", quote(el_date_picker("x"))),
  list("update_el_color_picker", quote(el_color_picker("x"))),
  list("update_el_cascader", quote(el_cascader("x"))),
  list("update_el_pagination", quote(el_pagination("x", total = 10))),
  list(
    "update_el_steps",
    quote(el_steps("x", steps = list(list(title = "S"))))
  ),
  list("update_el_calendar", quote(el_calendar("x"))),
  list("update_el_alert", quote(el_alert("x"))),
  list("update_el_button", quote(el_button("x"))),
  list("update_el_tag", quote(el_tag("x"))),
  list("update_el_progress", quote(el_progress("x"))),
  list("update_el_checkbox", quote(el_checkbox("x", "Agree"))),
  list("update_el_link", quote(el_link("More", id = "x"))),
  list("update_el_badge", quote(el_badge(value = 1, id = "x"))),
  list(
    "update_el_dropdown",
    quote(el_dropdown("x", items = list(list(command = "c", label = "L"))))
  ),
  list(
    "update_el_table",
    quote(el_table(id = "x", data = head(iris, 2))),
    list(data = head(iris, 3), border = FALSE, selection = TRUE)
  )
)

for (case in cases) {
  local({
    fn_name <- case[[1]]
    ui_call <- case[[2]]
    args <- if (length(case) > 2) case[[3]] else NULL

    test_that(paste(fn_name, "only sends fields the component declares"), {
      fn <- get(fn_name, envir = asNamespace("shiny.element"))
      keys <- vue_data_keys(eval(ui_call))
      expect_gt(length(keys), 0)

      if (is.null(args)) {
        args <- stats::setNames(
          as.list(rep(
            1,
            length(setdiff(names(formals(fn)), c("session", "id", "...")))
          )),
          setdiff(names(formals(fn)), c("session", "id", "..."))
        )
      }
      sent <- capture_update(fn, args)
      expect_gt(length(sent), 0)
      # .label and .error are the bridge's own keys, drawn around the
      # component rather than assigned to it
      expect_equal(
        setdiff(sent[!startsWith(sent, ".")], keys),
        character(0),
        info = paste(fn_name, "sends fields absent from the Vue data")
      )
    })
  })
}

test_that("fields that can be updated are declared even when not supplied", {
  # These were conditional: absent from the Vue data unless the user passed
  # them at construction, which made their update argument a no-op.
  expect_true(all(c("size", "placeholder") %in% vue_data_keys(el_input("x"))))
  expect_true(
    "placeholder" %in% vue_data_keys(el_select("x", choices = c(A = "a")))
  )
  expect_true("placeholder" %in% vue_data_keys(el_date_picker("x")))
  expect_true(all(
    c("min", "max") %in%
      vue_data_keys(el_checkbox_group("x", choices = c(A = "a")))
  ))
  expect_true(all(c("status", "color") %in% vue_data_keys(el_progress("x"))))
  expect_true("description" %in% vue_data_keys(el_alert("x")))
  expect_true("range" %in% vue_data_keys(el_calendar("x")))
})

test_that("an unsupplied field serialises as JSON null, which Element treats as unset", {
  html <- paste(as.character(el_input("x")), collapse = "")
  expect_match(html, '"placeholder":null', fixed = TRUE)
  expect_match(html, '"size":null', fixed = TRUE)
})

# ── widget mount points take up no room before JS runs ────────────────────────

test_that("the component is its host: id, no box of its own, no placeholder", {
  # The vueR htmlwidget rendered a 960x500 box until its script ran -- the
  # showcase page was 3215px tall against 1462px once mounted -- and the id sat
  # on that box rather than on the component, out of reach of shinyjs and
  # removeUI(). The host now carries the id and generates no box.
  for (tag in list(
    el_input("x"),
    el_select("x", choices = c(A = "a")),
    el_button("x"),
    el_table(id = "x", data = head(iris, 2)),
    el_form(id = "x")
  )) {
    html <- paste(as.character(htmltools::renderTags(tag)$html), collapse = "")
    expect_match(
      html,
      '<div id="x" data-shiny-vue style="display: contents">',
      fixed = TRUE
    )
    expect_false(grepl("html-widget", html, fixed = TRUE))
  }
})

# ── optional props fall back to Element's own defaults ────────────────────────

test_that(".el_optional_bind: maps null back to undefined", {
  # Vue treats null as a value and only falls back to a prop's default for
  # undefined. R cannot send undefined through JSON, so the template has to
  # map it. A conditional rather than ?? because the expression is evaluated
  # at runtime, where a polyfill cannot help with syntax.
  expect_equal(
    .el_optional_bind("placeholder"),
    "placeholder === null ? undefined : placeholder"
  )
})

test_that("optional props are bound through the fallback expression", {
  cases <- list(
    list(el_input("x"), c("size", "placeholder")),
    list(el_select("x", choices = c(A = "a")), "placeholder"),
    list(el_date_picker("x"), "placeholder"),
    list(el_checkbox_group("x", choices = c(A = "a")), c("min", "max")),
    list(el_progress("x"), "status"),
    list(el_alert("x"), "description")
  )
  for (case in cases) {
    html <- paste(as.character(case[[1]]), collapse = "")
    for (field in case[[2]]) {
      expect_match(
        html,
        sprintf(':%s="%s"', field, .el_optional_bind(field)),
        fixed = TRUE,
        info = field
      )
    }
  }
})

test_that("el_progress colour keeps its empty-string default, not the expression", {
  # ElProgress calls .length on color, so it must never see undefined either.
  html <- paste(as.character(el_progress("x")), collapse = "")
  expect_match(html, '"color":""', fixed = TRUE)
  expect_false(grepl("color === null", html, fixed = TRUE))
})

test_that("label and error travel as the bridge's own keys", {
  msg <- .el_form_item_update(list(id = "x"), label = "Name", error = "Taken")
  expect_equal(msg[[".label"]], "Name")
  expect_equal(msg[[".error"]], "Taken")
  expect_named(.el_form_item_update(list(id = "x")), "id")
})

test_that("new choices end a remote search's loading state", {
  sent <- capture_update(update_el_select, list(choices = c("a", "b")))
  expect_true("loading" %in% sent)
})

# Every update_el_*() of a component with a Vue instance, not just the list
# above: a field it sends must be one the component declares, or the update
# is refused in the browser. update_el_tooltip() and update_el_popover() sent
# unprefixed names for months, unnoticed because they were not listed.
test_that("every updater of a Vue component sends only declared fields", {
  ns <- asNamespace("shiny.element")
  # Markup components update through their bindings, not Vue data
  markup <- c(
    "update_el_tabs",
    "update_el_collapse",
    "update_el_dialog",
    "update_el_drawer"
  )
  build <- list(
    update_el_cascader_panel = quote(el_cascader_panel("x")),
    update_el_time_select = quote(el_time_select("x")),
    update_el_breadcrumb = quote(el_breadcrumb(
      "x",
      items = list(list(label = "a"))
    )),
    update_el_descriptions = quote(el_descriptions("x", items = c(a = "1"))),
    update_el_menu = quote(el_menu(
      "x",
      items = list(list(index = "a", label = "A"))
    )),
    update_el_carousel = quote(el_carousel(
      "x",
      items = list(list(name = "a", content = "A"))
    )),
    update_el_timeline = quote(el_timeline(
      "x",
      items = list(list(content = "a"))
    )),
    update_el_tooltip = quote(el_tooltip(
      "x",
      htmltools::tags$span("t"),
      content = "c"
    )),
    update_el_popover = quote(el_popover(
      "x",
      reference = htmltools::tags$span("r")
    )),
    update_el_popconfirm = quote(el_popconfirm(
      "x",
      reference = htmltools::tags$span("r")
    )),
    update_el_infinite_scroll = quote(el_infinite_scroll("x", "a")),
    update_el_badge = quote(el_badge("a", value = 1, id = "x")),
    update_el_link = quote(el_link("a", id = "x")),
    update_el_tree = quote(el_tree(
      "x",
      data = list(list(id = 1, label = "a"))
    )),
    update_el_transfer = quote(el_transfer(
      "x",
      data = data.frame(key = 1, label = "a")
    )),
    update_el_form = quote(el_form(id = "x", el_form_field("a", "input"))),
    update_el_pagination = quote(el_pagination("x", total = 10)),
    update_el_radio_group = quote(el_radio_group("x", choices = "a")),
    update_el_checkbox_group = quote(el_checkbox_group("x", choices = "a")),
    update_el_select = quote(el_select("x", choices = "a")),
    update_el_table = quote(el_table(id = "x", data = head(iris, 2))),
    update_el_dropdown = quote(el_dropdown(
      "x",
      items = list(list(command = "c", label = "L"))
    )),
    update_el_steps = quote(el_steps("x", steps = list(list(title = "S")))),
    update_el_check_tag = quote(el_check_tag("x", "Tag")),
    update_el_tree_select = quote(el_tree_select("x")),
    update_el_tour = quote(el_tour("x", steps = list(list(title = "S")))),
    update_el_image_viewer = quote(el_image_viewer("x", url_list = "a.png")),
    update_el_countdown = quote(el_countdown("x"))
  )
  fns <- setdiff(
    grep("^update_el_", getNamespaceExports("shiny.element"), value = TRUE),
    markup
  )
  for (fn in fns) {
    ui <- build[[fn]]
    if (is.null(ui)) {
      maker <- sub("^update_", "", fn)
      if (!exists(maker, envir = ns)) {
        next
      }
      ui <- call(maker, "x")
    }
    built <- tryCatch(eval(ui, envir = ns), error = function(e) NULL)
    expect_false(is.null(built), info = fn)
    if (is.null(built)) {
      next
    }
    keys <- vue_data_keys(built)
    f <- get(fn, envir = ns)
    args <- setdiff(names(formals(f)), c("session", "id", "..."))
    # One argument at a time, each given a value of a plausible type
    for (a in args) {
      val <- switch(
        a,
        items = list(list(label = "a")),
        fields = list(el_form_field("a", "input")),
        model = list(a = 1),
        errors = list(a = "x"),
        rules = list(a = list()),
        data = data.frame(key = 1, label = "a"),
        columns = list(list(prop = "a", label = "A")),
        steps = list(list(title = "S")),
        1
      )
      sent <- capture_update(f, stats::setNames(list(val), a))
      sent <- sent[!startsWith(sent, ".")]
      expect_equal(setdiff(sent, keys), character(0), info = paste(fn, a))
    }
  }
})

# An update takes, under the same names, every argument of the UI function
# that can change once the component is drawn -- not only a chosen few.
test_that("an update takes every argument of its UI function that can change", {
  fixed <- c("id", "session", "slots", "width")
  cases <- list(
    list("update_el_table", "el_table", "rownames"),
    list("update_el_table_v2", "el_table_v2", c("methods", "auto_resize")),
    list(
      "update_el_calendar",
      "el_calendar",
      c(
        "label_position",
        "label_width",
        "label_suffix",
        "required",
        "show_message",
        "inline_message"
      )
    )
  )
  for (case in cases) {
    ui <- setdiff(names(formals(get(case[[2]]))), c(fixed, case[[3]]))
    # Element reads these only when the component is created
    ui <- ui[!startsWith(ui, "default_")]
    expect_equal(
      setdiff(ui, names(formals(get(case[[1]])))),
      character(),
      info = case[[1]]
    )
  }
})

test_that("an update leaves NULL as it is and sends NA as Element's default", {
  sent <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) sent <<- msg
  )
  update_el_table(session, "x", stripe = TRUE, table_layout = NA)
  expect_true(sent$stripe)
  expect_true(is.na(sent$tableLayout))
  expect_false("size" %in% names(sent))
  update_el_table_v2(session, "x", table_v2_width = 500)
  expect_equal(sent$width, 500)
  expect_error(
    update_el_calendar(session, "x", controller_type = "dial"),
    "should be one of"
  )
})
