#' Element Plus Link
#'
#' A styled hyperlink that follows Element Plus's design language.
#'
#' @param label Link text. Accepts a string or HTML tag.
#' @param href URL target. `NULL` for a non-navigating link.
#' @param type Link colour type: `"default"` (default), `"primary"`,
#'   `"success"`, `"warning"`, `"danger"`, `"info"`.
#' @param underline When the link is underlined: `"hover"` (the default),
#'   `"always"` or `"never"`. `TRUE` and `FALSE`, Element UI's form, are
#'   `"hover"` and `"never"`.
#' @param target Where the link opens, as an `<a>`'s `target`. Default
#'   `"_self"`.
#' @param disabled Whether the link is disabled. Default `FALSE`.
#' @param icon Icon class string (e.g. `"el-icon-edit"`). Placed before the
#'   label. `NULL` for none.
#' @param id Give the link an id and it reports its clicks, as
#'   [shiny::actionLink()] does: `input$<id>` counts them, 0 on load, and
#'   [update_el_link()] changes it. Without one it is a plain link.
#' @param ... Additional HTML attributes passed to the `<a>` tag (a plain
#'   link only).
#'
#' @section Shiny inputs:
#' With an `id`, `input$<id>` -- the number of clicks, as
#' [shiny::actionLink()] reports it.
#'
#' @return An `htmltools` `<a>` tag, or with an `id` a Shiny UI element.
#'
#' @examples
#' el_link("Visit GitHub", href = "https://github.com", type = "primary")
#' el_link("Disabled", disabled = TRUE)
#' el_link("With icon", icon = "el-icon-edit", type = "success")
#'
#' # An action link: input$more counts its clicks
#' el_link("Show more", id = "more", type = "primary")
#'
#' @export
el_link <- function(label = "Link",
                    href = NULL,
                    type = "default",
                    underline = "hover",
                    disabled = FALSE,
                    icon = NULL,
                    id = NULL,
                    ...,
                    target = "_self") {
  .el_check_choices("el_link", environment())
  # Element Plus's boolean form: TRUE is "hover", FALSE "never"
  if (isTRUE(underline)) underline <- "hover"
  if (isFALSE(underline)) underline <- "never"
  underline <- match.arg(underline, c("hover", "always", "never"))
  icon <- .el_icon_name(icon)
  if (!is.null(id)) {
    ns_id <- .el_ui_id(id, NULL)
    return(el_widget(
      id     = ns_id,
      markup = htmltools::tag("el-link", list(
        ":href" = "href === null ? undefined : href", ":type" = "type",
        ":target" = "target",
        ":underline" = "underline", ":disabled" = "disabled",
        ":icon" = "icon === null ? undefined : icon", "@click" = "handleClick",
        "{{ text }}")),
      data = list(text = label, href = .el_or_na(href), type = type, target = target,
                  underline = underline, disabled = disabled, icon = .el_or_na(icon),
                  count = 0L),
      methods = list(handleClick = JS(sprintf(paste0(
        "function() { if (this.disabled) return; this.count++; ",
        "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s:shiny.action', this.count); }"),
        ns_id))),
      # An action link, as actionLink() is
      mounted = .el_mounted_init(stats::setNames("count", ns_id)),
      type    = "shiny.action"
    ))
  }
  link_classes <- c(
    "el-link",
    paste0("el-link--", type),
    if (disabled) "is-disabled",
    if (underline == "always") "is-underline",
    if (underline == "hover" && !disabled) "is-hover-underline"
  )

  a_attrs <- list(
    class = paste(link_classes, collapse = " "),
    href  = if (!disabled && !is.null(href)) href else NULL,
    target = if (!disabled && !is.null(href)) target else NULL,
    ...
  )

  icon_tag <- if (!is.null(icon)) el_icon(icon)
  label_tag <- shiny::tags$span(class = "el-link__inner", label)

  do.call(shiny::tags$a, c(a_attrs, list(icon_tag, label_tag)))
}


#' Update Element Plus Link
#'
#' Server-side update for an [el_link()] given an `id`.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateActionLink()].
#' @param id Link ID (un-namespaced).
#' @param label,href,type,underline,disabled,icon New values; `NULL` leaves
#'   one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$more, update_el_link(session, "more", label = "Show less"))
#' }
#' @export
update_el_link <- function(session = shiny::getDefaultReactiveDomain(), id,
                           label = NULL, href = NULL, type = NULL, underline = NULL,
                           disabled = NULL, icon = NULL) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(label))     msg$text      <- label
  if (!is.null(href))      msg$href      <- href
  if (!is.null(type))      msg$type      <- type
  if (!is.null(underline)) msg$underline <- underline
  if (!is.null(disabled))  msg$disabled  <- disabled
  if (!is.null(icon))      msg$icon      <- icon
  .el_send_update(session, msg)
  invisible(NULL)
}
