#' Set fields of a Vue component from the server
#'
#' The Vue layer's `update*Input()`: assigns fields of a component's state
#' -- its `data`, or what its `setup()` returned, or a [vue_store()]'s --
#' and the component, and every template showing them, follow. As with
#' Shiny's updaters, the component's value is reported back to
#' `input$<id>` afterwards, and the update is sent with the flush, after
#' the outputs ([flush_vue()]).
#'
#' A field given in `...` is replaced whole. A long list, or a deep object,
#' can be changed in place instead, sending only what changes:
#'
#' - `insert`, `replace`, `delete`: rows of a list field -- one field per
#'   call, `list(items = rows)`. Rows are a data.frame or a list of rows.
#'   `at` says where, counting from 1: the position `insert` goes before
#'   (the end when `NULL`), the positions `replace` and `delete` change. With
#'   `key`, rows are found by that field's value instead: `replace` puts
#'   each row in place of the one with its key (or at the end), and
#'   `delete = list(items = c("a", "c"))` takes away the rows with those
#'   keys.
#' - `set`: values at paths, `list("items[3].done" = TRUE, "user.name" =
#'   "Ann")` -- fields, then list positions counting from 1 and names.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id The component's id (un-namespaced).
#' @param ... Fields to set, `<field> = <value>`. A function is [JS()].
#' @param value The component's value: sets whichever field its `input`
#'   names.
#' @param insert,replace,delete Rows to insert, rows to put in place of
#'   others, or the rows to delete -- each `list(<field> = ...)`, one of
#'   them per call.
#' @param at Positions, counting from 1: where `insert` goes, which rows
#'   `replace` and `delete` change.
#' @param key A field the rows are found by, instead of positions.
#' @param set Values at paths, `list("<path>" = value)`.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @seealso [vue_app()], [call_vue()], [flush_vue()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   update_vue(id = "counter", value = 0)
#'   update_vue(id = "cart", note = "Free delivery today")
#'   # a list changed in place: one row added, one ticked
#'   update_vue(id = "todo", insert = list(items = list(text = "Call Ann")))
#'   update_vue(id = "todo", set = list("items[2].done" = TRUE))
#'   update_vue(id = "todo", delete = list(items = "t3"), key = "id")
#' }
#' @export
update_vue <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  ...,
  value = NULL,
  insert = NULL,
  replace = NULL,
  delete = NULL,
  at = NULL,
  key = NULL,
  set = NULL
) {
  .vue_check_session(session)
  fields <- list(...)
  if (
    length(fields) && (is.null(names(fields)) || any(!nzchar(names(fields))))
  ) {
    stop(
      "Fields must be named: `update_vue(session, id, n = 1)`.",
      call. = FALSE
    )
  }
  msg <- c(list(id = session$ns(id)), lapply(fields, .vue_rows))
  if (!missing(value)) {
    msg[".value"] <- list(.vue_rows(value))
  }
  edit <- .vue_edit(insert, replace, delete, at, key)
  if (!is.null(edit)) {
    msg$.edit <- edit
  }
  if (length(set)) {
    msg$.set <- .vue_set_paths(set)
  }
  .vue_send_update(session, msg)
}

#' The `.edit` of an update: one list field changed in place
#'
#' @param insert,replace,delete,at,key As for [update_vue()].
#' @return `NULL`, or `list(op, field, rows, at, key)`.
#' @keywords internal
.vue_edit <- function(insert, replace, delete, at, key) {
  given <- Filter(
    Negate(is.null),
    list(insert = insert, replace = replace, delete = delete)
  )
  if (!length(given)) {
    if (!is.null(at) || !is.null(key)) {
      stop(
        "`at` and `key` go with `insert`, `replace` or `delete`.",
        call. = FALSE
      )
    }
    return(NULL)
  }
  if (length(given) > 1L) {
    stop(
      "One of `insert`, `replace` and `delete` per update.",
      call. = FALSE
    )
  }
  op <- names(given)
  what <- given[[1]]
  if (!is.list(what) || length(what) != 1L || is.null(names(what))) {
    stop(
      "`",
      op,
      "` names the list it changes: `",
      op,
      " = list(items = ",
      if (op == "delete") "c(2, 5)" else "rows",
      ")`.",
      call. = FALSE
    )
  }
  if (!is.null(key) && (!is.character(key) || length(key) != 1L)) {
    stop("`key` must name one field of the rows.", call. = FALSE)
  }
  field <- names(what)
  if (op == "delete") {
    return(list(
      op = op,
      field = field,
      rows = NULL,
      at = I(what[[1]]),
      key = key
    ))
  }
  rows <- .vue_rows(what[[1]])
  # one row given as a named list is a list of one
  if (is.list(rows) && !is.null(names(rows)) && !is.data.frame(rows)) {
    rows <- list(rows)
  }
  if (!is.list(rows)) {
    rows <- as.list(rows)
  }
  if (op == "replace" && is.null(key) && length(at) != length(rows)) {
    stop("`replace` needs one position in `at` for each row.", call. = FALSE)
  }
  if (op == "insert" && length(at) > 1L) {
    stop("`insert` goes at one position.", call. = FALSE)
  }
  list(
    op = op,
    field = field,
    rows = I(unname(rows)),
    at = if (length(at)) I(at),
    key = key
  )
}

#' The `.set` of an update: values by path
#'
#' `"items[3].done"` is the field `items`, its third element (`2` from 0 in
#' the browser), its `done`.
#'
#' @param set A named list, path to value.
#' @return A list of `list(path, value)`.
#' @keywords internal
.vue_set_paths <- function(set) {
  if (!is.list(set) || is.null(names(set)) || any(!nzchar(names(set)))) {
    stop(
      "`set` names each path: `set = list(\"items[3].done\" = TRUE)`.",
      call. = FALSE
    )
  }
  unname(Map(
    function(path, value) {
      parts <- regmatches(
        path,
        gregexpr("\\[[0-9]+\\]|[^.\\[\\]]+", path, perl = TRUE)
      )[[1]]
      if (!length(parts) || grepl("^\\[", parts[1])) {
        stop(
          "`set`: ",
          sQuote(path),
          " must start with a field.",
          call. = FALSE
        )
      }
      path_out <- lapply(parts, function(p) {
        if (grepl("^\\[[0-9]+\\]$", p)) {
          as.integer(gsub("[^0-9]", "", p)) - 1L
        } else {
          p
        }
      })
      list(path = I(path_out), value = .vue_rows(value))
    },
    names(set),
    set
  ))
}

#' Call a method of a Vue component from the server
#'
#' [update_vue()] assigns data; a method is a function, reached with this.
#' The method is looked up on the component the template renders -- a
#' library table's `clearSelection()`, a child component's own -- or, with
#' `component`, on the first component of that name under the id.
#'
#' A method that returns something reports it as `input$<id>_<method>`,
#' the method name in snake_case; one that returns nothing reports `TRUE`.
#' The input has event priority, so the same answer twice still fires an
#' `observeEvent()`. A promise reports what it resolves to.
#'
#' @inheritParams update_vue
#' @param method The method's name.
#' @param args A list of arguments, passed in order.
#' @param result Whether to report the return value. Default `TRUE`.
#' @param component Name of the component to look for under `id`, when the
#'   template renders more than one.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @seealso [update_vue()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$reset, call_vue(id = "form", method = "resetFields"))
#' }
#' @export
call_vue <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  method,
  args = list(),
  result = TRUE,
  component = NULL
) {
  .vue_check_session(session)
  if (!is.character(method) || length(method) != 1L || !nzchar(method)) {
    stop("`method` must be a single method name.", call. = FALSE)
  }
  if (!grepl("^[A-Za-z][A-Za-z0-9_]*$", method)) {
    stop(
      "`method` must be a plain method name, not ",
      sQuote(method),
      ".",
      call. = FALSE
    )
  }
  if (!is.list(args)) {
    args <- list(args)
  }
  ns_id <- session$ns(id)
  # with the flush, as updates are: see .vue_send()
  .vue_send(
    session,
    "shinyVueCall",
    list(
      id = ns_id,
      method = method,
      # Unnamed, so jsonlite writes an array and the arguments stay positional
      args = unname(args),
      component = component,
      input = if (isTRUE(result)) {
        paste0(
          ns_id,
          "_",
          tolower(gsub("([a-z0-9])([A-Z])", "\\1_\\2", method))
        )
      }
    )
  )
  invisible(NULL)
}

#' Answer a Vue component that asked the server
#'
#' A component that needs the server -- a lazy tree its children, a remote
#' search its matches -- asks with `shinyVue.ask(input, question)` in the
#' browser: the question arrives as an input, with a `request` number, and
#' the component waits for the answer. This sends it, or refuses (`failed`),
#' which rejects the component's promise.
#'
#' @inheritParams update_vue
#' @param request The question as it arrived, or its `request` number.
#' @param value The answer.
#' @param failed `TRUE` to refuse the request instead.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @seealso [vue_app()].
#' @examples
#' if (interactive()) {
#'   # inside a server function: a component asked input$places_query
#'   observeEvent(input$places_query, {
#'     q <- input$places_query
#'     vue_answer(
#'       id = "places",
#'       request = q,
#'       value = grep(q$text, cities, value = TRUE)
#'     )
#'   })
#' }
#' @export
vue_answer <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  request,
  value = NULL,
  failed = FALSE
) {
  .vue_check_session(session)
  number <- if (is.list(request)) request$request else request
  if (is.null(number)) {
    stop(
      "`request` must be the question the component asked, or its number.",
      call. = FALSE
    )
  }
  .vue_send_update(
    session,
    list(
      id = session$ns(id),
      .resolve = if (isTRUE(failed)) {
        list(request = number, failed = TRUE)
      } else {
        list(
          request = number,
          value = if (is.null(value)) list() else .vue_rows(value)
        )
      }
    )
  )
}
