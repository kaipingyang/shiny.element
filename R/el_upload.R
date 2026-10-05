#' Let go of an upload job a failed or aborted file left behind
#'
#' Shiny keeps an upload job until `uploadEnd` finishes it, and finishing
#' one with files still to come is an error. A batch with a failed or
#' aborted file is sent again as a new job, so the old one would wait in the
#' session until it ended, with whatever part of a file reached its
#' directory. The browser names it here and it is removed: dropped from the
#' session's upload jobs and its directory deleted. Shiny offers no public
#' way to do this, so the session's upload context is reached into; should
#' that change, the job is left as before, to go when the session does, and
#' a warning says so once per session. `test-el_upload.R` checks that the
#' installed Shiny still has every internal used here.
#'
#' @param job_id The job's id, from `uploadInit`.
#' @param session The Shiny session the job belongs to.
#' @return Whether the job was found and removed, invisibly.
#' @keywords internal
.el_upload_abandon <- function(job_id, session) {
  if (!is.character(job_id) || length(job_id) != 1L || !nzchar(job_id)) {
    return(invisible(FALSE))
  }
  ctx <- tryCatch(
    session$.__enclos_env__$private$fileUploadContext,
    error = function(e) NULL
  )
  usable <- is.environment(ctx) &&
    is.function(ctx$getUploadOperation) &&
    is.function(ctx$onJobFinished)
  if (!usable) {
    # A real session without them: Shiny's internals have moved
    if (inherits(session, "ShinySession") && is.environment(session$userData)) {
      if (!isTRUE(session$userData$.el_upload_warned)) {
        session$userData$.el_upload_warned <- TRUE
        warning(
          "shiny.element could not release an interrupted upload: shiny ",
          as.character(utils::packageVersion("shiny")),
          " no longer has the internals it uses. The partial upload stays ",
          "until the session ends.",
          call. = FALSE
        )
      }
    }
    return(invisible(FALSE))
  }
  done <- tryCatch(
    {
      op <- ctx$getUploadOperation(job_id)
      if (is.null(op)) {
        FALSE
      } else {
        # A file half written is still open
        if (inherits(op$.currentFileData, "connection")) {
          try(close(op$.currentFileData), silent = TRUE)
        }
        dir <- op$.dir
        ctx$onJobFinished(job_id)
        if (is.character(dir) && length(dir) == 1L && dir.exists(dir)) {
          unlink(dir, recursive = TRUE)
        }
        TRUE
      }
    },
    error = function(e) FALSE
  )
  invisible(done)
}

#' JavaScript that pushes a batch of files through Shiny's upload channel
#'
#' Element calls `http-request` once per file, but Shiny's protocol is
#' per-batch: `uploadInit` opens a job for a set of files, each is POSTed to
#' the job's URL, and `uploadEnd` sets the input to that job's files. Running
#' the protocol per file would make each upload overwrite the last.
#'
#' Element's `uploadFiles()` starts every file in one synchronous loop, so
#' the calls are collected and flushed from a microtask, by which point the
#' whole batch is present. Then, as Shiny's own `fileInput()` does:
#'
#' * Files are POSTed **one after another**. Shiny's job takes each POST as
#'   the next file in its list, so two in flight at once could land under
#'   each other's names.
#' * A file is Element's "success" only once `uploadEnd` has accepted the
#'   batch: until then nothing has reached `input$<id>`.
#' * A job cannot finish with a file missing -- Shiny stops it as "stopped
#'   prematurely". So when a file fails, or is aborted with Element's
#'   `abort()`, that file is marked failed (or left, if aborted) and the rest
#'   of the batch is sent again as a fresh job. The interrupted job is
#'   named to the server, which lets it go ([.el_upload_abandon()]).
#'
#' Each call returns an object with `abort()`, which Element keeps per file:
#' it stops that file's request if it is in flight and drops it from the
#' batch otherwise.
#'
#' @param ns_id The namespaced input id.
#' @return A [JS()] object for the `http-request` prop.
#' @keywords internal
.el_upload_js <- function(ns_id) {
  JS(sprintf(
    paste0(
      "function(options) {\n",
      "  var self = this, inputId = %s;\n",
      # Outside a Shiny app there is nowhere to send the file; fail it the
      # way Element shows a failed upload rather than throw
      "  if (!window.Shiny || !Shiny.shinyapp) {\n",
      "    options.onError(new Error('no Shiny session to upload to'));\n",
      "    return Object.defineProperty(Object.create(XMLHttpRequest.prototype), 'abort', { value: function() {} });\n",
      "  }\n",
      "  var entry = { o: options, aborted: false, failed: false, xhr: null };\n",
      "  self._queue = self._queue || [];\n",
      "  self._queue.push(entry);\n",
      "  if (!self._flushing) {\n",
      "    self._flushing = true;\n",
      "    Promise.resolve().then(function() {\n",
      "      self._flushing = false;\n",
      "      runJob(self._queue.splice(0));\n",
      "    });\n",
      "  }\n",
      "  function warn(m) { if (window.console) console.warn('[shiny.element] upload: ' + m); }\n",
      # A job given up on is named to the server, which lets it go
      "  function abandon(res) {\n",
      "    window.Shiny && Shiny.setInputValue && Shiny.setInputValue('.shiny_element_upload_abandon:shiny.element.upload_abandon',\n",
      "                        res.jobId, { priority: 'event' });\n",
      "  }\n",
      "  function runJob(batch) {\n",
      "    batch = batch.filter(function(e) { return !e.aborted && !e.failed; });\n",
      "    if (!batch.length) return;\n",
      "    var info = batch.map(function(e) {\n",
      "      return { name: e.o.file.name, size: e.o.file.size, type: e.o.file.type };\n",
      "    });\n",
      "    Shiny.shinyapp.makeRequest('uploadInit', [info], function(res) {\n",
      "      postNext(batch, 0, res);\n",
      "    }, function(err) {\n",
      "      warn('uploadInit: ' + err);\n",
      "      batch.forEach(function(e) { e.failed = true; e.o.onError(new Error(String(err))); });\n",
      "    });\n",
      "  }\n",
      # One file at a time; a gap in the batch sends the rest again
      "  function postNext(batch, i, res) {\n",
      "    if (i === batch.length) return finish(batch, res);\n",
      "    var e = batch[i];\n",
      "    if (e.aborted) { abandon(res); return runJob(batch); }\n",
      "    e.xhr = $.ajax(res.uploadUrl, {\n",
      "      type: 'POST', cache: false, data: e.o.file,\n",
      "      processData: false, contentType: 'application/octet-stream',\n",
      "      xhr: function() {\n",
      "        var x = new window.XMLHttpRequest();\n",
      "        x.upload.addEventListener('progress', function(ev) {\n",
      "          if (ev.lengthComputable) {\n",
      # 99 at most: the file is done when the batch is
      "            e.o.onProgress({ percent: Math.min(99, Math.round(ev.loaded / ev.total * 100)) });\n",
      "          }\n",
      "        });\n",
      "        return x;\n",
      "      },\n",
      "      success: function() { e.xhr = null; postNext(batch, i + 1, res); },\n",
      "      error: function(x, status) {\n",
      "        e.xhr = null;\n",
      "        if (!e.aborted) {\n",
      "          e.failed = true;\n",
      "          e.o.onError(new Error('Upload failed for ' + e.o.file.name + ': ' + (status || 'error')));\n",
      "        }\n",
      "        abandon(res);\n",
      "        runJob(batch);\n",
      "      }\n",
      "    });\n",
      "  }\n",
      "  function finish(batch, res) {\n",
      # A file aborted after it was sent is still in the job: send the rest again
      "    if (batch.some(function(e) { return e.aborted; })) { abandon(res); return runJob(batch); }\n",
      "    Shiny.shinyapp.makeRequest('uploadEnd', [res.jobId, inputId], function() {\n",
      "      batch.forEach(function(e) { if (!e.aborted) e.o.onSuccess({ ok: true }); });\n",
      "    }, function(err) {\n",
      "      warn('uploadEnd: ' + err);\n",
      "      abandon(res);\n",
      "      batch.forEach(function(e) { e.failed = true; e.o.onError(new Error(String(err))); });\n",
      "    });\n",
      "  }\n",
      # What Element keeps in its requests[uid]. Element Plus calls abort() only
      # on an XMLHttpRequest, so the handle is one as far as instanceof goes
      "  var handle = Object.create(XMLHttpRequest.prototype);\n",
      "  Object.defineProperty(handle, 'abort', { value: function() {\n",
      "    entry.aborted = true;\n",
      "    if (entry.xhr) entry.xhr.abort();\n",
      "  } });\n",
      "  return handle;\n",
      "}"
    ),
    as.character(jsonlite::toJSON(ns_id, auto_unbox = TRUE))
  ))
}

#' Element Plus Upload
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
#' @param button_label Text for the trigger, as `buttonLabel` is for
#'   [shiny::fileInput()]: on the button when `drag = FALSE`, inside the
#'   drop zone otherwise.
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
#'   there. Without `action` the field has no name: Shiny's own file-input
#'   binding claims every `input[type=file]` on the page that has an id or a
#'   name, and would add an `input$<name>` of its own beside `input$<id>`.
#' @param tip Help text shown under the control.
#' @param action Post to this URL using Element's own upload instead of
#'   Shiny's channel. See details.
#' @param crossorigin Native attribute crossorigin. Element Plus's
#'   `crossorigin` ('' | 'anonymous' | 'use-credentials').
#' @param directory Whether to support uploading directory. After enabling it,
#'   only folders can be selected, and after selecting a folder, the files
#'   within the folder will be flattened. Element Plus's `directory`
#'   (boolean).
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param headers Request headers, as a named list.
#' @param extra_data Extra fields sent alongside the file, as a named list.
#' @param file_list Files shown initially, each `list(name=, url=)`.
#' @param with_credentials Whether to send cookies with the request.
#' @param before_upload `JS()` function called before a file is sent; returning `false` cancels it.
#' @param before_remove `JS()` function called before a file is removed; returning `false` cancels it.
#' @param on_change `JS()` function called when a file is added, or finishes.
#' @param on_progress `JS()` function called as a file uploads.
#' @param on_preview `JS()` function called when an uploaded file is clicked.
#' @param on_remove `JS()` function called after a file is removed.
#' @param on_exceed `JS()` function called when more files are picked than `limit`.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents: `default` (the
#'   trigger, in place of the button), `tip`, `file` (each file of the list,
#'   scoped with `file`), `trigger`. A shiny.element component given here is
#'   absorbed rather than nested. For a scoped slot, write the template with
#'   [template()].
#'
#' @section Shiny inputs:
#' Without `action`, `input$<id>` is a data frame of `name`, `size`, `type`
#' and `datapath`, one row per file in the last batch, exactly as
#' [shiny::fileInput()] reports it. Uploads inherit Shiny's
#' `shiny.maxRequestSize` limit and its temporary-file cleanup.
#'
#' With `action`, Shiny never sees the files; `input$<id>_success` lists the
#' names of files Element uploaded successfully.
#'
#' Either way, `input$<id>_error` is the name of a file that failed, as an
#' event. Without `action`, the rest of its batch is sent again without it,
#' so `input$<id>` holds the files that arrived; a file stopped with
#' `abort()` is left out the same way.
#'
#' Files go up one at a time, as [shiny::fileInput()] sends them, and each
#' is marked done once the whole batch has reached the server.
#'
#' @section Element methods:
#' Callable with [call_el()]:
#'
#' - `abort()` -- Cancel upload request: one file, given as its `uid`, or
#'   every file in flight
#' - `clearFiles()` -- Clear the uploaded file list (this method is not supported in the before-upload hook)
#' - `submit()` -- Upload the file list manually
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' # A drop zone taking several CSVs, read on the server like fileInput()
#' el_upload(
#'   "files",
#'   drag = TRUE,
#'   multiple = TRUE,
#'   accept = ".csv",
#'   tip = "CSV files only"
#' )
#'
#' # A plain button
#' el_upload("avatar", button_label = "Choose a picture", accept = "image/*")
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
el_upload <- function(
  id = NULL,
  button_label = "Upload",
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
  headers = NULL,
  extra_data = NULL,
  file_list = NULL,
  with_credentials = NULL,
  before_upload = NULL,
  before_remove = NULL,
  on_change = NULL,
  on_progress = NULL,
  on_preview = NULL,
  on_remove = NULL,
  on_exceed = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  crossorigin = NULL,
  directory = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  .el_check_choices("el_upload", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_upload")
  }
  ns_id <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  via_shiny <- is.null(action)

  # Shiny's fileInputBinding matches every input[type=file] and binds one
  # with an id or a name as an input of its own -- input$<id>_elfile once
  # stood beside input$<id>. The field name is unused when we do the
  # transport ourselves, so there it is empty and Shiny passes it over.
  field_name <- if (!is.null(name)) {
    name
  } else if (via_shiny) {
    ""
  } else {
    "file"
  }

  upload_attrs <- list(
    ref = "upload",
    name = field_name,
    # Element requires `action`; it goes unused when http-request takes over.
    action = if (via_shiny) "#" else action,
    ":multiple" = "multiple",
    ":show-file-list" = "showFileList",
    ":list-type" = "listType",
    ":auto-upload" = "autoUpload",
    ":disabled" = "disabled",
    ":accept" = .el_optional_bind("accept"),
    ":limit" = .el_optional_bind("limit"),
    # on-success and on-error are props taking a function, not events, so
    # they bind with : rather than @. Written as events they simply never run.
    ":on-success" = "handleSuccess",
    ":on-error" = "handleError"
  )
  upload_attrs[[":drag"]] <- "drag"
  upload_attrs[[":headers"]] <- .el_optional_bind("headers")
  upload_attrs[[":data"]] <- .el_optional_bind("extraData")
  # Two-way, so the files Element Plus holds -- each with its uid, status,
  # progress -- are the component's field, for el_upload_file() to find
  upload_attrs[["v-model:file-list"]] <- "fileList"
  upload_attrs[[":with-credentials"]] <- .el_optional_bind("withCredentials")
  upload_attrs[[":before-upload"]] <- .el_optional_bind("beforeUpload")
  upload_attrs[[":before-remove"]] <- .el_optional_bind("beforeRemove")
  upload_attrs[[":on-change"]] <- .el_optional_bind("onChange")
  upload_attrs[[":on-progress"]] <- .el_optional_bind("onProgress")
  upload_attrs[[":on-preview"]] <- .el_optional_bind("onPreview")
  upload_attrs[[":on-remove"]] <- .el_optional_bind("onRemove")
  upload_attrs[[":on-exceed"]] <- .el_optional_bind("onExceed")
  if (via_shiny) {
    upload_attrs[[":http-request"]] <- "shinyUpload"
  }

  # Both triggers are rendered and switched by v-if, so update_el_upload(drag =)
  # changes the drop zone and its contents together. Picking one in R would
  # leave the markup stuck in whichever shape it had at render time.
  # A picture card's trigger is the card itself, a "+" as upstream draws it.
  # A `default` slot of the caller's replaces the trigger: Vue refuses a
  # default slot given both as loose children and as a template.
  trigger <- if (is.null(slots$default)) {
    list(
      htmltools::tag(
        "el-icon",
        list(
          class = "el-icon--upload",
          "v-if" = "drag",
          htmltools::tag("upload-filled", list())
        )
      ),
      htmltools::tags$div(
        class = "el-upload__text",
        "v-if" = "drag",
        "{{buttonLabel}}"
      ),
      htmltools::tag(
        "el-icon",
        list(
          "v-else-if" = "listType === 'picture-card'",
          htmltools::tag("plus", list())
        )
      ),
      htmltools::tag(
        "el-button",
        list(
          "v-else" = NA,
          size = "small",
          type = "primary",
          "{{buttonLabel}}"
        )
      )
    )
  }
  if (!is.null(tip)) {
    trigger <- c(
      trigger,
      list(
        .el_slot("tip", htmltools::tags$div(class = "el-upload__tip", tip))
      )
    )
  }

  vue_data <- list(
    drag = drag,
    buttonLabel = button_label,
    multiple = multiple,
    showFileList = show_file_list,
    listType = list_type,
    autoUpload = auto_upload,
    disabled = disabled,
    accept = if (is.null(accept)) NA else accept,
    limit = if (is.null(limit)) NA else limit,
    succeeded = list(),
    failed = ""
  )

  vue_data$headers <- .el_or_na(headers)
  vue_data$extraData <- .el_or_na(extra_data)

  vue_data$fileList <- if (is.null(file_list)) list() else file_list

  vue_data$withCredentials <- .el_or_na(with_credentials)

  vue_data$beforeUpload <- .el_or_na(before_upload)

  vue_data$beforeRemove <- .el_or_na(before_remove)

  vue_data$onChange <- .el_or_na(on_change)

  vue_data$onProgress <- .el_or_na(on_progress)

  vue_data$onPreview <- .el_or_na(on_preview)

  vue_data$onRemove <- .el_or_na(on_remove)

  vue_data$onExceed <- .el_or_na(on_exceed)

  methods <- list(
    handleSuccess = JS(sprintf(
      paste0(
        "function(response, file, fileList) { ",
        "this.succeeded = fileList.filter(function(f) { return f.status === 'success'; })",
        ".map(function(f) { return f.name; }); ",
        "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_success', this.succeeded); }"
      ),
      ns_id
    )),
    handleError = JS(sprintf(
      "function(err, file) { this.failed = file.name; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_error', file.name, {priority: 'event'}); }",
      ns_id
    ))
  )
  if (via_shiny) {
    methods$shinyUpload <- .el_upload_js(ns_id)
  }
  # el_upload_clear(): empty the list and what was reported of it
  methods$shinyVueReceive <- JS(sprintf(
    paste0(
      "function(d) { if (d['.action'] === 'clear') { ",
      "if (this.$refs.upload) this.$refs.upload.clearFiles(); this.succeeded = []; ",
      "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_success', []); } ",
      "delete d['.action']; return d; }"
    ),
    ns_id
  ))

  el_widget(
    props = .el_props(list(
      crossorigin = crossorigin,
      directory = directory
    )),
    label = label,
    label_position = label_position,
    label_width = label_width,
    label_suffix = label_suffix,
    required = required,
    error = error,
    show_message = show_message,
    inline_message = inline_message,
    id = ns_id,
    markup = htmltools::tag("el-upload", c(upload_attrs, trigger)),
    data = vue_data,
    methods = methods,
    width = width,
    slots = slots
  )
}

#' Update an Element Plus Upload
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Upload ID (un-namespaced).
#' @param disabled New disabled state.
#' @param limit New maximum number of files.
#' @param label New label, as for [shiny::updateTextInput()]: text, or
#'   tags or `HTML()` drawn as markup. Only a component built with a `label`
#'   has one to change.
#' @param error An error message to show on the component, as Element's
#'   `error` does -- for a check only the server can make, such as whether
#'   a name is taken. `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_upload(session, "files", disabled = TRUE)
#'   })
#' }
#' @inheritParams el_upload
#' @details Every other argument of [el_upload()] that can change once it is
#'   drawn is an argument here too, under the same name. One left `NULL`
#'   stays as it is; `NA` returns it to Element's default.
#' @export
update_el_upload <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL,
  limit = NULL,
  label = NULL,
  error = NULL,
  button_label = NULL,
  drag = NULL,
  multiple = NULL,
  accept = NULL,
  show_file_list = NULL,
  list_type = NULL,
  auto_upload = NULL,
  headers = NULL,
  extra_data = NULL,
  file_list = NULL,
  with_credentials = NULL,
  before_upload = NULL,
  before_remove = NULL,
  on_change = NULL,
  on_progress = NULL,
  on_preview = NULL,
  on_remove = NULL,
  on_exceed = NULL,
  crossorigin = NULL,
  directory = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  if (!is.null(limit)) {
    msg$limit <- limit
  }
  msg <- .el_form_item_update(msg, label, error)
  msg <- c(
    msg,
    .el_update_props(
      "el_upload",
      Filter(
        Negate(is.null),
        list(
          button_label = button_label,
          drag = drag,
          multiple = multiple,
          accept = accept,
          show_file_list = show_file_list,
          list_type = list_type,
          auto_upload = auto_upload,
          headers = headers,
          extra_data = extra_data,
          file_list = file_list,
          with_credentials = with_credentials,
          before_upload = before_upload,
          before_remove = before_remove,
          on_change = on_change,
          on_progress = on_progress,
          on_preview = on_preview,
          on_remove = on_remove,
          on_exceed = on_exceed,
          crossorigin = crossorigin,
          directory = directory
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}

#' Clear an Element Plus Upload's file list
#'
#' Empties the list of chosen files, as you would after a form is submitted.
#' It does not undo an upload that has already happened.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Upload ID (un-namespaced).
#'   This is Element's `data` prop, renamed to keep it distinct from the
#'   uploaded file itself.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     el_upload_clear(session, "files")
#'   })
#' }
#' @export
el_upload_clear <- function(session = shiny::getDefaultReactiveDomain(), id) {
  .el_check_session(session)
  .el_send_update(session, list(id = session$ns(id), .action = "clear"))
  invisible(NULL)
}
