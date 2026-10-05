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
.el_camel_case <- function(x) .vue_camel(x)

#' Forward Element Plus events to Shiny inputs
#'
#' Element's events carry different arguments each, some of them DOM nodes or
#' native events that cannot be serialised. Rather than write a handler per
#' event, each one is bound to a generated method that hands its arguments to
#' `shinyVue.emit()` (see `inst/js/shiny-vue.js`), which drops what cannot
#' travel and sets `input$<id>_<event>`.
#'
#' @param ns_id The namespaced element id.
#' @param events Character vector of Element event names, in kebab-case.
#' @param shapes Named list of JavaScript functions, one per event that
#'   carries more than one argument, turning the arguments into a single
#'   object. `this` is the Vue instance. Returning `undefined` skips that
#'   emission. Without a shape, several arguments are sent as `arg1`, `arg2`,
#'   ...
#' @param throttle Events that fire on every frame -- a scroll, a drag --
#'   sent at most every 200 ms, the last one always: the server hears where
#'   the scroll or the drag ended.
#' @return A list with `attrs` (to merge into the tag) and `methods` (to merge
#'   into the Vue options).
#' @keywords internal
.el_event_bindings <- function(
  ns_id,
  events,
  shapes = list(),
  throttle = character()
) {
  if (!length(events)) {
    return(list(attrs = list(), methods = list()))
  }
  method_name <- function(event) {
    parts <- strsplit(event, "-", fixed = TRUE)[[1]]
    paste0(
      "elEmit",
      paste0(
        toupper(substring(parts, 1, 1)),
        substring(parts, 2),
        collapse = ""
      )
    )
  }
  input_name <- function(event) gsub("-", "_", event, fixed = TRUE)

  attrs <- stats::setNames(
    lapply(events, method_name),
    paste0("@", events)
  )
  unknown <- setdiff(throttle, events)
  if (length(unknown)) {
    stop("`throttle` names events not forwarded: ", toString(unknown))
  }
  methods <- stats::setNames(
    lapply(events, function(event) {
      shape <- shapes[[event]]
      wait <- if (event %in% throttle) ", 200" else ""
      if (is.null(shape)) {
        return(JS(sprintf(
          "function() { window.shinyVue.emit('%s', '%s', arguments%s); }",
          ns_id,
          input_name(event),
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
        input_name(event),
        wait
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

#' An id for a component given none
#'
#' Drawn at random, and marked as such: [render_vue()] does not take a new
#' one, each render, for another component, as it does an id the author
#' gave.
#'
#' @param prefix The component's name, `"el_input"`.
#' @return The id, with attribute `generated`.
#' @keywords internal
.el_auto_id <- function(prefix) {
  structure(paste0(prefix, "_", uuid::UUIDgenerate()), generated = TRUE)
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
  generated <- attr(id, "generated")
  # Set by the package's own articles, which render many examples on one page:
  # two that both use "city" would otherwise share one id.
  prefix <- getOption("shiny.element.id_prefix")
  if (!is.null(prefix)) {
    id <- paste0(prefix, id)
  }
  attr(id, "generated") <- generated
  if (is.null(session)) {
    return(id)
  }
  warning(
    "`session` is deprecated in UI functions. Inside a module, wrap ",
    "the id in ns() instead, as for any Shiny input: ",
    "el_input(ns(\"name\")).",
    call. = FALSE
  )
  session$ns(id)
}

#' Build a Vue `mounted` hook that reports initial values to Shiny
#'
#' Element Plus components only emit `@change` on user interaction, and Vue
#' `watch` handlers do not fire on mount. Without this hook the corresponding
#' `input$<id>` stays `NULL` until the user first touches the component, unlike
#' standard Shiny inputs which report their value immediately.
#'
#' The send is deferred until `shiny:connected` when the socket is not up yet:
#' a component on a static page, or one mounted before Shiny connects, would
#' otherwise call `Shiny.setInputValue()` into nothing.
#'
#' @param bindings Named character vector. Names are fully namespaced Shiny
#'   input ids, values are Vue data field names read off the instance, e.g.
#'   `c(my_slider = "value")`.
#' @return A [JS()] function, the Vue `mounted` option.
#' @keywords internal
.el_mounted_init <- function(bindings) .vue_mounted_report(bindings)

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
  if (is.list(choices)) {
    return(choices)
  }

  if (!is.null(names(choices))) {
    return(mapply(
      function(label, value) list(value = value, label = label),
      names(choices),
      unname(choices),
      SIMPLIFY = FALSE,
      USE.NAMES = FALSE
    ))
  }

  lapply(choices, function(x) list(value = x, label = as.character(x)))
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
#' Element Plus's props fall back to their own defaults when passed `undefined`,
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
  if (is.null(alias)) {
    return(main)
  }
  if (!is.null(main) && !identical(main, alias)) {
    stop(
      sprintf(
        "`%s` and `%s` are the same argument; give one of them.",
        main_name,
        alias_name
      ),
      call. = FALSE
    )
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
.el_jquery_dependency <- function() .vue_jquery_dependency()


#' Vue, as bundled with the package
#'
#' Vue 3, the global build with the template compiler, from `inst/vue3`:
#' components are compiled in the browser from their x-template. The
#' development build keeps Vue's warnings (`[Vue warn]`), which the production
#' build strips. It is versioned one step above the production build, so on a
#' page holding both -- `el_page(dev = TRUE)` beside components that bring the
#' default -- htmltools keeps the development one.
#'
#' @param dev Load `vue.global.js` rather than `vue.global.prod.js`.
#' @return An htmlDependency object.
#' @keywords internal
.el_vue_dependency <- function(dev = .vue_dev()) .vue_vue_dependency(dev)

#' The scripts every Vue component needs
#'
#' jQuery, Vue, the generic bridge (`shiny-vue.js`: mounting, the Shiny input
#' binding, serialising values, forwarding events) and Element's side of it
#' (`el-events.js`), in load order.
#'
#' @return A list of htmlDependency objects.
#' @keywords internal
.el_vue_dependencies <- function() {
  js <- system.file("js", package = "shiny.element")
  c(
    .vue_dependencies(),
    list(htmltools::htmlDependency(
      "el-events",
      "1.0.0",
      src = js,
      script = "el-events.js",
      all_files = FALSE
    ))
  )
}


#' Serialise a component's Vue options for the page
#'
#' JSON with `NA` and `NULL` as `null` and single values
#' unboxed -- with the paths of every [JS()] listed in `evals`,
#' so the bridge can turn their source back into functions. `</` is escaped,
#' or a `header_html` holding `</b>` would end the script element early.
#'
#' @param spec The list to write: `options`, and `input`, `rate`, `type`.
#' @return The JSON, as a single string.
#' @keywords internal
.el_vue_json <- function(spec) .vue_json(spec)


#' A value as a bookmarked session left it
#'
#' [shiny::restoreInput()], keeping the shape the component expects: a field
#' that is an array stays one, so a restored one-item selection is not unboxed
#' to a string, and an empty selection comes back as an empty array rather
#' than `NULL`.
#'
#' @param id The input id, namespaced as the page has it.
#' @param default The value to use when nothing is being restored.
#' @return The restored value, or `default`.
#' @keywords internal
.el_restore <- function(id, default) .vue_restore(id, default)


#' Send an update to a component
#'
#' One message type for every component, handled by shiny-vue.js: the fields
#' a component declares are assigned, one it does not is refused with a
#' warning, and a component with more to do -- move a carousel, validate a
#' form -- does it in its `shinyVueReceive` method. `.action` names such an
#' operation.
#'
#' @param session A Shiny session.
#' @param msg The message: `id`, namespaced, and the fields to set.
#' @return `NULL`, invisibly.
#' @keywords internal
.el_send_update <- function(session, msg) .vue_send_update(session, msg)


#' Add a label or error to an update
#'
#' The form item a labelled input is drawn in has no Vue field of its own:
#' its label and message are markup around the component. They travel as the
#' bridge's own keys, `.label` and `.error`, which el-events.js draws.
#'
#' @param msg The update message.
#' @param label New label: text, tags or `HTML()`, or `NULL`.
#' @param error New error message, `""` to clear it, or `NULL`.
#' @return The message.
#' @keywords internal
.el_form_item_update <- function(msg, label = NULL, error = NULL) {
  # Markup -- tags or HTML() -- goes as HTML, as Shiny's update*Input()
  # takes it; anything else as text
  if (!is.null(label)) {
    msg[[".label"]] <- if (
      inherits(label, c("shiny.tag", "shiny.tag.list", "html"))
    ) {
      list(html = as.character(htmltools::renderTags(label)$html))
    } else {
      as.character(label)
    }
  }
  if (!is.null(error)) {
    msg[[".error"]] <- as.character(error)
  }
  msg
}


#' Check a server function was given a session
#'
#' Every server function takes the session first, defaulting to the current
#' one, as Shiny's `update*Input()` do -- so `update_el_input("name", ...)`
#' passes the id as the session. Shiny stops that with a message naming the
#' function; so does this, rather than failing on `$` inside.
#'
#' @param session What was passed as `session`.
#' @param fn The calling function's name.
#' @return `session`, invisibly.
#' @keywords internal
.el_check_session <- function(session, fn = NULL) {
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

#' Element Plus's close icon, as its components draw it
#'
#' Icons are SVG components in Element Plus. A panel drawn as markup -- a
#' dialog, a drawer -- draws the same SVG itself.
#'
#' @param class The icon's own class, beside `el-icon`.
#' @return An `<i>` tag holding the SVG.
#' @keywords internal
.el_close_icon <- function(class) {
  htmltools::tags$i(
    class = paste("el-icon", class),
    htmltools::HTML(paste0(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">',
      '<path fill="currentColor" d="M764.288 214.592 512 466.88 259.712 214.592a31.936 ',
      '31.936 0 0 0-45.12 45.12L466.752 512 214.528 764.224a31.936 31.936 0 1 0 45.12 ',
      '45.184L512 557.184l252.288 252.288a31.936 31.936 0 0 0 45.12-45.12L557.12 ',
      '512.064l252.288-252.352a31.936 31.936 0 1 0-45.12-45.184z"></path></svg>'
    ))
  )
}

#' A slot's content, in Vue 3's syntax
#'
#' `<template v-slot:name>` -- Vue 3 has no `slot="name"` attribute, and an
#' element carrying one is rendered into the default slot instead.
#'
#' @param name The slot's name.
#' @param ... Its content.
#' @param scope The scope's name or destructuring, for a scoped slot.
#' @return A template tag.
#' @keywords internal
.el_slot <- function(name, ..., scope = NULL) {
  htmltools::tag(
    "template",
    c(
      stats::setNames(
        list(if (is.null(scope)) NA else scope),
        paste0("v-slot:", name)
      ),
      list(...)
    )
  )
}

#' Tags in Vue data, as the HTML they stand for
#'
#' A field of a component's data travels as JSON, where a tag -- an item's
#' `content = tags$b("x")`, a column's header -- would arrive as its
#' serialised object, and show as that, or as `[object Object]`. Every tag
#' and tag list found in the data is rendered to its HTML string instead,
#' which is what a `v-html` field reads; a field shown as text shows the
#' markup rather than an object.
#'
#' @param x A list of options or an update message.
#' @return `x`, with tags replaced by strings.
#' @keywords internal
.el_tags_as_html <- function(x) .vue_tags_as_html(x)

#' Markup as a string, for a `v-html` field
#'
#' A field read by `v-html` travels as JSON, where a tag would arrive as its
#' serialised object and show as text. Tags and tag lists are rendered to
#' their HTML first; a character value is taken as markup already.
#'
#' @param x A character string, tag, tag list or `HTML()`, or `NULL`.
#' @param arg The argument's name, for the error.
#' @return A single string, or `NULL`.
#' @keywords internal
.el_html_string <- function(x, arg = "html") {
  if (is.null(x)) {
    return(NULL)
  }
  if (
    inherits(x, c("shiny.tag", "shiny.tag.list")) ||
      (is.list(x) && !is.data.frame(x))
  ) {
    return(as.character(htmltools::renderTags(x)$html))
  }
  if (is.character(x)) {
    return(paste(x, collapse = ""))
  }
  stop(
    "`",
    arg,
    "` must be a string of HTML or htmltools tags, not ",
    class(x)[1],
    ".",
    call. = FALSE
  )
}

#' Check that items are a list of lists
#'
#' Components built from items -- tabs, panels, menu entries -- read each
#' item's fields with `$`, which on a string or a vector fails with R's own
#' "$ operator is invalid for atomic vectors". Saying what was expected is
#' more use.
#'
#' @param x The items as given; `NULL` and an empty list pass.
#' @param arg The argument's name, for the error.
#' @param fields The fields an item has, for the error.
#' @return `x`, invisibly.
#' @keywords internal
.el_check_items <- function(x, arg, fields) {
  if (is.null(x) || (is.list(x) && !length(x))) {
    return(invisible(x))
  }
  ok <- is.list(x) &&
    !is.data.frame(x) &&
    !inherits(x, c("shiny.tag", "shiny.tag.list")) &&
    all(vapply(
      x,
      function(i) is.list(i) && !inherits(i, "shiny.tag"),
      logical(1)
    ))
  if (!ok) {
    stop(
      "`",
      arg,
      "` must be a list of items, each a list such as ",
      "list(",
      paste0(fields, " = ...", collapse = ", "),
      "), not ",
      if (inherits(x, "shiny.tag")) "a tag" else class(x)[1],
      ".",
      call. = FALSE
    )
  }
  invisible(x)
}

#' Optional props, bound and given their data
#'
#' Element Plus's props that keep its own default unless given: each is bound
#' as `:kebab-name` to a field of the same camelCase name, through
#' [.el_optional_bind()], and the field holds the value or `NA` (read back
#' as `undefined`, Element's default).
#'
#' @param values A named list, names in snake_case as the R arguments are.
#' @param prefix A prefix for the fields' names, or `NULL`.
#' @param rename Named character vector: an argument's name, and the prop it
#'   stands for, where the two differ.
#' @return A list of `attrs` (for the tag) and `data` (for the Vue data).
#' @keywords internal
.el_props <- function(values, prefix = NULL, rename = NULL) {
  if (!length(values)) {
    return(list(attrs = list(), data = list()))
  }
  # An argument named apart from its prop -- a watermark's `width` would
  # be the component's own -- maps to the prop's upstream name
  upstream <- names(values)
  hit <- upstream %in% names(rename)
  upstream[hit] <- gsub("-", "_", rename[upstream[hit]])
  names(values) <- upstream
  camel <- vapply(names(values), .el_camel_case, "")
  # A wrapper that absorbs a trigger keeps its fields apart from the
  # trigger's own: tipPlacement, not placement
  if (!is.null(prefix)) {
    camel <- paste0(
      prefix,
      toupper(substring(camel, 1, 1)),
      substring(camel, 2)
    )
  }
  kebab <- gsub("_", "-", names(values), fixed = TRUE)
  attrs <- stats::setNames(lapply(camel, .el_optional_bind), paste0(":", kebab))
  # A picker's default value and time are Dates; from R they are text, made
  # into Dates in the browser by $elDate (el-events.js)
  for (k in which(names(values) %in% c("default_value", "default_time"))) {
    attrs[[k]] <- sprintf("$elDate(%s)", camel[[k]])
  }
  # A virtual-ref is an element; from R it is a CSS selector, looked up in
  # the browser by $elRef (el-events.js). Giving one turns on
  # virtual-triggering, which Element Plus needs to use it.
  vref <- which(names(values) == "virtual_ref")
  if (length(vref)) {
    attrs[[vref]] <- sprintf("$elRef(%s)", camel[[vref]])
    vtrig <- which(names(values) == "virtual_triggering")
    if (!is.null(values[[vref]]) && length(vtrig) && is.null(values[[vtrig]])) {
      values[vtrig] <- list(TRUE)
    }
  }
  list(attrs = attrs, data = stats::setNames(.el_prop_values(values), camel))
}

#' Props' values as the component's fields hold them
#'
#' `NULL` is `NA`, the placeholder that falls back to Element's default; a
#' prop Element Plus takes only as an array stays one when R gives a single
#' value (jsonlite would write "1" for c(1), and a tree-v2 handed a string
#' for its default-expanded-keys fails to mount); a data.frame is rows.
#'
#' @param values Named list, by the props' R names.
#' @return The list, values prepared.
#' @keywords internal
.el_prop_values <- function(values) {
  arrays <- names(values) %in% .el_array_props & vapply(values, is.atomic, TRUE)
  values[arrays] <- lapply(values[arrays], function(v) {
    if (is.null(v) || inherits(v, "JS_EVAL")) v else as.list(v)
  })
  lapply(values, function(v) if (is.null(v)) NA else .vue_rows(v))
}

#' Props Element Plus takes only as arrays
#'
#' From its API tables: those typed `Array` with no string, number or boolean
#' alternative. [.el_props()] keeps a length-one vector given for one of them
#' an array.
#'
#' @keywords internal
.el_array_props <- c(
  "button_texts",
  "colors",
  "default_checked_keys",
  "default_expanded_keys",
  "default_openeds",
  "empty_values",
  "expand_row_keys",
  "expanded_row_keys",
  "default_expanded_row_keys",
  "fallback_placements",
  "filtered_value",
  "gap",
  "icons",
  "left_default_checked",
  "right_default_checked",
  "page_sizes",
  "predefine",
  "preview_src_list",
  "range",
  "texts",
  "titles",
  "trigger_keys",
  "url_list"
)

#' An icon, as Element Plus names it
#'
#' Icons are components in Element Plus, given by name -- `"Search"`,
#' `"ArrowRight"` -- where Element UI took a class, `"el-icon-search"`. A class
#' in Element UI's form is turned into the name, so code written for either
#' works; anything else is passed through.
#'
#' @param x An icon name, an Element UI icon class, or `NULL`.
#' @return The Element Plus name, or `x` unchanged.
#' @keywords internal
.el_icon_name <- function(x) {
  if (!is.character(x) || length(x) != 1L || !grepl("^el-icon-", x)) {
    return(x)
  }
  parts <- strsplit(sub("^el-icon-", "", x), "-", fixed = TRUE)[[1]]
  name <- paste0(
    toupper(substring(parts, 1, 1)),
    substring(parts, 2),
    collapse = ""
  )
  # Element UI names that Element Plus spells differently
  renamed <- c(
    STools = "Tools",
    UserSolid = "UserFilled",
    StarOn = "StarFilled",
    StarOff = "Star",
    More = "MoreFilled",
    Error = "CircleCloseFilled",
    Success = "CircleCheckFilled",
    Warning = "WarningFilled",
    Info = "InfoFilled",
    Question = "QuestionFilled"
  )
  if (name %in% names(renamed)) renamed[[name]] else name
}

#' A date format in day.js's tokens
#'
#' Element Plus formats dates with day.js (`YYYY-MM-DD`, `x` for a
#' timestamp); Element UI used its own tokens (`yyyy-MM-dd`, `timestamp`).
#' The year and day tokens are the ones that differ.
#'
#' @param x A format, or `NULL`.
#' @return `x` in day.js's tokens.
#' @keywords internal
.el_dayjs_format <- function(x) {
  if (!is.character(x) || length(x) != 1L) {
    return(x)
  }
  if (identical(x, "timestamp")) {
    return("x")
  }
  x <- gsub("yyyy", "YYYY", x, fixed = TRUE)
  x <- gsub("yy", "YY", x, fixed = TRUE)
  gsub("(?<![D])dd(?!d)", "DD", x, perl = TRUE)
}

#' An icon inside a component's template
#'
#' Where Vue compiles the markup -- a menu, a dropdown, a slot -- an icon is
#' Element Plus's own `<el-icon>` holding the icon component. A tag is passed
#' through.
#'
#' @param x An icon's name (any form [el_icon()] takes), or a tag.
#' @return Markup.
#' @keywords internal
.el_vue_icon <- function(x) {
  if (!is.character(x)) {
    return(x)
  }
  htmltools::HTML(sprintf("<el-icon><%s /></el-icon>", .el_icon_pascal(x)))
}


#' Props an update function was given, as the component's fields
#'
#' `update_el_<name>()` takes `el_<name>()`'s arguments under the same names.
#' Each sets the component's field of that name in camelCase (`table_layout`
#' -> `tableLayout`) -- the field the prop is bound to, `NA` standing for
#' Element's default -- or the field `rename` names. An argument the UI
#' function does not have, or one that cannot change once drawn (`skip`), is
#' an error; enumerated ones are checked as the UI function checks them.
#'
#' @param fn The UI function's name, `"el_table"`.
#' @param dots The props given, named by their R names; leave out those the
#'   caller left `NULL`.
#' @param skip Arguments of `fn` an update cannot set this way.
#' @param rename `c(<argument> = "<field>")` for a field named otherwise.
#' @return A named list: field -> value.
#' @keywords internal
.el_update_props <- function(
  fn,
  dots,
  skip = character(),
  rename = character()
) {
  if (!length(dots)) {
    return(list())
  }
  nms <- names(dots)
  if (is.null(nms) || any(!nzchar(nms))) {
    stop(
      "Arguments of `",
      fn,
      "()` must be named: `stripe = TRUE`.",
      call. = FALSE
    )
  }
  fixed <- c("id", "session", "slots", "width", skip)
  known <- setdiff(names(formals(get(fn))), fixed)
  bad <- setdiff(nms, known)
  if (length(bad)) {
    stop(
      paste(sQuote(bad), collapse = ", "),
      if (length(bad) == 1L) " is not" else " are not",
      " an argument of `",
      fn,
      "()` an update can set.",
      call. = FALSE
    )
  }
  .el_check_choices(fn, list2env(dots[!vapply(dots, is.null, TRUE)]))
  fields <- vapply(nms, .el_camel_case, "")
  hit <- nms %in% names(rename)
  fields[hit] <- rename[nms[hit]]
  stats::setNames(.el_prop_values(dots), fields)
}
