#' Placeholder for an unset optional prop
#'
#' A field left out of a Vue instance's `data` is not reactive, so an update
#' can never set it later. Unset optional props are therefore declared as
#' `NA`, which serialises to `null`, and read back through
#' [.vue_optional_bind()], which turns that `null` into `undefined` so the
#' component applies its own default.
#'
#' @param x A value, or `NULL` when the user did not supply one.
#' @return `x`, or `NA` when `x` is `NULL`.
#' @keywords internal
.vue_or_na <- function(x) {
  if (is.null(x)) NA else x
}

#' Vue binding for a prop that may be unset
#'
#' A Vue prop falls back to its default when passed `undefined`, but takes
#' `null` as a value: a select bound to a null placeholder renders an empty
#' one instead of its own. R has no way to send `undefined`
#' through JSON, so an unsupplied field arrives as `null` and the expression
#' has to map it back.
#'
#' A conditional is used rather than `??` because a template expression is
#' evaluated at runtime, where a polyfill cannot help with syntax.
#'
#' @param field Name of the Vue data field.
#' @return A template expression yielding the field, or `undefined` when unset.
#' @keywords internal
.vue_optional_bind <- function(field) {
  sprintf("%1$s === null ? undefined : %1$s", field)
}
