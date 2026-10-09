# The Vue layer's own helpers, knowing no component library. The
# component layers' helpers of the same jobs call these.

#' snake_case to camelCase
#'
#' @param x One name.
#' @return The name in camelCase.
#' @keywords internal
.vue_camel <- function(x) {
  parts <- strsplit(x, "_", fixed = TRUE)[[1]]
  paste0(
    parts[1],
    paste0(
      toupper(substring(parts[-1], 1, 1)),
      substring(parts[-1], 2),
      collapse = ""
    )
  )
}

#' A value restored from a bookmark, an array kept an array
#'
#' @param id The input's id.
#' @param default The value without a bookmark.
#' @return The restored value, or `default`.
#' @keywords internal
.vue_restore <- function(id, default) {
  value <- shiny::restoreInput(id = id, default = default)
  if (identical(value, default)) {
    return(default)
  }
  if (is.list(default) && is.null(names(default))) {
    return(if (is.null(value)) list() else as.list(value))
  }
  value
}

#' A data.frame as rows, as `v-for` walks it and table components take it
#'
#' Factors become strings; a dot in a name becomes an underscore, since a
#' template expression cannot name `a.b`. A data.frame further in -- a row's
#' list of rows, a cell of a list column -- is rows too, and a list column's
#' cell is its value, not a list of one; `NA` is `null`.
#'
#' The rows are written by jsonlite, as JSON kept verbatim (class `json`):
#' its `dataframe = "rows"` is one vectorised pass, where a list of row lists
#' took jsonlite seconds for a table-v2's ten thousand rows. A data.frame
#' holding tags or [JS()] in a list column is turned into row lists instead,
#' so they are rendered and revived as anywhere else.
#'
#' @param data A data.frame, a list holding some, or anything else
#'   (returned as is).
#' @return The rows: JSON of class `json`, or a list of row lists.
#' @keywords internal
.vue_rows <- function(data) {
  if (!is.data.frame(data)) {
    if (is.list(data) && !inherits(data, "json") && length(data)) {
      data[] <- lapply(data, .vue_rows)
    }
    return(data)
  }
  names(data) <- gsub("\\.", "_", names(data))
  special <- function(x) {
    inherits(x, c("shiny.tag", "shiny.tag.list", "html", "JS_EVAL"))
  }
  in_cells <- vapply(
    data,
    function(col) is.list(col) && any(vapply(col, special, logical(1))),
    logical(1)
  )
  if (!any(in_cells)) {
    return(jsonlite::toJSON(
      data,
      dataframe = "rows",
      auto_unbox = TRUE,
      null = "null",
      na = "null",
      digits = NA,
      POSIXt = "ISO8601",
      UTC = TRUE,
      rownames = FALSE,
      factor = "string"
    ))
  }
  nms <- names(data)
  lapply(seq_len(nrow(data)), function(i) {
    row <- lapply(nms, function(col) {
      column <- data[[col]]
      if (is.list(column)) {
        return(.vue_rows(column[[i]]))
      }
      val <- column[i]
      if (is.factor(val)) as.character(val) else val
    })
    names(row) <- nms
    row
  })
}

#' Tags inside a list rendered to HTML strings
#'
#' @param x Anything.
#' @return `x`, with every tag in it rendered.
#' @keywords internal
.vue_tags_as_html <- function(x) {
  if (inherits(x, c("shiny.tag", "shiny.tag.list"))) {
    return(as.character(htmltools::renderTags(x)$html))
  }
  if (is.list(x) && !is.data.frame(x) && length(x)) {
    attrs <- attributes(x)
    x[] <- lapply(x, .vue_tags_as_html)
    attributes(x) <- attrs
  }
  x
}

#' Paths of the JS() values in a nested list, for the browser to revive
#'
#' @param x A nested list.
#' @return Dot-separated paths, dots inside names escaped.
#' @keywords internal
.vue_js_paths <- function(x) {
  walk <- function(node, path) {
    if (is.list(node) && !inherits(node, "POSIXlt")) {
      n <- length(node)
      if (!n) {
        return(character(0))
      }
      nms <- names(node)
      if (is.null(nms)) {
        nms <- as.character(seq_len(n) - 1L)
      }
      nms <- gsub(".", "\\.", nms, fixed = TRUE)
      unlist(
        lapply(seq_len(n), function(i) {
          walk(
            node[[i]],
            if (is.null(path)) nms[i] else paste0(path, ".", nms[i])
          )
        }),
        use.names = FALSE
      )
    } else if (is.character(node) && inherits(node, "JS_EVAL")) {
      path
    } else {
      character(0)
    }
  }
  out <- walk(x, NULL)
  if (is.null(out)) character(0) else out
}

#' A component's spec as the JSON its host carries
#'
#' @param spec `options`, and `input`, `rate`, `type`, `use`, ...
#' @return The JSON, as a single string, safe inside a `<script>`.
#' @keywords internal
.vue_json <- function(spec) {
  spec <- .vue_tags_as_html(spec)
  spec$evals <- I(.vue_js_paths(spec))
  json <- jsonlite::toJSON(
    spec,
    auto_unbox = TRUE,
    null = "null",
    na = "null",
    digits = NA,
    force = TRUE,
    POSIXt = "ISO8601",
    UTC = TRUE,
    rownames = FALSE,
    keep_vec_names = TRUE,
    dataframe = "columns",
    json_verbatim = TRUE
  )
  gsub("</", "<\\/", as.character(json), fixed = TRUE)
}

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

#' A mounted hook reporting fields as Shiny inputs
#'
#' Sends each field once the socket is connected (a send before is dropped),
#' and again after every update (`_svReport`), as Shiny's own
#' `update*Input()` reports the new value.
#'
#' @param bindings `c(<inputId> = "<field or expression>")`.
#' @return A [JS()] function, with the bindings as its `vue_report`
#'   attribute.
#' @keywords internal
.vue_mounted_report <- function(bindings) {
  js_str <- function(x) {
    vapply(
      x,
      function(e) as.character(jsonlite::toJSON(e, auto_unbox = TRUE)),
      character(1),
      USE.NAMES = FALSE
    )
  }
  sends <- paste(
    sprintf(
      "window.Shiny && Shiny.setInputValue && Shiny.setInputValue(%s, self.%s);",
      js_str(names(bindings)),
      bindings
    ),
    collapse = " "
  )
  js <- JS(paste0(
    "function() { var self = this; ",
    "var send = function() { ",
    sends,
    " }; ",
    "if (window.Shiny && Shiny.shinyapp && ",
    "typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) ",
    "{ send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } ",
    # Not a watcher, which would report every keystroke of an input
    # documented to report on `change`. Chained, because components folded
    # into one instance share it.
    "var prev = self._svReport; ",
    "self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"
  ))
  attr(js, "vue_report") <- bindings
  js
}

#' Whether to load Vue's development build
#'
#' `options(shiny.vue.dev = TRUE)`, or `shiny.element.dev` as before.
#'
#' @return `TRUE` or `FALSE`.
#' @keywords internal
.vue_dev <- function() {
  isTRUE(getOption("shiny.vue.dev", getOption("shiny.element.dev", FALSE)))
}

#' jQuery, which the bridge's scripts are written against
#'
#' A Shiny page always has it; a page without Shiny -- R Markdown, a saved
#' file -- may not. jquerylib's, under the name Shiny's own uses, so a Shiny
#' page still loads one copy.
#'
#' @return An htmlDependency object.
#' @keywords internal
.vue_jquery_dependency <- function() {
  jquerylib::jquery_core(3)
}

#' Vue, as bundled with the package
#'
#' Vue 3, the global build with the template compiler, from `inst/vue3`:
#' components are compiled in the browser from their x-template. The
#' development build keeps Vue's warnings (`[Vue warn]`), which the production
#' build strips. It is versioned one step above the production build, so on a
#' page holding both, htmltools keeps the development one.
#'
#' @param dev Load `vue.global.js` rather than `vue.global.prod.js`.
#' @return An htmlDependency object.
#' @keywords internal
.vue_vue_dependency <- function(dev = .vue_dev()) {
  htmltools::htmlDependency(
    name = "vue",
    version = if (isTRUE(dev)) "3.5.43.1" else "3.5.43",
    src = "vue3",
    package = "shiny.element",
    script = if (isTRUE(dev)) "vue.global.js" else "vue.global.prod.js",
    all_files = FALSE
  )
}

#' The scripts the Vue layer needs
#'
#' jQuery, Vue and the bridge (`shiny-vue.js`).
#'
#' @return A list of htmlDependency objects.
#' @keywords internal
.vue_dependencies <- function() {
  list(
    .vue_jquery_dependency(),
    .vue_vue_dependency(),
    htmltools::htmlDependency(
      "shiny-vue",
      "1.0.0",
      src = system.file("js", package = "shiny.element"),
      script = "shiny-vue.js",
      all_files = FALSE
    )
  )
}
