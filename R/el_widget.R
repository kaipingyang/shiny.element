#' Assemble a component: host, Vue instance, Shiny input binding
#'
#' Every control in this package has the same shape, and this builds it: a
#' host element carrying the id, the Element markup inside it, and the Vue
#' options beside them, which the package's bridge script compiles in place.
#' The host is a Shiny input binding, so it *is* the component to the rest of
#' Shiny -- `shinyjs::hide("id")` hides it, `removeUI("#id")` removes it and
#' destroys its Vue instance, and its value is `input$<id>`.
#'
#' Reach for it to wrap an Element component this package does not cover, or
#' to build an input of your own from [el] tags; `input` names the value.
#' It is what the package's own components are made of: [vue_app()] with
#' Element Plus installed (`use`), and a label in Element's form-item style.
#'
#' The raw Element tags come from [el], and [template()] writes a slot.
#'
#' @param id The element id -- inside a module, wrapped in `ns()`. It is the
#'   input id of the value `input` names.
#' @param markup The Element markup to mount on, usually one `htmltools::tag()`.
#' @param data The Vue instance's data. Every field that `update_el_*()` may
#'   set has to be declared here -- Vue does not track one that is not.
#' @param methods,watch,mounted,computed Vue options, included when not `NULL`.
#' @param emits Events the component sends with `$emit()`: each arrives as
#'   `input$<id>_<event>`, as for [vue_app()].
#' @param on Handlers of your own, for events the component does not report
#'   or to send something else than they carry: a named list of [JS()]
#'   functions, one per event -- Element's, by its name, or a DOM event of
#'   the element it draws, with Vue's modifiers (`"keyup.enter"`). Each is
#'   called with `report` first, then the event's arguments, `this` being
#'   the component's Vue instance; `report(name, value)` sets
#'   `input$<id>_<name>`, namespaced as the id is:
#'   `on = list("keyup.enter" = JS("function(report, e) {
#'   report('enter', e.target.value); }"))` reports `input$<id>_enter`. An
#'   event the component reports too runs both.
#' @param dependency htmlDependency objects to attach, beside Vue, Element
#'   Plus and the bridge, which every component carries.
#' @param head Tags to place before the host, such as a `<style>` block.
#' @param slots Named list of slot contents, one entry per Element slot:
#'   `list(title = tags$b("Bold"))` fills the `title` slot. A component given
#'   here is absorbed like any other ([.el_absorb()]). For a scoped slot,
#'   where Element hands the template its own data, write the template with
#'   [template()] and the value is used as it stands.
#' @param width Component width, as a CSS unit. Applied to the Element markup
#'   itself -- the host carries `display: contents` and generates no box, so a
#'   width set on it would do nothing.
#' @param input The field of `data` that is `input$<id>`, or several for one
#'   value made of them, as [vue_app()]'s `input`: the Shiny binding reads it
#'   on load and on every change, and a test driver or `shinyjs` sees it. An
#'   [update_vue()] from the server counts as a change.
#' @param label A label shown with the component, as Shiny's inputs have:
#'   text or a tag. `NULL`, the default, shows none. It is the component's
#'   accessible name too -- tied to it with `for` where the component has a
#'   native input that takes the id `<id>-input`, else with
#'   `aria-labelledby`.
#' @param label_position Where the label sits, as `el_form()`'s
#'   `label_position`: `"top"` (the default, as Shiny's labels sit), or
#'   beside the component, its text aligned `"left"` or `"right"` -- which
#'   shows once `label_width` gives the labels a common width.
#' @param label_width Width of a label beside the component, as a CSS unit,
#'   so that several line up. Element's `label-width`.
#' @param label_suffix Text after the label, such as `":"`. Element's
#'   `label-suffix`.
#' @param required Draw Element's red asterisk before the label. It marks the
#'   field; it does not check it -- shinyvalidate or [el_form()] does that.
#' @param error An error message shown under the component in Element's
#'   style, the field framed in red. Element's `error`.
#' @param show_message,inline_message Whether `error`'s message is shown, and
#'   whether beside the component rather than under it. Element's
#'   `show-message` and `inline-message`.
#' @param rate How often the value is sent while it changes:
#'   `list(policy = "debounce", delay = 250)`, as Shiny's `textInput()` does,
#'   or `"throttle"`. `NULL`, the default, sends every change.
#' @param absorbed The components folded into this one, by id: their fields
#'   as named here and the ref on each, so their updates reach them. Built by
#'   the package's wrappers; leave it `NULL`.
#' @param props Optional props from `.el_props()`: bound on the root tag of
#'   `markup`, with their fields added to `data`.
#' @param type An input type for [shiny::registerInputHandler()], which
#'   converts the value on its way into R.
#' @return A Shiny UI element with its dependencies attached.
#' @examples
#' # Wrapping el-avatar, which this package does not provide
#' my_avatar <- function(id, src, size = 50) {
#'   el_widget(
#'     id = id,
#'     markup = el$avatar(":src" = "src", ":size" = "size"),
#'     data = list(src = src, size = size)
#'   )
#' }
#' my_avatar("face", "https://example.org/face.png")
#'
#' # An input of your own: v-model keeps `value` in step with the control,
#' # and `input` makes it input$score -- on load, on change, and after
#' # update_vue(session, "score", value = 5) from the server.
#' el_widget(
#'   id = "score",
#'   markup = el$rate("v-model" = "value", ":max" = "max"),
#'   data = list(value = 3, max = 5),
#'   input = "value"
#' )
#' @export
el_widget <- function(
  id,
  markup,
  data,
  methods = NULL,
  watch = NULL,
  mounted = NULL,
  computed = NULL,
  emits = NULL,
  on = NULL,
  dependency = NULL,
  head = NULL,
  width = NULL,
  slots = NULL,
  input = NULL,
  rate = NULL,
  type = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  props = NULL,
  absorbed = NULL
) {
  container_id <- paste0(id, "_container")
  # the user's own handlers, on the component's own tag
  if (length(on)) {
    own <- .vue_on_bindings(id, on)
    markup <- .vue_on_attach(markup, own)
    methods <- c(methods, own$methods)
  }
  # Optional props from .el_props(): bound on the component's own tag, the
  # root of `markup`, with their fields in the data
  if (length(props$attrs)) {
    markup <- do.call(
      htmltools::tagAppendAttributes,
      c(list(markup), props$attrs)
    )
    data <- c(data, props$data)
  }
  label_position <- match.arg(label_position)

  if (length(slots)) {
    # A component in a slot joins this one's instance: its fields must not
    # land on this component's own (a progress's `type` on a button in it)
    filled <- .el_slot_markup(
      slots,
      taken = c(names(data), names(methods), names(computed))
    )
    markup <- .el_append_children(markup, filled$markup)
    data <- c(data, filled$data)
    absorbed <- c(absorbed, filled$absorbed)
    methods <- c(methods, filled$methods)
    watch <- c(watch, filled$watch)
    computed <- c(computed, filled$computed)
    # a component in a slot reports on load as it would on its own
    mounted <- .el_join_mounted(list(mounted, filled$mounted))
    dependency <- c(dependency, filled$dependencies)
  }
  # as written, with what the slots brought: what .el_absorb() folds into
  # another component, before the binding's own value is stripped below
  mounted_given <- mounted
  methods_given <- methods
  watch_given <- watch

  if (!is.null(width)) {
    markup <- .el_set_width(markup, width)
  }

  input_given <- input
  if (length(input_given)) {
    if (!is.character(input_given) || !all(input_given %in% names(data))) {
      stop("`input` must name fields of `data`.", call. = FALSE)
    }
  }

  # The field reported under the component's own id is its value, and goes
  # through the Shiny input binding. The package's components declare their
  # reported fields with .el_mounted_init(); a component of your own, with
  # `input`.
  input <- NULL
  init <- attr(mounted, "vue_report")
  if (!is.null(init)) {
    mounted <- NULL
    input <- unname(init[names(init) == id])
    rest <- init[names(init) != id]
    if (length(rest)) mounted <- .el_mounted_init(rest)
  }
  if (length(input_given) == 1L) {
    input <- input_given
  } else if (length(input_given) > 1L) {
    # one value of several fields: the binding reads an expression
    input <- sprintf(
      "({%s})",
      paste(sprintf("%s: %s", input_given, input_given), collapse = ", ")
    )
  }
  # Bookmarking: a restored session hands the value back, as every Shiny input
  # does through restoreInput(). An array stays an array -- a restored
  # selection of one would otherwise unbox to a string.
  if (
    length(input) &&
      grepl("^[A-Za-z_$][A-Za-z0-9_$]*$", input[[1]]) &&
      input[[1]] %in% names(data)
  ) {
    # `[<-` with a list, because `[[<-` with NULL would delete a field whose
    # default is NULL -- and Vue would then have no such field to bind
    data[input[[1]]] <- list(.el_restore(id, data[[input[[1]]]]))
  }

  # The value goes through the binding alone. A change handler that also
  # sends it under the component's own id would send it twice -- and, for a
  # typed value, unconverted, overwriting the Date the binding delivers.
  if (length(input) && (length(methods) || length(watch))) {
    # '<id>' or '<id>:<type>', the second for a typed value sent directly
    pattern <- sprintf(
      "window\\.Shiny && Shiny\\.setInputValue && Shiny\\.setInputValue\\((['\"])%s(:[A-Za-z0-9_.]+)?\\1, [^;]*\\);\\s*",
      gsub("([.\\-])", "\\\\\\1", id)
    )
    strip <- function(m) {
      if (!inherits(m, "JS_EVAL")) {
        return(m)
      }
      JS(gsub(pattern, "", as.character(m), perl = TRUE))
    }
    if (length(methods)) {
      methods <- lapply(methods, strip)
    }
    # A watcher sending it too would bypass the binding's rate policy -- a
    # debounced input reported on every keystroke
    if (length(watch)) watch <- lapply(watch, strip)
  }

  options <- list(data = data)
  for (nm in c("methods", "watch", "computed", "mounted")) {
    value <- get(nm)
    if (!is.null(value)) options[[nm]] <- value
  }
  if (length(emits)) {
    options$emits <- I(emits)
  }
  spec <- list(
    options = options,
    input = if (length(input)) input[[1]],
    rate = rate,
    type = type,
    # Element Plus, the icons and this package's template helpers: the
    # Element layer's plugin (el-events.js)
    use = .vue_use("shinyElement.plugin")
  )
  # the components folded into this one, which updates by their ids reach
  # here (.el_absorb())
  if (length(absorbed)) {
    spec$absorbed <- absorbed
  }
  # an id drawn at random (the component was given none): render_vue()
  # does not take a new one for another component
  if (isTRUE(attr(id, "generated"))) {
    spec$generated <- TRUE
  }

  # The template travels as a script, which the browser does not parse: no
  # flash of raw <el-*> tags before Vue runs, and camelCase attribute names
  # survive -- an HTML parser lowercases them. Its root keeps the
  # `<id>_container` id the component's selectors have always used.
  # Element tags that hand an `id` on to their native input are labelled with
  # `for`; the rest with aria-labelledby on their root
  if (!is.null(label) && inherits(markup, "shiny.tag")) {
    # Checked in a browser: el-input-number and el-cascader put an id on their
    # outer div, not on the input, so they take aria-labelledby
    native <- markup$name %in%
      c(
        "el-input",
        "el-autocomplete",
        "el-select",
        "el-date-picker",
        "el-time-picker",
        "el-time-select"
      )
    markup <- do.call(
      htmltools::tagAppendAttributes,
      c(list(markup), .el_label_attrs(list(), id, label, native))
    )
  }
  root <- if (is.null(label) && is.null(error) && !isTRUE(required)) {
    htmltools::tags$div(id = container_id, style = .el_host_style(), markup)
  } else {
    .el_labelled(
      container_id,
      id,
      label,
      label_position,
      markup,
      width = label_width,
      suffix = label_suffix,
      required = required,
      error = error,
      show_message = show_message,
      inline_message = inline_message,
      size_field = "size" %in% names(data)
    )
  }
  # Shiny's own UI in the markup -- an input, an output, an htmlwidget -- is
  # kept out of Vue's compiling (.vue_islands()); this package's components
  # are folded in (.el_absorb()) and its containers placed as they are
  taken <- .vue_islands(root, components = FALSE)
  rendered <- htmltools::renderTags(taken$template)
  host <- .vue_host(
    id,
    as.character(rendered$html),
    spec,
    islands = taken$holder
  )
  # What .el_absorb() needs to fold this component into another: its options
  # as written, with the hook that reports every one of its fields.
  # Absorbed, it has no binding: its change handlers report it again, and a
  # typed value goes out under '<id>:<type>' so Shiny still converts it
  full <- options
  if (!is.null(methods_given)) {
    full$methods <- methods_given
  }
  if (!is.null(watch_given)) {
    full$watch <- watch_given
  }
  full$mounted <- mounted_given
  if (!is.null(init) && !is.null(type) && length(input)) {
    names(init)[names(init) == id] <- paste0(id, ":", type)
    full$mounted <- .el_mounted_init(init)
  }
  if (length(input_given)) {
    every <- .el_mounted_init(stats::setNames(input, id))
    full$mounted <- if (is.null(mounted_given)) {
      every
    } else {
      JS(sprintf(
        "function() { (%s).call(this); (%s).call(this); }",
        every,
        mounted_given
      ))
    }
  }
  attr(host, "el_spec") <- list(
    options = full,
    markup = markup,
    absorbed = absorbed
  )

  # Dependencies the markup carried -- an absorbed component's handler, a
  # slot's -- come out of the template with it
  htmltools::attachDependencies(
    # no NULL in it: shinyjs's hidden() and disabled() walk the list and
    # refuse anything but tags
    do.call(htmltools::tagList, Filter(Negate(is.null), list(head, host))),
    c(
      .el_vue_dependencies(),
      if (inherits(dependency, "html_dependency")) {
        list(dependency)
      } else {
        dependency
      },
      rendered$dependencies
    )
  )
}


#' Set a width on a tag, replacing any width it already declares
#'
#' `htmltools` joins repeated attributes with a space, so appending a second
#' `style` turns `width: 100%` and `width: 200px` into
#' `style="width: 100% width: 200px"` -- neither of which a browser reads. The
#' existing declarations are parsed instead, the width among them dropped, and
#' the new one appended.
#'
#' @param tag A tag, or something else (returned unchanged).
#' @param width A CSS unit, as accepted by [shiny::validateCssUnit()].
#' @return The tag, with the width set.
#' @keywords internal
.el_set_width <- function(tag, width) {
  if (!inherits(tag, "shiny.tag")) {
    warning(
      "`width` was ignored: this component's markup is not a single tag.",
      call. = FALSE
    )
    return(tag)
  }

  css <- paste0("width: ", shiny::validateCssUnit(width))
  existing <- tag$attribs$style

  if (is.null(existing)) {
    tag$attribs$style <- css
    return(tag)
  }

  declarations <- trimws(strsplit(
    paste(unlist(existing), collapse = ";"),
    ";"
  )[[1]])
  declarations <- declarations[nzchar(declarations)]
  declarations <- declarations[!grepl("^width\\s*:", declarations)]

  tag$attribs$style <- paste(c(declarations, css), collapse = "; ")
  tag
}


#' Turn named slot contents into markup, absorbing any components
#'
#' @param slots Named list of slot contents.
#' @param taken Field and method names the component itself already uses;
#'   an absorbed component declaring one of them is renamed.
#' @return A list of `markup` plus the Vue options its components contribute.
#' @keywords internal
.el_slot_markup <- function(slots, taken = character(0)) {
  if (!length(slots) || is.null(names(slots))) {
    stop(
      "`slots` must be a named list, one entry per Element slot.",
      call. = FALSE
    )
  }

  parts <- lapply(slots, .el_absorb)
  # The component's own names go first, as a part with nothing in it but
  # them, so the merge renames whatever in a slot would clash
  taken <- unique(taken[nzchar(taken)])
  host <- list(
    markup = NULL,
    data = stats::setNames(rep(list(NA), length(taken)), taken)
  )
  merged <- do.call(.el_absorb_merge, c(list(host), unname(parts)))
  merged$markups <- merged$markups[-1]
  merged$data <- merged$data[setdiff(names(merged$data), taken)]

  markup <- Map(
    function(name, ui) {
      # A template written with template() already declares its own slot, and
      # a scoped one must, so leave it alone.
      if (inherits(ui, "html") && grepl("^\\s*<template", as.character(ui))) {
        return(ui)
      }
      # Element Plus names its slots in kebab-case -- date-cell, sub-title --
      # and Vue 3 matches them as written
      .el_slot(gsub("([a-z0-9])([A-Z])", "\\1-\\L\\2", name, perl = TRUE), ui)
    },
    names(slots),
    merged$markups
  )

  list(
    markup = unname(markup),
    data = merged$data,
    methods = merged$methods,
    watch = merged$watch,
    computed = merged$computed,
    mounted = merged$mounted,
    dependencies = merged$dependencies,
    absorbed = merged$absorbed
  )
}


#' Append children to a tag
#'
#' @param tag A tag.
#' @param children Children to add.
#' @return The tag, with the children appended.
#' @keywords internal
.el_append_children <- function(tag, children) {
  if (!length(children)) {
    return(tag)
  }
  if (!inherits(tag, "shiny.tag")) {
    warning(
      "slots were ignored: this component's markup is not a single tag.",
      call. = FALSE
    )
    return(tag)
  }
  tag$children <- c(tag$children, children)
  tag
}


#' Lay a component out under (or beside) a label
#'
#' Element's own form-item markup -- `.el-form-item__label` and
#' `.el-form-item__content` -- so the label looks as it does in an `el_form()`,
#' laid out with flexbox rather than Element's floats, which assume an
#' enclosing form. It is the template's root, inside the host: hiding or
#' removing the component by its id takes the label with it.
#'
#' @param container_id The root's id, `<id>_container`.
#' @param id The component's id.
#' @param label Text or a tag.
#' @param position `"top"` or `"left"`.
#' @param markup The component's Element markup.
#' @return A tag.
#' @keywords internal
.el_labelled <- function(
  container_id,
  id,
  label,
  position,
  markup,
  width = NULL,
  suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  size_field = FALSE
) {
  beside <- position %in% c("left", "right")
  item_class <- paste(
    c(
      "el-form-item",
      paste0("el-form-item--label-", position),
      if (isTRUE(required)) "is-required",
      if (!is.null(error)) "is-error"
    ),
    collapse = " "
  )
  label_style <- if (beside) {
    # Element's own line height, 40px or less by size, is left in place:
    # it is the control's height, so the label's first line sits level
    # with the control however tall the rest of the component grows
    paste0(
      "float: none; flex: none; padding: 0 12px 0 0; ",
      "text-align: ",
      position,
      ";",
      if (!is.null(width)) {
        paste0(" width: ", shiny::validateCssUnit(width), ";")
      }
    )
  } else {
    "float: none; display: block; text-align: left; padding: 0 0 6px; line-height: 1.4"
  }
  # No whitespace between the label and its suffix: "Name:", as Element
  # writes it, not "Name :". htmltools puts a line break between children,
  # so text is joined first, and a tag label gets a span that eats the space.
  text <- if (is.null(suffix)) {
    list(label)
  } else if (is.character(label)) {
    list(paste0(label, suffix))
  } else {
    list(label, htmltools::tags$span(suffix, .noWS = "outside"))
  }
  label_tag <- if (!is.null(label)) {
    htmltools::tags$label(
      id = paste0(id, "-label"),
      `for` = paste0(id, "-input"),
      class = "el-form-item__label",
      style = label_style,
      # kept for update_el_*(label =), which replaces the text before it
      `data-suffix` = suffix,
      text,
      .noWS = "inside"
    )
  }
  message <- if (!is.null(error) && isTRUE(show_message)) {
    htmltools::tags$div(
      class = paste(
        c(
          "el-form-item__error",
          if (isTRUE(inline_message)) "el-form-item__error--inline"
        ),
        collapse = " "
      ),
      # Element positions the message under a form item's box; this one is
      # laid out with flexbox, so it flows instead
      style = if (isTRUE(inline_message)) {
        "position: static; display: inline-block; margin-left: 10px"
      } else {
        "position: static; display: block; padding-top: 4px"
      },
      error
    )
  }
  htmltools::tags$div(
    id = container_id,
    class = item_class,
    # Element's line heights per size, so a label beside a small control
    # lines up with it: the component's own size -- bound, so an update
    # moves the label too -- or else Element's global one, el_page(size =),
    # which Element's own form item falls back to as well
    `:class` = .el_form_item_size_class(size_field),
    style = if (beside) {
      "display: flex; align-items: flex-start; margin-bottom: 15px"
    } else {
      "margin-bottom: 15px"
    },
    label_tag,
    htmltools::tags$div(
      class = "el-form-item__content",
      # Beside a label, Element's content line height centres a short
      # control -- a radio group, a switch -- on the label's line
      style = if (beside) {
        "margin-left: 0; flex: 1 1 auto; min-width: 0"
      } else {
        "margin-left: 0; line-height: normal"
      },
      # Under the control, or beside it: inside the content either way, so a
      # message lines up with the control rather than with the label
      markup,
      message
    )
  )
}

#' The class sizing a form item
#'
#' @param size_field Whether the component has a `size` field.
#' @return A Vue class binding.
#' @keywords internal
.el_form_item_size_class <- function(size_field) {
  global <- "($ELEMENT && $ELEMENT.size)"
  current <- if (size_field) sprintf("(size || %s)", global) else global
  sprintf("%1$s ? 'el-form-item--' + %1$s : ''", current)
}

#' Tie a component's Element tag to its label
#'
#' A component whose Element tag hands an `id` on to a native input -- an
#' input, a select, a picker -- is labelled with `for`; any other, with
#' `aria-labelledby` on its root.
#'
#' @param attrs The Element tag's attributes.
#' @param id The component's id.
#' @param label The label; nothing is added when it is `NULL`.
#' @param native Whether the tag passes `id` to a native input.
#' @return The attributes, with the tie added.
#' @keywords internal
.el_label_attrs <- function(attrs, id, label, native = FALSE) {
  if (is.null(label)) {
    return(attrs)
  }
  if (native) {
    attrs$id <- paste0(id, "-input")
  } else {
    attrs[["aria-labelledby"]] <- paste0(id, "-label")
  }
  attrs
}
