# Read back the Vue instance's `data` from a rendered component.
#
# Whether a field appears here is what decides if update_el_*() can ever set
# it: the shared updater assigns into the instance's `data`, and Vue only
# tracks fields that were declared when the instance was created. Asserting on
# the data is therefore closer to the thing that matters than matching the
# binding expression in the markup, which is an implementation detail.
vue_data_of <- function(ui) {
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  if (!grepl('application/json', html, fixed = TRUE)) {
    stop(
      "no component options found -- is this a markup-only component?",
      call. = FALSE
    )
  }
  json <- sub('^.*?<script type="application/json"[^>]*>', "", html)
  json <- sub("</script>.*$", "", json)
  vue_payload_of(ui)$data
}

# The whole Vue option object: `data`, `methods`, `watch`, `mounted`.
vue_payload_of <- function(ui) {
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  if (!grepl("application/json", html, fixed = TRUE)) {
    stop(
      "no component options found -- is this a markup-only component?",
      call. = FALSE
    )
  }
  json <- sub('^.*?<script type="application/json"[^>]*>', "", html)
  json <- sub("</script>.*$", "", json)
  jsonlite::fromJSON(json, simplifyVector = FALSE)$options
}

# Does the markup bind this attribute at all, whatever expression it uses?
binds_attr <- function(ui, attr) {
  html <- paste(as.character(ui), collapse = "")
  grepl(paste0(":", attr, "=\""), html, fixed = TRUE) ||
    attr %in% names(optional_entries(ui))
}

# The optional props bound through v-bind="$optional('<group>')" on the
# component's tags -- on `tag` only, when given -- as prop -> entry (a
# field's name, or list(field =, wrap =)), from the spec's `optional` map
optional_entries <- function(ui, tag = NULL) {
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  specs <- regmatches(
    html,
    gregexpr(
      "(?s)(?<=data-shiny-vue-options>).*?(?=</script>)",
      html,
      perl = TRUE
    )
  )[[1]]
  optional <- list()
  for (sp in specs) {
    optional <- c(
      optional,
      jsonlite::fromJSON(sp, simplifyVector = FALSE)$optional
    )
  }
  tags <- regmatches(html, gregexpr("<el-[a-z0-9-]+[^>]*>", html))[[1]]
  if (!is.null(tag)) {
    tags <- tags[startsWith(tags, paste0("<", tag, " "))]
  }
  groups <- sub(
    "^\\$optional\\((&#39;|')",
    "",
    unlist(regmatches(
      tags,
      gregexpr("\\$optional\\((&#39;|')[A-Za-z0-9_-]+", tags, perl = TRUE)
    ))
  )
  do.call(c, unname(optional[unique(groups)]))
}

# A stand-in session that records the last custom message sent through it
mock_session <- function() {
  env <- new.env()
  list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) {
      env$type <- type
      env$msg <- msg
    },
    captured = function() env
  )
}

# Everything el_widget() writes for the bridge: the Vue `options`, and the
# `input` -- the field reported as input$<id> through the Shiny binding --
# with its `rate` and `type`.
vue_spec_of <- function(ui) {
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  json <- sub(
    '^.*?<script type="application/json" data-shiny-vue-options>',
    "",
    html
  )
  json <- sub("</script>.*$", "", json)
  jsonlite::fromJSON(json, simplifyVector = FALSE)
}

# Rows as R lists, whether .vue_rows() wrote them as JSON (a data.frame) or
# kept them as lists
rows_of <- function(x) {
  if (inherits(x, "json")) jsonlite::fromJSON(x, simplifyVector = FALSE) else x
}
