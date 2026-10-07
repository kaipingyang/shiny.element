render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

# Capture the custom message a server-side function sends. Named to avoid
# shadowing testthat::capture_message(), which catches conditions instead.
sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) {
      captured <<- list(type = type, msg = msg)
    }
  )
  expr(session)
  captured
}

# ── 基础结构 ──────────────────────────────────────────────────────────────────

test_that("el_calendar: returns a tagList with the container id", {
  cal <- el_calendar(id = "c1")
  expect_true(inherits(cal, "shiny.tag.list"))
  expect_match(render_html(cal), 'id="c1_container"')
})

test_that("el_calendar: binds value, and Element Plus's controller type", {
  html <- render_html(el_calendar(id = "c1", controller_type = "select"))
  # Element Plus wants a Date; the value stays a "YYYY-MM-DD" string
  expect_match(html, ':model-value="elDate(value)"', fixed = TRUE)
  expect_match(html, '@update:model-value="elPick"', fixed = TRUE)
  expect_match(html, ':controller-type="controllerType', fixed = TRUE)
  expect_match(html, '"controllerType":"select"', fixed = TRUE)
})

test_that("el_calendar: attaches the shared bridge", {
  deps <- htmltools::findDependencies(el_calendar(id = "c1"))
  expect_true("shiny-vue" %in% vapply(deps, function(d) d$name, character(1)))
})

# ── value ─────────────────────────────────────────────────────────────────────

test_that("el_calendar: defaults to today", {
  html <- render_html(el_calendar(id = "c1"))
  expect_match(html, sprintf('"value":"%s"', format(Sys.Date(), "%Y-%m-%d")))
})

test_that("el_calendar: a Date is formatted, a string passes through", {
  expect_match(
    render_html(el_calendar(id = "c1", value = as.Date("2026-03-01"))),
    '"value":"2026-03-01"'
  )
  expect_match(
    render_html(el_calendar(id = "c1", value = "2026-03-01")),
    '"value":"2026-03-01"'
  )
})


# ── range ─────────────────────────────────────────────────────────────────────

test_that("el_calendar: range is always bound, null when not supplied", {
  # Declared and bound even when not supplied: a field missing from the Vue
  # data is not reactive, so the matching update_*() argument would be a
  # silent no-op. NA serialises to JSON null, which Element treats as unset.
  expect_match(
    render_html(el_calendar(id = "c1")),
    ':range="range === null ? undefined : range.map(elDate)"',
    fixed = TRUE
  )
  expect_match(
    render_html(el_calendar(id = "c1")),
    '"range":null',
    fixed = TRUE
  )

  html <- render_html(el_calendar(
    id = "c1",
    range = c("2026-03-01", "2026-03-31")
  ))
  expect_match(
    html,
    ':range="range === null ? undefined : range.map(elDate)"',
    fixed = TRUE
  )
  expect_match(html, '"range":\\["2026-03-01","2026-03-31"\\]')
})

test_that("el_calendar: Date ranges are coerced to strings", {
  html <- render_html(el_calendar(
    id = "c1",
    range = as.Date(c("2026-03-01", "2026-03-31"))
  ))
  expect_match(html, '"range":\\["2026-03-01","2026-03-31"\\]')
})

# ── reporting to Shiny ────────────────────────────────────────────────────────

test_that("el_calendar: reports its value on mount as well as on change", {
  # watch alone never fires on mount, so input$c1 would stay NULL until the
  # user picked a date. The value is the binding's: read on load, watched after.
  expect_equal(vue_spec_of(el_calendar(id = "c1"))$input, "value")
})

# ── update_el_calendar ────────────────────────────────────────────────────────

test_that("update_el_calendar: sends under the right message type", {
  out <- sent_message(function(s) {
    update_el_calendar(s, "c1", value = "2026-05-05")
  })
  expect_equal(out$type, "shinyVueUpdate")
  expect_equal(out$msg$id, "c1")
  expect_equal(out$msg$value, "2026-05-05")
})

test_that("update_el_calendar: formats Dates the same way the UI does", {
  out <- sent_message(function(s) {
    update_el_calendar(s, "c1", value = as.Date("2026-05-05"))
  })
  expect_equal(out$msg$value, "2026-05-05")
})

test_that("update_el_calendar: range is coerced to character", {
  out <- sent_message(function(s) {
    update_el_calendar(s, "c1", range = as.Date(c("2026-05-01", "2026-05-31")))
  })
  expect_equal(out$msg$range, c("2026-05-01", "2026-05-31"))
})

test_that("update_el_calendar: NULL fields are excluded", {
  out <- sent_message(function(s) {
    update_el_calendar(s, "c1", value = "2026-01-01")
  })
  expect_equal(out$msg$value, "2026-01-01")
  expect_null(out$msg$range)
})

# ── events ────────────────────────────────────────────────────────────────────

test_that("events travel as rows, with ids and days", {
  rows <- jsonlite::fromJSON(as.character(.el_calendar_events(data.frame(
    date = as.Date("2026-10-05") + 0:1,
    end = as.Date(c(NA, "2026-10-09")),
    title = c("a", "b"),
    room = c("A1", "B2")
  ))))
  expect_equal(rows$id, 1:2)
  expect_equal(rows$date, c("2026-10-05", "2026-10-06"))
  expect_equal(rows$end, c(NA, "2026-10-09"))
  # other columns kept
  expect_equal(rows$room, c("A1", "B2"))
  # a list of rows is rows too
  listed <- jsonlite::fromJSON(as.character(.el_calendar_events(
    list(list(id = "x", date = "2026-10-05", title = "a"))
  )))
  expect_equal(listed$id, "x")
  expect_length(.el_calendar_events(NULL), 0)
  expect_error(.el_calendar_events(data.frame(date = "2026-10-05")), "title")
  expect_error(
    .el_calendar_events(data.frame(date = "2026-10-05", title = "a"), "insert"),
    "gives each event its `id`"
  )
})

test_that("a calendar with events draws them in its day cells, with the dialog", {
  html <- render_html(el_calendar(
    "plan",
    events = data.frame(date = "2026-10-05", title = "Standup"),
    editable = TRUE
  ))
  expect_match(html, "eventsOn(data.day)", fixed = TRUE)
  expect_match(html, "el-calendar-dialog", fixed = TRUE)
  expect_match(html, '"title":"Standup"', fixed = TRUE)
  expect_match(html, '"editable":true', fixed = TRUE)
  # declared, so Vue tracks them
  expect_match(html, '"eventForm":null', fixed = TRUE)
  expect_match(html, "plan_' + kind + ':shiny.element.cal_event", fixed = TRUE)
  expect_match(html, "plan_dates:shiny.element.cal_event", fixed = TRUE)
  # a prop on the calendar, not text beside it
  props <- render_html(el_calendar("c", controller_type = "select"))
  expect_match(props, '<el-calendar[^>]*:controller-type=', perl = TRUE)
  # a day cell of one's own replaces ours
  own <- render_html(el_calendar(
    "c",
    slots = list(
      dateCell = template(
        "<b>{{ data.day }}</b>",
        slot = "dateCell",
        scope = "{ data }"
      )
    )
  ))
  expect_false(grepl("el-calendar-cell__events", own, fixed = TRUE))
  expect_match(own, "{{ data.day }}", fixed = TRUE)
})

test_that("update_el_calendar() sends all the events or a few, by id", {
  ev <- data.frame(id = 7, date = "2026-10-05", title = "a")
  all <- sent_message(function(s) update_el_calendar(s, "c", events = ev))
  expect_equal(jsonlite::fromJSON(as.character(all$msg$events))$id, 7)
  ins <- sent_message(function(s) update_el_calendar(s, "c", insert = ev))
  expect_equal(ins$msg$calendarEdit$op, "insert")
  rep <- sent_message(function(s) update_el_calendar(s, "c", replace = ev))
  expect_equal(rep$msg$calendarEdit$op, "replace")
  del <- sent_message(function(s) update_el_calendar(s, "c", delete = c(7, 8)))
  expect_equal(unclass(del$msg$calendarEdit$ids), c(7, 8))
  ed <- sent_message(function(s) update_el_calendar(s, "c", editable = FALSE))
  expect_false(ed$msg$editable)
  expect_error(
    sent_message(function(s) {
      update_el_calendar(s, "c", insert = ev, delete = 1)
    }),
    "one of"
  )
  expect_error(
    sent_message(function(s) {
      update_el_calendar(
        s,
        "c",
        insert = data.frame(date = "2026-10-05", title = "a")
      )
    }),
    "its `id`"
  )
})

test_that("the calendar's requests arrive with Dates", {
  handler <- shiny:::inputHandlers$get("shiny.element.cal_event")
  got <- handler(list(
    id = 3,
    changes = list(date = "2026-10-16", end = NULL),
    event = list(date = "2026-10-16", end = "2026-10-18", title = "x")
  ))
  expect_equal(got$changes$date, as.Date("2026-10-16"))
  expect_true("end" %in% names(got$changes))
  expect_null(got$changes$end)
  expect_equal(got$event$end, as.Date("2026-10-18"))
  expect_equal(got$event$title, "x")
  dates <- handler(list(
    current = "2026-10-07",
    start = "2026-09-27",
    end = "2026-10-31"
  ))
  expect_equal(dates$start, as.Date("2026-09-27"))
})

test_that("the event dialog's words can be changed", {
  html <- render_html(el_calendar(
    "c",
    editable = TRUE,
    event_labels = list(add = "新建日程", save = "保存")
  ))
  expect_match(html, '"add":"新建日程"', fixed = TRUE)
  expect_match(html, '"cancel":"Cancel"', fixed = TRUE)
  expect_error(
    el_calendar("c", event_labels = list(nope = "x")),
    "dialog's words"
  )
  msg <- sent_message(function(s) {
    update_el_calendar(s, "c", event_labels = list(save = "OK"))
  })
  expect_equal(msg$msg$eventLabels$save, "OK")
})
