#' Placeholder for an unset optional prop
#'
#' A field left out of a Vue instance's `data` is not reactive, so an update
#' can never set it later. Unset optional props are therefore declared as
#' `NA`, which serialises to `null`; for the props of an `$optional()` group
#' ([.vue_optional_props()]) the bridge makes that `null` `undefined`, so the
#' component applies its own default.
#'
#' @param x A value, or `NULL` when the user did not supply one.
#' @return `x`, or `NA` when `x` is `NULL`.
#' @keywords internal
.vue_or_na <- function(x) {
  if (is.null(x)) NA else x
}

#' Optional props as a group: their fields and the map the bridge reads
#'
#' The props a component library defaults when they are not given, bound
#' together on one tag with `v-bind="$optional('<group>')"` (see
#' [.vue_bind_optional()]). Each prop has a field in the component's data,
#' named in camelCase, so an update sets it as any other; unset (`NULL`)
#' is `NA`, sent as `null` and made `undefined` in the browser, where Vue
#' applies the prop's default. A deliberate `null` is `JS("null")`.
#'
#' @param values Named list of the props' values, names in snake_case as the
#'   R arguments are; `NULL` for unset.
#' @param group The group's name, as the template reads it: usually the
#'   tag's, `"select"`.
#' @param prefix A prefix for the fields' names, keeping a folded
#'   component's fields apart from its host's (`tipPlacement`), or `NULL`.
#' @param rename `c(<argument> = "<prop-kebab>")` for an argument named apart
#'   from the prop it stands for.
#' @param wrap `c(<argument> = "<wrap>")`: the value goes through
#'   `sv.optionalWraps[<wrap>]` in the browser, a function a component
#'   library registers.
#' @param fields `c(<argument> = "<field>")` for a field named otherwise
#'   than the prop -- one an update function already sets by that name.
#'   Taken as it is: no prefix is added.
#' @return `list(map =, data =)`: `map` for the spec's `optional`, one group
#'   of `<prop-kebab> = <field>` (or `list(field =, wrap =)`); `data` the
#'   fields, by name.
#' @keywords internal
.vue_optional_props <- function(
  values,
  group,
  prefix = NULL,
  rename = NULL,
  wrap = NULL,
  fields = NULL
) {
  # read in a template as $optional('<group>'): a plain name
  if (
    !is.character(group) ||
      length(group) != 1L ||
      !grepl("^[A-Za-z][A-Za-z0-9_-]*$", group)
  ) {
    stop(
      "`group` must be a single name: letters, digits, _ and -.",
      call. = FALSE
    )
  }
  map <- stats::setNames(list(list()), group)
  if (!length(values)) {
    return(list(map = map, data = list()))
  }
  args <- names(values)
  props <- gsub("_", "-", args, fixed = TRUE)
  hit <- args %in% names(rename)
  props[hit] <- rename[args[hit]]
  names_of <- vapply(gsub("-", "_", props, fixed = TRUE), .vue_camel, "")
  if (!is.null(prefix)) {
    names_of <- paste0(
      prefix,
      toupper(substring(names_of, 1, 1)),
      substring(names_of, 2)
    )
  }
  named <- args %in% names(fields)
  names_of[named] <- unname(fields[args[named]])
  entries <- Map(
    function(arg, field) {
      if (arg %in% names(wrap)) {
        list(field = field, wrap = wrap[[arg]])
      } else {
        field
      }
    },
    args,
    names_of
  )
  map[[group]] <- stats::setNames(unname(entries), props)
  data <- lapply(values, function(v) if (is.null(v)) NA else .vue_rows(v))
  list(map = map, data = stats::setNames(unname(data), names_of))
}

#' A tag's attributes with a group of optional props bound
#'
#' One `v-bind` per element: an attribute list that has one already -- a
#' user's root tag in a component's markup -- gets one merged object, the
#' existing one spread last so that it wins. The binding goes first among
#' the attributes, so an explicit binding of the same prop after it wins as
#' well (Vue 3 merges `v-bind` and attributes in source order).
#'
#' @param attrs A tag's attributes, a named list.
#' @param group The group's name, as given to [.vue_optional_props()].
#' @return The attributes.
#' @keywords internal
.vue_bind_optional <- function(attrs, group) {
  ours <- sprintf("$optional('%s')", group)
  has <- if (is.null(names(attrs))) {
    rep(FALSE, length(attrs))
  } else {
    names(attrs) %in% "v-bind"
  }
  value <- if (any(has)) {
    theirs <- unlist(attrs[has], use.names = FALSE)
    sprintf("{...%s, %s}", ours, paste0("...(", theirs, ")", collapse = ", "))
  } else {
    ours
  }
  c(list(`v-bind` = value), attrs[!has])
}
