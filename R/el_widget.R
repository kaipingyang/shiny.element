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
#' @param width Component width, as a CSS unit. Applied to the Element markup
#'   itself -- the host carries `display: contents` and generates no box, so a
#'   width set on it would do nothing.
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
#' # Reporting to Shiny works as it does inside the package: a method that
#' # calls Shiny.setInputValue().
#' el_widget(
#'   id      = "score",
#'   markup  = el$rate("v-model" = "value", "@change" = "handleChange"),
#'   data    = list(value = 3),
#'   methods = list(
#'     handleChange = htmlwidgets::JS(
#'       "function(v) { Shiny.setInputValue('score', v); }"
#'     )
#'   )
#' )
#' @export
el_widget <- function(id, markup, data, methods = NULL, watch = NULL,
                       mounted = NULL, computed = NULL, dependency = NULL,
                       head = NULL, width = NULL) {
  container_id <- paste0(id, "_container")

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
