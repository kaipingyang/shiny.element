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

test_that("el_calendar: returns its specification, drawn with the container id", {
  cal <- el_calendar(id = "c1")
  expect_s3_class(cal, c("el_calendar", "el_component"))
  expect_s3_class(htmltools::as.tags(cal), "shiny.tag.list")
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
  expect_error(.el_calendar_events(data.frame(title = "a")), "needs `date`")
  # a title is optional: a block of colour alone
  untitled <- jsonlite::fromJSON(as.character(.el_calendar_events(
    data.frame(date = "2026-10-05", color = "#EED5B7")
  )))
  expect_equal(untitled$title, "")
  expect_error(
    .el_calendar_events(
      data.frame(date = "2026-10-05", title = "a"),
      "insert"
    ),
    "gives each event its `id`"
  )
})

test_that("a calendar with events draws them in its day cells, with the dialog", {
  html <- render_html(el_calendar(
    "plan",
    events = data.frame(date = "2026-10-05", title = "Standup"),
    editable = TRUE
  ))
  expect_match(html, "eventsShown(data.day)", fixed = TRUE)
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
  expect_equal(ins$msg$.edit$op, "insert")
  rep <- sent_message(function(s) update_el_calendar(s, "c", replace = ev))
  expect_equal(rep$msg$.edit$op, "replace")
  del <- sent_message(function(s) update_el_calendar(s, "c", delete = c(7, 8)))
  expect_equal(unclass(del$msg$.edit$at), c(7, 8))
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
    event = list(id = 3, date = "2026-10-14", end = "2026-10-18", title = "x"),
    changes = list(date = "2026-10-16", end = NULL)
  ))
  expect_equal(got$changes$date, as.Date("2026-10-16"))
  expect_true("end" %in% names(got$changes))
  expect_null(got$changes$end)
  expect_equal(got$event$end, as.Date("2026-10-18"))
  expect_equal(got$event$date, as.Date("2026-10-14"))
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

test_that("a calendar output renders the server's events and keeps a copy", {
  days <- data.frame(
    id = 1:2,
    date = as.Date("2026-10-05") + c(0, 3),
    title = c("a", "b"),
    color = c("#EED5B7", NA)
  )
  shiny::testServer(
    function(input, output, session) {
      ev <- shiny::reactiveVal(days)
      session$userData$ev <- ev
      output$cal <- render_el_calendar(el_calendar(events = ev()))
    },
    {
      first <- output$cal
      expect_named(first, c("html", "deps"))
      expect_match(first$html, 'id="cal-el"', fixed = TRUE)
      expect_match(first$html, 'data-shiny-vue-id="cal"', fixed = TRUE)
      expect_equal(.el_table_data(session, "cal"), days)
      # other events: only they are sent
      session$userData$ev(days[1, ])
      session$flushReact()
      expect_named(output$cal, "patch")
      expect_named(output$cal$patch$fields, "events")
      # edits by id follow on the server's copy (testServer's session
      # namespaces ids, so the copy is edited as update_el_calendar() does)
      .el_calendar_edit_copy(
        session,
        "cal",
        "insert",
        data.frame(id = 9L, date = as.Date("2026-10-20"), title = "c")
      )
      copy <- .el_table_data(session, "cal")
      expect_equal(copy$id, c(1L, 9L))
      expect_true(is.na(copy$color[2]))
      .el_calendar_edit_copy(
        session,
        "cal",
        "replace",
        data.frame(id = 1L, date = as.Date("2026-10-06"), title = "a2")
      )
      expect_equal(.el_table_data(session, "cal")$title, c("c", "a2"))
      .el_calendar_edit_copy(session, "cal", "delete", 9)
      expect_equal(.el_table_data(session, "cal")$id, 1L)
    }
  )
  expect_error(
    shiny::testServer(
      function(input, output, session) {
        output$cal <- render_el_calendar(htmltools::div())
      },
      output$cal
    ),
    "renders an el_calendar"
  )
  html <- render_html(el_calendar_output("cal"))
  expect_match(html, 'class="shiny-vue-output"', fixed = TRUE)
})

test_that("a calendar output can be cached", {
  runs <- 0
  shiny::testServer(
    function(input, output, session) {
      n <- shiny::reactiveVal(1)
      session$userData$n <- n
      output$cal <- shiny::bindCache(
        render_el_calendar({
          runs <<- runs + 1
          el_calendar(events = data.frame(date = "2026-10-05", title = n()))
        }),
        n()
      )
    },
    {
      output$cal
      session$userData$n(2)
      session$flushReact()
      output$cal
      session$userData$n(1)
      session$flushReact()
      expect_named(output$cal, "patch")
      expect_equal(runs, 2)
    }
  )
})

test_that("update_el_calendar() keeps the server's copy in step", {
  session <- list(
    ns = function(id) id,
    userData = new.env(),
    sendCustomMessage = function(type, msg) NULL
  )
  .el_table_rendered(
    session,
    "cal",
    data.frame(id = 1L, date = as.Date("2026-10-05"), title = "a")
  )
  update_el_calendar(
    session,
    "cal",
    insert = data.frame(id = 2L, date = as.Date("2026-10-06"), title = "b")
  )
  expect_equal(.el_table_data(session, "cal")$id, 1:2)
  update_el_calendar(session, "cal", delete = 1)
  expect_equal(.el_table_data(session, "cal")$id, 2L)
  update_el_calendar(
    session,
    "cal",
    events = data.frame(id = 5L, date = "2026-10-09", title = "e")
  )
  expect_equal(.el_table_data(session, "cal")$id, 5L)
  expect_equal(
    shiny::isolate(el_calendar_events(session, "cal"))$id,
    5L
  )
})

# rows as columns, as jsonlite reads them back
cal_rows <- function(x) jsonlite::fromJSON(as.character(x))

test_that("an event's times are kept, an all-day one's dropped", {
  rows <- cal_rows(.el_calendar_events(data.frame(
    date = c("2026-10-05", "2026-10-05 09:30:00", "2026-10-06T14:00"),
    end = c(NA, "2026-10-05 10:00", NA),
    title = c("a", "b", "c")
  )))
  expect_equal(
    rows$date,
    c("2026-10-05", "2026-10-05 09:30", "2026-10-06 14:00")
  )
  expect_equal(rows$end, c(NA, "2026-10-05 10:00", NA))
  # a date-time as its own time zone shows it
  t <- as.POSIXct("2026-10-05 08:15", tz = "Asia/Shanghai")
  expect_equal(
    cal_rows(.el_calendar_events(data.frame(date = t, title = "x")))$date,
    "2026-10-05 08:15"
  )
  # toastui's all-day events with times
  all_day <- cal_rows(.el_calendar_events(data.frame(
    date = "2021-02-03 10:00:00",
    end = "2021-02-03 20:00:00",
    category = "allday",
    title = ""
  )))
  expect_equal(c(all_day$date, all_day$end), c("2021-02-03", "2021-02-03"))
})

test_that("toastui's camelCase keys are taken in snake_case too", {
  rows <- cal_rows(.el_calendar_events(data.frame(
    date = "2026-10-05",
    calendar_id = "w",
    is_read_only = TRUE
  )))
  expect_equal(rows$calendarId, "w")
  expect_true(rows$isReadOnly)
  expect_null(rows$calendar_id)
  expect_error(
    .el_calendar_events(data.frame(
      date = "2026-10-05",
      calendar_id = "a",
      calendarId = "b"
    )),
    "one column, given twice"
  )
})

test_that("calendars, the count and the week start are checked", {
  cals <- cal_rows(.el_calendar_calendars(data.frame(
    id = c("w", "h"),
    is_visible = c(TRUE, FALSE)
  )))
  expect_equal(cals$isVisible, c(TRUE, FALSE))
  expect_error(.el_calendar_calendars(data.frame(name = "x")), "needs `id`")
  expect_error(el_calendar(calendars = list(name = "x")), "needs `id`")
  expect_equal(.el_calendar_count(3), 3L)
  expect_true(is.na(.el_calendar_count(NULL)))
  expect_error(el_calendar(visible_event_count = 0), "whole number")
  # Element UI's 1 (Monday) to 7 (Sunday), as dayjs counts: 0 is Sunday
  expect_equal(.el_calendar_week_start(1), 1L)
  expect_equal(.el_calendar_week_start(7), 0L)
  expect_error(el_calendar(first_day_of_week = 0), "1 \\(Monday\\)")
})

test_that("times come back as date-times, days as Dates", {
  got <- .el_calendar_dates(list(
    event = list(date = "2026-10-05 09:30", end = "2026-10-06"),
    changes = list(date = "2026-10-07 09:30")
  ))
  expect_s3_class(got$event$date, "POSIXct")
  expect_equal(format(got$event$date, "%Y-%m-%d %H:%M"), "2026-10-05 09:30")
  expect_s3_class(got$event$end, "Date")
  expect_equal(format(got$changes$date, "%H:%M"), "09:30")
})

test_that("our slots go into the tag, the dialog and the popover", {
  html <- render_html(el_calendar(
    "c",
    events = data.frame(date = "2026-10-05", title = "a"),
    editable = TRUE,
    slots = list(
      event = template(
        "<b>{{ event.title }}</b>",
        slot = "event",
        scope = "{ event }"
      ),
      eventForm = el$input(`v-model` = "form.location"),
      eventDetail = htmltools::tags$i("{{ event.location }}")
    )
  ))
  expect_match(
    html,
    '<template v-for="{ event } in [{ event: ev, day: data.day }]"><b>{{ event.title }}</b></template>',
    fixed = TRUE
  )
  # no scope written: every name the slot offers
  expect_match(
    html,
    "v-for=\"{ form, labels, calendars } in [{ form: eventForm,",
    fixed = TRUE
  )
  expect_match(html, 'v-model="form.location"', fixed = TRUE)
  expect_match(html, "{ event: eventDetail,", fixed = TRUE)
  # ours replace our fields; Element's own slots still reach the calendar
  expect_no_match(html, 'v-model="eventForm.title"', fixed = TRUE)
  expect_no_match(html, "v-slot:event-form", fixed = TRUE)
})

test_that("update_el_calendar() sends the events layer's options", {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- msg
  )
  update_el_calendar(
    session,
    "c",
    calendars = data.frame(id = "w", is_visible = FALSE),
    visible_event_count = 2,
    use_detail_popup = TRUE,
    first_day_of_week = 1,
    workweek = TRUE
  )
  expect_false(cal_rows(captured$calendars)$isVisible)
  expect_equal(captured$visibleEventCount, 2L)
  expect_true(captured$useDetailPopup)
  expect_equal(captured$firstDayOfWeek, 1L)
  expect_true(captured$workweek)
  # NA: back to every event and Element's week
  update_el_calendar(
    session,
    "c",
    visible_event_count = NA,
    first_day_of_week = NA
  )
  expect_true(is.na(captured$visibleEventCount))
  expect_true(is.na(captured$firstDayOfWeek))
})
