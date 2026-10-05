# Snapshot which Element Plus attributes and events each component renders.
#
# Components are rendered with their defaults and the resulting markup is read
# back, so this records what the package actually emits rather than what the
# source appears to pass. Writes /tmp/elapi/ours.json for tools/api-coverage.py.

suppressMessages(pkgload::load_all(".", quiet = TRUE, helpers = FALSE))

# Components that need an argument before they will render at all
fixtures <- list(
  el_checkbox_group = list("cg", choices = c("A", "B")),
  el_radio_group = list("rg", choices = c("A", "B")),
  el_select = list("sel", choices = c("A", "B")),
  el_form_field = list(prop = "f", label = "F"),
  el_icon = list("edit"),
  el_check_tag = list("ct", "Tag"),
  el_tree_select = list("ts"),
  el_pagination = list("pg", total = 100),
  # Per-item props only render once there is an item to carry them
  el_descriptions = list(
    "d",
    items = list(
      list(label = htmltools::tags$b("L"), content = "y"),
      list(
        label = "A",
        content = "x",
        span = 1,
        rowspan = 1,
        width = 1,
        min_width = 1,
        label_width = 1,
        align = "left",
        label_align = "left",
        class_name = "a",
        label_class_name = "b"
      )
    )
  ),
  el_skeleton = list(
    "sk",
    slots = list(
      template = htmltools::tag(
        "template",
        list(
          slot = "template",
          htmltools::tag("el-skeleton-item", list(variant = "text"))
        )
      )
    )
  )
)
# Server-side helpers, dependency getters and item constructors (R/el_items.R) render no component of their own
skip <- "^el_message_close$|^el_notification_close$|^call_el$|^el_loading$|^el_loading_close$|^el_message_box$|^el_widget$|_dependency$|^el$|^el_page$|^el_rule$|^el_table_config$|^el_form_(validate|reset|clear)|^el_upload_clear$|^el_message$|^el_notification$|^el_load_children$|^el_table_row$|^el_upload_file$|^el_tree_node$|^JS$|^el_(tab_pane|collapse_item|timeline_item|descriptions_item|carousel_item|step|breadcrumb_item|dropdown_item|tour_step|anchor_link|menu_item|sub_menu|menu_item_group|option|option_group|table_column|table_v2_column|skeleton_item)$"

ui_fns <- setdiff(
  grep("^el_", getNamespaceExports("shiny.element"), value = TRUE),
  grep(skip, getNamespaceExports("shiny.element"), value = TRUE)
)

# Which named slots the markup fills, via slot="x" or <template slot="x">
# Both spellings: slot="x" (what template() writes) and v-slot:x / #x on a
# <template> (what a column header uses)
slots_of <- function(html) {
  m <- regmatches(html, gregexpr('(?<![-:])slot="[^"]+"', html, perl = TRUE))[[
    1
  ]]
  v <- regmatches(
    html,
    gregexpr('(v-slot:|<template #)[A-Za-z][A-Za-z0-9_-]*', html)
  )[[1]]
  # a dynamic slot name names its slots in quotes: v-slot:[x ? 'filter-icon' : 'none']
  d <- regmatches(html, gregexpr("v-slot:\\[[^]]*\\]", html))[[1]]
  dyn <- unlist(regmatches(d, gregexpr("'[a-z][a-z0-9-]*'", d)))
  unique(c(
    sub('^slot="', "", sub('"$', "", m)),
    sub("^(v-slot:|<template #)", "", v),
    gsub("'", "", dyn)
  ))
}

attrs_of <- function(html) {
  tags <- regmatches(html, gregexpr("<el-[a-z0-9-]+[^>]*>", html))[[1]]
  per <- list()
  for (t in tags) {
    nm <- sub("^<(el-[a-z0-9-]+).*", "\\1", t)
    at <- regmatches(
      t,
      gregexpr("(?<=\\s)[:@a-zA-Z][a-zA-Z0-9:@._-]*(?==\")", t, perl = TRUE)
    )[[1]]
    per[[nm]] <- union(per[[nm]], at)
  }
  per
}

# Children only render when there are items to render, and some only in one
# mode (el-checkbox-button needs button = TRUE), so a component may be rendered
# more than once and its tags pooled.
variants <- list(
  el_tour = list(list(
    "tr",
    steps = list(list(
      target = "#a",
      title = "A",
      description = "d",
      show_arrow = TRUE,
      placement = "top",
      content_style = list(),
      mask = TRUE,
      type = "primary",
      next_button_props = list(),
      prev_button_props = list(),
      scroll_into_view_options = TRUE,
      show_close = TRUE,
      close_icon = "Close",
      header = htmltools::tags$b("H")
    ))
  )),
  el_anchor = list(list(
    "an",
    links = list(list(
      title = "A",
      href = "#a",
      children = list(list(title = "B", href = "#b"))
    ))
  )),
  el_steps = list(list(
    "st",
    steps = list(
      list(
        title = "A",
        description = "d",
        icon = "el-icon-edit",
        status = "success"
      ),
      list(
        title = htmltools::tags$b("A"),
        description = htmltools::tags$i("d"),
        icon = htmltools::tags$i(class = "el-icon-edit")
      )
    )
  )),
  el_carousel = list(list(
    "ca",
    items = list(list(name = "a", label = "A", content = "x"))
  )),
  el_menu = list(list(
    "mn",
    items = list(
      list(index = "a", label = "A", route = "/a", disabled = TRUE),
      list(
        index = "b",
        title = "B",
        popper_class = "p",
        popper_style = "x",
        show_timeout = 1,
        hide_timeout = 1,
        disabled = FALSE,
        teleported = TRUE,
        popper_offset = 6,
        expand_close_icon = "Plus",
        expand_open_icon = "Minus",
        collapse_close_icon = "Plus",
        collapse_open_icon = "Minus",
        children = list(list(index = "b1", title = "B1"))
      ),
      list(
        group = TRUE,
        title = "G",
        children = list(list(index = "c", label = "C"))
      )
    )
  )),
  el_dropdown = list(list(
    "dd",
    items = list(
      list(
        command = "a",
        label = "A",
        disabled = TRUE,
        divided = TRUE,
        icon = "Plus"
      ),
      list(command = "b", label = "B", icon = htmltools::tags$b("i"))
    )
  )),
  el_table = list(list(
    "tb",
    data = data.frame(a = 1),
    columns = list(
      list(prop = "a", filter_icon = "Filter"),
      list(type = "expand", cell = htmltools::tags$p("x"))
    )
  )),
  el_select = list(list(
    "sg",
    choices = list(
      list(
        label = "G1",
        disabled = FALSE,
        options = list(list(value = "a", label = "A"))
      )
    )
  )),
  el_checkbox_group = list(list("cb", choices = c("A", "B"), button = TRUE)),
  el_radio_group = list(list("rb", choices = c("A", "B"), button = TRUE))
)

# Slots are only in the markup when something fills them, so each component
# is rendered again with every slot upstream documents, to record which ones
# it actually passes through.
slot_names <- list(
  el_alert = "title",
  el_avatar = "default",
  el_autocomplete = c("prefix", "suffix", "prepend", "append"),
  el_cascader = "empty",
  el_date_picker = "range-separator",
  el_form_field = c("error", "label"),
  el_image = c("placeholder", "error"),
  el_page_header = c("title", "content"),
  el_popconfirm = "reference",
  el_popover = "reference",
  el_select = c("prefix", "empty"),
  el_table = "append",
  el_timeline = "dot",
  el_transfer = c("left-footer", "right-footer"),
  el_upload = c("tip", "trigger"),
  el_dropdown = "dropdown",
  el_descriptions = c("title", "extra"),
  el_empty = c("image", "description"),
  el_result = c("icon", "title", "subTitle", "extra"),
  el_statistic = c("prefix", "suffix", "title", "formatter")
)

# Every slot Element Plus documents for a component's own tag is probed too:
# a component passing slots = through to its markup fills them all
upstream_slots <- local({
  path <- "/tmp/elapi/docs.json"
  docs_dir <- ".upstream/element-plus/docs/en-US/component"
  # Without the parsed docs every upstream-only slot goes unprobed and reads
  # as missing (150/233 instead of 233/233), so refuse rather than undercount.
  if (!file.exists(path) || file.mtime(path) < file.mtime(docs_dir)) {
    stop(
      "Parse the upstream docs first: python tools/api-coverage.py --docs",
      call. = FALSE
    )
  }
  docs <- jsonlite::read_json(path)
  found <- list()
  for (file in names(docs)) {
    for (title in names(docs[[file]])) {
      sec <- docs[[file]][[title]]
      if (!identical(sec$kind, "Slot")) {
        next
      }
      base <- trimws(sub("\\s*[Ss]lots?$", "", title))
      if (!nzchar(base)) {
        base <- file
      }
      slug <- tolower(gsub("([a-z0-9])([A-Z])", "\\1-\\2", base))
      slug <- gsub("[[:space:]_]+", "-", slug)
      fn <- paste0("el_", gsub("-", "_", slug))
      found[[fn]] <- union(
        found[[fn]],
        vapply(sec$items, function(i) i$name, "")
      )
    }
  }
  found
})
for (f in names(upstream_slots)) {
  slot_names[[f]] <- setdiff(
    union(slot_names[[f]], upstream_slots[[f]]),
    "default"
  )
}

out <- list()
for (f in sort(ui_fns)) {
  args <- if (!is.null(fixtures[[f]])) fixtures[[f]] else list()
  ui <- tryCatch(do.call(f, args), error = function(e) NULL)
  if (is.null(ui)) {
    out[[f]] <- list(
      ok = FALSE,
      params = setdiff(names(formals(f)), c("session", "id", "..."))
    )
    next
  }
  html <- tryCatch(
    paste(as.character(htmltools::renderTags(ui)$html), collapse = ""),
    error = function(e) ""
  )

  for (v in variants[[f]]) {
    extra <- tryCatch(do.call(f, v), error = function(e) NULL)
    if (!is.null(extra)) {
      html <- paste(
        html,
        paste(as.character(htmltools::renderTags(extra)$html), collapse = "")
      )
    }
  }

  if (!is.null(slot_names[[f]])) {
    probe <- stats::setNames(
      lapply(slot_names[[f]], function(n) htmltools::tags$span(n)),
      slot_names[[f]]
    )
    with_slots <- tryCatch(
      do.call(f, c(args, list(slots = probe))),
      error = function(e) NULL
    )
    if (!is.null(with_slots)) {
      html <- paste(
        html,
        paste(
          as.character(htmltools::renderTags(with_slots)$html),
          collapse = ""
        )
      )
    }
  }
  # Formals say what a user may set; rendered attributes say what is actually
  # bound. A prop bound conditionally (if (!is.null(x))) shows up in the first
  # but not the second -- and cannot be changed later by update_el_*().
  # call_el() reaches the methods of any component with a Vue instance of
  # its own -- a host marked data-shiny-vue -- and of the drawer, which is
  # markup but lists its one method on the element (el-overlay-binding.js)
  invokable <- grepl("data-shiny-vue", html, fixed = TRUE) || f == "el_drawer"

  # Fields a component reads off each item (t$label, item$disabled), for the
  # components that render their items as markup rather than through Vue
  # -- including the helpers it hands items to, such as .el_tab_pane()
  ns <- asNamespace("shiny.element")
  src <- paste(deparse(get(f, envir = ns)), collapse = "\n")
  helpers <- unique(regmatches(
    src,
    gregexpr("\\.el_tab_[A-Za-z_]+|\\.el_[a-z]+_item[A-Za-z_]*", src)
  )[[1]])
  helpers <- helpers[vapply(
    helpers,
    exists,
    logical(1),
    envir = ns,
    inherits = FALSE
  )]
  for (h in helpers) {
    src <- paste(src, paste(deparse(get(h, envir = ns)), collapse = "\n"))
  }
  item_fields <- unique(sub(
    "^.*\\$",
    "",
    regmatches(src, gregexpr("\\b(t|item|it|tab|x|p)\\$[A-Za-z_]+", src))[[1]]
  ))

  # Events forwarded as input$<id>_<event>: bound to a generated elEmit* method
  forwarded <- unique(sub(
    '^@',
    '',
    sub(
      '="elEmit$',
      '',
      regmatches(html, gregexpr('@[a-z-]+="elEmit', html))[[1]]
    )
  ))
  out[[f]] <- list(
    ok = TRUE,
    tags = attrs_of(html),
    item_fields = item_fields,
    forwarded = forwarded,
    slots = c(
      slots_of(html),
      # Content passed through ... is the default slot
      if ("..." %in% names(formals(f))) "default"
    ),
    invokable = invokable,
    params = setdiff(names(formals(f)), c("session", "id", "..."))
  )
}

# Services -- Message, Notification, MessageBox, Loading -- are called from the
# server, so there is nothing to render; record their arguments instead.
ns <- asNamespace("shiny.element")
out[[".services"]] <- lapply(
  stats::setNames(
    nm = c(
      "el_message",
      "el_notification",
      "el_message_box",
      "el_loading",
      "el_message_close",
      "el_notification_close",
      "el_loading_close"
    )
  ),
  function(f) {
    if (exists(f, envir = ns)) names(formals(get(f, envir = ns))) else NULL
  }
)

dir.create("/tmp/elapi", showWarnings = FALSE, recursive = TRUE)
jsonlite::write_json(
  out,
  "/tmp/elapi/ours.json",
  auto_unbox = TRUE,
  pretty = TRUE
)

failed <- setdiff(
  names(out)[!vapply(out, function(x) isTRUE(x$ok), logical(1))],
  ".services"
)
n <- length(setdiff(names(out), ".services"))
cat(sprintf("rendered %d/%d components\n", n - length(failed), n))
if (length(failed)) {
  cat(
    "could not render (add a fixture above):",
    paste(failed, collapse = ", "),
    "\n"
  )
}
