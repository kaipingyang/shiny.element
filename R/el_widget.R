#' Assemble a component: mount point, Vue instance, dependencies
#'
#' Every control in this package has the same shape: a host `div` holding the
#' Element markup, a Vue instance mounted on it, and the scripts that let
#' `update_el_*()` and [el_call()] reach it. This builds that shape, and is
#' what the package's own components are made of.
#'
#' Reach for it to wrap an Element component this package does not cover, or
#' to build one that behaves differently from the wrapper here. Calling
#' [vueR::vue()] yourself works too -- nothing stops you -- but then three
#' things are yours to remember, each of which is here because of a bug:
#'
#' * `display: contents` on the host, or every component starts its own line;
#' * `width = 0, height = 0` on the widget, or it holds open a 960x500 empty
#'   box until its script runs, and the page jumps when it does;
#' * the `el` selector pointing at the host, which Vue compiles in place.
#'
#' The raw Element tags come from [el], and [template()] writes a slot.
#'
#' @param id The namespaced element id.
#' @param markup The Element markup to mount on, usually one `htmltools::tag()`.
#' @param data The Vue instance's data. Every field that `update_el_*()` may
#'   set has to be declared here -- Vue does not track one that is not.
#' @param methods,watch,mounted,computed Vue options, included when not `NULL`.
#' @param dependency htmlDependency objects to attach. Outside this package
#'   pass [element_ui_dependency()], unless the page already loads it through
#'   [el_page()] or [use_element()].
#' @param head Tags to place before the host, such as a `<style>` block.
#' @param slots Named list of slot contents, one entry per Element slot:
#'   `list(title = tags$b("Bold"))` fills the `title` slot. A component given
#'   here is absorbed like any other ([.el_absorb()]). For a scoped slot,
#'   where Element hands the template its own data, write the template with
#'   [template()] and the value is used as it stands.
#' @param width Component width, as a CSS unit. Applied to the Element markup
#'   itself -- the host carries `display: contents` and generates no box, so a
#'   width set on it would do nothing.
#' @param report Fields of `data` to report as Shiny inputs, as
#'   `c(<field> = <input id>)`: `report = c(value = id)` makes `input[[id]]`
#'   the `value` field. Each is reported on load, on every change -- the
#'   user's, or an [update_vue_data()] from the server -- and needs no
#'   JavaScript of your own. Inside a module, pass the namespaced id.
#' @return A Shiny UI element with its dependencies attached.
#' @examples
#' # Wrapping el-avatar, which this package does not provide
#' my_avatar <- function(id, src, size = 50) {
#'   el_widget(
#'     id     = id,
#'     markup = el$avatar(":src" = "src", ":size" = "size"),
#'     data   = list(src = src, size = size)
#'   )
#' }
#' my_avatar("face", "https://example.org/face.png")
#'
#' # An input of your own: v-model keeps `value` in step with the control,
#' # and `report` makes it input$score -- on load, on change, and after
#' # update_vue_data(session, "score", list(value = 5)) from the server.
#' el_widget(
#'   id     = "score",
#'   markup = el$rate("v-model" = "value", ":max" = "max"),
#'   data   = list(value = 3, max = 5),
#'   report = c(value = "score")
#' )
#' @export
el_widget <- function(id, markup, data, methods = NULL, watch = NULL,
                      mounted = NULL, computed = NULL, dependency = NULL,
                      head = NULL, width = NULL, slots = NULL, report = NULL) {
  container_id <- paste0(id, "_container")

  if (length(report)) {
    if (is.null(names(report)) || !all(nzchar(names(report))) ||
        !all(names(report) %in% names(data))) {
      stop("`report` must name fields of `data`: report = c(<field> = <input id>).",
           call. = FALSE)
    }
    # Reported on load and after an update, as every component here is ...
    init <- .el_mounted_init(stats::setNames(names(report), unname(report)))
    mounted <- if (is.null(mounted)) init else htmlwidgets::JS(sprintf(
      "function() { (%s).call(this); (%s).call(this); }", init, mounted))
    # ... and on every change of the field, however it came about: a
    # component of your own has no Element change event to wait for.
    for (field in names(report)) {
      watch[[field]] <- htmlwidgets::JS(sprintf(paste0(
        "{handler: function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(%s, v); }, ",
        "deep: true}"), jsonlite::toJSON(unname(report[[field]]), auto_unbox = TRUE)))
    }
  }

  if (length(slots)) {
    filled     <- .el_slot_markup(slots)
    markup     <- .el_append_children(markup, filled$markup)
    data       <- c(data, filled$data)
    methods    <- c(methods, filled$methods)
    watch      <- c(watch, filled$watch)
    dependency <- c(dependency, filled$dependencies)
  }

  if (!is.null(width)) {
    markup <- .el_set_width(markup, width)
  }

  options <- list(
    el   = paste0("#", container_id),
    data = data
  )
  for (nm in c("methods", "watch", "computed", "mounted")) {
    value <- get(nm)
    if (!is.null(value)) options[[nm]] <- value
  }

  ui <- htmltools::tagList(
    head,
    htmltools::tags$div(id = container_id, style = .el_host_style(), markup),
    # A widget with no size of its own: the Vue instance renders into the host
    # above, and the widget element itself is only there to carry the payload.
    vueR::vue(elementId = id, width = 0, height = 0, options)
  )

  if (is.null(dependency)) ui else htmltools::attachDependencies(ui, dependency)
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
    warning("`width` was ignored: this component's markup is not a single tag.",
            call. = FALSE)
    return(tag)
  }

  css <- paste0("width: ", shiny::validateCssUnit(width))
  existing <- tag$attribs$style

  if (is.null(existing)) {
    tag$attribs$style <- css
    return(tag)
  }

  declarations <- trimws(strsplit(paste(unlist(existing), collapse = ";"), ";")[[1]])
  declarations <- declarations[nzchar(declarations)]
  declarations <- declarations[!grepl("^width\\s*:", declarations)]

  tag$attribs$style <- paste(c(declarations, css), collapse = "; ")
  tag
}


#' Turn named slot contents into markup, absorbing any components
#'
#' @param slots Named list of slot contents.
#' @return A list of `markup` plus the Vue options its components contribute.
#' @keywords internal
.el_slot_markup <- function(slots) {
  if (!length(slots) || is.null(names(slots))) {
    stop("`slots` must be a named list, one entry per Element slot.",
         call. = FALSE)
  }

  parts <- lapply(slots, .el_absorb)
  merged <- do.call(.el_absorb_merge, parts)

  markup <- Map(function(name, ui) {
    # A template written with template() already declares its own slot, and
    # a scoped one must, so leave it alone.
    if (inherits(ui, "html") && grepl("^\\s*<template", as.character(ui))) {
      return(ui)
    }
    htmltools::tag("template", list(slot = name, ui))
  }, names(slots), merged$markups)

  list(markup = unname(markup), data = merged$data, methods = merged$methods,
       watch = merged$watch, dependencies = merged$dependencies)
}


#' Append children to a tag
#'
#' @param tag A tag.
#' @param children Children to add.
#' @return The tag, with the children appended.
#' @keywords internal
.el_append_children <- function(tag, children) {
  if (!length(children)) return(tag)
  if (!inherits(tag, "shiny.tag")) {
    warning("slots were ignored: this component's markup is not a single tag.",
            call. = FALSE)
    return(tag)
  }
  tag$children <- c(tag$children, children)
  tag
}
