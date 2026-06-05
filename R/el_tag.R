#' Element UI Tag
#'
#' Creates a styled tag/chip component. Tracks click and close events as
#' Shiny inputs.
#'
#' @param id Tag ID. Auto-generated UUID if `NULL`.
#' @param label Tag text.
#' @param type Tag colour: `NULL` (default blue), `"success"`, `"info"`,
#'   `"warning"`, `"danger"`.
#' @param closable Whether to show a close button. Default `FALSE`. When
#'   `TRUE`, `input$<id>_closed` fires once when the user closes the tag.
#' @param size Tag size: `NULL`, `"medium"`, `"small"`, `"mini"`.
#' @param effect Visual effect: `"light"` (default), `"dark"`, `"plain"`.
#' @param color Custom background colour (CSS string). `NULL` for themed colour.
#' @param hit Whether to show a solid border. Default `FALSE`.
#' @param disable_transitions Disable the zoom-in-center animation. Default `FALSE`.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed tag component.
#'
#' @section Shiny inputs:
#' - `input$<id>` — click count (integer), incremented each time the tag body
#'   is clicked.
#' - `input$<id>_closed` — set to `1` when the user clicks the close button
#'   (only meaningful when `closable = TRUE`).
#'
#' @examples
#' el_tag("tag1", "Success", type = "success")
#' el_tag("tag2", "Closable", closable = TRUE)
#'
#' @export
el_tag <- function(
    id                   = NULL,
    label                = "Tag",
    type                 = NULL,
    closable             = FALSE,
    size                 = NULL,
    effect               = "light",
    color                = NULL,
    hit                  = FALSE,
    disable_transitions  = FALSE,
    session              = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_tag_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  tag_attrs <- list(
    ":type"                = "type",
    ":closable"            = "closable",
    ":effect"             = "effect",
    ":hit"                 = "hit",
    ":disable-transitions" = "disableTransitions",
    "@click"               = "handleClick",
    "@close"               = "handleClose"
  )
  if (!is.null(size))  tag_attrs[[":size"]]  <- "size"
  if (!is.null(color)) tag_attrs[[":color"]] <- "color"

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-tag", c(tag_attrs, list("{{label}}")))
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el   = paste0("#", container_id),
        data = list(
          label              = label,
          type               = type,
          closable           = closable,
          size               = size,
          effect             = effect,
          color              = color,
          hit                = hit,
          disableTransitions = disable_transitions,
          count              = 0L
        ),
        methods = list(
          handleClick = htmlwidgets::JS(sprintf(
            "function() { this.count++; Shiny.setInputValue('%s', this.count); }",
            ns_id
          )),
          handleClose = htmlwidgets::JS(sprintf(
            "function() { Shiny.setInputValue('%s_closed', 1, {priority: 'event'}); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_tag_handler_dependency())
}


#' Update Element UI Tag
#'
#' Server-side update for [el_tag()].
#'
#' @param session Shiny session object.
#' @param id Tag ID (un-namespaced).
#' @param label New label text.
#' @param type New colour type.
#' @param closable New closable state.
#'
#' @export
update_el_tag <- function(session, id, label = NULL, type = NULL,
                          closable = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(label))    msg$label    <- label
  if (!is.null(type))     msg$type     <- type
  if (!is.null(closable)) msg$closable <- closable
  session$sendCustomMessage("updateElTag", msg)
}


#' @keywords internal
el_tag_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-tag-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-tag-handler.js",
    all_files = FALSE
  )
}
