#' Element Plus Link
#'
#' A styled hyperlink that follows Element Plus's design language.
#'
#' @param label Link text. Accepts a string or HTML tag.
#' @param href URL target. `NULL` for a non-navigating link.
#' @param type Link colour type: `"default"`, `"primary"`, `"success"`,
#'   `"warning"`, `"danger"`, `"info"`.
#' @param underline When the link is underlined: `"hover"`, `"always"` or
#'   `"never"`. `TRUE` and `FALSE`, Element UI's form, are `"hover"` and
#'   `"never"`. `type` and `underline` left `NULL` are `"default"` and
#'   `"hover"`, or for a link with an `id` a config provider's
#'   [el_config_provider(link =)][el_config_provider].
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
#' @template on
#' @section Shiny inputs:
#' `r .el_events_md("el_link")`
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
#' @export
el_link <- function(
  label = "Link",
  href = NULL,
  type = NULL,
  underline = NULL,
  disabled = FALSE,
  icon = NULL,
  id = NULL,
  ...,
  target = "_self",
  on = NULL
) {
  .el_check_choices("el_link", environment())
  # R reads these to draw the component
  .vue_unbound(underline = underline)
  # Element Plus's boolean form: TRUE is "hover", FALSE "never"
  if (isTRUE(underline)) {
    underline <- "hover"
  }
  if (isFALSE(underline)) {
    underline <- "never"
  }
  if (!is.null(underline)) {
    underline <- match.arg(underline, c("hover", "always", "never"))
  }
  icon <- .el_icon_name(icon)
  # state followed in the browser needs an instance of its own
  if (is.null(id) && .vue_has_bind(list(label, href, type, target, disabled))) {
    id <- .vue_auto_id("el_link")
  }
  if (!is.null(id)) {
    ns_id <- .vue_ui_id(id, NULL)
    return(el_widget(
      props = .el_props(list(
        href = href,
        type = type,
        underline = underline,
        icon = icon
      )),
      id = ns_id,
      markup = htmltools::tag(
        "el-link",
        list(
          ":target" = "target",
          ":disabled" = "disabled",
          "@click" = "handleClick",
          "{{ text }}"
        )
      ),
      data = list(
        text = label,
        target = target,
        disabled = disabled,
        count = 0L
      ),
      methods = list(
        handleClick = JS(sprintf(
          paste0(
            "function() { if (this.disabled) return; this.count++; ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s:shiny.action', this.count); }"
          ),
          ns_id
        ))
      ),
      # An action link, as actionLink() is
      mounted = .vue_mounted_report(stats::setNames("count", ns_id)),
      type = "shiny.action",
      on = on
    ))
  }
  type <- type %||% "default"
  underline <- underline %||% "hover"
  link_classes <- c(
    "el-link",
    paste0("el-link--", type),
    if (disabled) "is-disabled",
    if (underline == "always") "is-underline",
    if (underline == "hover" && !disabled) "is-hover-underline"
  )

  a_attrs <- list(
    class = paste(link_classes, collapse = " "),
    href = if (!disabled && !is.null(href)) href else NULL,
    target = if (!disabled && !is.null(href)) target else NULL,
    ...
  )

  icon_tag <- if (!is.null(icon)) el_icon(icon)
  label_tag <- shiny::tags$span(class = "el-link__inner", label)

  do.call(shiny::tags$a, c(a_attrs, list(icon_tag, label_tag)))
}


#' @rdname el_link
#' @section Updating from the server:
#' Server-side update for an [el_link()] given an `id`.
#'
#' `update_el_link()` is called for its side effect and returns `NULL` invisibly.
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateActionLink()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$more, update_el_link(session, "more", label = "Show less"))
#' }
#' @export
update_el_link <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  label = NULL,
  href = NULL,
  type = NULL,
  underline = NULL,
  disabled = NULL,
  icon = NULL
) {
  .vue_check_session(session)
  msg <- list(id = session$ns(id))
  msg <- c(
    msg,
    .el_update_props(
      "el_link",
      Filter(
        Negate(is.null),
        list(
          label = label,
          href = href,
          type = type,
          underline = underline,
          disabled = disabled,
          icon = icon
        )
      ),
      rename = c(label = "text")
    )
  )
  .vue_send_update(session, msg)
  invisible(NULL)
}
