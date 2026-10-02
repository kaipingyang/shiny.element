.onLoad <- function(libname, pkgname) {
  # Dates arrive as Date, as from shiny::dateInput(): "yyyy-MM-dd" text from
  # the picker, one value or several. An empty picker is NULL.
  shiny::registerInputHandler("shiny.element.date", function(x, ...) {
    if (is.null(x) || !length(x)) return(NULL)
    x <- unlist(x)
    if (all(is.na(x) | x == "")) return(NULL)
    x[x == ""] <- NA
    as.Date(x)
  }, force = TRUE)
  # An upload job a failed or aborted file left behind, to be let go of
  shiny::registerInputHandler("shiny.element.upload_abandon", function(x, session, name) {
    .el_upload_abandon(x, session)
    NULL
  }, force = TRUE)
}
