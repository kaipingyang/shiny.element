# Events: a component's events forwarded to Shiny inputs, and handlers of
# the user's own, for any component library, which gives the names of the
# events it forwards (its registry), checked with .vue_events_check().

#' Forward a component's events to Shiny inputs
#'
#' Events carry different arguments each, some of them DOM nodes or native
#' events that cannot be serialised. Rather than write a handler per event,
#' each one is bound to a generated method that hands its arguments to
#' `shinyVue.emit()` (see `inst/js/shiny-vue.js`), which drops what cannot
#' travel and sets `input$<id>_<event>`.
#'
#' @param ns_id The namespaced element id.
#' @param events The events forwarded, by their Vue names (kebab-case).
#' @param on The user's own handlers: see [.vue_on_bindings()].
#' @param shapes Named list of JavaScript functions, one per event that
#'   carries more than one argument, turning the arguments into a single
#'   object. `this` is the Vue instance. Returning `undefined` skips that
#'   emission. Without a shape, several arguments are sent as `arg1`, `arg2`,
#'   ...
#' @param throttle Events that fire on every frame -- a scroll, a drag --
#'   sent at most every 200 ms, the last one always: the server hears where
#'   the scroll or the drag ended.
#' @param bound Events the component listens to whether or not they are
#'   reported, through the method of the same name, which it wraps: a tree's
#'   `check-change` keeps its checked keys.
#' @return A list with `attrs` (to merge into the tag) and `methods` (to merge
#'   into the Vue options).
#' @keywords internal
.vue_event_bindings <- function(
  ns_id,
  events,
  on = NULL,
  shapes = list(),
  throttle = character(),
  bound = character()
) {
  silent <- setdiff(bound, events)
  own <- .vue_on_bindings(ns_id, on)
  every <- c(events, silent)
  if (!length(every)) {
    return(own)
  }
  method_name <- function(event) {
    parts <- strsplit(event, "-", fixed = TRUE)[[1]]
    paste0(
      "svEmit",
      paste0(
        toupper(substring(parts, 1, 1)),
        substring(parts, 2),
        collapse = ""
      )
    )
  }
  attrs <- stats::setNames(
    lapply(every, method_name),
    paste0("@", every)
  )
  methods <- stats::setNames(
    lapply(every, function(event) {
      if (event %in% silent) {
        return(JS("function() {}"))
      }
      shape <- shapes[[event]]
      wait <- if (event %in% throttle) ", 200" else ""
      to <- gsub("-", "_", event, fixed = TRUE)
      if (is.null(shape)) {
        return(JS(sprintf(
          "function() { window.shinyVue.emit('%s', '%s', arguments%s); }",
          ns_id,
          to,
          wait
        )))
      }
      # The shape runs with `this` as the Vue instance, so it can look a row
      # up in the instance's own data. A shape that returns undefined skips
      # that emission.
      JS(sprintf(
        paste0(
          "function() { var shape = %s; ",
          "var v = shape.apply(this, arguments); if (v === undefined) return; ",
          "window.shinyVue.emit('%s', '%s', [v]%s); }"
        ),
        shape,
        ns_id,
        to,
        wait
      ))
    }),
    vapply(every, method_name, character(1))
  )
  # the user's handler of an event forwarded too: both run
  tag <- .vue_on_attach(list(attribs = attrs), own)
  list(attrs = tag$attribs, methods = c(methods, own$methods))
}


#' The events forwarded: those on by default and those asked for
#'
#' @param asked The user's `events`, in snake_case or kebab-case.
#' @param known The component's events, kebab-case.
#' @param default Those reported unasked.
#' @param what The component, for the error: `"my_table()"`.
#' @param see Where to read about them, appended to the error.
#' @return The events, kebab-case.
#' @keywords internal
.vue_events_check <- function(
  asked,
  known,
  default = character(),
  what = "the component",
  see = NULL
) {
  if (is.null(asked)) {
    return(default)
  }
  if (!is.character(asked) || anyNA(asked)) {
    stop(
      "`events` must name events, as `events = \"",
      gsub("-", "_", if (length(known)) known[1] else "row_click"),
      "\"`.",
      call. = FALSE
    )
  }
  if (!is.null(names(asked)) && any(nzchar(names(asked)))) {
    stop(
      "`events` takes no names: each event is reported as ",
      "input$<id>_<event>. For an input of your own, give a handler with ",
      "`on`.",
      call. = FALSE
    )
  }
  kebab <- gsub("_", "-", asked, fixed = TRUE)
  unknown <- asked[!kebab %in% known]
  if (length(unknown)) {
    snake <- gsub("-", "_", known, fixed = TRUE)
    stop(
      paste(sQuote(unknown, FALSE), collapse = ", "),
      if (length(unknown) == 1L) {
        " is not an event of "
      } else {
        " are not events of "
      },
      what,
      ". ",
      if (length(snake)) {
        paste0("Its events: ", toString(snake), ". ")
      } else {
        "It forwards none; give a handler of your own with `on`. "
      },
      see,
      call. = FALSE
    )
  }
  union(default, kebab)
}

#' Handlers of the user's own, as `on`
#'
#' Each becomes a method the component's tag listens with: `@<event>`.
#' The handler is called with `report` first -- `report(name, value)` sets
#' `input$<id>_<name>` -- then the event's own arguments, and `this` the
#' Vue instance.
#'
#' @param ns_id The namespaced id.
#' @param on A named list of [JS()] functions.
#' @return A list with `attrs` and `methods`.
#' @keywords internal
.vue_on_bindings <- function(ns_id, on) {
  if (is.null(on) || !length(on)) {
    return(list(attrs = list(), methods = list()))
  }
  if (
    !is.list(on) ||
      is.null(names(on)) ||
      any(!nzchar(names(on))) ||
      anyDuplicated(names(on))
  ) {
    stop(
      "`on` must be a named list of JS() functions, one per event: ",
      "`on = list(\"keyup.enter\" = JS(\"function(report, e) { ... }\"))`.",
      call. = FALSE
    )
  }
  plain <- !vapply(on, inherits, TRUE, "JS_EVAL")
  if (any(plain)) {
    stop(
      "`on` takes JS() functions; ",
      paste(sQuote(names(on)[plain], FALSE), collapse = ", "),
      if (sum(plain) == 1L) " is" else " are",
      " not.",
      call. = FALSE
    )
  }
  events <- gsub("_", "-", names(on), fixed = TRUE)
  names(on) <- events
  method <- sprintf("svOn%d", seq_along(on))
  methods <- stats::setNames(
    lapply(on, function(f) {
      JS(sprintf(
        paste0(
          "function() { var report = function(name, value) { ",
          "window.shinyVue.emit('%s', String(name), [value === undefined ? true : value]); }; ",
          "return (%s).apply(this, [report].concat(Array.prototype.slice.call(arguments))); }"
        ),
        ns_id,
        f
      ))
    }),
    method
  )
  list(
    attrs = stats::setNames(as.list(method), paste0("@", events)),
    methods = methods
  )
}

#' Add `on` handlers to a tag, beside any it already listens with
#'
#' A tag carries one `@<event>`: where the component already listens to
#' that event -- one it forwards -- both run, its own first.
#'
#' @param tag The component's tag.
#' @param on Output of `.vue_on_bindings()`.
#' @return The tag.
#' @keywords internal
.vue_on_attach <- function(tag, on) {
  for (key in names(on$attrs)) {
    given <- tag$attribs[[key]]
    if (is.null(given)) {
      tag$attribs[[key]] <- on$attrs[[key]]
      next
    }
    if (!grepl("^[A-Za-z_$][A-Za-z0-9_$]*$", given)) {
      stop(
        "`on` cannot handle ",
        sQuote(sub("^@", "", key), FALSE),
        ": the component handles it itself.",
        call. = FALSE
      )
    }
    tag$attribs[[key]] <- sprintf(
      "(...a) => { %s(...a); %s(...a); }",
      given,
      on$attrs[[key]]
    )
  }
  tag
}
