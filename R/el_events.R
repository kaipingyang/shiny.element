#' The Shiny inputs a component reports
#'
#' Every input a component can report, from one list: the ones it always
#' reports -- its value, and the requests the server answers -- and the
#' Element Plus events it forwards, some of them unasked (`default`) and the
#' rest when asked for with the component's `events` argument. Each is
#' `input$<id>_<event>`, the event in snake_case, namespaced in a module as
#' the component's id is.
#'
#' A component's help page lists the same in its "Shiny inputs" section, and
#' an unknown name given to `events` is an error that lists them.
#'
#' For an event not in the list -- a key with a modifier, a DOM event on the
#' element Element draws -- or to send something else than what an event
#' carries, give the component a handler of your own with `on`: see
#' [el_widget()].
#'
#' @param component A component function, or its name: `el_tree`,
#'   `"el_tree"` or `"tree"`.
#' @return A data frame, one row per input, of class `el_events`:
#'   \describe{
#'     \item{input}{The input, `input$<id>` or `input$<id>_<name>`.}
#'     \item{event}{What to give `events` to have it reported: Element's
#'       event in snake_case; `NA` for an input always reported.}
#'     \item{default}{`TRUE` when it is reported without being asked for.}
#'     \item{about}{When it is sent: Element's description of the event.}
#'     \item{value}{What it holds. Empty for an event whose arguments are
#'       sent as they are (see Details).}
#'     \item{args}{The event's arguments in Element.}
#'   }
#' @details
#' An event's arguments are sent as they are when nothing is said in
#' `value`: one as itself, several as `list(arg1, arg2, ...)`, none as
#' `TRUE`. Arguments that cannot travel -- DOM nodes, a component's internal
#' objects -- are dropped; a keyboard event is sent as `list(key, code,
#' ctrl, shift, alt, meta)`. Every event input is sent with `priority =
#' "event"`: an observer runs even when the value is the same as before.
#' @examples
#' el_events("el_tree")
#' el_events(el_input)
#'
#' # asking for an event
#' el_input("q", events = "keydown") # input$q_keydown
#' @export
el_events <- function(component) {
  fn <- .el_events_fn(component)
  entry <- .el_event_registry[[fn]]
  always <- lapply(entry$inputs, function(x) {
    data.frame(
      input = .el_input_name(x$input),
      event = NA_character_,
      default = TRUE,
      about = x$about,
      value = "",
      args = "",
      stringsAsFactors = FALSE
    )
  })
  forwarded <- lapply(entry$events, function(x) {
    snake <- gsub("-", "_", x$event, fixed = TRUE)
    data.frame(
      input = .el_input_name(snake),
      event = snake,
      default = x$default,
      about = x$about,
      value = x$value,
      args = x$args,
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, c(always, forwarded))
  if (is.null(out)) {
    out <- data.frame(
      input = character(),
      event = character(),
      default = logical(),
      about = character(),
      value = character(),
      args = character(),
      stringsAsFactors = FALSE
    )
  }
  rownames(out) <- NULL
  structure(out, class = c("el_events", "data.frame"), component = fn)
}

#' @export
print.el_events <- function(x, ...) {
  fn <- attr(x, "component")
  if (!nrow(x)) {
    cat(fn, "() reports no input.\n", sep = "")
    return(invisible(x))
  }
  show <- function(rows, title) {
    if (!nrow(rows)) {
      return()
    }
    cat(title, "\n", sep = "")
    what <- ifelse(nzchar(rows$value), rows$value, rows$about)
    width <- max(nchar(rows$input))
    cat(
      sprintf("  %-*s  %s", width, rows$input, what),
      sep = "\n"
    )
  }
  cat(fn, "() reports, as input$<id>...:\n\n", sep = "")
  show(x[x$default, , drop = FALSE], "Unasked")
  asked <- x[!x$default, , drop = FALSE]
  if (nrow(asked)) {
    cat("\n")
    show(asked, "When asked for, with `events =`")
    cat(
      "\n  ",
      fn,
      "(..., events = c(",
      paste0('"', utils::head(asked$event, 2), '"', collapse = ", "),
      "))\n",
      sep = ""
    )
  }
  invisible(x)
}

#' A component's name in the registry
#' @noRd
.el_events_fn <- function(component) {
  if (is.function(component)) {
    hit <- Filter(
      function(fn) {
        identical(component, get(fn, envir = asNamespace("shiny.element")))
      },
      names(.el_event_registry)
    )
    if (length(hit)) {
      return(hit[[1]])
    }
    hit <- Filter(
      function(fn) {
        identical(component, get(fn, envir = asNamespace("shiny.element")))
      },
      grep("^el_", getNamespaceExports("shiny.element"), value = TRUE)
    )
    if (!length(hit)) {
      stop("`component` must be a component function.", call. = FALSE)
    }
    return(hit[[1]])
  }
  if (!is.character(component) || length(component) != 1L) {
    stop(
      "`component` must be a component function or its name, as \"el_tree\".",
      call. = FALSE
    )
  }
  fn <- if (startsWith(component, "el_")) {
    component
  } else {
    paste0("el_", component)
  }
  fn <- gsub("-", "_", fn, fixed = TRUE)
  if (is.null(.el_event_registry[[fn]])) {
    # a component reporting nothing, as el_space()
    if (fn %in% getNamespaceExports("shiny.element")) {
      return(fn)
    }
    stop(
      sQuote(component),
      " is not a component reporting inputs. Those that do: ",
      toString(names(.el_event_registry)),
      ".",
      call. = FALSE
    )
  }
  fn
}

#' `input$<id>` or `input$<id>_<name>`
#' @noRd
.el_input_name <- function(suffix) {
  ifelse(nzchar(suffix), paste0("input$<id>_", suffix), "input$<id>")
}

#' The events a component forwards: its defaults and those asked for
#'
#' @param fn The component's function name.
#' @param asked The user's `events`: Element's names, in snake_case or
#'   kebab-case.
#' @return Element's names, kebab-case.
#' @noRd
.el_events_forwarded <- function(fn, asked = NULL) {
  entry <- .el_event_registry[[fn]]
  known <- vapply(entry$events, `[[`, "", "event")
  default <- known[vapply(entry$events, `[[`, TRUE, "default")]
  .vue_events_check(
    asked,
    known = known,
    default = default,
    what = paste0(fn, "()"),
    see = sprintf("See el_events(\"%s\").", fn)
  )
}

#' The "Shiny inputs" table of a component's help page
#'
#' Run by roxygen in each component's "Shiny inputs" section, from a chunk:
#' the table is the registry's, as [el_events()] prints it.
#'
#' @param fn The component's function name.
#' @return Markdown, one string.
#' @noRd
.el_events_md <- function(fn) {
  x <- el_events(fn)
  if (!nrow(x)) {
    return("None: it reports nothing.\n")
  }
  cell <- function(s) gsub("|", "\\|", s, fixed = TRUE)
  rows <- vapply(
    seq_len(nrow(x)),
    function(i) {
      r <- x[i, , drop = FALSE]
      sprintf(
        "| `%s` | %s | %s |",
        r$input,
        if (r$default) "unasked" else sprintf("`events = \"%s\"`", r$event),
        cell(if (nzchar(r$value)) r$value else r$about)
      )
    },
    ""
  )
  paste0(
    paste(
      c(
        "| Input | Reported | Value |",
        "|---|---|---|",
        rows,
        "",
        sprintf(
          "The same list as `el_events(\"%s\")`, which says how an event's arguments travel.",
          fn
        )
      ),
      collapse = "\n"
    ),
    "\n"
  )
}

#' The events a container reports, for its binding
#'
#' Tabs, collapse, dialog and drawer are markup driven by a Shiny binding of
#' their own, which reports an event only when its name is in the
#' container's `data-el-events`.
#'
#' @param fn The component's function name.
#' @param asked The user's `events`.
#' @return The events' input suffixes, space-separated.
#' @noRd
.el_events_attr <- function(fn, asked) {
  paste(
    gsub("-", "_", .el_events_forwarded(fn, asked), fixed = TRUE),
    collapse = " "
  )
}
