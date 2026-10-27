#' Optional props, given their data
#'
#' Element Plus's props that keep its own default unless given: each has a
#' field of its camelCase name holding the value, `NA` when unset (Element's
#' default, `undefined` in the browser; `JS("null")` is a deliberate
#' `null`), and an entry naming that field for the prop. [.el_bind_props()]
#' binds the entries on their tag as one group, `v-bind="$optional('<group>')"`
#' ([.vue_optional_props()]); [el_widget()] does it for its root tag.
#'
#' @param values A named list, names in snake_case as the R arguments are.
#' @param prefix A prefix for the fields' names, or `NULL`.
#' @param rename Named character vector: an argument's name, and the prop it
#'   stands for, where the two differ.
#' @return A list of `data` (for the Vue data) and `entries` (`<prop-kebab>
#'   = <field>`, or `list(field =, wrap =)`), not yet bound to a tag.
#' @keywords internal
.el_props <- function(values, prefix = NULL, rename = NULL) {
  if (!length(values)) {
    return(list(data = list(), entries = list()))
  }
  # An argument named apart from its prop -- a watermark's `width` would
  # be the component's own -- maps to the prop's upstream name
  upstream <- names(values)
  hit <- upstream %in% names(rename)
  upstream[hit] <- gsub("-", "_", rename[upstream[hit]])
  names(values) <- upstream
  # A virtual-ref is an element; from R it is a CSS selector. Giving one
  # turns on virtual-triggering, which Element Plus needs to use it.
  vref <- which(names(values) == "virtual_ref")
  if (length(vref)) {
    vtrig <- which(names(values) == "virtual_triggering")
    if (!is.null(values[[vref]]) && length(vtrig) && is.null(values[[vtrig]])) {
      values[vtrig] <- list(TRUE)
    }
  }
  # Values R gives as text, made into what Element takes in the browser
  # (el-events.js): a picker's default value and time into Dates ($elDate),
  # a virtual-ref selector into its element ($elRef)
  wrap <- c(
    default_value = "elDate",
    default_time = "elDate",
    virtual_ref = "elRef"
  )
  wrap <- wrap[names(wrap) %in% names(values)]
  o <- .vue_optional_props(
    .el_prop_values(values),
    "props",
    prefix = prefix,
    wrap = wrap
  )
  list(data = o$data, entries = o$map$props)
}

#' Bind optional props on their tag, as one group
#'
#' The group is named after the tag (`el-select` -> `select`), or the next
#' free name when a component folded into the same instance has taken it.
#'
#' @param tag The Element tag the props belong to.
#' @param props Output of [.el_props()].
#' @param taken Group names already used in the instance.
#' @return `list(tag =, props =)`: the tag with its `v-bind`, and the props
#'   with `groups` (`<group> = <entries>`) in place of `entries`.
#' @keywords internal
.el_bind_props <- function(tag, props, taken = character()) {
  if (!length(props$entries)) {
    return(list(tag = tag, props = props))
  }
  base <- sub("^el-", "", tag$name)
  group <- base
  k <- 1L
  while (group %in% taken) {
    k <- k + 1L
    group <- paste0(base, "_", k)
  }
  tag$attribs <- .vue_bind_optional(tag$attribs, group)
  props$groups <- c(props$groups, stats::setNames(list(props$entries), group))
  props$entries <- NULL
  list(tag = tag, props = props)
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
  fields <- vapply(nms, .vue_camel, "")
  hit <- nms %in% names(rename)
  fields[hit] <- rename[nms[hit]]
  stats::setNames(.el_prop_values(dots), fields)
}

#' Send an update of a component's props
#'
#' For the components whose props are all bound through [.el_props()]: the
#' fields are named as the component's own, prefix and renames included, so
#' an update reaches what the UI declared.
#'
#' @param session The Shiny session.
#' @param id The component's id.
#' @param fn The UI function, whose arguments the values are checked against.
#' @param values Named list of the arguments given; `NULL` ones are left out.
#' @param prefix,rename As for [.el_props()].
#' @return `NULL`, invisibly.
#' @keywords internal
.el_send_props_update <- function(
  session,
  id,
  fn,
  values,
  prefix = NULL,
  rename = NULL
) {
  .vue_check_session(session)
  values <- values[!vapply(values, is.null, logical(1))]
  .el_check_choices(fn, list2env(values))
  msg <- c(list(id = session$ns(id)), .el_props(values, prefix, rename)$data)
  .vue_send_update(session, msg)
  invisible(NULL)
}
