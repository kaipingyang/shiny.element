# 工具函数示例
#' Turn a snake_case name into camelCase
#'
#' Arguments are snake_case throughout this package, while Vue reads its props
#' in camelCase. Where a user writes the name themselves -- a key in a column
#' definition, say -- both spellings have to work, or the snake_case one sits
#' in the object doing nothing.
#'
#' @param x A name.
#' @return The same name in camelCase.
#' @keywords internal
.el_camel_case <- function(x) {
  parts <- strsplit(x, "_", fixed = TRUE)[[1]]
  paste0(parts[1], paste0(toupper(substring(parts[-1], 1, 1)),
                          substring(parts[-1], 2), collapse = ""))
}

#' Forward Element UI events to Shiny inputs
#'
#' Element's events carry different arguments each, some of them DOM nodes or
#' native events that cannot be serialised. Rather than write a handler per
#' event, each one is bound to a generated method that hands its arguments to
#' `shinyElement.emit()` (see `inst/js/el-events.js`), which drops what cannot
#' travel and sets `input$<id>_<event>`.
#'
#' @param ns_id The namespaced element id.
#' @param events Character vector of Element event names, in kebab-case.
#' @param shapes Named list of JavaScript functions, one per event that
#'   carries more than one argument, turning the arguments into a single
#'   object. `this` is the Vue instance. Returning `undefined` skips that
#'   emission. Without a shape, several arguments are sent as `arg1`, `arg2`,
#'   ...
#' @return A list with `attrs` (to merge into the tag) and `methods` (to merge
#'   into the Vue options).
#' @keywords internal
.el_event_bindings <- function(ns_id, events, shapes = list()) {
  if (!length(events)) {
    return(list(attrs = list(), methods = list()))
  }
  method_name <- function(event) {
    parts <- strsplit(event, "-", fixed = TRUE)[[1]]
    paste0("elEmit", paste0(toupper(substring(parts, 1, 1)), substring(parts, 2),
                            collapse = ""))
  }
  input_name <- function(event) gsub("-", "_", event, fixed = TRUE)

  attrs <- stats::setNames(
    lapply(events, method_name),
    paste0("@", events)
  )
  methods <- stats::setNames(
    lapply(events, function(event) {
      shape <- shapes[[event]]
      if (is.null(shape)) {
        return(htmlwidgets::JS(sprintf(
          "function() { window.shinyElement.emit('%s', '%s', arguments); }",
          ns_id, input_name(event)
        )))
      }
      # The shape runs with `this` as the Vue instance, so it can look a row
      # up in the instance's own data.
      # A shape that returns undefined skips that emission -- how a
      # high-frequency event is throttled.
      htmlwidgets::JS(sprintf(
        paste0("function() { var shape = %s; ",
               "var v = shape.apply(this, arguments); if (v === undefined) return; ",
               "window.shinyElement.emit('%s', '%s', [v]); }"),
        shape, ns_id, input_name(event)
      ))
    }),
    vapply(events, method_name, character(1))
  )
  list(attrs = attrs, methods = methods)
}

#' Placeholder for an unset optional prop
#'
#' A field left out of the Vue instance's `data` is not reactive, so
#' `update_el_*()` can never set it later. Unset optional props are therefore
#' declared as `NA`, which serialises to `null`, and read back through
#' [.el_optional_bind()], which turns that `null` into `undefined` so Element
#' applies its own default.
#'
#' @param x A value, or `NULL` when the user did not supply one.
#' @return `x`, or `NA` when `x` is `NULL`.
#' @keywords internal
.el_or_na <- function(x) {
  if (is.null(x)) NA else x
}

#' The id a UI function gives its component
#'
#' A UI function does not namespace its `id`, any more than
#' [shiny::textInput()] does: inside a module the caller writes `ns("name")`.
#' Namespacing from the default reactive domain, as every component once did,
#' namespaced twice whenever UI was built inside a module's server --
#' `renderUI()` -- turning `ns("name")` into `"mod-mod-name"`, an input that
#' never reported and said nothing about it.
#'
#' A session given explicitly is still honoured, with a warning, for code
#' written against the old behaviour.
#'
#' @param id The id as given.
#' @param session `NULL`, or a session passed by the caller.
#' @return The id the component uses.
#' @keywords internal
.el_ui_id <- function(id, session = NULL) {
  # Set by the package's own articles, which render many examples on one page:
  # two that both use "city" would otherwise share one id.
  prefix <- getOption("shiny.element.id_prefix")
  if (!is.null(prefix)) id <- paste0(prefix, id)
  if (is.null(session)) return(id)
  warning("`session` is deprecated in UI functions. Inside a module, wrap ",
          "the id in ns() instead, as for any Shiny input: ",
          "el_input(ns(\"name\")).", call. = FALSE)
  session$ns(id)
}

#' Build a Vue `mounted` hook that reports initial values to Shiny
#'
#' Element UI components only emit `@change` on user interaction, and Vue
#' `watch` handlers do not fire on mount. Without this hook the corresponding
#' `input$<id>` stays `NULL` until the user first touches the widget, unlike
#' standard Shiny inputs which report their value immediately.
#'
#' The send is deferred until `shiny:connected` when the socket is not up yet:
#' htmlwidgets' `renderValue()` runs before the Shiny WebSocket is established,
#' and `Shiny.setInputValue()` called then is silently dropped.
#'
#' @param bindings Named character vector. Names are fully namespaced Shiny
#'   input ids, values are Vue data field names read off the instance, e.g.
#'   `c(my_slider = "value")`.
#' @return An [htmlwidgets::JS()] object for the Vue `mounted` option.
#' @keywords internal
.el_mounted_init <- function(bindings) {
  js_str <- function(x) {
    vapply(x, function(e) as.character(jsonlite::toJSON(e, auto_unbox = TRUE)),
           character(1), USE.NAMES = FALSE)
  }

  sends <- paste(
    sprintf("window.Shiny && Shiny.setInputValue && Shiny.setInputValue(%s, self.%s);", js_str(names(bindings)), bindings),
    collapse = " "
  )
  htmlwidgets::JS(paste0(
    "function() { var self = this; ",
    "var send = function() { ", sends, " }; ",
    "if (window.Shiny && Shiny.shinyapp && ",
    "typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) ",
    "{ send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } ",
    # Element raises `change` only for the user's own edits, so a value set by
    # update_el_*() showed on screen while input$<id> kept the old one --
    # unlike Shiny's update*Input(), whose new value is reported back. The
    # updaters call this once they have assigned. It is not a watcher, which
    # would report every keystroke of an input documented to report on
    # `change`. Chained, because absorbed components share one instance.
    "var prev = self._elReport; ",
    "self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"
  ))
}

#' Normalise `choices` into option configs
#'
#' Accepts a named vector (`c(Label = value)`), an unnamed vector, or a list
#' already shaped as `list(value = , label = )` items, and returns the list
#' form that `el-option` / `el-radio` / `el-checkbox` iterate over.
#'
#' The named branch deliberately does not require a character vector. It used
#' to, so `c(Beijing = 1, Shanghai = 2)` fell through to the unnamed branch:
#' the labels were lost (rendered as "1" and "2") and the surviving names
#' turned the serialised JSON into an object rather than the array `v-for`
#' expects.
#'
#' @param choices A named vector, an unnamed vector, or a list of configs.
#' @return An unnamed list of `list(value = , label = )` items.
#' @keywords internal
.el_normalize_choices <- function(choices) {
  # A list is assumed to be in option shape already.
  if (is.list(choices)) return(choices)

  if (!is.null(names(choices))) {
    return(mapply(
      function(label, value) list(value = value, label = label),
      names(choices), unname(choices),
      SIMPLIFY = FALSE, USE.NAMES = FALSE
    ))
  }

  lapply(choices, function(x) list(value = x, label = as.character(x)))
}

#' Build a component's JS handler dependency
#'
#' Every handler is paired with el-update.js, the shared updater it calls.
#' htmltools de-duplicates the shared entry, so listing it here rather than
#' relying on `el_page()` guarantees it is present and loaded first, whatever
#' the page is built from.
#'
#' @param name The component's handler name, e.g. `"input"` for
#'   `el-input-handler.js`.
#' @return A list of htmlDependency objects.
#' @keywords internal
.el_handler_dependency <- function(name) {
  js <- system.file("js", package = "shiny.element")

  list(
    .el_jquery_dependency(),
    htmltools::htmlDependency(
      name      = "el-invoke",
      version   = "1.0.0",
      src       = js,
      script    = "el-invoke.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name      = "el-events",
      version   = "1.0.0",
      src       = js,
      script    = "el-events.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name      = "el-update",
      version   = "1.0.0",
      src       = js,
      script    = "el-update.js",
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name      = paste0("el-", name, "-handler"),
      version   = "1.0.0",
      src       = js,
      script    = paste0("el-", name, "-handler.js"),
      all_files = FALSE
    )
  )
}

#' Inline style for a component's Vue mount point
#'
#' Vue mounts onto the `<div id="…_container">` each component renders, but it
#' does not remove that div: it stays in the document as a block-level box.
#' Every component therefore started on its own line, so two buttons or two
#' tags could never sit side by side without wrapping them in a grid.
#'
#' `display: contents` makes the box itself generate no layout, leaving the
#' component to take part in the surrounding flow with its own display — inline
#' for a button, block for an alert. The style is inline rather than in a
#' stylesheet so it cannot be switched off with `el_page(theme_css = NULL)`.
#'
#' @return A CSS declaration string.
#' @keywords internal
.el_host_style <- function() {
  "display: contents"
}

#' Vue binding for a prop that may be unset
#'
#' Element UI's props fall back to their own defaults when passed `undefined`,
#' but treat `null` as a value: an `el-select` bound to a null placeholder
#' renders an empty one instead of "请选择". R has no way to send `undefined`
#' through JSON, so an unsupplied field arrives as `null` and the expression
#' has to map it back.
#'
#' A conditional is used rather than `??` because a template expression is
#' evaluated at runtime, where a polyfill cannot help with syntax.
#'
#' @param field Name of the Vue data field.
#' @return A template expression yielding the field, or `undefined` when unset.
#' @keywords internal
.el_optional_bind <- function(field) {
  sprintf("%1$s === null ? undefined : %1$s", field)
}


#' Take an argument given under either of its two names
#'
#' The choice components take Shiny's names, `choices` and `selected`, and
#' Element's, `options` and `value`. Given both, the two must agree: letting
#' one silently win, as `colour <- color %||% colour` does, hides a call
#' that says two different things.
#'
#' @param main,alias The argument's values under each name.
#' @param main_name,alias_name The names, for the error message.
#' @return Whichever was given; `main` when neither was.
#' @keywords internal
.el_alias <- function(main, alias, main_name, alias_name) {
  if (is.null(alias)) return(main)
  if (!is.null(main) && !identical(main, alias)) {
    stop(sprintf("`%s` and `%s` are the same argument; give one of them.",
                 main_name, alias_name), call. = FALSE)
  }
  alias
}


#' jQuery, for the package's scripts
#'
#' Every handler and binding script is written against jQuery, which a Shiny
#' page always has. A page without Shiny -- R Markdown, Quarto, the package's
#' own website -- may not, and the scripts stopped at their first line. The
#' dependency is jquerylib's, under the name Shiny's own uses, so a Shiny page
#' still loads one copy, the newer.
#'
#' @return An htmlDependency object.
#' @keywords internal
.el_jquery_dependency <- function() {
  jquerylib::jquery_core(3)
}
