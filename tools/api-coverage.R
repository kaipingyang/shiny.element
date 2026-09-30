# Snapshot which Element UI attributes and events each component renders.
#
# Components are rendered with their defaults and the resulting markup is read
# back, so this records what the package actually emits rather than what the
# source appears to pass. Writes /tmp/elapi/ours.json for tools/api-coverage.py.

suppressMessages(pkgload::load_all(".", quiet = TRUE, helpers = FALSE))

# Components that need an argument before they will render at all
fixtures <- list(
  el_checkbox_group = list("cg", choices = c("A", "B")),
  el_radio_group    = list("rg", choices = c("A", "B")),
  el_select         = list("sel", choices = c("A", "B")),
  el_form_field     = list(prop = "f", label = "F"),
  el_icon           = list("edit"),
  el_pagination     = list("pg", total = 100)
)

# Server-side helpers and dependency getters render nothing
skip <- "_dependency$|^el$|^el_page$|^el_rule$|^el_table_config$|^el_form_(validate|reset|clear)|^el_upload_clear$|^el_message$|^el_notification$"

ui_fns <- setdiff(grep("^el_", getNamespaceExports("shiny.element"), value = TRUE),
                  grep(skip, getNamespaceExports("shiny.element"), value = TRUE))

attrs_of <- function(html) {
  tags <- regmatches(html, gregexpr("<el-[a-z-]+[^>]*>", html))[[1]]
  per <- list()
  for (t in tags) {
    nm <- sub("^<(el-[a-z-]+).*", "\\1", t)
    at <- regmatches(t, gregexpr("(?<=\\s)[:@a-zA-Z][a-zA-Z0-9:@._-]*(?==\")", t, perl = TRUE))[[1]]
    per[[nm]] <- union(per[[nm]], at)
  }
  per
}

out <- list()
for (f in sort(ui_fns)) {
  args <- if (!is.null(fixtures[[f]])) fixtures[[f]] else list()
  ui <- tryCatch(do.call(f, args), error = function(e) NULL)
  if (is.null(ui)) {
    out[[f]] <- list(ok = FALSE,
                     params = setdiff(names(formals(f)), c("session", "id", "...")))
    next
  }
  html <- tryCatch(paste(as.character(htmltools::renderTags(ui)$html), collapse = ""),
                   error = function(e) "")
  # Formals say what a user may set; rendered attributes say what is actually
  # bound. A prop bound conditionally (if (!is.null(x))) shows up in the first
  # but not the second -- and cannot be changed later by update_el_*().
  out[[f]] <- list(ok = TRUE, tags = attrs_of(html),
                   params = setdiff(names(formals(f)), c("session", "id", "...")))
}

dir.create("/tmp/elapi", showWarnings = FALSE, recursive = TRUE)
jsonlite::write_json(out, "/tmp/elapi/ours.json", auto_unbox = TRUE, pretty = TRUE)

failed <- names(out)[!vapply(out, function(x) isTRUE(x$ok), logical(1))]
cat(sprintf("rendered %d/%d components\n", length(out) - length(failed), length(out)))
if (length(failed)) {
  cat("could not render (add a fixture above):", paste(failed, collapse = ", "), "\n")
}
