# Server to browser: messages queued per session and sent with the flush,
# as Shiny's sendInputMessage() is.

#' Stop unless `session` is a Shiny session
#'
#' @param session What was given.
#' @param fn The calling function's name, for the message.
#' @return `session`, invisibly.
#' @keywords internal
.vue_check_session <- function(session, fn = NULL) {
  if (is.null(fn)) {
    fn <- tryCatch(deparse(sys.call(-1)[[1]]), error = function(e) {
      "the function"
    })
  }
  if (is.null(session)) {
    stop(
      sprintf(
        "`%s()` was called outside a Shiny session: there is no server to send to.",
        fn
      ),
      call. = FALSE
    )
  }
  if (is.atomic(session)) {
    # The argument the caller most likely meant to give first
    second <- tryCatch(
      names(formals(sys.function(-1)))[2],
      error = function(e) NULL
    )
    if (is.null(second) || is.na(second)) {
      second <- "id"
    }
    stop(
      sprintf(
        paste0(
          "`session` must be a Shiny session, not %s. It is the first argument; ",
          "to use the current session, name the rest: `%s(%s = ...)`."
        ),
        if (is.character(session)) {
          sprintf('"%s"', session[1])
        } else {
          class(session)[1]
        },
        fn,
        second
      ),
      call. = FALSE
    )
  }
  invisible(session)
}

#' Send fields to a component: the shinyVueUpdate message
#'
#' @param session A Shiny session.
#' @param msg `list(id =, <field> = <value>, ...)`; dot-keys are the bridge's.
#' @param immediate Send now rather than with the flush: see [.vue_send()].
#' @return `NULL`, invisibly.
#' @keywords internal
.vue_send_update <- function(session, msg, immediate = FALSE) {
  msg <- .vue_tags_as_html(msg)
  # Functions travel as source, listed by path, as a component's options do
  evals <- .vue_js_paths(msg)
  if (length(evals)) {
    msg[[".evals"]] <- I(evals)
  }
  .vue_send(session, "shinyVueUpdate", msg, immediate = immediate)
}

#' Send a message to the components, with the flush
#'
#' Shiny's own `update*Input()` queue their messages and send them with the
#' flush, after the outputs it recalculated (`sendInputMessage()`), as DT's
#' and leaflet's proxies do (`deferUntilFlush`). Updates and method calls do
#' the same: queued per session and sent once the flush is done, so a
#' component re-rendered and updated in one observer is updated after it is
#' drawn. A flush is requested, for a call from outside one -- a `later()`
#' callback. [flush_vue()] sends what is queued at once; a session without
#' `onFlushed()` (a test's mock) is sent to at once.
#'
#' @param session A Shiny session.
#' @param type The custom message's type.
#' @param msg The message.
#' @param immediate Send now: a progress, a feedback service.
#' @return `NULL`, invisibly.
#' @keywords internal
.vue_send <- function(session, type, msg, immediate = FALSE) {
  queue <- .vue_queue(session)
  if (isTRUE(immediate) || is.null(queue)) {
    session$sendCustomMessage(type, msg)
    return(invisible(NULL))
  }
  queue$messages[[length(queue$messages) + 1L]] <- list(type = type, msg = msg)
  if (!isTRUE(queue$armed)) {
    # a session that cannot be asked for a flush -- testServer()'s
    # MockShinySession says requestFlush() is "for internal use only" --
    # is sent to at once
    asked <- tryCatch(
      {
        session$requestFlush()
        TRUE
      },
      error = function(e) FALSE
    )
    if (!asked) {
      return(.vue_send_queued(session))
    }
    queue$armed <- TRUE
    session$onFlushed(
      function() {
        queue$armed <- FALSE
        .vue_send_queued(session)
      },
      once = TRUE
    )
  }
  invisible(NULL)
}

#' A session's queue of messages for the components
#'
#' One per session, in its `userData`, which a module's session shares with
#' the session it belongs to -- so messages from both keep their order.
#'
#' @param session A Shiny session.
#' @return An environment, or `NULL` for a session that cannot hold one
#'   until the flush.
#' @keywords internal
.vue_queue <- function(session) {
  if (
    !is.function(session$onFlushed) ||
      !is.function(session$requestFlush) ||
      !is.environment(session$userData)
  ) {
    return(NULL)
  }
  queue <- session$userData$.shiny_vue_queue
  if (is.null(queue)) {
    queue <- new.env(parent = emptyenv())
    queue$messages <- list()
    queue$armed <- FALSE
    session$userData$.shiny_vue_queue <- queue
  }
  queue
}

#' Send what is queued, in order
#' @param session A Shiny session.
#' @return `NULL`, invisibly.
#' @keywords internal
.vue_send_queued <- function(session) {
  queue <- .vue_queue(session)
  if (is.null(queue) || !length(queue$messages)) {
    return(invisible(NULL))
  }
  messages <- queue$messages
  queue$messages <- list()
  for (m in messages) {
    session$sendCustomMessage(m$type, m$msg)
  }
  invisible(NULL)
}

#' Send queued updates now
#'
#' Updates and method calls -- [update_vue()], [call_vue()], every
#' `update_el_*()` and `call_el()` -- are sent as Shiny's own
#' `update*Input()` are: with the flush, once the observer that made them,
#' and the rest of the flush, is done. An update made before a long
#' computation in the same observer therefore shows after it.
#' `flush_vue()` sends them at once: wrapped around the updates, it runs
#' them and sends what is queued; called alone, it sends what is queued so
#' far.
#'
#' Often there is a better way: a long computation in an
#' [shiny::ExtendedTask] leaves the observer at once, and the update goes
#' with that flush. A component library may send some updates at once by
#' their nature -- a progress bar, as [shiny::withProgress()] does.
#'
#' Only the components' messages are sent: outputs are still calculated
#' with the flush, as Shiny does.
#'
#' @param expr Code making updates, run before they are sent.
#' @param session Shiny session; the current one by default.
#' @return The value of `expr`, invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$run, {
#'     flush_vue({
#'       update_el_table(session, "tbl", loading = TRUE)
#'     })
#'     result <- slow_query()
#'     update_el_table(session, "tbl", data = result, loading = FALSE)
#'   })
#' }
#' @export
flush_vue <- function(
  expr = NULL,
  session = shiny::getDefaultReactiveDomain()
) {
  value <- expr
  .vue_check_session(session)
  .vue_send_queued(session)
  invisible(value)
}
