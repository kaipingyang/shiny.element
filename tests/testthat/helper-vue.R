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
    stop("no component options found -- is this a markup-only component?", call. = FALSE)
  }
  json <- sub('^.*?<script type="application/json"[^>]*>', "", html)
  json <- sub("</script>.*$", "", json)
  vue_payload_of(ui)$data
}

# The whole Vue option object: `data`, `methods`, `watch`, `mounted`.
vue_payload_of <- function(ui) {
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  if (!grepl("application/json", html, fixed = TRUE)) {
    stop("no component options found -- is this a markup-only component?", call. = FALSE)
  }
  json <- sub('^.*?<script type="application/json"[^>]*>', "", html)
  json <- sub("</script>.*$", "", json)
  jsonlite::fromJSON(json, simplifyVector = FALSE)$options
}

# Does the markup bind this attribute at all, whatever expression it uses?
binds_attr <- function(ui, attr) {
  html <- paste(as.character(ui), collapse = "")
  grepl(paste0(":", attr, "=\""), html, fixed = TRUE)
}

# A stand-in session that records the last custom message sent through it
mock_session <- function() {
  env <- new.env()
  list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) {
      env$type <- type
      env$msg  <- msg
    },
    captured = function() env
  )
}

# Everything el_widget() writes for the bridge: the Vue `options`, and the
# `input` -- the field reported as input$<id> through the Shiny binding --
# with its `rate` and `type`.
vue_spec_of <- function(ui) {
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  json <- sub('^.*?<script type="application/json" data-shiny-vue-options>', "", html)
  json <- sub("</script>.*$", "", json)
  jsonlite::fromJSON(json, simplifyVector = FALSE)
}
