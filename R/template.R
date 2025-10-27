#' Generate a <template> tag for Vue/Element UI slot usage
#'
#' @param ... Content inside the template
#' @param slot Slot name (optional)
#' @param scope Slot scope or v-slot syntax (optional)
#' @export
template <- function(..., slot = NULL, scope = NULL) {
  attrs <- c(
    if (!is.null(slot)) sprintf('slot="%s"', slot),
    if (!is.null(scope)) sprintf('slot-scope="%s"', scope)
  )
  attr_str <- if (length(attrs) > 0) paste(attrs, collapse = " ") else ""
  htmltools::HTML(
    sprintf('<template %s>%s</template>', attr_str, paste0(..., collapse = ""))
  )
}