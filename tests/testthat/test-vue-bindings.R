# Every identifier a template binding references must be declared on the Vue
# instance. Vue only warns about an undeclared one at render time, in the
# browser, with the development build -- so a missing declaration otherwise
# shows up as a prop that silently does nothing.
#
# This catches the case where a binding is added without a matching field in
# `data`, which is also what makes update_el_*() unable to reach it.

# Components that will not render without an argument
binding_fixtures <- list(
  el_checkbox_group = list("cg", choices = c("A", "B")),
  el_radio_group = list("rg", choices = c("A", "B")),
  el_select = list("sel", choices = c("A", "B")),
  el_form_field = list(prop = "f", label = "F"),
  el_icon = list("edit"),
  el_pagination = list("pg", total = 100)
)

# Server-side helpers and dependency getters render no Vue instance
binding_skip <- paste0(
  "_dependency$|^el$|^el_page$|^el_rule$|^el_table_config$|",
  "^el_form_(validate|reset|clear)|^el_upload_clear$|^el_message$|^el_notification$"
)

quoted_values <- function(html, pattern) {
  m <- regmatches(html, gregexpr(pattern, html, perl = TRUE))[[1]]
  sub('^[^"]*"', "", sub('"$', "", m))
}

undeclared_refs <- function(ui) {
  payload <- vue_payload_of(ui)
  declared <- c(
    names(payload$data),
    names(payload$methods),
    names(payload$computed)
  )
  html <- paste(as.character(ui), collapse = "")

  exprs <- c(
    quoted_values(html, ':[a-z-]+="[^"]*"'),
    quoted_values(html, '@[a-z-]+="[^"]*"')
  )
  # A string literal inside an expression names nothing: 'is-selected' in
  # :class="data.isSelected ? 'is-selected' : ''" is a class name, not a field.
  bare <- gsub("'[^']*'", "", exprs)
  refs <- unique(unlist(lapply(bare, function(e) {
    regmatches(e, gregexpr("[A-Za-z_$][A-Za-z0-9_$]*", e))[[1]]
  })))

  # v-for aliases, and the fields read off them (item.timestamp)
  locals <- unique(unlist(lapply(
    quoted_values(html, 'v-for="[^"]*"'),
    function(v) {
      regmatches(v, gregexpr("[A-Za-z_$][A-Za-z0-9_$]*", v))[[1]]
    }
  )))
  # slot-scope destructures its own names
  scoped <- unique(unlist(lapply(
    c(
      quoted_values(html, 'slot-scope="[^"]*"'),
      quoted_values(html, 'v-slot[^=]*="[^"]*"')
    ),
    function(v) {
      regmatches(v, gregexpr("[A-Za-z_$][A-Za-z0-9_$]*", v))[[1]]
    }
  )))
  members <- unique(unlist(lapply(bare, function(e) {
    regmatches(
      e,
      gregexpr("(?<=\\.)[A-Za-z_$][A-Za-z0-9_$]*", e, perl = TRUE)
    )[[1]]
  })))

  literals <- c(
    "null",
    "undefined",
    "true",
    "false",
    "Shiny",
    "Math",
    "JSON",
    "this",
    "self",
    "window",
    "document",
    # Vue's own template variables
    "$event",
    "$refs",
    "$emit",
    # the bridge's own global properties (shiny-vue.js, el-events.js)
    "$elRef",
    "$elDate",
    "$setInput",
    "$ELEMENT"
  )
  setdiff(refs, c(declared, locals, scoped, members, literals))
}

test_that("every template binding references a declared field", {
  exports <- getNamespaceExports("shiny.element")
  fns <- setdiff(
    grep("^el_", exports, value = TRUE),
    grep(binding_skip, exports, value = TRUE)
  )

  offenders <- list()
  for (f in sort(fns)) {
    args <- if (!is.null(binding_fixtures[[f]])) {
      binding_fixtures[[f]]
    } else {
      list()
    }
    ui <- tryCatch(do.call(f, args), error = function(e) NULL)
    if (is.null(ui)) {
      next
    }
    missing <- tryCatch(undeclared_refs(ui), error = function(e) character(0))
    if (length(missing)) offenders[[f]] <- missing
  }

  # Reported as "component: field, field" so a failure names the culprit
  report <- if (length(offenders)) {
    paste0(
      names(offenders),
      ": ",
      vapply(offenders, paste, character(1), collapse = ", ")
    )
  } else {
    character(0)
  }
  expect_equal(report, character(0))
})

# ── the shared widget constructor ─────────────────────────────────────────────

test_that("the package's own components go through el_widget()", {
  # el_widget() builds the host, the binding and the bridge's JSON. A
  # component here that made its own `new Vue()` -- or went back to an
  # htmlwidget -- would be invisible to Shiny again.
  sources <- list.files("../../R", pattern = "^el_.*[.]R$", full.names = TRUE)
  sources <- setdiff(sources, grep("el_widget[.]R$", sources, value = TRUE))

  offenders <- vapply(
    sources,
    function(path) {
      code <- readLines(path, warn = FALSE)
      code <- code[!grepl("^\\s*#", code)]
      any(grepl("vueR::|htmlwidgets::createWidget|new Vue\\(", code))
    },
    logical(1)
  )

  expect_equal(basename(sources[offenders]), character(0))
})

test_that("el_widget() lets a user wrap a component the package does not cover", {
  # el-avatar has no wrapper here. Building one should need nothing but
  # exported functions -- and should not need the user to know about
  # display:contents or the widget's size.
  avatar <- el_widget(
    id = "face",
    markup = el$avatar(":src" = "src", ":size" = "size"),
    data = list(src = "a.png", size = 50),
    dependency = element_plus_dependency()
  )
  html <- paste(as.character(htmltools::renderTags(avatar)$html), collapse = "")

  expect_match(html, "<el-avatar")
  # The host is the component: it carries the id and generates no box
  expect_match(
    html,
    '<div id="face" data-shiny-vue style="display: contents">',
    fixed = TRUE
  )
  expect_false(grepl("html-widget", html, fixed = TRUE))
  expect_equal(names(vue_data_of(avatar)), c("src", "size"))
})

test_that("a user's component can report to Shiny the same way", {
  w <- el_widget(
    id = "score",
    markup = el$rate("v-model" = "value", "@change" = "onChange"),
    data = list(value = 3),
    methods = list(
      onChange = JS(
        "function(v) { Shiny.setInputValue('score', v); }"
      )
    ),
    dependency = element_plus_dependency()
  )
  expect_equal(names(vue_payload_of(w)$methods), "onChange")
  expect_true(
    "onChange" %in%
      unlist(vue_payload_of(w)$evals) ||
      grepl("setInputValue", vue_payload_of(w)$methods$onChange)
  )
})

test_that("the widget element takes up no space", {
  # The widget element is only a carrier for the payload -- the Vue instance
  # renders into the host div beside it, which is display:contents. Left to
  # htmlwidgets' sizing policy it would be 960x500 of empty space, which is
  # exactly the layout jump el_widget() exists to prevent. A component's own
  # size comes from Element's props (el_table's height, el_slider's height),
  # which have nothing to do with this.
  exports <- getNamespaceExports("shiny.element")
  fns <- setdiff(
    grep("^el_", exports, value = TRUE),
    grep(binding_skip, exports, value = TRUE)
  )

  sized <- character(0)
  for (f in sort(fns)) {
    args <- if (!is.null(binding_fixtures[[f]])) {
      binding_fixtures[[f]]
    } else {
      list()
    }
    ui <- tryCatch(do.call(f, args), error = function(e) NULL)
    if (is.null(ui)) {
      next
    }
    html <- paste(as.character(ui), collapse = "")
    if (!grepl("html-widget", html, fixed = TRUE)) {
      next
    }
    if (!grepl("width:0px;height:0px", html, fixed = TRUE)) sized <- c(sized, f)
  }
  expect_equal(sized, character(0))
})

# ── width ─────────────────────────────────────────────────────────────────────

test_that("width lands on the Element markup, not on the host", {
  # The host is display:contents and generates no box, so a width set there
  # would be ignored by the browser -- measured at 953px either way.
  html <- paste(as.character(el_input("i", width = 200)), collapse = "")
  expect_match(html, '<el-input[^>]*style="width: 200px"')
  expect_no_match(html, 'id="i_container" style="display: contents; width')
})

test_that("width replaces a width the component already declares", {
  # el_table's markup carries width: 100%. htmltools joins repeated attributes
  # with a space, so appending a second style would produce
  # style="width: 100% width: 300px" and neither would apply.
  html <- paste(
    as.character(el_table("t", data = head(iris, 2), width = "300px")),
    collapse = ""
  )
  expect_match(html, 'style="width: 300px"')
  expect_no_match(html, "width: 100% width")

  # and without it, the default stands
  expect_match(
    paste(as.character(el_table("t", data = head(iris, 2))), collapse = ""),
    'style="width: 100%"'
  )
})

test_that("width accepts what a Shiny input accepts", {
  expect_match(
    paste(
      as.character(el_select("s", choices = "A", width = "50%")),
      collapse = ""
    ),
    "width: 50%"
  )
  # a bare number means pixels, as in shiny::textInput()
  expect_match(
    paste(
      as.character(el_select("s", choices = "A", width = 150)),
      collapse = ""
    ),
    "width: 150px"
  )
})

# ── absorbing components into a wrapper ───────────────────────────────────────

test_that("a wrapper absorbs a component rather than nesting it", {
  ui <- el_tooltip("tip", el_button("btn", "Save"), content = "hint")
  # One instance, carrying both components' markup and both their fields
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  expect_equal(length(gregexpr("html-widget", html)[[1]]), 1L)
  expect_match(html, "<el-tooltip[^>]*>\\s*<el-button")

  data <- vue_data_of(ui)
  expect_true("tipContent" %in% names(data)) # the wrapper's, prefixed
  expect_true("label" %in% names(data)) # the button's, as they were
})

test_that("a second absorbed component has its fields renamed", {
  # el_button and el_tag both declare label, type, size, disabled and
  # handleClick
  ui <- el_popover("pop", el_button("b", "Open"), body = el_tag("t", "inside"))
  payload <- vue_payload_of(ui)

  expect_true("label" %in% names(payload$data))
  expect_true(any(grepl("^el3_", names(payload$data))))
  expect_true(any(grepl("^el3_", names(payload$methods))))

  # and the markup refers to the renamed fields, not the originals
  html <- paste(as.character(ui), collapse = "")
  expect_match(html, '<el-tag[^>]*:type="el3_type"')
})

test_that("renaming leaves string literals alone", {
  # :class="data.isSelected ? 'is-selected' : ''" names a CSS class
  expr <- ":class=\"data.isSelected ? 'is-selected' : ''\""
  out <- .el_rewrite_expr(expr, c(isSelected = "x_isSelected"))
  expect_match(out, "'is-selected'", fixed = TRUE)
  # a member access is not a field of the instance either
  expect_match(out, "data.isSelected", fixed = TRUE)
})

# ── slots ─────────────────────────────────────────────────────────────────────

test_that("slots fill the component's named slots", {
  ui <- el_alert(
    "a",
    title = "Plain",
    slots = list(title = shiny::tags$b("Bold"))
  )
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  expect_match(html, '<template v-slot:title>')
  expect_match(html, "<b>Bold</b>", fixed = TRUE)
})

test_that("a component used as slot content is absorbed", {
  ui <- el_alert("a", slots = list(title = el_tag("t", "Live")))
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  # One instance, carrying the tag's fields as well as the alert's
  expect_equal(length(gregexpr("html-widget", html)[[1]]), 1L)
  expect_match(html, "<el-tag")
  # The tag's fields join the alert's; those both declare -- type,
  # closable, effect -- are the tag's under a prefix, not the alert's
  # overwritten, which is what happened before
  d <- vue_data_of(ui)
  expect_true(any(grepl("label$", names(d))))
  expect_equal(sum(names(d) == "type"), 1L)
  expect_true(any(grepl("^el[0-9]+_type$", names(d))))
  expect_match(html, ':type="el[0-9]+_type')
})

test_that("a scoped slot is passed through as written", {
  # Element hands the template its own data, so the caller writes the
  # template and it is used as it stands
  ui <- el_calendar(
    "c",
    slots = list(
      dateCell = template(
        htmltools::HTML("<p>{{data.day}}</p>"),
        slot = "dateCell",
        scope = "{date, data}"
      )
    )
  )
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  expect_match(html, 'v-slot:date-cell="{date, data}"', fixed = TRUE)
  expect_match(html, "{{data.day}}", fixed = TRUE)
})

test_that("el_calendar's day cell is a default, not a fixture", {
  # It used to be hard-coded, so a user could not change how a day rendered
  plain <- paste(
    as.character(htmltools::renderTags(el_calendar("c"))$html),
    collapse = ""
  )
  expect_match(plain, "isSelected", fixed = TRUE)

  custom <- paste(
    as.character(
      htmltools::renderTags(el_calendar(
        "c",
        slots = list(
          dateCell = template(
            htmltools::HTML("<p>x</p>"),
            slot = "dateCell",
            scope = "{date, data}"
          )
        )
      ))$html
    ),
    collapse = ""
  )
  expect_no_match(custom, "isSelected", fixed = TRUE)
})

test_that("a column may render its own header", {
  ui <- el_table(
    "t",
    data = head(iris, 2),
    columns = list(
      list(prop = "Sepal_Length", label = "SL", header_html = "<b>S.L.</b>")
    )
  )
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  expect_match(html, 'v-slot:header="scope"', fixed = TRUE)
  expect_match(html, "headerHtml", fixed = TRUE)
})

# ── cell templates, column types, row actions ────────────────────────────────

test_that("a column's cell template is lifted out of the column data", {
  ui <- el_table(
    "t",
    data = data.frame(s = c("a", "b")),
    columns = list(
      list(type = "index", label = "#"),
      list(prop = "s", label = "S", cell = el$tag("{{ scope.row.s }}")),
      list(
        label = "Do",
        cell = el$button("@click" = "rowAction('go', scope)", "Go")
      )
    )
  )
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  cols <- vue_data_of(ui)$columns

  # The markup holds the templates, one branch each; the JSON does not
  expect_false(any(vapply(cols, function(c) "cell" %in% names(c), logical(1))))
  expect_match(html, 'v-slot:default="scope"', fixed = TRUE)
  expect_match(
    html,
    "v-(else-)?if=\"col.cellKey === &#39;cell_s&#39;\"|v-(else-)?if=\"col.cellKey === 'cell_s'\"",
    perl = TRUE
  )
  expect_match(html, "v-else-if=", fixed = TRUE)
  expect_match(html, "<el-tag>{{ scope.row.s }}</el-tag>", fixed = TRUE)

  # A column without a template gets only comments from its default slot, so
  # Element Plus renders the cell itself
  expect_equal(vapply(cols, `[[`, "", "slot"), c("none", "default", "default"))
  expect_equal(cols[[3]]$cellKey, "cell_Do")
  expect_equal(cols[[1]]$type, "index")
  expect_true(binds_attr(ui, "type"))
})

test_that("a table without cell templates renders no cell branch at all", {
  html <- paste(
    as.character(el_table("t", data = head(iris, 2))),
    collapse = ""
  )
  expect_false(grepl("cellKey", html, fixed = TRUE))
})

test_that("rowAction reports the row number and row as an event input", {
  p <- vue_payload_of(el_table("t", data = head(iris, 2)))
  expect_match(
    p$methods$rowAction,
    "Shiny.setInputValue('t_' + name",
    fixed = TRUE
  )
  expect_match(p$methods$rowAction, "row_index", fixed = TRUE)
  expect_match(p$methods$rowAction, "priority: 'event'", fixed = TRUE)
})

test_that("loading drives Element's v-loading, and the update reaches it", {
  ui <- el_table("t", data = head(iris, 2), loading = TRUE)
  expect_match(
    paste(as.character(ui), collapse = ""),
    'v-loading="loading"',
    fixed = TRUE
  )
  expect_true(vue_data_of(ui)$loading)
  s <- mock_session()
  update_el_table(s, "t", loading = FALSE)
  expect_equal(s$captured()$msg, list(id = "t", loading = FALSE))
})

test_that("update_el_table keeps a template's key for the same column", {
  s <- mock_session()
  update_el_table(
    s,
    "t",
    data = data.frame(s = "x"),
    columns = list(list(prop = "s", label = "S", cell = el$tag("x")))
  )
  cols <- s$captured()$msg$columns
  expect_equal(cols[[1]]$cellKey, "cell_s")
  expect_null(cols[[1]][["cell"]])
})

# ── el_widget(report =) ───────────────────────────────────────────────────────

test_that("el_widget reports the named fields on load and on every change", {
  # Its own id: the binding's value
  ui <- el_widget(
    "score",
    markup = el$rate("v-model" = "value"),
    data = list(value = 3),
    report = c(value = "score")
  )
  expect_equal(vue_spec_of(ui)$input, "value")
  # Any other id: reported on load and on every change by the instance
  p <- vue_payload_of(el_widget(
    "score",
    markup = el$rate("v-model" = "value"),
    data = list(value = 3, max = 5),
    report = c(value = "score", max = "score_max")
  ))
  expect_match(
    p$mounted,
    'Shiny.setInputValue("score_max", self.max)',
    fixed = TRUE
  )
  expect_match(p$watch$max, 'Shiny.setInputValue("score_max", v)', fixed = TRUE)
  expect_match(p$watch$max, "deep: true", fixed = TRUE)
})

test_that("el_widget keeps a mounted hook of its own alongside report", {
  ui <- el_widget(
    "s",
    markup = el$rate("v-model" = "value"),
    data = list(value = 3, n = 1),
    report = c(value = "s", n = "s_n"),
    mounted = JS("function() { this.ready = true; }")
  )
  p <- vue_payload_of(ui)
  expect_match(p$mounted, "this.ready = true", fixed = TRUE)
  expect_match(p$mounted, 'Shiny.setInputValue("s_n", self.n)', fixed = TRUE)
  expect_equal(vue_spec_of(ui)$input, "value")
})

test_that("report must name fields the component declares", {
  expect_error(
    el_widget(
      "s",
      markup = el$rate(),
      data = list(value = 3),
      report = c(nope = "s")
    ),
    "must name fields"
  )
  expect_error(
    el_widget("s", markup = el$rate(), data = list(value = 3), report = "s"),
    "must name fields"
  )
})

# ── wrappers: their own value through the binding ────────────────────────────

test_that("a carousel's own value goes through the binding, absorbed ones as before", {
  ui <- el_carousel(
    "car",
    items = list(
      list(name = "a", content = el_switch("inner", value = TRUE)),
      list(name = "b", content = "two")
    )
  )
  spec <- vue_spec_of(ui)
  expect_equal(spec$input, "active")
  # the slide name and the absorbed switch still report under their own ids
  expect_match(
    spec$options$mounted,
    'Shiny.setInputValue("car_name"',
    fixed = TRUE
  )
  expect_match(
    spec$options$mounted,
    'Shiny.setInputValue("inner"',
    fixed = TRUE
  )
})

test_that("a renamed absorbed component reports its renamed field", {
  # Two switches in one popover clash on every field; the later is renamed
  # with a prefix, and its report must follow
  ui <- el_popover(
    "pop",
    reference = el_switch("s1", value = TRUE),
    body = el_switch("s2", value = FALSE)
  )
  m <- vue_payload_of(ui)$mounted
  expect_match(m, 'Shiny.setInputValue("s1", self.value)', fixed = TRUE)
  expect_match(m, 'setInputValue[(]"s2", self[.]el[0-9]+_value[)]')
})
