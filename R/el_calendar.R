#' Element Plus Calendar
#'
#' A month of days to pick one from, or a range of weeks to show -- and,
#' with `events`, a month planner: each day shows its events, which the
#' user can add, edit, delete and drag to another day (`editable`).
#' Days show times, groups (`calendars`) and a "+N more" beyond
#' `visible_event_count`; the dialog and the popovers take Element's
#' components of your own through slots.
#'
#' The server owns the events, as toastui's calendar has it: what the user
#' does arrives as a request -- `input$<id>_add`, `_update`, `_delete` --
#' and the calendar changes when the server answers with
#' [update_el_calendar()] (`insert`, `replace`, `delete`, or all of them
#' with `events`). So the server can check a change, give a new event its
#' id from a database, or refuse. Without Shiny -- a static page -- the
#' calendar applies the user's changes itself.
#'
#' @param id Calendar ID (auto-generated if NULL)
#' @param value Bound value (Date/string/number)
#' @param controller_type How the header switches month and year: `"button"`
#'   (the default) or `"select"`. Element Plus's `controller-type`.
#' @param formatter With `controller_type = "select"`, a [JS()] function
#'   `function(value, type)` returning the label of each option. Element
#'   Plus's `formatter`.
#' @param range Date range, c("YYYY-MM-DD", "YYYY-MM-DD")
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels.
#' @param slots Named list of slot contents. Element's: `dateCell` renders
#'   one day -- Element hands the template `date` and `data`, so write it
#'   with [template()] -- and replaces the one that draws the events; call
#'   `eventsOn(data.day)` in it for the day's events. The events layer's own,
#'   for Element's components in what it draws: `event`, the content of an
#'   event's tag (scope `{ event, day }`); `eventForm`, the dialog's fields
#'   in place of ours (scope `{ form, labels, calendars }`: bind a field with
#'   `` `v-model` = "form.location" `` and it travels with the event in
#'   `_add` and `_update`); `eventDetail`, the popover of
#'   `use_detail_popup` (scope `{ event, labels, calendars }`). Write a
#'   scope of your own with `template(scope = "{ event }")`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param events The events to show: a data.frame, or a list of rows, with
#'   `date`, the day -- a Date or `"YYYY-MM-DD"` -- or the time it starts
#'   -- a date-time or `"YYYY-MM-DD HH:MM"` --, named as Element names the
#'   day of a cell. Optionally, from toastui where Element has no name:
#'   `end`, the day or time it ends; `title`; `body`, shown on hover and
#'   in the popover; `id` (the row's number when absent); `calendarId`,
#'   its group in `calendars`; `isReadOnly`, an event the user cannot
#'   change; `isVisible = FALSE`, one not shown; `category = "allday"`,
#'   times not shown. From Element's tag: `type` (`"primary"`,
#'   `"success"`, `"info"`, `"warning"`, `"danger"`) or `color`, a
#'   background colour of your own. toastui's camelCase names can be
#'   written in snake_case (`calendar_id`). Any other column travels with
#'   the event and comes back in the inputs. A day shows its all-day events
#'   first, then the others by time, the time before the title. In a Shiny
#'   app whose events come from the server, render the calendar as an
#'   output: [el_calendar_output()].
#' @param editable Whether the user can change the events: double-click a
#'   day, or drag across several, to add one; click an event to edit or
#'   delete it in a dialog; drag it to another day to move it (its times
#'   and a span's length kept). An event with `isReadOnly` stays as it is.
#' @param event_labels The dialog's and popovers' words, to change any of: a
#'   named list of `add`, `edit` (the dialog's titles), `title`, `allday`,
#'   `date`, `end`, `calendar`, `type`, `body` (its fields), `save`,
#'   `delete`, `cancel` (its buttons), `more` (the link to a day's hidden
#'   events, `{n}` their number) -- `list(add = "新建日程", save = "保存",
#'   more = "还有 {n} 项")`.
#' @param calendars Groups of events, toastui's: a data.frame, or a list of
#'   rows, with `id`, which an event names as its `calendarId`; optionally
#'   `name`, shown in the dialog and the popover; `type` or `color`, for its
#'   events with none of their own; `isVisible = FALSE`, its events hidden.
#' @param visible_event_count How many events a day shows; the rest are
#'   behind a "+N more" that lists them in a popover. `NULL` shows them all,
#'   scrolling. toastui's `visibleEventCount`.
#' @param use_detail_popup Whether a click on an event the user cannot edit
#'   shows it in a popover: its title, when, calendar and body, or the
#'   `eventDetail` slot. toastui's `useDetailPopup`.
#' @param first_day_of_week The day the week starts on, `1` (Monday) to `7`
#'   (Sunday), as Element UI's `firstDayOfWeek`. `NULL` keeps Element Plus's,
#'   which is Sunday.
#' @param workweek Whether to hide Saturday and Sunday, as toastui's
#'   `workweek`.
#'
#' @section Shiny inputs:
#' | Input | When | Value |
#' |---|---|---|
#' | `input$<id>` | on load and when a day is picked | the day, `"YYYY-MM-DD"` |
#' | `input$<id>_dates` | on load and when another month is shown | `list(current, start, end)`, Dates: the day the calendar is on and the first and last days drawn |
#' | `input$<id>_click` | an event is clicked | the event, a list with its days as Dates and its times as date-times (the time shown, in the R session's time zone) |
#' | `input$<id>_add` | the user saves a new event (`editable`) | the event asked for, without an `id`: `list(date, end, title, type, body)`, its `calendarId` with `calendars`, and the fields of an `eventForm` slot |
#' | `input$<id>_update` | the user saves an edit or drops an event on another day | `list(event, changes)`: the event as it is, and what to change -- toastui's shape |
#' | `input$<id>_delete` | the user deletes an event | the event |
#'
#' The requests change nothing by themselves: answer them with
#' [update_el_calendar()], as the example does.
#' @return A Shiny UI element.
#' @export
#' @examples
#' # The default day cell
#' el_calendar("cal")
#'
#' # Your own, with whatever Element hands the template
#' el_calendar(
#'   "cal",
#'   slots = list(
#'     dateCell = template(
#'       htmltools::HTML("<p>{{ data.day.slice(8) }}</p>"),
#'       slot = "dateCell",
#'       scope = "{date, data}"
#'     )
#'   )
#' )
#' # Basic usage
#' el_calendar(id = "calendar1", value = Sys.Date())
#'
#' # With date range
#' el_calendar(id = "calendar2", range = c("2025-01-01", "2025-01-31"))
#'
#' # A planner whose events the server keeps, rendered as an output: each
#' # request changes them, and the calendar is rendered again -- patched,
#' # only the events sent
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(el_calendar_output("plan"))
#'   server <- function(input, output, session) {
#'     events <- reactiveVal(data.frame(
#'       id = 1:2,
#'       date = Sys.Date() + c(0, 3),
#'       title = c("Standup", "Review"),
#'       type = c("primary", "warning")
#'     ))
#'     output$plan <- render_el_calendar(
#'       el_calendar(events = events(), editable = TRUE)
#'     )
#'     observeEvent(input$plan_add, {
#'       new <- input$plan_add
#'       events(rbind(
#'         events(),
#'         data.frame(
#'           id = max(events()$id) + 1L,
#'           date = new$date,
#'           title = new$title,
#'           type = new$type
#'         )
#'       ))
#'     })
#'     observeEvent(input$plan_update, {
#'       d <- events()
#'       i <- d$id == input$plan_update$event$id
#'       for (k in intersect(names(input$plan_update$changes), names(d))) {
#'         d[[k]][i] <- input$plan_update$changes[[k]]
#'       }
#'       events(d)
#'     })
#'     observeEvent(input$plan_delete, {
#'       events(events()[events()$id != input$plan_delete$id, ])
#'     })
#'   }
#'   shinyApp(ui, server)
#' }

el_calendar <- function(
  id = NULL,
  value = NULL,
  range = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  controller_type = NULL,
  formatter = NULL,
  width = NULL,
  slots = NULL,
  session = NULL,
  events = NULL,
  editable = FALSE,
  event_labels = NULL,
  calendars = NULL,
  visible_event_count = NULL,
  use_detail_popup = FALSE,
  first_day_of_week = NULL,
  workweek = FALSE
) {
  .el_check_choices("el_calendar", environment())
  # mistakes are reported here, where the calendar is written
  .el_calendar_events(events)
  .el_calendar_labels(event_labels)
  .el_calendar_calendars(calendars)
  .el_calendar_count(visible_event_count)
  .el_calendar_week_start(first_day_of_week)
  .el_component(".el_calendar_tags", as.list(environment()), "el_calendar")
}

#' Draw a calendar from its specification
#' @noRd
.el_calendar_tags <- function(
  id = NULL,
  value = NULL,
  range = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  controller_type = NULL,
  formatter = NULL,
  width = NULL,
  slots = NULL,
  session = NULL,
  events = NULL,
  editable = FALSE,
  event_labels = NULL,
  calendars = NULL,
  visible_event_count = NULL,
  use_detail_popup = FALSE,
  first_day_of_week = NULL,
  workweek = FALSE
) {
  .el_check_choices("el_calendar", environment())

  if (is.null(id)) {
    id <- .el_auto_id("el_calendar")
  }
  ns_id <- .el_ui_id(id, session)
  events <- .el_calendar_events(events)

  # Element Plus's calendar takes and gives Date objects; the value stays a
  # "YYYY-MM-DD" string here, as input$<id> reports it, read and written in
  # local time so a day never shifts with the time zone.
  calendar_attrs <- list(
    # as upstream names it: a slot's template reaches the calendar's
    # methods as $refs.calendar.selectDate()
    ref = "calendar",
    # drawn again when the first day of the week changes: Element reads it
    # once, as the calendar is created, from the week start set around it
    ":key" = "'week-' + weekStart()",
    ":model-value" = "elDate(value)",
    "@update:model-value" = "elPick",
    ":class" = "calendarClass()"
  )
  # Bound unconditionally so update_el_calendar(range = ) can set it later; a
  # field left out of the Vue data is not reactive.
  calendar_attrs[[":range"]] <- "range === null ? undefined : range.map(elDate)"

  vue_data <- list(
    value = if (is.null(value)) {
      format(Sys.Date(), "%Y-%m-%d")
    } else {
      if (inherits(value, "Date")) format(value, "%Y-%m-%d") else value
    }
  )
  vue_data$range <- if (is.null(range)) NA else as.character(range)
  vue_data$events <- events
  vue_data$editable <- isTRUE(editable)
  vue_data$calendars <- .el_calendar_calendars(calendars)
  vue_data$visibleEventCount <- .el_calendar_count(visible_event_count)
  vue_data$useDetailPopup <- isTRUE(use_detail_popup)
  vue_data$firstDayOfWeek <- .el_calendar_week_start(first_day_of_week)
  vue_data$workweek <- isTRUE(workweek)
  # the event the dialog edits: a copy, or NULL while it is closed
  vue_data["eventForm"] <- list(NULL)
  vue_data["eventDragged"] <- list(NULL)
  # the popovers: the event shown, the day whose events are listed, the
  # element they point at
  vue_data["eventDetail"] <- list(NULL)
  vue_data["eventMore"] <- list(NULL)
  vue_data["eventAnchor"] <- list(NULL)
  # days being dragged across to add an event: list(from, to)
  vue_data["eventSelect"] <- list(NULL)
  vue_data$eventLabels <- .el_calendar_labels(event_labels)

  # Element's slots go to the calendar; ours -- event, event-form,
  # event-detail -- into the pieces the events layer draws
  slot_names <- gsub(
    "([a-z0-9])([A-Z])",
    "\\1-\\L\\2",
    names(slots) %||% character(),
    perl = TRUE
  )
  own_cell <- "date-cell" %in% slot_names
  parts <- if (length(slots)) {
    .el_slot_markup(slots, taken = c(names(vue_data), .el_calendar_methods))
  }
  ours <- slot_names %in% names(.el_calendar_scopes)
  our_slots <- if (any(ours)) {
    Map(.el_calendar_scoped, slot_names[ours], parts$markup[ours])
  } else {
    list()
  }
  # the props go on the calendar itself: the markup is the calendar and
  # the dialog and popovers beside it
  props <- .el_props(list(
    controller_type = controller_type,
    formatter = formatter
  ))
  vue_data <- c(vue_data, props$data)
  calendar <- htmltools::tag(
    "el-calendar",
    c(
      .el_label_attrs(calendar_attrs, ns_id, label),
      props$attrs,
      parts$markup[!ours],
      if (!own_cell) list(.el_calendar_cell(our_slots$event))
    )
  )

  el_widget(
    label = label,
    label_position = label_position,
    label_width = label_width,
    label_suffix = label_suffix,
    required = required,
    error = error,
    show_message = show_message,
    inline_message = inline_message,
    id = ns_id,
    markup = htmltools::tagList(
      calendar,
      .el_calendar_more(),
      .el_calendar_detail(our_slots[["event-detail"]]),
      .el_calendar_dialog(our_slots[["event-form"]])
    ),
    data = c(vue_data, parts$data),
    dependency = c(list(.el_calendar_dependency()), parts$dependencies),
    methods = c(
      parts$methods,
      .el_calendar_event_methods(ns_id),
      list(
        elPick = JS("function(d) { this.value = this.elDay(d); }"),
        elDate = JS(paste0(
          "function(s) { if (!s || typeof s !== 'string') return s; ",
          "var p = s.slice(0, 10).split('-'); ",
          "return new Date(+p[0], +p[1] - 1, +p[2]); }"
        )),
        elDay = JS(paste0(
          "function(d) { if (!(d instanceof Date)) return d; ",
          "var pad = function(n) { return (n < 10 ? '0' : '') + n; }; ",
          "return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }"
        ))
      )
    ),
    watch = c(
      parts$watch,
      list(
        value = JS(sprintf(
          paste0(
            "function(newVal, oldVal) { window.Shiny && Shiny.setInputValue && ",
            "Shiny.setInputValue('%s', newVal); ",
            # another month shown: its dates
            "if (!oldVal || String(newVal).slice(0, 7) !== String(oldVal).slice(0, 7)) ",
            "this.reportDates(); }"
          ),
          ns_id
        )),
        # immediate: the dates shown on load too
        range = list(
          immediate = TRUE,
          handler = JS("function() { this.reportDates(); }")
        ),
        # another first day of the week draws other days
        firstDayOfWeek = JS("function() { this.reportDates(); }")
      )
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width = width
  )
}

#' @rdname el_calendar
#' @param insert Events to add, each with its `id`.
#' @param replace Events to put in place of those with the same `id`.
#' @param delete The `id`s of events to delete.
#' @section Updating from the server:
#' Server-side update for [el_calendar()]: the selected day, the range, and
#' every other argument that can change once the calendar is drawn, under
#' the same name. One left `NULL` stays as it is; `NA` returns a prop to
#' Element's default.
#'
#' `events` replaces all the events; `insert`, `replace` and `delete`
#' change a few, found by `id`, and send only those -- one of the four per
#' call. `calendars` replaces the groups: an `isVisible = FALSE` hides a
#' group's events, as toastui's `cal_proxy_toggle()` does.
#'
#' `update_el_calendar()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_calendar(session, "cal", value = "2026-06-01")
#'   })
#'   update_el_calendar(session, "cal", controller_type = "select")
#' }
#' @export
update_el_calendar <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  range = NULL,
  label = NULL,
  error = NULL,
  controller_type = NULL,
  formatter = NULL,
  events = NULL,
  insert = NULL,
  replace = NULL,
  delete = NULL,
  editable = NULL,
  event_labels = NULL,
  calendars = NULL,
  visible_event_count = NULL,
  use_detail_popup = NULL,
  first_day_of_week = NULL,
  workweek = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  edits <- c(
    insert = !is.null(insert),
    replace = !is.null(replace),
    delete = !is.null(delete)
  )
  if (sum(edits) > 1L || (any(edits) && !is.null(events))) {
    stop(
      "Give one of `events`, `insert`, `replace` and `delete` at a time.",
      call. = FALSE
    )
  }
  message <- c(
    list(id = ns_id),
    .el_update_props(
      "el_calendar",
      Filter(
        Negate(is.null),
        list(controller_type = controller_type, formatter = formatter)
      )
    )
  )
  if (!is.null(value)) {
    message$value <- if (inherits(value, "Date")) {
      format(value, "%Y-%m-%d")
    } else {
      value
    }
  }
  if (!is.null(range)) {
    message$range <- as.character(range)
  }
  if (!is.null(events)) {
    message$events <- .el_calendar_events(events)
    # the server's copy follows what the calendar shows
    .el_table_data_set(session, ns_id, events)
  }
  if (!is.null(editable)) {
    message$editable <- isTRUE(editable)
  }
  if (!is.null(event_labels)) {
    message$eventLabels <- .el_calendar_labels(event_labels)
  }
  if (!is.null(calendars)) {
    message$calendars <- .el_calendar_calendars(calendars)
  }
  # NA: every event again, Element's week start again
  if (!is.null(visible_event_count)) {
    message["visibleEventCount"] <- list(
      .el_calendar_count(visible_event_count)
    )
  }
  if (!is.null(use_detail_popup)) {
    message$useDetailPopup <- isTRUE(use_detail_popup)
  }
  if (!is.null(first_day_of_week)) {
    message["firstDayOfWeek"] <- list(
      .el_calendar_week_start(first_day_of_week)
    )
  }
  if (!is.null(workweek)) {
    message$workweek <- isTRUE(workweek)
  }
  if (edits[["insert"]] || edits[["replace"]]) {
    op <- if (edits[["insert"]]) "insert" else "replace"
    rows <- if (op == "insert") insert else replace
    message$calendarEdit <- list(
      op = op,
      rows = .el_calendar_events(rows, op)
    )
    .el_calendar_edit_copy(session, ns_id, op, rows)
  }
  if (edits[["delete"]]) {
    message$calendarEdit <- list(op = "delete", ids = I(delete))
    .el_calendar_edit_copy(session, ns_id, "delete", delete)
  }

  message <- .el_form_item_update(message, label, error)
  .el_send_update(session, message)
  invisible(NULL)
}

# ── events ────────────────────────────────────────────────────────────────────

#' A calendar's events, as rows for the browser
#'
#' @param events `NULL`, a data.frame or a list of rows, with `date`;
#'   `end`, `title`, `body`, `type`, `color`, `calendarId`, `isReadOnly`,
#'   `isVisible` and `id` optional, any other column kept.
#' @param arg The update argument the rows came in, which must give ids.
#' @return Rows, each with an `id` (the row's number when none is given),
#'   days as `"YYYY-MM-DD"` and times as `"YYYY-MM-DD HH:MM"`.
#' @keywords internal
.el_calendar_events <- function(events, arg = NULL) {
  events <- .el_calendar_rows(
    events,
    "`events` must be a data.frame, or a list of rows, with `date`."
  )
  if (is.null(events)) {
    return(I(list()))
  }
  if (is.null(events$date)) {
    stop("`events` needs `date`: the day each is on.", call. = FALSE)
  }
  if (is.null(events$title)) {
    events$title <- ""
  }
  if (is.null(events$id)) {
    # events added or replaced later are found by id: the server gives it
    if (!is.null(arg)) {
      stop("`", arg, "` gives each event its `id`.", call. = FALSE)
    }
    events$id <- seq_len(nrow(events))
  }
  # toastui's all-day events may carry times, which are not shown
  allday <- if (is.null(events$category)) {
    rep(FALSE, nrow(events))
  } else {
    events$category %in% "allday"
  }
  for (col in intersect(c("date", "end"), names(events))) {
    events[[col]] <- .el_calendar_time(events[[col]], allday)
  }
  .vue_rows(events)
}

#' A calendar's groups, as rows for the browser
#'
#' @param calendars `NULL`, a data.frame or a list of rows, with `id`;
#'   `name`, `type`, `color` and `isVisible` optional.
#' @return Rows.
#' @noRd
.el_calendar_calendars <- function(calendars) {
  calendars <- .el_calendar_rows(
    calendars,
    "`calendars` must be a data.frame, or a list of rows, with `id`."
  )
  if (is.null(calendars)) {
    return(I(list()))
  }
  if (is.null(calendars$id)) {
    stop(
      "`calendars` needs `id`, which events name as `calendarId`.",
      call. = FALSE
    )
  }
  .vue_rows(calendars)
}

#' Rows as a data.frame, the keys toastui spells in camelCase accepted in
#' snake_case too; `NULL` for none
#' @noRd
.el_calendar_rows <- function(x, wrong) {
  if (is.null(x)) {
    return(NULL)
  }
  if (!is.data.frame(x)) {
    x <- tryCatch(
      do.call(rbind, lapply(x, as.data.frame, stringsAsFactors = FALSE)),
      error = function(e) stop(wrong, call. = FALSE)
    )
    if (!is.data.frame(x)) {
      stop(wrong, call. = FALSE)
    }
  }
  if (!nrow(x)) {
    return(NULL)
  }
  for (key in intersect(
    c("calendar_id", "is_read_only", "is_visible"),
    names(x)
  )) {
    camel <- .el_camel_case(key)
    if (!is.null(x[[camel]]) && !identical(x[[camel]], x[[key]])) {
      stop(
        "`",
        key,
        "` and `",
        camel,
        "` are one column, given twice with different values.",
        call. = FALSE
      )
    }
    x[[camel]] <- x[[key]]
    x[[key]] <- NULL
  }
  x
}

#' Days as "YYYY-MM-DD", times as "YYYY-MM-DD HH:MM", NA as NA
#'
#' A date-time is written as its own time zone shows it; an all-day event's
#' time is dropped.
#' @noRd
.el_calendar_time <- function(x, allday = FALSE) {
  if (inherits(x, "Date")) {
    out <- format(x, "%Y-%m-%d")
  } else if (inherits(x, "POSIXt")) {
    out <- format(x, "%Y-%m-%d %H:%M")
  } else {
    s <- sub("T", " ", as.character(x), fixed = TRUE)
    timed <- grepl("^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}", s)
    out <- ifelse(timed, substr(s, 1, 16), substr(s, 1, 10))
  }
  out[allday] <- substr(out[allday], 1, 10)
  out[is.na(x)] <- NA
  out
}

#' How many events a day shows before "+N": a whole number, or NA for all
#' @noRd
.el_calendar_count <- function(n) {
  if (is.null(n) || identical(n, NA)) {
    return(NA)
  }
  if (!is.numeric(n) || length(n) != 1 || is.na(n) || n < 1 || n != round(n)) {
    stop(
      "`visible_event_count` is a whole number of events, 1 or more.",
      call. = FALSE
    )
  }
  as.integer(n)
}

#' The first day of the week, 1 (Monday) to 7 (Sunday) as Element UI's
#' `firstDayOfWeek`, as dayjs counts it (0 Sunday to 6 Saturday); NA for
#' the locale's
#' @noRd
.el_calendar_week_start <- function(day) {
  if (is.null(day) || identical(day, NA)) {
    return(NA)
  }
  if (!is.numeric(day) || length(day) != 1 || !day %in% 1:7) {
    stop(
      "`first_day_of_week` is 1 (Monday) to 7 (Sunday).",
      call. = FALSE
    )
  }
  as.integer(day) %% 7L
}

# the methods the events layer adds, whose names a slot must not take
.el_calendar_methods <- c(
  "eventCalendar",
  "eventType",
  "eventColor",
  "eventStyle",
  "eventLabel",
  "eventWhen",
  "eventsOn",
  "eventsShown",
  "eventsHidden",
  "moreLabel",
  "canEdit",
  "isAllday",
  "setAllday",
  "clickEvent",
  "openMore",
  "closePopovers",
  "listenOutside",
  "openAdd",
  "saveEvent",
  "deleteEvent",
  "cancelEvent",
  "dragStart",
  "dropOn",
  "selectStart",
  "selectMove",
  "selectEnd",
  "inSelection",
  "weekStart",
  "calendarClass",
  "reportDates",
  "eventRequest",
  "shinyVueReceive"
)

# our slots, and what their scope offers: an object the slot's scope
# destructures, as an Element slot's would
.el_calendar_scopes <- c(
  "event" = "{ event: ev, day: data.day }",
  "event-form" = "{ form: eventForm, labels: eventLabels, calendars: calendars }",
  "event-detail" = "{ event: eventDetail, labels: eventLabels, calendars: calendars }"
)

#' One of our slots' content, in place: a `v-for` over its one scope
#'
#' The slot is not Element's -- the events layer draws the tag, the dialog
#' and the popover -- so its content goes where it is drawn, its scope
#' given by a `v-for` of one: `{ form }` is what the user wrote in
#' `template(scope = )`, or the whole scope when they gave none.
#' @noRd
.el_calendar_scoped <- function(name, markup) {
  html <- paste(as.character(markup), collapse = "")
  m <- regmatches(
    html,
    regexec(
      "(?s)^\\s*<template\\s+v-slot:[A-Za-z0-9_-]+(?:=\"([^\"]*)\")?\\s*>(.*)</template>\\s*$",
      html,
      perl = TRUE
    )
  )[[1]]
  scope <- if (length(m) && nzchar(m[2])) m[2] else NULL
  inner <- if (length(m)) m[3] else html
  provided <- .el_calendar_scopes[[name]]
  if (is.null(scope)) {
    # no scope written: every name the slot offers
    scope <- paste0(
      "{ ",
      paste(
        regmatches(
          provided,
          gregexpr("[a-zA-Z]+(?=:)", provided, perl = TRUE)
        )[[1]],
        collapse = ", "
      ),
      " }"
    )
  }
  htmltools::HTML(sprintf(
    '<template v-for="%s in [%s]">%s</template>',
    scope,
    provided,
    inner
  ))
}

#' The day cell: the day, and its events
#'
#' The "+N" of `visible_event_count` sits beside the day, where the
#' cell's height cannot hide it.
#'
#' @param event Our `event` slot's content, in place of the title.
#' @noRd
.el_calendar_cell <- function(event = NULL) {
  template(
    htmltools::tags$div(
      class = "el-calendar-cell",
      `:class` = "{ 'is-selecting': inSelection(data.day) }",
      `@dblclick` = "openAdd(data.day)",
      `@mousedown` = "selectStart(data.day, $event)",
      `@mouseenter` = "selectMove(data.day)",
      `@dragover.prevent` = NA,
      `@drop.prevent` = "dropOn(data.day)",
      htmltools::tags$div(
        class = "el-calendar-cell__head",
        htmltools::tags$span(
          class = "el-calendar-cell__day",
          "{{ Number(data.day.slice(8)) }}"
        ),
        htmltools::tags$span(
          `v-if` = "eventsHidden(data.day) > 0",
          class = "el-calendar-more",
          role = "button",
          tabindex = "0",
          `@mousedown.stop` = NA,
          `@dblclick.stop` = NA,
          `@click.stop` = "openMore(data.day, $event)",
          `@keydown.enter.stop` = "openMore(data.day, $event)",
          "{{ moreLabel(data.day) }}"
        )
      ),
      htmltools::tags$div(
        class = "el-calendar-cell__events",
        `:class` = "{ 'is-scrolling': visibleEventCount === null }",
        el$tag(
          `v-for` = "ev in eventsShown(data.day)",
          `:key` = "ev.id",
          `:type` = "eventType(ev)",
          size = "small",
          class = "el-calendar-event",
          `:title` = "ev.body || ev.title",
          # a block of colour with no title is still named, for screen
          # readers
          `:aria-label` = "ev.title || ev.body || ev.date",
          `:color` = "eventColor(ev)",
          `:style` = "eventStyle(ev)",
          `:draggable` = "canEdit(ev)",
          `@dragstart` = "dragStart(ev, $event)",
          `@mousedown.stop` = NA,
          `@dblclick.stop` = NA,
          `@click.stop` = "clickEvent(ev, $event)",
          event %||% "{{ eventLabel(ev, data.day) }}"
        )
      )
    ),
    slot = "date-cell",
    scope = "{ data }"
  )
}

#' The popover listing all of a day's events, from its "+N"
#' @noRd
.el_calendar_more <- function() {
  el$popover(
    `:visible` = "eventMore !== null",
    `:virtual-ref` = "eventAnchor",
    `virtual-triggering` = NA,
    placement = "bottom",
    `:width` = "220",
    `popper-class` = "el-calendar-popover",
    htmltools::tags$div(
      `v-if` = "eventMore !== null",
      class = "el-calendar-more__list",
      htmltools::tags$div(
        class = "el-calendar-more__day",
        "{{ eventMore }}"
      ),
      el$tag(
        `v-for` = "ev in eventsOn(eventMore)",
        `:key` = "ev.id",
        `:type` = "eventType(ev)",
        size = "small",
        class = "el-calendar-event",
        `:title` = "ev.body || ev.title",
        `:aria-label` = "ev.title || ev.body || ev.date",
        `:color` = "eventColor(ev)",
        `:style` = "eventStyle(ev)",
        `@click.stop` = "clickEvent(ev, $event, true)",
        "{{ eventLabel(ev, eventMore) }}"
      )
    )
  )
}

#' The popover showing an event the user cannot edit (`use_detail_popup`)
#'
#' @param detail Our `event-detail` slot's content, in place of ours.
#' @noRd
.el_calendar_detail <- function(detail = NULL) {
  el$popover(
    `:visible` = "eventDetail !== null",
    `:virtual-ref` = "eventAnchor",
    `virtual-triggering` = NA,
    placement = "right",
    `:width` = "260",
    `popper-class` = "el-calendar-popover",
    htmltools::tags$div(
      `v-if` = "eventDetail !== null",
      class = "el-calendar-detail",
      detail %||%
        htmltools::tagList(
          htmltools::tags$div(
            class = "el-calendar-detail__title",
            "{{ eventDetail.title }}"
          ),
          htmltools::tags$div(
            class = "el-calendar-detail__when",
            "{{ eventWhen(eventDetail) }}"
          ),
          htmltools::tags$div(
            `v-if` = "eventCalendar(eventDetail)",
            class = "el-calendar-detail__calendar",
            "{{ eventCalendar(eventDetail).name || eventCalendar(eventDetail).id }}"
          ),
          htmltools::tags$div(
            `v-if` = "eventDetail.body",
            class = "el-calendar-detail__body",
            "{{ eventDetail.body }}"
          )
        )
    )
  )
}

#' The dialog that adds, edits and deletes an event
#'
#' @param form Our `event-form` slot's content, in place of our fields.
#' @noRd
.el_calendar_dialog <- function(form = NULL) {
  field <- function(label, input, ...) {
    el$form_item(`:label` = paste0("eventLabels.", label), input, ...)
  }
  picker <- function(model, ...) {
    el$date_picker(
      `v-model` = model,
      `:type` = "isAllday(eventForm) ? 'date' : 'datetime'",
      `:value-format` = "isAllday(eventForm) ? 'YYYY-MM-DD' : 'YYYY-MM-DD HH:mm'",
      `:format` = "isAllday(eventForm) ? 'YYYY-MM-DD' : 'YYYY-MM-DD HH:mm'",
      style = "width: 100%",
      ...
    )
  }
  fields <- form %||%
    htmltools::tagList(
      field("title", el$input(`v-model` = "eventForm.title")),
      field(
        "allday",
        el$switch(
          `:model-value` = "isAllday(eventForm)",
          `@update:model-value` = "setAllday"
        )
      ),
      field("date", picker("eventForm.date", `:clearable` = "false")),
      field("end", picker("eventForm.end")),
      field(
        "calendar",
        `v-if` = "calendars.length",
        el$select(
          `v-model` = "eventForm.calendarId",
          el$option(
            `v-for` = "c in calendars",
            `:key` = "c.id",
            `:label` = "c.name || c.id",
            `:value` = "c.id"
          )
        )
      ),
      field(
        "type",
        el$select(
          `v-model` = "eventForm.type",
          # an event of a calendar takes its type unless given one
          `:placeholder` = "eventType(eventForm)",
          el$option(
            `v-for` = "t in ['primary', 'success', 'info', 'warning', 'danger']",
            `:key` = "t",
            `:label` = "t",
            `:value` = "t"
          )
        )
      ),
      field(
        "body",
        el$input(
          `v-model` = "eventForm.body",
          type = "textarea",
          `:rows` = "2"
        )
      )
    )
  el$dialog(
    `:model-value` = "eventForm !== null",
    `@update:model-value` = "$event || cancelEvent()",
    `:title` = "eventForm && eventForm.id !== undefined ? eventLabels.edit : eventLabels.add",
    width = "460px",
    `append-to-body` = NA,
    class = "el-calendar-dialog",
    el$form(
      `v-if` = "eventForm",
      `label-width` = "72px",
      `@submit.prevent` = NA,
      fields
    ),
    htmltools::HTML(paste0(
      "<template v-slot:footer>",
      as.character(el$button(
        `v-if` = "eventForm && eventForm.id !== undefined",
        type = "danger",
        plain = NA,
        `@click` = "deleteEvent",
        "{{ eventLabels.delete }}"
      )),
      as.character(el$button(
        `@click` = "cancelEvent",
        "{{ eventLabels.cancel }}"
      )),
      as.character(el$button(
        type = "primary",
        `@click` = "saveEvent",
        `:disabled` = "!eventForm || !eventForm.date",
        "{{ eventLabels.save }}"
      )),
      "</template>"
    ))
  )
}

#' The events layer's stylesheet
#' @noRd
.el_calendar_dependency <- function() {
  css <- paste(
    ".el-calendar-cell { height: 100%; display: flex; flex-direction: column; gap: 2px; overflow: hidden; }",
    ".el-calendar-cell.is-selecting { background-color: var(--el-color-primary-light-9); }",
    ".el-calendar-cell__events { flex: 1; min-height: 0; display: flex; flex-direction: column; gap: 2px; overflow: hidden; }",
    ".el-calendar-cell__events.is-scrolling { overflow-y: auto; }",
    ".el-calendar-event { width: 100%; justify-content: flex-start; cursor: pointer; overflow: hidden; flex-shrink: 0; }",
    ".el-calendar-event .el-tag__content { overflow: hidden; text-overflow: ellipsis; }",
    ".el-calendar-cell__head { display: flex; justify-content: space-between; align-items: baseline; gap: 4px; }",
    ".el-calendar-more { font-size: 12px; color: var(--el-color-primary); cursor: pointer; white-space: nowrap; }",
    ".el-calendar-more:hover { text-decoration: underline; }",
    ".el-calendar-more__list { display: flex; flex-direction: column; gap: 4px; }",
    ".el-calendar-more__day { font-weight: 600; margin-bottom: 2px; }",
    ".el-calendar-detail { display: flex; flex-direction: column; gap: 6px; }",
    ".el-calendar-detail__title { font-weight: 600; font-size: 14px; color: var(--el-text-color-primary); }",
    ".el-calendar-detail__when, .el-calendar-detail__calendar { color: var(--el-text-color-secondary); }",
    ".el-calendar-detail__body { white-space: pre-wrap; }",
    # workweek: the columns of Saturday and Sunday, wherever the week
    # starts
    paste(
      vapply(
        1:7,
        function(i) {
          sprintf(
            ".el-calendar.is-hide-col-%d .el-calendar-table tr > :nth-child(%d) { display: none; }",
            i,
            i
          )
        },
        character(1)
      ),
      collapse = "\n"
    ),
    sep = "\n"
  )
  htmltools::htmlDependency(
    "el-calendar-events",
    "1.0.0",
    src = system.file("js", package = "shiny.element"),
    head = paste0("<style>", css, "</style>"),
    all_files = FALSE
  )
}

#' What the events layer does in the browser
#'
#' The user's actions become requests -- `input$<id>_add`, `_update`,
#' `_delete` -- and the server, which owns the events, answers with
#' [update_el_calendar()]; `_click` reports a click on an event and
#' `_dates` the days shown. Without Shiny (a static page) the calendar
#' applies them itself.
#' @noRd
.el_calendar_event_methods <- function(ns_id) {
  # "YYYY-MM-DD[ HH:MM]" as a UTC instant, and back to a day
  parse <- paste0(
    "var parse = function(s) { var p = String(s).slice(0, 10).split('-'); ",
    "return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; ",
    "var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; "
  )
  list(
    eventCalendar = JS(paste0(
      "function(ev) { if (!ev || ev.calendarId === undefined || ev.calendarId === null) return null; ",
      "var id = String(ev.calendarId); ",
      "return (this.calendars || []).filter(function(c) { return String(c.id) === id; })[0] || null; }"
    )),
    # the event's own type or colour, else its calendar's
    eventType = JS(paste0(
      "function(ev) { var c = this.eventCalendar(ev); ",
      "return ev.type || (c && c.type) || 'primary'; }"
    )),
    eventColor = JS(paste0(
      "function(ev) { var c = this.eventCalendar(ev); ",
      "return ev.color || (c && c.color) || undefined; }"
    )),
    # a colour of the event's own: its border too, and the page's text
    eventStyle = JS(paste0(
      "function(ev) { var col = this.eventColor(ev); return col ? {borderColor: col, ",
      "color: 'var(--el-text-color-primary)'} : null; }"
    )),
    # a timed event shows its time on its first day
    eventLabel = JS(paste0(
      "function(ev, day) { var d = String(ev.date); ",
      "return (d.length > 10 && d.slice(0, 10) === day ? d.slice(11, 16) + ' ' : '') + (ev.title || ''); }"
    )),
    eventWhen = JS(paste0(
      "function(ev) { if (!ev) return ''; var d = String(ev.date), e = ev.end ? String(ev.end) : ''; ",
      "if (!e) return d; ",
      "return d + ' \u2013 ' + (e.slice(0, 10) === d.slice(0, 10) ? e.slice(11) : e); }"
    )),
    # the day's events, shown ones, all-day first, then by time
    eventsOn = JS(paste0(
      "function(day) { var self = this; ",
      "var on = (self.events || []).filter(function(e) { ",
      "if (e.isVisible === false) return false; var c = self.eventCalendar(e); ",
      "if (c && c.isVisible === false) return false; ",
      "var start = String(e.date).slice(0, 10), end = e.end ? String(e.end).slice(0, 10) : start; ",
      "return start <= day && day <= end; }); ",
      "var key = function(e) { var d = String(e.date); ",
      "return d.length > 10 && d.slice(0, 10) === day ? d.slice(11) : ''; }; ",
      "return on.map(function(e, i) { return [e, i]; }).sort(function(a, b) { ",
      "var ka = key(a[0]), kb = key(b[0]); ",
      "return ka < kb ? -1 : ka > kb ? 1 : a[1] - b[1]; }).map(function(p) { return p[0]; }); }"
    )),
    eventsShown = JS(paste0(
      "function(day) { var all = this.eventsOn(day), n = this.visibleEventCount; ",
      "return n && all.length > n ? all.slice(0, n) : all; }"
    )),
    eventsHidden = JS(paste0(
      "function(day) { var n = this.visibleEventCount; if (!n) return 0; ",
      "return Math.max(0, this.eventsOn(day).length - n); }"
    )),
    moreLabel = JS(paste0(
      "function(day) { return String(this.eventLabels.more).replace('{n}', this.eventsHidden(day)); }"
    )),
    canEdit = JS("function(ev) { return !!this.editable && !ev.isReadOnly; }"),
    isAllday = JS(
      "function(f) { return !f || !f.date || String(f.date).length <= 10; }"
    ),
    # the dialog's switch: times added, or dropped
    setAllday = JS(paste0(
      "function(on) { var f = this.eventForm; if (!f || !f.date) return; ",
      "var day = function(s) { return String(s).slice(0, 10); }; ",
      "if (on) { f.date = day(f.date); if (f.end) f.end = day(f.end); } ",
      "else { f.date = day(f.date) + ' 09:00'; if (f.end) f.end = day(f.end) + ' 10:00'; } }"
    )),
    # a request to the server, or -- with none -- the change made here
    eventRequest = JS(sprintf(
      paste0(
        "function(kind, value, apply) { ",
        "if (window.Shiny && Shiny.setInputValue) { ",
        "Shiny.setInputValue('%s_' + kind + ':shiny.element.cal_event', ",
        "window.shinyVue.plain(value), {priority: 'event'}); } ",
        "else if (apply) { apply.call(this); } }"
      ),
      ns_id
    )),
    # a click: reported; the dialog to edit it, or the popover to read it.
    # From the "+N" list the popover points at the "+N".
    clickEvent = JS(paste0(
      "function(ev, e, fromMore) { var self = this; self.eventRequest('click', ev); ",
      "var anchor = fromMore ? self.eventAnchor : (e && e.currentTarget) || null; ",
      "self.closePopovers(); ",
      "if (self.canEdit(ev)) { self.eventForm = Object.assign({}, ev, {end: ev.end || null}); return; } ",
      "if (self.useDetailPopup && anchor) { self.eventAnchor = anchor; self.eventDetail = ev; ",
      "self.listenOutside(); } }"
    )),
    openMore = JS(paste0(
      "function(day, e) { this.closePopovers(); this.eventAnchor = e.currentTarget; ",
      "this.eventMore = day; this.listenOutside(); }"
    )),
    closePopovers = JS(
      "function() { this.eventMore = null; this.eventDetail = null; }"
    ),
    # a press outside the popovers, or Escape, closes them
    listenOutside = JS(paste0(
      "function() { var self = this; if (self._outside) return; ",
      "var off = function() { document.removeEventListener('mousedown', down, true); ",
      "document.removeEventListener('keydown', key, true); self._outside = null; }; ",
      "var down = function(e) { var t = e.target; ",
      "if (t.closest && (t.closest('.el-calendar-popover') || t === self.eventAnchor)) return; ",
      "self.closePopovers(); off(); }; ",
      "var key = function(e) { if (e.key === 'Escape') { self.closePopovers(); off(); } }; ",
      "self._outside = off; document.addEventListener('mousedown', down, true); ",
      "document.addEventListener('keydown', key, true); }"
    )),
    openAdd = JS(paste0(
      "function(day, end) { if (!this.editable) return; this.closePopovers(); ",
      "var f = {date: day, end: end && end !== day ? end : null, title: '', type: 'primary', body: ''}; ",
      "if (this.calendars && this.calendars.length) f.calendarId = this.calendars[0].id; ",
      "this.eventForm = f; }"
    )),
    cancelEvent = JS("function() { this.eventForm = null; }"),
    saveEvent = JS(paste0(
      "function() { var self = this, f = self.eventForm; if (!f || !f.date) return; ",
      "var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.date) ev.end = null; ",
      "if (ev.id === undefined) { ",
      "self.eventRequest('add', ev, function() { ",
      "ev.id = 'local-' + Date.now(); self.events.push(ev); }); ",
      "} else { ",
      "var old = self.events.filter(function(e) { return e.id === ev.id; })[0] || {}; ",
      "var changes = {}; Object.keys(ev).forEach(function(k) { ",
      "if (ev[k] !== old[k] && !(ev[k] === null && old[k] === undefined)) changes[k] = ev[k]; }); ",
      "self.eventRequest('update', {event: old, changes: changes}, function() { ",
      "var i = self.events.indexOf(old); if (i >= 0) self.events.splice(i, 1, ev); }); } ",
      "self.eventForm = null; }"
    )),
    deleteEvent = JS(paste0(
      "function() { var self = this, f = self.eventForm; if (!f) return; ",
      "var old = self.events.filter(function(e) { return e.id === f.id; })[0]; ",
      "if (old) self.eventRequest('delete', old, function() { ",
      "self.events.splice(self.events.indexOf(old), 1); }); ",
      "self.eventForm = null; }"
    )),
    dragStart = JS(paste0(
      "function(ev, e) { if (!this.canEdit(ev)) { e.preventDefault(); return; } ",
      "this.closePopovers(); this.eventDragged = ev.id; ",
      "if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; ",
      "e.dataTransfer.setData('text/plain', String(ev.id)); } }"
    )),
    # dropped on another day: moved there, its times and a span's length
    # kept
    dropOn = JS(paste0(
      "function(day) { var self = this, id = self.eventDragged; ",
      "self.eventDragged = null; if (!self.editable || id === null) return; ",
      "var old = self.events.filter(function(e) { return e.id === id; })[0]; ",
      "if (!old || String(old.date).slice(0, 10) === day) return; ",
      parse,
      "var shift = parse(day) - parse(old.date); ",
      "var changes = {date: day + String(old.date).slice(10)}; ",
      "if (old.end) changes.end = fmt(parse(old.end) + shift) + String(old.end).slice(10); ",
      "var ev = Object.assign({}, old, changes); ",
      "self.eventRequest('update', {event: old, changes: changes}, function() { ",
      "self.events.splice(self.events.indexOf(old), 1, ev); }); }"
    )),
    # pressed on a day and dragged across others: a new event over them
    selectStart = JS(paste0(
      "function(day, e) { var self = this; if (!self.editable || e.button !== 0) return; ",
      "self.eventSelect = {from: day, to: day}; ",
      "var up = function() { document.removeEventListener('mouseup', up, true); self.selectEnd(); }; ",
      "document.addEventListener('mouseup', up, true); }"
    )),
    selectMove = JS(
      "function(day) { if (this.eventSelect) this.eventSelect.to = day; }"
    ),
    selectEnd = JS(paste0(
      "function() { var s = this.eventSelect; this.eventSelect = null; ",
      "if (!s || s.from === s.to) return; ",
      "this.openAdd(s.from < s.to ? s.from : s.to, s.from < s.to ? s.to : s.from); }"
    )),
    inSelection = JS(paste0(
      "function(day) { var s = this.eventSelect; if (!s || s.from === s.to) return false; ",
      "var a = s.from < s.to ? s.from : s.to, b = s.from < s.to ? s.to : s.from; ",
      "return a <= day && day <= b; }"
    )),
    # The week's first day, as dayjs counts it. Element reads it from
    # dayjs's global locale as a calendar's date table is created, which
    # happens while this component renders: it is set for that render and
    # put back once it is done, so no other component sees it.
    weekStart = JS(paste0(
      "function() { var dj = window.ElementPlus && ElementPlus.dayjs; ",
      "var fdw = this.firstDayOfWeek; ",
      "if (!dj) return fdw === null || fdw === undefined ? 0 : fdw; ",
      "var loc = dj.Ls && dj.Ls[dj.locale()]; ",
      "if (fdw === null || fdw === undefined || !loc) return dj.localeData ? dj.localeData().firstDayOfWeek() : 0; ",
      "var had = Object.prototype.hasOwnProperty.call(loc, 'weekStart'), old = loc.weekStart; ",
      "loc.weekStart = fdw; ",
      "Promise.resolve().then(function() { if (had) loc.weekStart = old; else delete loc.weekStart; }); ",
      "return fdw; }"
    )),
    # workweek: Saturday's and Sunday's columns hidden
    calendarClass = JS(paste0(
      "function() { var out = ['el-calendar--events']; if (!this.workweek) return out; ",
      "var s = this.firstDayOfWeek; ",
      "if (s === null || s === undefined) { var dj = window.ElementPlus && ElementPlus.dayjs; ",
      "s = dj && dj.localeData ? dj.localeData().firstDayOfWeek() : 0; } ",
      "[0, 6].forEach(function(w) { out.push('is-hide-col-' + (((w - s + 7) % 7) + 1)); }); ",
      "return out; }"
    )),
    # the days shown, counted off the drawn month: Element's first day of
    # the week follows its locale, or first_day_of_week
    reportDates = JS(sprintf(
      paste0(
        "function() { var self = this; self.$nextTick(function() { ",
        "var root = self.$el && self.$el.querySelectorAll ? self.$el : null; ",
        "if (!root || !window.Shiny || !Shiny.setInputValue) return; ",
        "var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; ",
        parse,
        "var start, end; ",
        "if (self.range && self.range.length) { start = parse(self.range[0]); ",
        "end = start + (cells.length - 1) * 864e5; } else { ",
        "var v = String(self.value).slice(0, 10).split('-'); ",
        "var first = Date.UTC(+v[0], +v[1] - 1, 1); ",
        "var prev = root.querySelectorAll('.el-calendar-table td.prev').length; ",
        "start = first - prev * 864e5; end = start + (cells.length - 1) * 864e5; } ",
        "Shiny.setInputValue('%s_dates:shiny.element.cal_event', ",
        "{current: String(self.value).slice(0, 10), start: fmt(start), end: fmt(end)}); }); }"
      ),
      ns_id
    )),
    # update_el_calendar(insert =, replace =, delete =): only those events
    shinyVueReceive = JS(paste0(
      "function(d) { if (!('calendarEdit' in d)) return d; ",
      "var e = d.calendarEdit, events = this.events, rows = e.rows || []; ",
      "delete d.calendarEdit; ",
      "var at = function(id) { for (var i = 0; i < events.length; i++) ",
      "if (String(events[i].id) === String(id)) return i; return -1; }; ",
      "if (e.op === 'insert') rows.forEach(function(r) { events.push(r); }); ",
      "else if (e.op === 'replace') rows.forEach(function(r) { var i = at(r.id); ",
      "if (i >= 0) events.splice(i, 1, r); else events.push(r); }); ",
      "else if (e.op === 'delete') [].concat(e.ids || []).forEach(function(id) { ",
      "var i = at(id); if (i >= 0) events.splice(i, 1); }); ",
      "return d; }"
    ))
  )
}

#' A calendar's message with its dates as Dates, its times as date-times
#'
#' A time is the wall-clock time the calendar shows, read in the R
#' session's time zone.
#' @noRd
.el_calendar_dates <- function(x) {
  if (!is.list(x)) {
    return(x)
  }
  for (k in names(x)) {
    v <- x[[k]]
    if (k %in% c("date", "end", "start", "current")) {
      x[k] <- list(
        if (is.null(v) || identical(v, "")) {
          NULL
        } else if (nchar(v) > 10) {
          as.POSIXct(substr(v, 1, 16), format = "%Y-%m-%d %H:%M", tz = "")
        } else {
          as.Date(substr(v, 1, 10))
        }
      )
    } else if (is.list(v)) {
      x[[k]] <- .el_calendar_dates(v)
    }
  }
  x
}

#' The event dialog's and popovers' words, English unless given
#' @noRd
.el_calendar_labels <- function(labels = NULL) {
  words <- list(
    add = "New event",
    edit = "Edit event",
    title = "Title",
    allday = "All day",
    date = "Date",
    end = "Until",
    calendar = "Calendar",
    type = "Type",
    body = "Details",
    save = "Save",
    delete = "Delete",
    cancel = "Cancel",
    more = "+{n} more"
  )
  labels <- as.list(labels)
  unknown <- setdiff(names(labels), names(words))
  if (length(unknown) || (length(labels) && is.null(names(labels)))) {
    stop(
      "`event_labels` names the dialog's words: ",
      toString(names(words)),
      ".",
      call. = FALSE
    )
  }
  utils::modifyList(words, labels)
}

#' The server's copy of a calendar's events, edited as the browser's is
#' @noRd
.el_calendar_edit_copy <- function(session, id, op, rows) {
  if (!.el_table_known(session, id)) {
    return(invisible(NULL))
  }
  events <- .el_table_data(session, id)
  if (!is.data.frame(events)) {
    return(invisible(NULL))
  }
  if (op == "delete") {
    events <- events[
      !as.character(events$id) %in% as.character(rows),
      ,
      drop = FALSE
    ]
  } else {
    rows <- as.data.frame(rows, stringsAsFactors = FALSE)
    if (op == "replace") {
      events <- events[
        !as.character(events$id) %in% as.character(rows$id),
        ,
        drop = FALSE
      ]
    }
    # the columns of either, the missing ones NA
    for (col in setdiff(names(rows), names(events))) {
      events[[col]] <- rep(NA, nrow(events))
    }
    for (col in setdiff(names(events), names(rows))) {
      rows[[col]] <- rep(NA, nrow(rows))
    }
    events <- rbind(events, rows[names(events)])
  }
  rownames(events) <- NULL
  .el_table_data_set(session, id, events)
  invisible(NULL)
}

# ── as an output ──────────────────────────────────────────────────────────────

#' A calendar as a Shiny output
#'
#' The calendar of an app whose events the server reads -- from a
#' database, a folder, a computation -- as toastui's `calendarOutput()` and
#' `renderCalendar()`: the page holds `el_calendar_output()`, the server
#' renders [el_calendar()] into it with its events. Rendering again with
#' new events patches the calendar in place: the month shown and an open
#' dialog stay, and only what changed is sent.
#'
#' The output's id is the calendar's: `input$<id>` is the day picked and
#' `input$<id>_click`, `_dates`, `_add`, `_update`, `_delete` are as for
#' [el_calendar()]; [update_el_calendar()] reaches the calendar by it, and
#' [el_calendar_events()] reads the events it shows.
#'
#' @param outputId The output's id.
#' @param width The calendar's width, as a CSS unit.
#' @param loading Whether Element's loading mask covers the calendar while
#'   Shiny recalculates it, in place of Shiny fading the output.
#' @param expr An expression returning [el_calendar()], given no `id`.
#' @param env,quoted As for [shiny::renderUI()].
#' @return `el_calendar_output()`, a tag; `render_el_calendar()`, a render
#'   function.
#' @seealso [el_calendar()], [update_el_calendar()], [el_calendar_events()].
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   archive <- data.frame(
#'     date = Sys.Date() - c(9, 6, 2),
#'     title = c("", "", "Validated"),
#'     body = c("Raw data", "Archive", "Validated data"),
#'     color = c("lightgrey", "#EED5B7", "#E9C46B")
#'   )
#'   ui <- el_page(el_calendar_output("snapshot"), verbatimTextOutput("picked"))
#'   server <- function(input, output, session) {
#'     output$snapshot <- render_el_calendar(
#'       el_calendar(value = max(archive$date), events = archive)
#'     )
#'     output$picked <- renderPrint(input$snapshot_click$date)
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_calendar_output <- function(outputId, width = "100%", loading = TRUE) {
  el_table_output(outputId, width = width, loading = loading)
}

#' @rdname el_calendar_output
#' @export
render_el_calendar <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  .el_render_component(
    expr,
    env,
    class = "el_calendar",
    what = "render_el_calendar() renders an el_calendar().",
    data_arg = "events",
    output_fn = el_calendar_output,
    label = "render_el_calendar"
  )
}

#' The events a calendar shows
#'
#' What the browser holds, as R: the events last rendered with
#' [render_el_calendar()] or sent with [update_el_calendar()], with every
#' event [update_el_calendar()] has since inserted, replaced or deleted. The
#' user's requests (`input$<id>_add`, ...) are not in it until the server
#' answers them. A reactive read.
#'
#' @param session The Shiny session, the current one by default.
#' @param id The calendar's id, the output's.
#' @return The events, as given; `NULL` for a calendar the server has not
#'   rendered or updated.
#' @seealso [render_el_calendar()], [update_el_calendar()].
#' @export
el_calendar_events <- function(
  session = shiny::getDefaultReactiveDomain(),
  id
) {
  .el_check_session(session)
  el_table_data(session, id)
}
