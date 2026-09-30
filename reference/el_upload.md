# Element UI Upload

A file upload area, as a button or a drop zone.

## Usage

``` r
el_upload(
  id = NULL,
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
  headers = NULL,
  extra_data = NULL,
  file_list = NULL,
  with_credentials = NULL,
  thumbnail_mode = NULL,
  before_upload = NULL,
  before_remove = NULL,
  on_change = NULL,
  on_progress = NULL,
  on_preview = NULL,
  on_remove = NULL,
  on_exceed = NULL,
  width = NULL,
  slots = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Upload ID (auto-generated if NULL).

- label:

  Text for the trigger. Shown on the button when `drag = FALSE`, and
  inside the drop zone otherwise.

- drag:

  Render a drop zone rather than a button.

- multiple:

  Allow selecting several files at once.

- accept:

  File types to accept, as an `accept` attribute would have them, e.g.
  `".csv,.tsv"` or `"image/*"`.

- limit:

  Maximum number of files.

- show_file_list:

  Show the list of chosen files.

- list_type:

  `"text"` (default), `"picture"` or `"picture-card"`.

- auto_upload:

  Start uploading as soon as files are chosen.

- disabled:

  Disable the control.

- name:

  Field name Element posts the file under. Only meaningful with
  `action`, where it names the multipart field; it defaults to `"file"`
  there. Without `action` a unique name is used instead, because Shiny's
  own file-input binding claims every `input[type=file]` on the page and
  keys them by name – two uploads both called "file" make it report a
  duplicate input id.

- tip:

  Help text shown under the control.

- action:

  Post to this URL using Element's own upload instead of Shiny's
  channel. See details.

- headers:

  Request headers, as a named list.

- extra_data:

  Extra fields sent alongside the file, as a named list.

- file_list:

  Files shown initially, each `list(name=, url=)`.

- with_credentials:

  Whether to send cookies with the request.

- thumbnail_mode:

  Whether files are shown as thumbnails.

- before_upload:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function called before a file is sent; returning `false` cancels it.

- before_remove:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function called before a file is removed; returning `false` cancels
  it.

- on_change:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function called when a file is added, or finishes.

- on_progress:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function called as a file uploads.

- on_preview:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function called when an uploaded file is clicked.

- on_remove:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function called after a file is removed.

- on_exceed:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function called when more files are picked than `limit`.

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).
  number taken as pixels. Element's own markup carries it, so it behaves
  like the `width` argument of a Shiny input.

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Details

By default the files travel through Shiny's own upload channel, so
`input$<id>` is the same data frame
[`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)
produces, complete with a `datapath` pointing at a temporary file.
Element's file list, progress bars and hooks all keep working: only the
transport is replaced.

Give `action` instead to use Element's own upload, posting straight to
that URL. Shiny then plays no part – useful for a pre-signed S3 URL or
an existing file service, but the server sees no `datapath`.

## Server inputs

Without `action`, `input$<id>` is a data frame of `name`, `size`, `type`
and `datapath`, one row per file in the last batch, exactly as
[`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)
reports it. Uploads inherit Shiny's `shiny.maxRequestSize` limit and its
temporary-file cleanup.

With `action`, Shiny never sees the files; `input$<id>_success` lists
the names of files Element uploaded successfully, and `input$<id>_error`
the name of the last one that failed.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `abort()` – Cancel upload request

- `clearFiles()` – Clear the uploaded file list (this method is not
  supported in the before-upload hook)

- `submit()` – Upload the file list manually

## Examples

``` r
# A drop zone taking several CSVs, read on the server like fileInput()
el_upload("files", drag = TRUE, multiple = TRUE, accept = ".csv",
          tip = "CSV files only")
#> <div id="files_container" style="display: contents">
#>   <el-upload ref="upload" name="files_elfile" action="#" :multiple="multiple" :show-file-list="showFileList" :list-type="listType" :auto-upload="autoUpload" :disabled="disabled" :accept="accept === null ? undefined : accept" :limit="limit === null ? undefined : limit" :on-success="handleSuccess" :on-error="handleError" :drag="drag" :headers="headers === null ? undefined : headers" :data="extraData === null ? undefined : extraData" :file-list="fileList === null ? undefined : fileList" :with-credentials="withCredentials === null ? undefined : withCredentials" :thumbnail-mode="thumbnailMode === null ? undefined : thumbnailMode" :before-upload="beforeUpload === null ? undefined : beforeUpload" :before-remove="beforeRemove === null ? undefined : beforeRemove" :on-change="onChange === null ? undefined : onChange" :on-progress="onProgress === null ? undefined : onProgress" :on-preview="onPreview === null ? undefined : onPreview" :on-remove="onRemove === null ? undefined : onRemove" :on-exceed="onExceed === null ? undefined : onExceed" :http-request="shinyUpload">
#>     <i class="el-icon-upload" v-if="drag"></i>
#>     <div class="el-upload__text" v-if="drag">{{label}}</div>
#>     <el-button v-if="!drag" size="small" type="primary">{{label}}</el-button>
#>     <div class="el-upload__tip" slot="tip">CSV files only</div>
#>   </el-upload>
#> </div>
#> <div id="files" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="files">{"x":{"el":"#files_container","data":{"drag":true,"label":"Upload","multiple":true,"showFileList":true,"listType":"text","autoUpload":true,"disabled":false,"accept":".csv","limit":null,"succeeded":[],"failed":"","headers":null,"extraData":null,"fileList":null,"withCredentials":null,"thumbnailMode":null,"beforeUpload":null,"beforeRemove":null,"onChange":null,"onProgress":null,"onPreview":null,"onRemove":null,"onExceed":null},"methods":{"handleSuccess":"function(response, file, fileList) { this.succeeded = fileList.filter(function(f) { return f.status === 'success'; }).map(function(f) { return f.name; }); Shiny.setInputValue('files_success', this.succeeded); }","handleError":"function(err, file) { this.failed = file.name; Shiny.setInputValue('files_error', file.name); }","shinyUpload":"function(options) {\n  var self = this, inputId = \"files\";\n  self._queue = self._queue || [];\n  self._queue.push(options);\n  if (self._flushing) return;\n  self._flushing = true;\n  Promise.resolve().then(function() {\n    var batch = self._queue.splice(0);\n    self._flushing = false;\n    var info = batch.map(function(o) {\n      return { name: o.file.name, size: o.file.size, type: o.file.type };\n    });\n    Shiny.shinyapp.makeRequest('uploadInit', [info], function(res) {\n      var remaining = batch.length;\n      batch.forEach(function(o) {\n        $.ajax(res.uploadUrl, {\n          type: 'POST', cache: false, data: o.file,\n          processData: false, contentType: 'application/octet-stream',\n          xhr: function() {\n            var x = new window.XMLHttpRequest();\n            x.upload.addEventListener('progress', function(e) {\n              if (e.lengthComputable) {\n                o.onProgress({ percent: Math.round(e.loaded / e.total * 100) });\n              }\n            });\n            return x;\n          },\n          success: function() {\n            o.onSuccess({ ok: true });\n            if (--remaining === 0) {\n              Shiny.shinyapp.makeRequest('uploadEnd', [res.jobId, inputId],\n                function() {}, function(e) { console.warn('[shiny.element] uploadEnd: ' + e); });\n            }\n          },\n          error: function() {\n            remaining--;\n            o.onError(new Error('Upload failed for ' + o.file.name));\n          }\n        });\n      });\n    }, function(e) {\n      console.warn('[shiny.element] uploadInit: ' + e);\n      batch.forEach(function(o) { o.onError(new Error(String(e))); });\n    });\n  });\n}"}},"evals":["methods.handleSuccess","methods.handleError","methods.shinyUpload"],"jsHooks":[]}</script>

# A plain button
el_upload("avatar", label = "Choose a picture", accept = "image/*")
#> <div id="avatar_container" style="display: contents">
#>   <el-upload ref="upload" name="avatar_elfile" action="#" :multiple="multiple" :show-file-list="showFileList" :list-type="listType" :auto-upload="autoUpload" :disabled="disabled" :accept="accept === null ? undefined : accept" :limit="limit === null ? undefined : limit" :on-success="handleSuccess" :on-error="handleError" :drag="drag" :headers="headers === null ? undefined : headers" :data="extraData === null ? undefined : extraData" :file-list="fileList === null ? undefined : fileList" :with-credentials="withCredentials === null ? undefined : withCredentials" :thumbnail-mode="thumbnailMode === null ? undefined : thumbnailMode" :before-upload="beforeUpload === null ? undefined : beforeUpload" :before-remove="beforeRemove === null ? undefined : beforeRemove" :on-change="onChange === null ? undefined : onChange" :on-progress="onProgress === null ? undefined : onProgress" :on-preview="onPreview === null ? undefined : onPreview" :on-remove="onRemove === null ? undefined : onRemove" :on-exceed="onExceed === null ? undefined : onExceed" :http-request="shinyUpload">
#>     <i class="el-icon-upload" v-if="drag"></i>
#>     <div class="el-upload__text" v-if="drag">{{label}}</div>
#>     <el-button v-if="!drag" size="small" type="primary">{{label}}</el-button>
#>   </el-upload>
#> </div>
#> <div id="avatar" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="avatar">{"x":{"el":"#avatar_container","data":{"drag":false,"label":"Choose a picture","multiple":false,"showFileList":true,"listType":"text","autoUpload":true,"disabled":false,"accept":"image/*","limit":null,"succeeded":[],"failed":"","headers":null,"extraData":null,"fileList":null,"withCredentials":null,"thumbnailMode":null,"beforeUpload":null,"beforeRemove":null,"onChange":null,"onProgress":null,"onPreview":null,"onRemove":null,"onExceed":null},"methods":{"handleSuccess":"function(response, file, fileList) { this.succeeded = fileList.filter(function(f) { return f.status === 'success'; }).map(function(f) { return f.name; }); Shiny.setInputValue('avatar_success', this.succeeded); }","handleError":"function(err, file) { this.failed = file.name; Shiny.setInputValue('avatar_error', file.name); }","shinyUpload":"function(options) {\n  var self = this, inputId = \"avatar\";\n  self._queue = self._queue || [];\n  self._queue.push(options);\n  if (self._flushing) return;\n  self._flushing = true;\n  Promise.resolve().then(function() {\n    var batch = self._queue.splice(0);\n    self._flushing = false;\n    var info = batch.map(function(o) {\n      return { name: o.file.name, size: o.file.size, type: o.file.type };\n    });\n    Shiny.shinyapp.makeRequest('uploadInit', [info], function(res) {\n      var remaining = batch.length;\n      batch.forEach(function(o) {\n        $.ajax(res.uploadUrl, {\n          type: 'POST', cache: false, data: o.file,\n          processData: false, contentType: 'application/octet-stream',\n          xhr: function() {\n            var x = new window.XMLHttpRequest();\n            x.upload.addEventListener('progress', function(e) {\n              if (e.lengthComputable) {\n                o.onProgress({ percent: Math.round(e.loaded / e.total * 100) });\n              }\n            });\n            return x;\n          },\n          success: function() {\n            o.onSuccess({ ok: true });\n            if (--remaining === 0) {\n              Shiny.shinyapp.makeRequest('uploadEnd', [res.jobId, inputId],\n                function() {}, function(e) { console.warn('[shiny.element] uploadEnd: ' + e); });\n            }\n          },\n          error: function() {\n            remaining--;\n            o.onError(new Error('Upload failed for ' + o.file.name));\n          }\n        });\n      });\n    }, function(e) {\n      console.warn('[shiny.element] uploadInit: ' + e);\n      batch.forEach(function(o) { o.onError(new Error(String(e))); });\n    });\n  });\n}"}},"evals":["methods.handleSuccess","methods.handleError","methods.shinyUpload"],"jsHooks":[]}</script>

# Element's own upload, straight to a pre-signed URL
el_upload("direct", action = "https://example.invalid/presigned")
#> <div id="direct_container" style="display: contents">
#>   <el-upload ref="upload" name="file" action="https://example.invalid/presigned" :multiple="multiple" :show-file-list="showFileList" :list-type="listType" :auto-upload="autoUpload" :disabled="disabled" :accept="accept === null ? undefined : accept" :limit="limit === null ? undefined : limit" :on-success="handleSuccess" :on-error="handleError" :drag="drag" :headers="headers === null ? undefined : headers" :data="extraData === null ? undefined : extraData" :file-list="fileList === null ? undefined : fileList" :with-credentials="withCredentials === null ? undefined : withCredentials" :thumbnail-mode="thumbnailMode === null ? undefined : thumbnailMode" :before-upload="beforeUpload === null ? undefined : beforeUpload" :before-remove="beforeRemove === null ? undefined : beforeRemove" :on-change="onChange === null ? undefined : onChange" :on-progress="onProgress === null ? undefined : onProgress" :on-preview="onPreview === null ? undefined : onPreview" :on-remove="onRemove === null ? undefined : onRemove" :on-exceed="onExceed === null ? undefined : onExceed">
#>     <i class="el-icon-upload" v-if="drag"></i>
#>     <div class="el-upload__text" v-if="drag">{{label}}</div>
#>     <el-button v-if="!drag" size="small" type="primary">{{label}}</el-button>
#>   </el-upload>
#> </div>
#> <div id="direct" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="direct">{"x":{"el":"#direct_container","data":{"drag":false,"label":"Upload","multiple":false,"showFileList":true,"listType":"text","autoUpload":true,"disabled":false,"accept":null,"limit":null,"succeeded":[],"failed":"","headers":null,"extraData":null,"fileList":null,"withCredentials":null,"thumbnailMode":null,"beforeUpload":null,"beforeRemove":null,"onChange":null,"onProgress":null,"onPreview":null,"onRemove":null,"onExceed":null},"methods":{"handleSuccess":"function(response, file, fileList) { this.succeeded = fileList.filter(function(f) { return f.status === 'success'; }).map(function(f) { return f.name; }); Shiny.setInputValue('direct_success', this.succeeded); }","handleError":"function(err, file) { this.failed = file.name; Shiny.setInputValue('direct_error', file.name); }"}},"evals":["methods.handleSuccess","methods.handleError"],"jsHooks":[]}</script>

if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_upload("files", drag = TRUE, multiple = TRUE),
    tableOutput("info")
  )
  server <- function(input, output, session) {
    output$info <- renderTable({
      req(input$files)
      input$files[, c("name", "size", "type")]
    })
  }
  shinyApp(ui, server)
}
```
