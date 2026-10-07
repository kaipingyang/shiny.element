#' Element Plus Calendar
#'
#' A month of days to pick one from, or a range of weeks to show -- and,
#' with `events`, a month planner: each day shows its events, which the
#' user can add, edit, delete and drag to another day (`editable`).
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
#' @param slots Named list of Element slot contents. `dateCell` renders one
#'   day: Element hands the template `date` and `data`, so write it with
#'   [template()]. A default is used when none is given.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param events The events to show: a data.frame, or a list of rows, with
#'   `start`, the day (a Date, a date-time or `"YYYY-MM-DD"`); optionally
#'   `end`, the last day of an event spanning several, `title`, `body` (shown
#'   on hover), `id` (the row's number when absent) -- toastui's names --
#'   and, from Element's tag, `type` (`"primary"`, `"success"`, `"info"`,
#'   `"warning"`, `"danger"`) and `color`, a background colour of your own.
#'   Any other column travels with the event and comes back in the inputs.
#'   In a Shiny app whose events come from the server, render the calendar
#'   as an output: [el_calendar_output()]. A day cell of your own
#'   (`slots = list(dateCell = ...)`) replaces the one that draws them; call
#'   `eventsOn(data.day)` in it for the day's events.
#' @param editable Whether the user can change the events: double-click a
#'   day to add one, click an event to edit or delete it in a dialog, drag
#'   it to another day to move it (a span keeps its length).
#' @param event_labels The dialog's words, to change any of: a named list of
#'   `add`, `edit` (its titles), `title`, `start`, `end`, `type` (its fields),
#'   `save`, `delete`, `cancel` (its buttons) -- `list(add = "新建日程",
#'   save = "保存")`.
#'
#' @section Shiny inputs:
#' | Input | When | Value |
#' |---|---|---|
#' | `input$<id>` | on load and when a day is picked | the day, `"YYYY-MM-DD"` |
#' | `input$<id>_dates` | on load and when another month is shown | `list(current, start, end)`, Dates: the day the calendar is on and the first and last days drawn |
#' | `input$<id>_click` | an event is clicked | the event, a list with its dates as Dates |
#' | `input$<id>_add` | the user saves a new event (`editable`) | the event asked for, without an `id`: `list(start, end, title, type)` |
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
#'       start = Sys.Date() + c(0, 3),
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
#'           start = new$start,
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
  event_labels = NULL
) {
  .el_check_choices("el_calendar", environment())
  # mistakes are reported here, where the calendar is written
  .el_calendar_events(events)
  .el_calendar_labels(event_labels)
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
  event_labels = NULL
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
    ":model-value" = "elDate(value)",
    "@update:model-value" = "elPick",
    class = "el-calendar--events"
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
  # the event the dialog edits: a copy, or NULL while it is closed
  vue_data["eventForm"] <- list(NULL)
  vue_data["eventDragged"] <- list(NULL)
  vue_data$eventLabels <- .el_calendar_labels(event_labels)

  # A day cell of the user's own takes the place of ours, which draws the
  # day's events; theirs can call eventsOn(data.day) for the same list
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
  # the props go on the calendar itself: the markup is the calendar and
  # the dialog beside it
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
      parts$markup,
      if (!own_cell) list(.el_calendar_cell())
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
    markup = htmltools::tagList(calendar, .el_calendar_dialog()),
    data = c(vue_data, parts$data),
    dependency = parts$dependencies,
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
        )
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
#' call.
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
  event_labels = NULL
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
#' @param events `NULL`, a data.frame or a list of rows, with `start`;
#'   `end`, `title`, `body`, `type`, `color` and `id` optional, any other
#'   column kept.
#' @param arg The update argument the rows came in, which must give ids.
#' @return Rows, each with an `id` (the row's number when none is given)
#'   and days as `"YYYY-MM-DD"`.
#' @keywords internal
.el_calendar_events <- function(events, arg = NULL) {
  if (is.null(events)) {
    return(I(list()))
  }
  if (!is.data.frame(events)) {
    events <- tryCatch(
      do.call(rbind, lapply(events, as.data.frame, stringsAsFactors = FALSE)),
      error = function(e) {
        stop(
          "`events` must be a data.frame, or a list of rows, with `start`.",
          call. = FALSE
        )
      }
    )
  }
  if (!nrow(events)) {
    return(I(list()))
  }
  if (is.null(events$start)) {
    stop("`events` needs `start`: the day each is on.", call. = FALSE)
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
  for (col in intersect(c("start", "end"), names(events))) {
    events[[col]] <- .el_calendar_day(events[[col]])
  }
  .vue_rows(events)
}

#' Days as "YYYY-MM-DD", NA as NA
#' @noRd
.el_calendar_day <- function(x) {
  if (inherits(x, c("Date", "POSIXt"))) {
    out <- format(as.Date(x), "%Y-%m-%d")
  } else {
    out <- substr(as.character(x), 1, 10)
  }
  out[is.na(x)] <- NA
  out
}

# the methods the events layer adds, whose names a slot must not take
.el_calendar_methods <- c(
  "eventStyle",
  "eventsOn",
  "clickEvent",
  "openAdd",
  "saveEvent",
  "deleteEvent",
  "cancelEvent",
  "dragStart",
  "dropOn",
  "reportDates",
  "eventRequest",
  "shinyVueReceive"
)

#' The day cell: the day, and its events
#' @noRd
.el_calendar_cell <- function() {
  template(
    htmltools::tags$div(
      class = "el-calendar-cell",
      style = paste(
        "height: 100%; display: flex; flex-direction: column; gap: 2px;",
        "overflow: hidden;"
      ),
      `@dblclick` = "openAdd(data.day)",
      `@dragover.prevent` = NA,
      `@drop.prevent` = "dropOn(data.day)",
      htmltools::tags$span(
        class = "el-calendar-cell__day",
        "{{ Number(data.day.slice(8)) }}"
      ),
      htmltools::tags$div(
        class = "el-calendar-cell__events",
        style = paste(
          "flex: 1; overflow-y: auto; display: flex; flex-direction: column;",
          "gap: 2px;"
        ),
        el$tag(
          `v-for` = "ev in eventsOn(data.day)",
          `:key` = "ev.id",
          `:type` = "ev.type || 'primary'",
          size = "small",
          class = "el-calendar-event",
          style = paste(
            "width: 100%; justify-content: flex-start; cursor: pointer;",
            "overflow: hidden;"
          ),
          `:title` = "ev.body || ev.title",
          # a block of colour with no title is still named, for screen
          # readers
          `:aria-label` = "ev.title || ev.body || ev.start",
          `:color` = "ev.color",
          `:style` = "eventStyle(ev)",
          `:draggable` = "editable",
          `@dragstart` = "dragStart(ev, $event)",
          `@click.stop` = "clickEvent(ev)",
          "{{ ev.title }}"
        )
      )
    ),
    slot = "date-cell",
    scope = "{ data }"
  )
}

#' The dialog that adds, edits and deletes an event
#' @noRd
.el_calendar_dialog <- function() {
  field <- function(label, input) {
    el$form_item(`:label` = paste0("eventLabels.", label), input)
  }
  el$dialog(
    `:model-value` = "eventForm !== null",
    `@update:model-value` = "$event || cancelEvent()",
    `:title` = "eventForm && eventForm.id !== undefined ? eventLabels.edit : eventLabels.add",
    width = "420px",
    `append-to-body` = NA,
    class = "el-calendar-dialog",
    el$form(
      `v-if` = "eventForm",
      `label-width` = "64px",
      `@submit.prevent` = NA,
      field("title", el$input(`v-model` = "eventForm.title")),
      field(
        "start",
        el$date_picker(
          `v-model` = "eventForm.start",
          type = "date",
          `value-format` = "YYYY-MM-DD",
          `:clearable` = "false",
          style = "width: 100%"
        )
      ),
      field(
        "end",
        el$date_picker(
          `v-model` = "eventForm.end",
          type = "date",
          `value-format` = "YYYY-MM-DD",
          style = "width: 100%"
        )
      ),
      field(
        "type",
        el$select(
          `v-model` = "eventForm.type",
          el$option(
            `v-for` = "t in ['primary', 'success', 'info', 'warning', 'danger']",
            `:key` = "t",
            `:label` = "t",
            `:value` = "t"
          )
        )
      )
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
        `:disabled` = "!eventForm || !eventForm.title",
        "{{ eventLabels.save }}"
      )),
      "</template>"
    ))
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
  list(
    # a colour of the event's own: its border too, and the page's text
    eventStyle = JS(paste0(
      "function(ev) { return ev.color ? {borderColor: ev.color, ",
      "color: 'var(--el-text-color-primary)'} : null; }"
    )),
    eventsOn = JS(paste0(
      "function(day) { return (this.events || []).filter(function(e) { ",
      "var end = e.end || e.start; return e.start <= day && day <= end; }); }"
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
    clickEvent = JS(paste0(
      "function(ev) { var self = this; self.eventRequest('click', ev); ",
      "if (self.editable) self.eventForm = Object.assign({}, ev, ",
      "{end: ev.end || null}); }"
    )),
    openAdd = JS(paste0(
      "function(day) { if (!this.editable) return; ",
      "this.eventForm = {start: day, end: null, title: '', type: 'primary'}; }"
    )),
    cancelEvent = JS("function() { this.eventForm = null; }"),
    saveEvent = JS(paste0(
      "function() { var self = this, f = self.eventForm; if (!f || !f.title) return; ",
      "var ev = Object.assign({}, f); if (!ev.end || ev.end <= ev.start) ev.end = null; ",
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
      "function(ev, e) { if (!this.editable) { e.preventDefault(); return; } ",
      "this.eventDragged = ev.id; ",
      "if (e.dataTransfer) { e.dataTransfer.effectAllowed = 'move'; ",
      "e.dataTransfer.setData('text/plain', String(ev.id)); } }"
    )),
    # dropped on another day: moved there, a span keeping its length
    dropOn = JS(paste0(
      "function(day) { var self = this, id = self.eventDragged; ",
      "self.eventDragged = null; if (!self.editable || id === null) return; ",
      "var old = self.events.filter(function(e) { return e.id === id; })[0]; ",
      "if (!old || old.start === day) return; ",
      "var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; ",
      "var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; ",
      "var shift = parse(day) - parse(old.start); ",
      "var changes = {start: day}; if (old.end) changes.end = fmt(parse(old.end) + shift); ",
      "var ev = Object.assign({}, old, changes); ",
      "self.eventRequest('update', {event: old, changes: changes}, function() { ",
      "self.events.splice(self.events.indexOf(old), 1, ev); }); }"
    )),
    # the days shown, counted off the drawn month: Element's first day of
    # the week follows its locale
    reportDates = JS(sprintf(
      paste0(
        "function() { var self = this; self.$nextTick(function() { ",
        "var root = self.$el && self.$el.querySelectorAll ? self.$el : null; ",
        "if (!root || !window.Shiny || !Shiny.setInputValue) return; ",
        "var cells = root.querySelectorAll('.el-calendar-table td'); if (!cells.length) return; ",
        "var parse = function(s) { var p = s.split('-'); return Date.UTC(+p[0], +p[1] - 1, +p[2]); }; ",
        "var fmt = function(t) { return new Date(t).toISOString().slice(0, 10); }; ",
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

#' A calendar's message with its dates as Dates
#' @noRd
.el_calendar_dates <- function(x) {
  if (!is.list(x)) {
    return(x)
  }
  for (k in names(x)) {
    v <- x[[k]]
    if (k %in% c("date", "end", "start", "current")) {
      x[k] <- list(
        if (is.null(v) || identical(v, "")) NULL else as.Date(substr(v, 1, 10))
      )
    } else if (is.list(v)) {
      x[[k]] <- .el_calendar_dates(v)
    }
  }
  x
}

#' The event dialog's words, English unless given
#' @noRd
.el_calendar_labels <- function(labels = NULL) {
  words <- list(
    add = "New event",
    edit = "Edit event",
    title = "Title",
    start = "Date",
    end = "Until",
    type = "Type",
    save = "Save",
    delete = "Delete",
    cancel = "Cancel"
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
#'     start = Sys.Date() - c(9, 6, 2),
#'     title = c("", "", "Validated"),
#'     body = c("Raw data", "Archive", "Validated data"),
#'     color = c("lightgrey", "#EED5B7", "#E9C46B")
#'   )
#'   ui <- el_page(el_calendar_output("snapshot"), verbatimTextOutput("picked"))
#'   server <- function(input, output, session) {
#'     output$snapshot <- render_el_calendar(
#'       el_calendar(value = max(archive$start), events = archive)
#'     )
#'     output$picked <- renderPrint(input$snapshot_click$start)
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
