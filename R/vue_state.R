#' Vue's reactivity for the page: `ref()`, `reactive()`, `computed()`,
#' `watch()`
#'
#' State the page's components share, in the browser, made with Vue's own
#' functions -- the shapes Shiny's server has, on the other side:
#'
#' | Shiny (server) | Vue | Here (browser) | Read as |
#' |---|---|---|---|
#' | `reactiveVal()` | `ref()` | `vue_ref(id, value)` | `$vueRef.<id>` |
#' | `reactiveValues()` | `reactive()` | `vue_reactive(id, list())` | `$vueReactive.<id>.<field>` |
#' | `reactive()` | `computed()` | `vue_computed(id, expr)` | `$vueComputed.<id>` |
#' | `observe()` | `watch()` | `vue_watch(source, handler)` | -- |
#'
#' Each component is a Vue app of its own, and a template compiled in the
#' browser cannot import: what upstream shares through a module of refs,
#' these share through the names every app sees -- in templates, in
#' [v_bind()] and [v_model()] expressions, in `on` statements, and in a
#' component's `setup()` as `shinyVue.useRef(id)`, `useReactive(id)`,
#' `useComputed(id)`. A [vue_store()] is the same with Pinia's getters and
#' actions, for a whole piece of logic.
#'
#' Each is a component of the page with no markup, so the server reaches it
#' as any: `input = TRUE` reports it as `input$<id>` (a ref's and a
#' computed's value, a reactive's object), and `update_vue(session, id,
#' value = )` sets a ref, `update_vue(session, id, <field> = )` a
#' reactive's field.
#'
#' `vue_watch()` runs `handler` whenever `source` changes: Vue's inline
#' statement, with `$value` and `$oldValue`, or a [JS()] function of the two.
#' It acts in the browser -- a store set, a message from a component
#' library it is given with `use` -- and stops when it leaves the page.
#'
#' In a module, give the id as `ns("count")` and `ns` to the expressions
#' that read it, as for [v_bind()].
#'
#' @param id The state's name: `$vueRef.<id>`, and `input$<id>`.
#' @param value The initial value: for `vue_reactive()`, a named list.
#' @param expr,source A JavaScript expression over the page's state, a
#'   string: `"$vueRef.count * 2"`.
#' @param handler What `vue_watch()` runs: Vue's inline statement, a
#'   string, or a [JS()] function `function(value, oldValue)`.
#' @param immediate,deep As Vue's `watch()`: run once at the start; follow
#'   changes inside objects.
#' @param input Whether to report it as `input$<id>`.
#' @param use For `vue_watch()`, the Vue plugins its statement uses, as
#'   [vue_app()]'s: a component library's message service, for one.
#' @inheritParams v_bind
#' @return A tag to put on the page; it draws nothing.
#' @seealso [vue_store()]; [v_bind()], [v_model()] to bind arguments to
#'   them.
#' @examples
#' htmltools::tagList(
#'   vue_ref("count", 0),
#'   vue_computed("twice", "$vueRef.count * 2"),
#'   vue_watch(
#'     "$vueRef.count",
#'     "console.log('count is', $value)"
#'   ),
#'   vue_app(
#'     "counter",
#'     htmltools::tags$button(
#'       v_on(click = "$vueRef.count++"),
#'       "{{ $vueRef.count }} -> {{ $vueComputed.twice }}"
#'     )
#'   )
#' )
#' @name vue_reactivity
NULL

#' @rdname vue_reactivity
#' @export
vue_ref <- function(id, value = NULL, input = FALSE) {
  .vue_state_host(
    id,
    list(kind = "ref"),
    data = list(value = value),
    input = if (isTRUE(input)) "value"
  )
}

#' @rdname vue_reactivity
#' @export
vue_reactive <- function(id, value = list(), input = FALSE) {
  if (!is.list(value) || (length(value) && is.null(names(value)))) {
    stop("`value` must be a named list: the object's fields.", call. = FALSE)
  }
  .vue_state_host(
    id,
    list(kind = "reactive"),
    data = value,
    input = if (isTRUE(input)) "shinyVueValue"
  )
}

#' @rdname vue_reactivity
#' @export
vue_computed <- function(id, expr, ns = NULL, input = FALSE) {
  b <- v_bind(expr, ns)
  .vue_state_host(
    id,
    list(kind = "computed", expr = .vue_binding_spec(b)),
    input = if (isTRUE(input)) "value"
  )
}

#' @rdname vue_reactivity
#' @export
vue_watch <- function(
  source,
  handler,
  immediate = FALSE,
  deep = FALSE,
  ns = NULL,
  use = NULL
) {
  b <- v_bind(source, ns)
  if (
    !inherits(handler, "JS_EVAL") &&
      !(is.character(handler) && length(handler) == 1L && !is.na(handler))
  ) {
    stop(
      "`handler` must be Vue's inline statement, a string, or a JS() function.",
      call. = FALSE
    )
  }
  .vue_state_host(
    .vue_auto_id("vue_watch"),
    list(
      kind = "watch",
      source = .vue_binding_spec(b),
      handler = if (inherits(handler, "JS_EVAL")) handler else unclass(handler),
      statement = !inherits(handler, "JS_EVAL"),
      immediate = isTRUE(immediate),
      deep = isTRUE(deep)
    ),
    use = use
  )
}

# A host with no markup holding page state the bridge makes
.vue_state_host <- function(
  id,
  state,
  data = list(),
  input = NULL,
  use = NULL
) {
  .vue_app_spec(
    id = id,
    template = htmltools::tags$span(hidden = NA),
    data = data,
    options = list(),
    input = input,
    use = use,
    dependencies = list(),
    state = state
  )
}
