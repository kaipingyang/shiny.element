#' Set fields of a Vue component from the server
#'
#' The Vue layer's `update*Input()`: assigns fields of a component's state
#' -- its `data`, or what its `setup()` returned, or a [vue_store()]'s --
#' and the component, and every template showing them, follow. As with
#' Shiny's updaters, the component's value is reported back to
#' `input$<id>` afterwards.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id The component's id (un-namespaced).
#' @param ... Fields to set, `<field> = <value>`. A function is [JS()].
#' @param value The component's value: sets whichever field its `input`
#'   names.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @seealso [vue_app()], [call_vue()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   update_vue(id = "counter", value = 0)
#'   update_vue(id = "cart", note = "Free delivery today")
#' }
#' @export
update_vue <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  ...,
  value = NULL
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
  .vue_send_update(session, msg)
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
  session$sendCustomMessage(
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
