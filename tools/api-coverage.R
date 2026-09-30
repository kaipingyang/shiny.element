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
  el_pagination     = list("pg", total = 100),
  # Per-item props only render once there is an item to carry them
  el_descriptions   = list("d", items = list(
    list(label = htmltools::tags$b("L"), content = "y"),
    list(
    label = "A", content = "x", span = 1, label_class_name = "a",
    content_class_name = "b", label_style = list(color = "red"),
    content_style = list(color = "red")))),
  el_skeleton       = list("sk", slots = list(
    template = htmltools::tag("template", list(slot = "template",
      htmltools::tag("el-skeleton-item", list(variant = "text"))))))
)

# Server-side helpers and dependency getters render nothing
skip <- "^el_call$|^el_loading$|^el_loading_close$|^el_message_box$|^el_widget$|_dependency$|^el$|^el_page$|^el_rule$|^el_table_config$|^el_form_(validate|reset|clear)|^el_upload_clear$|^el_message$|^el_notification$"

ui_fns <- setdiff(grep("^el_", getNamespaceExports("shiny.element"), value = TRUE),
                  grep(skip, getNamespaceExports("shiny.element"), value = TRUE))

# Which named slots the markup fills, via slot="x" or <template slot="x">
slots_of <- function(html) {
  m <- regmatches(html, gregexpr('slot="[^"]+"', html))[[1]]
  unique(sub('^slot="', "", sub('"$', "", m)))
}

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

# Slots are only in the markup when something fills them, so each component
# is rendered again with every slot upstream documents, to record which ones
# it actually passes through.
slot_names <- list(
  el_alert = "title", el_avatar = "default",
  el_autocomplete = c("prefix", "suffix", "prepend", "append"),
  el_cascader = "empty", el_date_picker = "range-separator",
  el_form_field = c("error", "label"), el_image = c("placeholder", "error"),
  el_page_header = c("title", "content"), el_popconfirm = "reference",
  el_popover = "reference", el_select = c("prefix", "empty"),
  el_table = "append", el_timeline = "dot",
  el_transfer = c("left-footer", "right-footer"),
  el_upload = c("tip", "trigger"), el_dropdown = "dropdown",
  el_descriptions = c("title", "extra"), el_empty = c("image", "description"),
  el_result = c("icon", "title", "subTitle", "extra"),
  el_statistic = c("prefix", "suffix", "title", "formatter")
)

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

  if (!is.null(slot_names[[f]])) {
    probe <- stats::setNames(
      lapply(slot_names[[f]], function(n) htmltools::tags$span(n)),
      slot_names[[f]]
    )
    with_slots <- tryCatch(do.call(f, c(args, list(slots = probe))),
                           error = function(e) NULL)
    if (!is.null(with_slots)) {
      html <- paste(html,
        paste(as.character(htmltools::renderTags(with_slots)$html), collapse = ""))
    }
  }
  # Formals say what a user may set; rendered attributes say what is actually
  # bound. A prop bound conditionally (if (!is.null(x))) shows up in the first
  # but not the second -- and cannot be changed later by update_el_*().
  # el_call() reaches a component's methods, but only where the component
  # carries the el-invoke script -- record that so methods can be counted.
  deps <- tryCatch(htmltools::renderTags(ui)$dependencies, error = function(e) list())
  dep_names <- vapply(deps, function(d) d$name, character(1))

  out[[f]] <- list(ok = TRUE, tags = attrs_of(html),
                   slots = c(slots_of(html),
                             # Content passed through ... is the default slot
                             if ("..." %in% names(formals(f))) "default"),
                   invokable = "el-invoke" %in% dep_names,
                   params = setdiff(names(formals(f)), c("session", "id", "...")))
}

dir.create("/tmp/elapi", showWarnings = FALSE, recursive = TRUE)
jsonlite::write_json(out, "/tmp/elapi/ours.json", auto_unbox = TRUE, pretty = TRUE)

failed <- names(out)[!vapply(out, function(x) isTRUE(x$ok), logical(1))]
cat(sprintf("rendered %d/%d components\n", length(out) - length(failed), length(out)))
if (length(failed)) {
  cat("could not render (add a fixture above):", paste(failed, collapse = ", "), "\n")
}
