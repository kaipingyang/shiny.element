render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- list(type = type, msg = msg)
  )
  expr(session)
  captured
}

# ── transport ─────────────────────────────────────────────────────────────────

test_that("el_upload: replaces the transport but keeps Element's own upload", {
  # http-request swaps out how bytes travel; the file list, progress bars and
  # hooks are Element's and keep working.
  html <- render_html(el_upload("files"))
  expect_match(html, ':http-request="shinyUpload"', fixed = TRUE)
  expect_match(html, "uploadInit", fixed = TRUE)
  expect_match(html, "uploadEnd", fixed = TRUE)
})

test_that("el_upload: a whole selection shares one Shiny job", {
  # Element calls http-request once per file, but uploadEnd sets the input to
  # one job's files, so per-file jobs make each upload overwrite the last.
  js <- render_html(el_upload("files"))
  expect_match(js, "_queue", fixed = TRUE)
  # Element's uploadFiles() loop is synchronous, so a microtask sees the batch.
  expect_match(js, "Promise.resolve().then", fixed = TRUE)
  expect_match(js, "splice(0)", fixed = TRUE)
})

test_that("el_upload: progress is forwarded to Element's own handler", {
  html <- render_html(el_upload("files"))
  expect_match(html, "x.upload.addEventListener", fixed = TRUE)
  expect_match(html, "o.onProgress", fixed = TRUE)
})

test_that("el_upload: giving action uses Element's upload instead", {
  direct <- render_html(el_upload("files", action = "https://example.invalid/put"))
  expect_match(direct, 'action="https://example.invalid/put"', fixed = TRUE)
  expect_false(grepl("http-request", direct, fixed = TRUE))
  expect_false(grepl("uploadInit", direct, fixed = TRUE))
})

test_that("el_upload: Element still needs an action even when unused", {
  expect_match(render_html(el_upload("files")), 'action="#"', fixed = TRUE)
})

# ── the duplicate-input-id problem ────────────────────────────────────────────

test_that("el_upload: the file field gets a unique name by default", {
  # Shiny's fileInputBinding claims every input[type=file] and keys it by id
  # or name, so two uploads both called "file" trip its duplicate-id warning.
  expect_match(render_html(el_upload("files")), 'name="files_elfile"', fixed = TRUE)
  expect_match(render_html(el_upload("other")), 'name="other_elfile"', fixed = TRUE)
})

test_that("el_upload: with action the field keeps Element's default name", {
  # There the name is the multipart field the server reads.
  expect_match(render_html(el_upload("files", action = "/u")), 'name="file"', fixed = TRUE)
})

test_that("el_upload: an explicit name wins either way", {
  expect_match(render_html(el_upload("files", name = "doc")), 'name="doc"', fixed = TRUE)
  expect_match(render_html(el_upload("files", action = "/u", name = "doc")),
               'name="doc"', fixed = TRUE)
})

# ── rendering ─────────────────────────────────────────────────────────────────

test_that("el_upload: returns a tagList with the container id", {
  u <- el_upload("files")
  expect_true(inherits(u, "shiny.tag.list"))
  expect_match(render_html(u), 'id="files_container"')
})

test_that("el_upload: attaches the shared bridge", {
  deps <- htmltools::findDependencies(el_upload("files"))
  expect_true("shiny-vue" %in% vapply(deps, function(d) d$name, character(1)))
})

test_that("el_upload: drag renders a drop zone, otherwise a button", {
  dragged <- render_html(el_upload("files", drag = TRUE, button_label = "Drop here"))
  expect_match(dragged, "drag", fixed = TRUE)
  expect_match(dragged, "el-icon-upload", fixed = TRUE)
  expect_match(dragged, "Drop here", fixed = TRUE)

  plain <- render_html(el_upload("files", button_label = "Pick"))
  expect_match(plain, "<el-button", fixed = TRUE)
  expect_false(grepl("el-upload-dragger", plain, fixed = TRUE))
})

test_that("el_upload: tip goes into the named slot", {
  html <- render_html(el_upload("files", tip = "CSV only"))
  expect_match(html, 'class="el-upload__tip" slot="tip"', fixed = TRUE)
  expect_match(html, "CSV only", fixed = TRUE)

  expect_false(grepl("el-upload__tip", render_html(el_upload("files")), fixed = TRUE))
})

test_that("el_upload: flags reach the Vue data", {
  html <- render_html(el_upload("files", multiple = TRUE, show_file_list = FALSE,
                                list_type = "picture", auto_upload = FALSE,
                                disabled = TRUE))
  expect_match(html, '"multiple":true')
  expect_match(html, '"showFileList":false')
  expect_match(html, '"listType":"picture"')
  expect_match(html, '"autoUpload":false')
  expect_match(html, '"disabled":true')
})

test_that("el_upload: accept and limit fall back to Element's defaults", {
  plain <- render_html(el_upload("files"))
  expect_match(plain, '"accept":null', fixed = TRUE)
  expect_match(plain, '"limit":null', fixed = TRUE)
  expect_match(plain, .el_optional_bind("accept"), fixed = TRUE)

  set <- render_html(el_upload("files", accept = ".csv", limit = 3))
  expect_match(set, '"accept":".csv"', fixed = TRUE)
  expect_match(set, '"limit":3', fixed = TRUE)
})

test_that("el_upload: success and error are bound as props, not events", {
  # on-success and on-error take a function; written as @events they never run
  # and input$<id>_success stays empty.
  html <- render_html(el_upload("files"))
  expect_match(html, ':on-success="handleSuccess"', fixed = TRUE)
  expect_match(html, ':on-error="handleError"', fixed = TRUE)
  expect_false(grepl('@on-success', html, fixed = TRUE))
})

test_that("el_upload: reports successes and failures separately", {
  html <- render_html(el_upload("files"))
  expect_match(html, "files_success", fixed = TRUE)
  expect_match(html, "files_error", fixed = TRUE)
})

# ── server-side ───────────────────────────────────────────────────────────────

test_that("update_el_upload: sends under the right message type", {
  out <- sent_message(function(s) update_el_upload(s, "files", disabled = TRUE))
  expect_equal(out$type, "shinyVueUpdate")
  expect_equal(out$msg$id, "files")
  expect_true(out$msg$disabled)
})

test_that("update_el_upload: NULL fields are excluded", {
  out <- sent_message(function(s) update_el_upload(s, "files", limit = 2))
  expect_equal(out$msg$limit, 2)
  expect_null(out$msg$disabled)
})

test_that("el_upload_clear: sends the id and the operation", {
  out <- sent_message(function(s) el_upload_clear(s, "files"))
  expect_equal(out$type, "shinyVueUpdate")
  expect_equal(out$msg, list(id = "files", .action = "clear"))
})

test_that("el_upload_clear() empties the list through the component's own method", {
  # Emptying the list is a method, not a prop.
  m <- vue_payload_of(el_upload("files"))$methods
  expect_match(m$shinyVueReceive, "clearFiles", fixed = TRUE)
  expect_match(m$shinyVueReceive, "files_success", fixed = TRUE)
})

test_that("letting go of an upload job removes it and its directory", {
  base <- tempfile("uploads")
  dir.create(base)
  ctx <- shiny:::FileUploadContext$new(base)
  job <- ctx$createUploadOperation(list(list(name = "a.txt", size = 1, type = "text/plain")))
  dir <- ctx$getUploadOperation(job)$.dir
  expect_true(dir.exists(dir))
  session <- list(.__enclos_env__ = list(private = list(fileUploadContext = ctx)))
  expect_true(shiny.element:::.el_upload_abandon(job, session))
  expect_null(ctx$getUploadOperation(job))
  expect_false(dir.exists(dir))
  # an unknown job, a malformed id, or a session without the context: nothing
  expect_false(shiny.element:::.el_upload_abandon(job, session))
  expect_false(shiny.element:::.el_upload_abandon(NULL, session))
  expect_false(shiny.element:::.el_upload_abandon("x", list()))
})
