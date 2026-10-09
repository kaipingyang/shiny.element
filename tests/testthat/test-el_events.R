# What a component reports: its registry entry, the `events` that ask for
# more, and `on`, handlers of the user's own.

render_html <- function(x) {
  paste(as.character(htmltools::renderTags(x)$html), collapse = "")
}

forwarded_events <- function(html) {
  sub(
    '^@',
    "",
    regmatches(html, gregexpr('@[a-z-]+(?==")', html, perl = TRUE))[[1]]
  )
}

test_that("every event in the registry is forwarded when asked for", {
  for (fn in names(.el_event_registry)) {
    every <- vapply(.el_event_registry[[fn]]$events, `[[`, "", "event")
    if (!length(every) || !"events" %in% names(formals(get(fn)))) {
      next
    }
    args <- switch(
      fn,
      el_table = list(data = data.frame(a = 1)),
      el_countdown = list("x", value = 1),
      el_tabs = list("x", tabs = list(list(name = "a", label = "A"))),
      el_pagination = list("x", total = 10),
      el_form = list(id = "x"),
      list("x")
    )
    html <- render_html(do.call(get(fn), c(args, list(events = every))))
    if (fn %in% c("el_dialog", "el_drawer", "el_tabs")) {
      # a container's binding reports what data-el-events lists
      listed <- regmatches(html, regexpr('data-el-events="[^"]*"', html))
      expect_setequal(
        strsplit(sub('data-el-events="([^"]*)"', "\\1", listed), " ")[[1]],
        gsub("-", "_", every)
      )
    } else {
      expect_true(
        all(every %in% forwarded_events(html)),
        info = paste(fn, toString(setdiff(every, forwarded_events(html))))
      )
    }
  }
})

test_that("unasked, a component forwards only its defaults", {
  html <- render_html(el_input("q"))
  expect_false(any(
    c("keydown", "focus", "blur", "mouseenter") %in% forwarded_events(html)
  ))
  html <- render_html(el_autocomplete("ac"))
  expect_true("select" %in% forwarded_events(html))
  expect_false("focus" %in% forwarded_events(html))
  dlg <- render_html(el_dialog("d", title = "t", content = "c"))
  expect_match(dlg, 'data-el-events="closed"', fixed = TRUE)
})

test_that("events takes snake_case or Element's names, and nothing else", {
  html <- render_html(el_input("q", events = c("keydown", "compositionend")))
  expect_true(all(c("keydown", "compositionend") %in% forwarded_events(html)))
  html <- render_html(el_tree("t", events = c("node_drop", "node-expand")))
  expect_true(all(c("node-drop", "node-expand") %in% forwarded_events(html)))
  expect_match(html, "'t', 'node_drop'", fixed = TRUE)

  expect_error(
    el_input("q", events = "keypress"),
    "'keypress' is not an event of el_input(). Its events: input, blur",
    fixed = TRUE
  )
  expect_error(el_input("q", events = c(go = "keydown")), "takes no names")
  expect_error(el_input("q", events = NA_character_), "must name events")
  expect_error(el_dialog("d", events = "shown"), "el_dialog()", fixed = TRUE)
})

test_that("el_events() lists every input, with how to ask for it", {
  x <- el_events("el_tree")
  expect_s3_class(x, "el_events")
  expect_true(all(c("input$<id>", "input$<id>_checked") %in% x$input))
  expect_true(all(x$default[is.na(x$event)]))
  drop <- x[x$event %in% "node_drop", ]
  expect_equal(drop$input, "input$<id>_node_drop")
  expect_false(drop$default)
  # the same from the function, or its short name
  expect_identical(el_events(el_tree)$input, x$input)
  expect_identical(el_events("tree")$input, x$input)
  # a component reporting nothing
  expect_equal(nrow(el_events("el_space")), 0L)
  expect_output(print(el_events("el_space")), "reports no input")
  expect_output(print(x), "events = c\\(")
  expect_error(el_events("el_nothing"), "not a component")
  expect_error(el_events(sum), "must be a component function")
})

test_that("each component's help page lists what el_events() does", {
  md <- .el_events_md("el_tree")
  expect_match(
    md,
    "| `input$<id>_node_drop` | `events = \"node_drop\"` |",
    fixed = TRUE
  )
  expect_match(md, "| `input$<id>_checked` | unasked |", fixed = TRUE)
  expect_match(.el_events_md("el_space"), "reports nothing")
})

test_that("on binds a handler of the user's own, reporting under the id", {
  ui <- el_input(
    "q",
    on = list("keyup.enter" = JS("function(report, e) { report('enter', 1); }"))
  )
  html <- render_html(ui)
  expect_match(html, '@keyup.enter="elOn1"', fixed = TRUE)
  p <- vue_payload_of(ui)
  expect_match(p$methods$elOn1, "shinyVue.emit('q', String(name)", fixed = TRUE)

  # in a module, the id it reports under is the namespaced one
  html <- render_html(el_button(
    shiny::NS("m")("b"),
    "B",
    on = list(dblclick = JS("function(report) { report('twice'); }"))
  ))
  expect_match(html, "shinyVue.emit('m-b'", fixed = TRUE)

  # an event the component reports too: both run
  html <- render_html(el_autocomplete(
    "ac",
    on = list(select = JS("function(report, item) { report('picked', 1); }"))
  ))
  expect_match(
    html,
    "@select=\"(...a) =&gt; { elEmitSelect(...a); elOn1(...a); }\"",
    fixed = TRUE
  )

  expect_error(el_input("q", on = list(JS("function() {}"))), "named list")
  expect_error(
    el_input("q", on = list(keyup = "x")),
    "takes JS() functions",
    fixed = TRUE
  )
})
