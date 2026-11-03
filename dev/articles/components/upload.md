# Upload

Upload files by clicking or drag-and-drop.

## Basic Usage

Customize upload button type and text using `slot`. Set `limit` and
`on-exceed` to limit the maximum number of uploads allowed and specify
method when the limit is exceeded. Plus, you can abort removing a file
in the `before-remove` hook.

`action` posts the files to a URL with Element’s own upload – here
upstream’s mock service, as its example does. With no `action` they go
through Shiny’s own upload channel, and `input$<id>` is the data frame
[`fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html) gives –
`name`, `size`, `type`, `datapath`. `limit` caps the number of files;
`on_exceed` hears when there are more.

``` r

el_upload(
  "docs",
  action = "https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15",
  button_label = "Click to upload",
  multiple = TRUE,
  limit = 3,
  tip = "jpg/png files with a size less than 500KB.",
  file_list = list(
    list(
      name = "element-plus-logo.svg",
      url = "https://element-plus.org/images/element-plus-logo.svg"
    ),
    list(
      name = "element-plus-logo2.svg",
      url = "https://element-plus.org/images/element-plus-logo.svg"
    )
  ),
  on_preview = JS("function(uploadFile) { console.log(uploadFile); }"),
  on_remove = JS(
    "function(file, uploadFiles) { console.log(file, uploadFiles); }"
  ),
  before_remove = JS(
    "function(uploadFile) {",
    "  return ElementPlus.ElMessageBox.confirm('Cancel the transfer of ' + uploadFile.name + ' ?')",
    "    .then(function() { return true; }, function() { return false; });",
    "}"
  ),
  on_exceed = JS(
    "function(files, uploadFiles) {",
    "  ElementPlus.ElMessage.warning('The limit is 3, you selected ' + files.length +",
    "    ' files this time, add up to ' + (files.length + uploadFiles.length) + ' totally');",
    "}"
  )
)
```

## Cover Previous File

Set `limit` and `on-exceed` to automatically replace the previous file
when select a new file.

With `limit = 1`, a new file covers the old one: `on_exceed` clears the
list and starts the new file, through the upload’s own methods –
`$find(id)`, as upstream’s `ref`. The button sends it, with `submit()`.

``` r

el_upload(
  "cover",
  action = "https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15",
  limit = 1,
  auto_upload = FALSE,
  button_label = "select file",
  tip = "limit 1 file, new file will cover the old file",
  on_exceed = v_bind(paste(
    "(files) => { const upload = $find('cover'); upload.clearFiles();",
    "const file = files[0]; file.uid = ElementPlus.genFileId();",
    "upload.handleStart(file); }"
  ))
)
el_button(
  "cover_submit",
  "upload to server",
  type = "success",
  on = list(click = v_on("$find('cover').submit()"))
)
```

## User Avatar

Use `before-upload` hook to limit the upload file format and size.

One picture, no list: the slot draws the box, a
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
hook checks the file before it goes.

``` r

tagList(
  tags$style(
    ".avatar-uploader .el-upload { border: 1px dashed var(--el-border-color);",
    " border-radius: 6px; width: 178px; height: 178px; display: flex;",
    " align-items: center; justify-content: center; font-size: 28px; color: #8c939d; }"
  ),
  tags$div(
    class = "avatar-uploader",
    el_upload(
      "avatar",
      show_file_list = FALSE,
      accept = "image/*",
      before_upload = JS(
        "function(file) {",
        "  if (file.size / 1024 / 1024 > 2) {",
        "    ElementPlus.ElMessage.error('Avatar picture size can not exceed 2MB!');",
        "    return false;",
        "  }",
        "  return true;",
        "}"
      ),
      slots = list(default = el_icon("Plus"))
    )
  )
)
```

## Photo Wall

Use `list-type` to change the fileList style.

`list_type = "picture-card"`: each file a card with its thumbnail. A
card’s preview button calls `on_preview`, which puts the file in a store
that a dialog follows – as upstream’s `dialogImageUrl` and
`dialogVisible`.

``` r

food <- "https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg"
plant <- "https://element-plus.org/images/plant-1.png"
vue_store("photo_preview", state = list(url = "", open = FALSE))
el_upload(
  "photos",
  action = "https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15",
  list_type = "picture-card",
  file_list = list(
    list(name = "food.jpeg", url = food),
    list(name = "plant-1.png", url = plant),
    list(name = "food.jpeg", url = food)
  ),
  on_preview = v_bind(paste(
    "(uploadFile) => { $vueStore.photo_preview.url = uploadFile.url;",
    "$vueStore.photo_preview.open = true; }"
  )),
  on_remove = JS(
    "function(uploadFile, uploadFiles) { console.log(uploadFile, uploadFiles); }"
  ),
  slots = list(default = el_icon("Plus"))
)
el_dialog(
  "photo_dialog",
  visible = v_model("$vueStore.photo_preview.open"),
  content = vue_app(
    "photo_img",
    tags$img(
      style = "width: 100%",
      `:src` = "$vueStore.photo_preview.url",
      alt = "Preview Image"
    )
  )
)
```

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

## Custom Thumbnail

Use `scoped-slot` to change default thumbnail template.

The `file` slot, scoped with `file`, draws each card, with buttons of
its own: zoom shows the file in a dialog that follows a store, as
upstream’s; download and delete write it to the console.

``` r

vue_store("thumb_preview", state = list(url = "", open = FALSE))
el_upload(
  "thumbs",
  action = "https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15",
  list_type = "picture-card",
  auto_upload = FALSE,
  file_list = list(list(
    name = "food.jpeg",
    url = "https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg"
  )),
  slots = list(
    default = el_icon("Plus"),
    file = template(
      slot = "file",
      scope = "{ file }",
      tags$div(
        tags$img(
          class = "el-upload-list__item-thumbnail",
          `:src` = "file.url",
          alt = ""
        ),
        tags$span(
          class = "el-upload-list__item-actions",
          tags$span(
            class = "el-upload-list__item-preview",
            v_on(
              click = "$vueStore.thumb_preview.url = file.url; $vueStore.thumb_preview.open = true"
            ),
            el_icon("ZoomIn")
          ),
          tags$span(
            class = "el-upload-list__item-delete",
            v_on(click = "console.log(file)"),
            el_icon("Download")
          ),
          tags$span(
            class = "el-upload-list__item-delete",
            v_on(click = "console.log(file)"),
            el_icon("Delete")
          )
        )
      )
    )
  )
)
el_dialog(
  "thumb_dialog",
  visible = v_model("$vueStore.thumb_preview.open"),
  content = vue_app(
    "thumb_img",
    tags$img(
      style = "width: 100%",
      `:src` = "$vueStore.thumb_preview.url",
      alt = "Preview Image"
    )
  )
)
```

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

## File List with Thumbnail

``` r

el_upload(
  "pics",
  list_type = "picture",
  button_label = "Click to upload",
  tip = "jpg/png files with a size less than 500kb",
  accept = "image/*",
  file_list = list(list(
    name = "food.jpeg",
    url = "https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg"
  ))
)
```

## File List Control

Use `on-change` hook function to control upload file list.

`on_change` sees the list change; keeping only the last three files is a
line of JavaScript.

``` r

el_upload(
  "latest",
  button_label = "Click to upload",
  tip = "jpg/png files with a size less than 500kb",
  on_change = JS(
    "function(file, fileList) { if (fileList.length > 3) fileList.splice(0, fileList.length - 3); }"
  )
)
```

## Drag to Upload

You can drag your file to a certain area to upload it.

``` r

el_upload(
  "dropped",
  drag = TRUE,
  multiple = TRUE,
  button_label = "Drop file here or click to upload",
  tip = "jpg/png files with a size less than 500kb"
)
```

## Upload Directory

Enable folder upload via the `directory` prop.

After enabling it, only folders can be selected, and after selecting a
folder, the files within the folder will be flattened.

`directory = TRUE` picks a folder, and uploads every file in it; here
dropped or chosen in the drag area.

``` r

el_upload(
  "folder",
  drag = TRUE,
  directory = TRUE,
  multiple = TRUE,
  slots = list(
    default = tagList(
      el_icon("UploadFilled", class = "el-icon--upload"),
      tags$div(
        class = "el-upload__text",
        "Drop directory here or ",
        tags$em("click to upload")
      )
    )
  )
)
```

## Manual Upload

`auto_upload = FALSE` keeps the files until `submit()` sends them: from
the browser, `$find(id).submit()`, as upstream’s `ref`; from the server,
[`call_el()`](https://kaipingyang.github.io/shiny.element/dev/reference/call_el.md).

``` r

el_upload(
  "queued",
  action = "https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15",
  auto_upload = FALSE,
  button_label = "select file",
  tip = "jpg/png files with a size less than 500kb"
)
el_button(
  "send",
  "upload to server",
  type = "success",
  on = list(click = v_on("$find('queued').submit()"))
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `action` | `action` | request URL. | [^1] |  | \# |
| `headers` | `headers` | request headers. | [^2]`Headers \\| Record<string, any>` |  | — |
| `multiple` | `multiple` | whether uploading multiple files is permitted. | [^3] |  | false |
| `data` | `data` | additions options of request. support `Awaitable` data and `Function` since v2.3.13. | [^4]`Record<string, any> \\| Awaitable<Record<string, any>>` / [^5]`(rawFile: UploadRawFile) => Awaitable<Record<string, any>>` |  | {} |
| `with-credentials` | `with_credentials` | whether cookies are sent. | [^6] |  | false |
| `show-file-list` | `show_file_list` | whether to show the uploaded file list. | [^7] |  | true |
| `drag` | `drag` | whether to activate drag and drop mode. | [^8] |  | false |
| `accept` | `accept` | accepted [file types](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#attr-accept), will not work when `thumbnail-mode === true`. | [^9] |  | ’’ |
| `crossorigin` | `crossorigin` | native attribute [crossorigin](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/crossorigin). | [^10]`'' \\| 'anonymous' \\| 'use-credentials'` |  | — |
| `on-preview` | `on_preview` | hook function when clicking the uploaded files. | [^11]`(uploadFile: UploadFile) => void` |  | — |
| `on-remove` | `on_remove` | hook function when files are removed. | [^12]`(uploadFile: UploadFile, uploadFiles: UploadFiles) => void` |  | — |
| `on-success` | `input$<id>` | hook function when uploaded successfully. | [^13]`(response: any, uploadFile: UploadFile, uploadFiles: UploadFiles) => void` |  | — |
| `on-error` | `input$<id>_error` | hook function when some errors occurs. | [^14]`(error: Error, uploadFile: UploadFile, uploadFiles: UploadFiles) => void` |  | — |
| `on-progress` | `on_progress` | hook function when some progress occurs. | [^15]`(evt: UploadProgressEvent, uploadFile: UploadFile, uploadFiles: UploadFiles) => void` |  | — |
| `on-change` | `on_change` | hook function when select file or upload file success or upload file fail. | [^16]`(uploadFile: UploadFile, uploadFiles: UploadFiles) => void` |  | — |
| `on-exceed` | `on_exceed` | hook function when limit is exceeded. | [^17]`(files: File[], uploadFiles: UploadUserFile[]) => void` |  | — |
| `before-upload` | `before_upload` | hook function before uploading with the file to be uploaded as its parameter. If `false` is returned or a `Promise` is returned and then is rejected, uploading will be aborted. | [^18]`(rawFile: UploadRawFile) => Awaitable<void \\| undefined \\| null \\| boolean \\| File \\| Blob>` |  | — |
| `before-remove` | `before_remove` | hook function before removing a file with the file and file list as its parameters. If `false` is returned or a `Promise` is returned and then is rejected, removing will be aborted. | [^19]`(uploadFile: UploadFile, uploadFiles: UploadFiles) => Awaitable<boolean>` |  | — |
| `file-list` | `file_list` | default uploaded files. | [^20]`UploadUserFile[]` |  | \[\] |
| `list-type` | `list_type` | type of file list. | [^21]`'text' \\| 'picture' \\| 'picture-card'` |  | text |
| `auto-upload` | `auto_upload` | whether to auto upload file. | [^22] |  | true |
| `http-request` | `(the Shiny upload)` | override default xhr behavior, allowing you to implement your own upload-file’s request. | [^23]`(options: UploadRequestOptions) => XMLHttpRequest \\| Promise<unknown>` |  | ajaxUpload [see](https://github.com/element-plus/element-plus/blob/dev/packages/components/upload/src/ajax.ts#L55) |
| `disabled` | `disabled` | whether to disable upload. | [^24] |  | false |
| `limit` | `limit` | maximum number of uploads allowed. | [^25] |  | — |
| `directory` | `directory` | whether to support uploading directory. After enabling it, only folders can be selected, and after selecting a folder, the files within the folder will be flattened. | [^26] |  | false |

### Slots

| Element   | In R                       | Description                         |
|-----------|----------------------------|-------------------------------------|
| `default` | default content            | customize default content.          |
| `trigger` | `slots = list(trigger = )` | content which triggers file dialog. |
| `tip`     | `slots = list(tip = )`     | content of tips.                    |
| `file`    | `slots = list(file = )`    | content of thumbnail template.      |

### Exposes

| Element | In R | Description |
|----|----|----|
| `abort` | `call_el(session, id, "abort")` | cancel upload request. When a `file` is specified, abort the corresponding pending upload; when no file is specified, abort all pending uploads. |
| `submit` | `call_el(session, id, "submit")` | upload the file list manually. |
| `clearFiles` | `call_el(session, id, "clearFiles")` | clear the file list (this method is not supported in the `before-upload` hook). |
| `handleStart` | `call_el(session, id, "handleStart")` | select the file manually. |
| `handleRemove` | `call_el(session, id, "handleRemove")` | remove the file manually. `file` and `rawFile` has been merged. `rawFile` will be removed in `v2.2.0`. |

[^1]: string

[^2]: object

[^3]: boolean

[^4]: object

[^5]: Function

[^6]: boolean

[^7]: boolean

[^8]: boolean

[^9]: string

[^10]: enum

[^11]: Function

[^12]: Function

[^13]: Function

[^14]: Function

[^15]: Function

[^16]: Function

[^17]: Function

[^18]: Function

[^19]: Function

[^20]: array

[^21]: enum

[^22]: boolean

[^23]: Function

[^24]: boolean

[^25]: number

[^26]: boolean
