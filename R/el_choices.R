#' The values Element accepts for its enumerated props
#'
#' Read from Element 2.15.14's documentation ("Accepted Values") and checked
#' against its source and stylesheet, which the documentation does not
#' always match -- `tools/el-choices.py` lists the candidates. Where they
#' differ the union is kept, so nothing Element renders is refused:
#'
#' * `el-button` and `el-link` default `type` to `"default"`, which the
#'   documentation omits.
#' * `el-select` and `el-date-picker` document `large | small | mini`, but
#'   hand `size` to `el-input`, whose stylesheet has `medium | small | mini`.
#' * `el-input-number` documents `large | small`; its stylesheet has all four.
#' * `el-avatar`'s `size` is also a number of pixels.
#' * `el-input`'s `autocomplete` is not checked: the documentation lists
#'   `on | off`, but HTML takes `email`, `new-password` and many more.
#'
#' @name .el_choices
#' @keywords internal
.el_choices <- local({
  sizes   <- c("medium", "small", "mini")
  sizes4  <- c("large", "medium", "small", "mini")
  place12 <- c("top", "top-start", "top-end", "bottom", "bottom-start", "bottom-end",
               "left", "left-start", "left-end", "right", "right-start", "right-end")
  place6  <- c("top", "top-start", "top-end", "bottom", "bottom-start", "bottom-end")
  status  <- c("wait", "process", "finish", "error", "success")
  fits    <- c("fill", "contain", "cover", "none", "scale-down")
  buttons <- c("default", "primary", "success", "warning", "danger", "info", "text")
  notices <- c("success", "warning", "info", "error")
  list(
    el_alert          = list(type = notices, effect = c("light", "dark")),
    el_avatar         = list(size = c("large", "medium", "small"),
                             shape = c("circle", "square"), fit = fits),
    el_badge          = list(type = c("primary", "success", "warning", "danger", "info")),
    el_button         = list(size = sizes, type = buttons,
                             native_type = c("button", "submit", "reset")),
    el_card           = list(shadow = c("always", "hover", "never")),
    el_carousel       = list(trigger = c("hover", "click"),
                             indicator_position = c("outside", "none"),
                             arrow = c("always", "hover", "never"),
                             direction = c("horizontal", "vertical"), type = "card"),
    el_cascader       = list(size = sizes),
    el_checkbox       = list(size = sizes),
    el_checkbox_group = list(size = sizes),
    el_color_picker   = list(color_format = c("hsl", "hsv", "hex", "rgb")),
    el_container      = list(direction = c("horizontal", "vertical")),
    el_date_picker    = list(size = sizes4,
                             type = c("year", "month", "date", "dates", "months", "years",
                                      "datetime", "week", "datetimerange", "daterange",
                                      "monthrange")),
    el_descriptions   = list(direction = c("vertical", "horizontal"), size = sizes),
    el_divider        = list(direction = c("horizontal", "vertical"),
                             content_position = c("left", "right", "center")),
    el_dropdown       = list(size = sizes, placement = place6,
                             trigger = c("hover", "click"), type = buttons),
    el_form           = list(label_position = c("left", "right", "top"), size = sizes),
    el_image          = list(fit = fits),
    el_input          = list(size = sizes),
    el_input_number   = list(size = sizes4),
    el_autocomplete   = list(placement = place6),
    el_link           = list(type = c("default", "primary", "success", "warning", "danger", "info")),
    el_menu           = list(mode = c("horizontal", "vertical"), menu_trigger = c("hover", "click")),
    el_message        = list(type = notices),
    el_message_box    = list(type = notices),
    el_notification   = list(type = notices,
                             position = c("top-right", "top-left", "bottom-right", "bottom-left")),
    el_popover        = list(trigger = c("click", "focus", "hover", "manual"), placement = place12),
    el_progress       = list(type = c("line", "circle", "dashboard"),
                             status = c("success", "exception", "warning"),
                             stroke_linecap = c("butt", "round", "square")),
    el_radio_group    = list(size = sizes),
    el_result         = list(icon = notices),
    el_row            = list(type = "flex",
                             justify = c("start", "end", "center", "space-around", "space-between"),
                             align = c("top", "middle", "bottom")),
    el_select         = list(size = sizes4),
    el_slider         = list(input_size = sizes4),
    el_steps          = list(direction = c("vertical", "horizontal"),
                             process_status = status, finish_status = status),
    el_table          = list(size = sizes, tooltip_effect = c("dark", "light")),
    el_tabs           = list(type = c("card", "border-card"),
                             tab_position = c("top", "right", "bottom", "left")),
    el_tag            = list(type = c("success", "info", "warning", "danger"), size = sizes,
                             effect = c("dark", "light", "plain")),
    el_time_picker    = list(size = sizes),
    el_time_select    = list(size = sizes),
    el_tooltip        = list(effect = c("dark", "light"), placement = place12),
    el_transfer       = list(target_order = c("original", "push", "unshift")),
    el_upload         = list(list_type = c("text", "picture", "picture-card"))
  )
})

#' Refuse a value Element does not accept
#'
#' Called first thing by every component with an enumerated argument: a
#' typo -- `type = "primry"` -- is an error naming the values that work,
#' rather than a component Element quietly draws in its default style.
#' Exact matching, unlike [match.arg()]: `"prim"` is not `"primary"` to
#' Element either.
#'
#' @param fn The function's name, a key of [.el_choices].
#' @param env Its evaluation environment.
#' @return `NULL`, invisibly; or an error.
#' @keywords internal
.el_check_choices <- function(fn, env) {
  allowed <- .el_choices[[fn]]
  for (arg in names(allowed)) {
    if (!exists(arg, envir = env, inherits = FALSE)) next
    value <- get(arg, envir = env, inherits = FALSE)
    if (is.null(value) || (length(value) == 1L && is.na(value))) next
    if (fn == "el_avatar" && arg == "size" && is.numeric(value)) next
    if (!is.character(value) || length(value) != 1L || !value %in% allowed[[arg]]) {
      stop(sprintf("`%s` should be one of %s, not %s.", arg,
                   paste0('"', allowed[[arg]], '"', collapse = ", "),
                   paste(deparse(value), collapse = "")),
           call. = FALSE)
    }
  }
  invisible(NULL)
}
