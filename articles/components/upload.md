# Upload

Upload files by clicking or drag-and-drop. The files go through Shiny’s
own upload channel, so `input$<id>` is the data frame
[`fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html) gives –
`name`, `size`, `type`, `datapath` – while Element draws the list, the
progress and the thumbnails. Give `action` to send them straight to a
URL of your own instead.

## Click to upload files

`limit` caps the number of files; `on_exceed` hears when there are more.

``` r

ui <- el_page(
  el_upload("docs", button_label = "Click to upload", multiple = TRUE, limit = 3,
            tip = "jpg/png files with a size less than 500kb",
            on_exceed = JS("function(files, list) {",
                           "  ELEMENT.Message.warning('3 files at most');",
                           "}")),
  tableOutput("files"))

server <- function(input, output, session) {
  output$files <- renderTable(input$docs[, c("name", "size", "type")])
}

shinyApp(ui, server)
```

![The click example, running](../../shots/upload-click.png)

## Photo wall

`list_type = "picture-card"`: each file a card with its thumbnail, drawn
in the browser from the file itself.

``` r

el_upload("photos", list_type = "picture-card", accept = "image/*", multiple = TRUE,
          slots = list(default = el$icon("plus")))
```

## File list with thumbnails

``` r

el_upload("pics", list_type = "picture", button_label = "Click to upload",
          tip = "jpg/png files with a size less than 500kb", accept = "image/*",
          file_list = list(list(name = "food.jpeg",
                                url = "https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg")))
```

## File list control

`on_change` sees the list change; keeping only the last three files is a
line of JavaScript.

``` r

el_upload("latest", button_label = "Click to upload",
          on_change = JS("function(file, fileList) { if (fileList.length > 3) fileList.splice(0, fileList.length - 3); }"))
```

## Drag to upload

``` r

el_upload("dropped", drag = TRUE, multiple = TRUE,
          button_label = "Drop file here or click to upload",
          tip = "jpg/png files with a size less than 500kb")
```

## Manual upload

`auto_upload = FALSE` keeps the files until `submit()` sends them – from
the server, with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md).

``` r

ui <- el_page(
  el_upload("queued", auto_upload = FALSE, multiple = TRUE, button_label = "Select file",
            tip = "Chosen files wait for the button"),
  el_button("send", "Upload to server", type = "success", size = "small"),
  tableOutput("arrived"))

server <- function(input, output, session) {
  observeEvent(input$send, el_call(id = "queued", method = "submit"))
  output$arrived <- renderTable(input$queued[, c("name", "size")])
}

shinyApp(ui, server)
```

![The manual example, running](../../shots/upload-manual.png)

## Failures and cancelling

A file that fails, or is stopped with `abort()`, is left out and the
rest of its batch still arrives; `input$<id>_error` names it.
[`el_upload_file()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md)
names a file for a method:

``` r

el_call(session, "docs", "abort", list(el_upload_file("big.csv")))
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `action` | `action` | required, request URL | string | — | — |
| `headers` | `headers` | request headers | object | — | — |
| `multiple` | `multiple` | whether uploading multiple files is permitted | boolean | — | — |
| `data` | `extra_data` | additions options of request | object | — | — |
| `name` | `name` | key name for uploaded file | string | — | file |
| `with-credentials` | `with_credentials` | whether cookies are sent | boolean | — | false |
| `show-file-list` | `show_file_list` | whether to show the uploaded file list | boolean | — | true |
| `drag` | `drag` | whether to activate drag and drop mode | boolean | — | false |
| `accept` | `accept` | accepted [file types](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#attr-accept), will not work when `thumbnail-mode` is `true` | string | — | — |
| `on-preview` | `on_preview` | hook function when clicking the uploaded files | function(file) | — | — |
| `on-remove` | `on_remove` | hook function when files are removed | function(file, fileList) | — | — |
| `on-success` | `input$<id>` | hook function when uploaded successfully | function(response, file, fileList) | — | — |
| `on-error` | `input$<id>_error` | hook function when some errors occurs | function(err, file, fileList) | — | — |
| `on-progress` | `on_progress` | hook function when some progress occurs | function(event, file, fileList) | — | — |
| `on-change` | `on_change` | hook function when select file or upload file success or upload file fail | function(file, fileList) | — | — |
| `before-upload` | `before_upload` | hook function before uploading with the file to be uploaded as its parameter. If `false` is returned or a `Promise` is returned and then is rejected, uploading will be aborted | function(file) | — | — |
| `before-remove` | `before_remove` | hook function before removing a file with the file and file list as its parameters. If `false` is returned or a `Promise` is returned and then is rejected, removing will be aborted. | function(file, fileList) | — | — |
| `thumbnail-mode` | `thumbnail_mode` | whether thumbnail is displayed | boolean | — | false |
| `file-list` | `file_list` | default uploaded files, e.g. \[{name: ‘food.jpg’, url: ‘<https://xxx.cdn.com/xxx.jpg>’}\] | array | — | \[\] |
| `list-type` | `list_type` | type of fileList | string | text/picture/picture-card | text |
| `auto-upload` | `auto_upload` | whether to auto upload file | boolean | — | true |
| `http-request` | `(the Shiny upload)` | override default xhr behavior, allowing you to implement your own upload-file’s request | function | — | — |
| `disabled` | `disabled` | whether to disable upload | boolean | — | false |
| `limit` | `limit` | maximum number of uploads allowed | number | — | — |
| `on-exceed` | `on_exceed` | hook function when limit is exceeded | function(files, fileList) | — | \- |

### Slot

| Element   | In R                       | Description                        |
|-----------|----------------------------|------------------------------------|
| `trigger` | `slots = list(trigger = )` | content which triggers file dialog |
| `tip`     | `slots = list(tip = )`     | content of tips                    |

### Methods

| Element | In R | Description |
|----|----|----|
| `clearFiles` | `el_call(session, id, "clearFiles")` | clear the uploaded file list (this method is not supported in the `before-upload` hook) |
| `abort` | `el_call(session, id, "abort")` | cancel upload request |
| `submit` | `el_call(session, id, "submit")` | upload the file list manually |
