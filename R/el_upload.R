#' JavaScript that pushes a batch of files through Shiny's upload channel
#'
#' Element calls `http-request` once per file, but Shiny's protocol is
#' per-batch: `uploadInit` opens a job for a set of files, each is POSTed to
#' the job's URL, and `uploadEnd` sets the input to that job's files. Running
#' the protocol per file therefore makes each upload overwrite the last, so a
#' three-file selection arrives as a single row.
#'
#' Element's `uploadFiles()` starts and uploads each file in one synchronous
#' loop, so the calls are collected in a queue and flushed from a microtask,
#' by which point the whole batch is present. Replacing only the transport
#' this way leaves Element's file list, progress bars and its `on-success`,
#' `on-progress` and `on-error` hooks working as they normally do.
#'
#' @param ns_id The namespaced input id.
#' @return An [htmlwidgets::JS()] object for the `http-request` prop.
#' @keywords internal
.el_upload_js <- function(ns_id) {
  htmlwidgets::JS(sprintf(paste0(
    "function(options) {\n",
    "  var self = this, inputId = %s;\n",
    "  self._queue = self._queue || [];\n",
    "  self._queue.push(options);\n",
    "  if (self._flushing) return;\n",
    "  self._flushing = true;\n",
    "  Promise.resolve().then(function() {\n",
    "    var batch = self._queue.splice(0);\n",
    "    self._flushing = false;\n",
    "    var info = batch.map(function(o) {\n",
    "      return { name: o.file.name, size: o.file.size, type: o.file.type };\n",
    "    });\n",
    "    Shiny.shinyapp.makeRequest('uploadInit', [info], function(res) {\n",
    "      var remaining = batch.length;\n",
    "      batch.forEach(function(o) {\n",
    "        $.ajax(res.uploadUrl, {\n",
    "          type: 'POST', cache: false, data: o.file,\n",
    "          processData: false, contentType: 'application/octet-stream',\n",
    "          xhr: function() {\n",
    "            var x = new window.XMLHttpRequest();\n",
    "            x.upload.addEventListener('progress', function(e) {\n",
    "              if (e.lengthComputable) {\n",
    "                o.onProgress({ percent: Math.round(e.loaded / e.total * 100) });\n",
    "              }\n",
    "            });\n",
    "            return x;\n",
    "          },\n",
    "          success: function() {\n",
    "            o.onSuccess({ ok: true });\n",
    "            if (--remaining === 0) {\n",
    "              Shiny.shinyapp.makeRequest('uploadEnd', [res.jobId, inputId],\n",
    "                function() {}, function(e) { console.warn('[shiny.element] uploadEnd: ' + e); });\n",
    "            }\n",
    "          },\n",
    "          error: function() {\n",
    "            remaining--;\n",
    "            o.onError(new Error('Upload failed for ' + o.file.name));\n",
    "          }\n",
    "        });\n",
    "      });\n",
    "    }, function(e) {\n",
    "      console.warn('[shiny.element] uploadInit: ' + e);\n",
    "      batch.forEach(function(o) { o.onError(new Error(String(e))); });\n",
    "    });\n",
    "  });\n",
    "}"
  ), as.character(jsonlite::toJSON(ns_id, auto_unbox = TRUE))))
}

#' Element UI Upload
#'
#' A file upload area, as a button or a drop zone.
#'
#' By default the files travel through Shiny's own upload channel, so
#' `input$<id>` is the same data frame [shiny::fileInput()] produces, complete
#' with a `datapath` pointing at a temporary file. Element's file list,
#' progress bars and hooks all keep working: only the transport is replaced.
#'
#' Give `action` instead to use Element's own upload, posting straight to that
#' URL. Shiny then plays no part -- useful for a pre-signed S3 URL or an
#' existing file service, but the server sees no `datapath`.
#'
#' @param id Upload ID (auto-generated if NULL).
#' @param label Text for the trigger. Shown on the button when `drag = FALSE`,
#'   and inside the drop zone otherwise.
#' @param drag Render a drop zone rather than a button.
#' @param multiple Allow selecting several files at once.
#' @param accept File types to accept, as an `accept` attribute would have
#'   them, e.g. `".csv,.tsv"` or `"image/*"`.
#' @param limit Maximum number of files.
#' @param show_file_list Show the list of chosen files.
#' @param list_type `"text"` (default), `"picture"` or `"picture-card"`.
#' @param auto_upload Start uploading as soon as files are chosen.
#' @param disabled Disable the control.
#' @param name Field name Element posts the file under. Only meaningful with
#'   `action`, where it names the multipart field; it defaults to `"file"`
#'   there. Without `action` a unique name is used instead, because Shiny's
#'   own file-input binding claims every `input[type=file]` on the page and
#'   keys them by name -- two uploads both called "file" make it report a
#'   duplicate input id.
#' @param tip Help text shown under the control.
#' @param action Post to this URL using Element's own upload instead of
#'   Shiny's channel. See details.
#' @param session Shiny session for module support.
#'
#' @section Server inputs:
#' Without `action`, `input$<id>` is a data frame of `name`, `size`, `type`
#' and `datapath`, one row per file in the last batch, exactly as
#' [shiny::fileInput()] reports it. Uploads inherit Shiny's
#' `shiny.maxRequestSize` limit and its temporary-file cleanup.
#'
#' With `action`, Shiny never sees the files; `input$<id>_success` lists the
#' names of files Element uploaded successfully, and `input$<id>_error` the
#' name of the last one that failed.
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' # A drop zone taking several CSVs, read on the server like fileInput()
#' el_upload("files", drag = TRUE, multiple = TRUE, accept = ".csv",
#'           tip = "CSV files only")
#'
#' # A plain button
#' el_upload("avatar", label = "Choose a picture", accept = "image/*")
#'
#' # Element's own upload, straight to a pre-signed URL
#' el_upload("direct", action = "https://example.invalid/presigned")
#'
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_upload("files", drag = TRUE, multiple = TRUE),
#'     tableOutput("info")
#'   )
#'   server <- function(input, output, session) {
#'     output$info <- renderTable({
#'       req(input$files)
#'       input$files[, c("name", "size", "type")]
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
el_upload <- function(id = NULL,
                      label = "Upload",
                      drag = FALSE,
                      multiple = FALSE,
                      accept = NULL,
                      limit = NULL,
                      show_file_list = TRUE,
                      list_type = "text",
                      auto_upload = TRUE,
                      disabled = FALSE,
                      name = NULL,
                      tip = NULL,
                      action = NULL,
                      session = shiny::getDefaultReactiveDomain()) {
  if (is.null(id)) id <- paste0("el_upload_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  via_shiny <- is.null(action)

  # Shiny's fileInputBinding matches every input[type=file] and identifies it
  # by id or name, so several uploads sharing Element's default "file" trip
  # its duplicate-id warning. The field name is unused when we do the
  # transport ourselves, so it can safely be made unique there.
  field_name <- if (!is.null(name)) {
    name
  } else if (via_shiny) {
    paste0(ns_id, "_elfile")
  } else {
    "file"
  }

  upload_attrs <- list(
    ref              = "upload",
    name             = field_name,
    # Element requires `action`; it goes unused when http-request takes over.
    action           = if (via_shiny) "#" else action,
    ":multiple"      = "multiple",
    ":show-file-list" = "showFileList",
    ":list-type"     = "listType",
    ":auto-upload"   = "autoUpload",
    ":disabled"      = "disabled",
    ":accept"        = .el_optional_bind("accept"),
    ":limit"         = .el_optional_bind("limit"),
    # on-success and on-error are props taking a function, not events, so
    # they bind with : rather than @. Written as events they simply never run.
    ":on-success"    = "handleSuccess",
    ":on-error"      = "handleError"
  )
  upload_attrs[[":drag"]] <- "drag"
  if (via_shiny) upload_attrs[[":http-request"]] <- "shinyUpload"

  # Both triggers are rendered and switched by v-if, so update_el_upload(drag =)
  # changes the drop zone and its contents together. Picking one in R would
  # leave the markup stuck in whichever shape it had at render time.
  trigger <- list(
    htmltools::tags$i(class = "el-icon-upload", "v-if" = "drag"),
    htmltools::tags$div(class = "el-upload__text", "v-if" = "drag", "{{label}}"),
    htmltools::tag("el-button", list(
      "v-if" = "!drag", size = "small", type = "primary", "{{label}}"
    ))
  )
  if (!is.null(tip)) {
    trigger <- c(trigger, list(
      htmltools::tags$div(class = "el-upload__tip", slot = "tip", tip)
    ))
  }

  vue_data <- list(
    drag         = drag,
    label        = label,
    multiple     = multiple,
    showFileList = show_file_list,
    listType     = list_type,
    autoUpload   = auto_upload,
    disabled     = disabled,
    accept       = if (is.null(accept)) NA else accept,
    limit        = if (is.null(limit)) NA else limit,
    succeeded    = list(),
    failed       = ""
  )

  methods <- list(
    handleSuccess = htmlwidgets::JS(sprintf(
      paste0(
        "function(response, file, fileList) { ",
        "this.succeeded = fileList.filter(function(f) { return f.status === 'success'; })",
        ".map(function(f) { return f.name; }); ",
        "Shiny.setInputValue('%s_success', this.succeeded); }"
      ), ns_id
    )),
    handleError = htmlwidgets::JS(sprintf(
      "function(err, file) { this.failed = file.name; Shiny.setInputValue('%s_error', file.name); }",
      ns_id
    ))
  )
  if (via_shiny) methods$shinyUpload <- .el_upload_js(ns_id)

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id, style = .el_host_style(),
      htmltools::tag("el-upload", c(upload_attrs, trigger))
    ),
    vueR::vue(
      elementId = ns_id, width = 0, height = 0,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = methods
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_upload_handler_dependency())
}

#' Update an Element UI Upload
#'
#' @param session Shiny session object.
#' @param id Upload ID (un-namespaced).
#' @param disabled New disabled state.
#' @param limit New maximum number of files.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_upload(session, "files", disabled = TRUE)
#'   })
#' }
#' @export
update_el_upload <- function(session, id, disabled = NULL, limit = NULL) {
  msg <- list(id = session$ns(id))
  if (!is.null(disabled)) msg$disabled <- disabled
  if (!is.null(limit))    msg$limit    <- limit
  session$sendCustomMessage("updateElUpload", msg)
  invisible(NULL)
}

#' Clear an Element UI Upload's file list
#'
#' Empties the list of chosen files, as you would after a form is submitted.
#' It does not undo an upload that has already happened.
#'
#' @param session Shiny session object.
#' @param id Upload ID (un-namespaced).
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     el_upload_clear(session, "files")
#'   })
#' }
#' @export
el_upload_clear <- function(session, id) {
  session$sendCustomMessage("clearElUpload", list(id = session$ns(id)))
  invisible(NULL)
}
