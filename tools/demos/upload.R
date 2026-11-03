## basic
#' `action` posts the files to a URL with Element's own upload -- here
#' upstream's mock service, as its example does. With no `action` they go
#' through Shiny's own upload channel, and `input$<id>` is the data frame
#' `fileInput()` gives -- `name`, `size`, `type`, `datapath`. `limit` caps
#' the number of files; `on_exceed` hears when there are more.
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

## limit-cover
#' With `limit = 1`, a new file covers the old one: `on_exceed` clears the
#' list and starts the new file, through the upload's own methods --
#' `$find(id)`, as upstream's `ref`. The button sends it, with `submit()`.
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

## avatar
#' One picture, no list: the slot draws the box, a `JS()` hook checks the
#' file before it goes.
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

## photo-wall
#' `list_type = "picture-card"`: each file a card with its thumbnail. A
#' card's preview button calls `on_preview`, which puts the file in a store
#' that a dialog follows -- as upstream's `dialogImageUrl` and
#' `dialogVisible`.
#| shot_js = c("document.querySelector('#photos .el-upload-list__item-preview').click()")
#| shot_wait = 2
#| shot_sel = ".el-overlay"
#| shot_expect = "document.querySelector('#photo_dialog img').src.indexOf('4e7f3a15429bfda99bce42a18cdd1jpeg') >= 0"
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

## custom-thumbnail
#' The `file` slot, scoped with `file`, draws each card, with buttons of
#' its own: zoom shows the file in a dialog that follows a store, as
#' upstream's; download and delete write it to the console.
#| shot_js = "document.querySelector('#thumbs .el-upload-list__item-preview').click()"
#| shot_wait = 2
#| shot_sel = ".el-overlay"
#| shot_expect = "document.querySelector('#thumb_dialog img').src.indexOf('4e7f3a15429bfda99bce42a18cdd1jpeg') >= 0"
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

## file-list-with-thumbnail
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

## file-list
#' `on_change` sees the list change; keeping only the last three files is a
#' line of JavaScript.
el_upload(
  "latest",
  button_label = "Click to upload",
  tip = "jpg/png files with a size less than 500kb",
  on_change = JS(
    "function(file, fileList) { if (fileList.length > 3) fileList.splice(0, fileList.length - 3); }"
  )
)

## drag-and-drop
el_upload(
  "dropped",
  drag = TRUE,
  multiple = TRUE,
  button_label = "Drop file here or click to upload",
  tip = "jpg/png files with a size less than 500kb"
)

## directory
#' `directory = TRUE` picks a folder, and uploads every file in it; here
#' dropped or chosen in the drag area.
#| shot_expect = "document.querySelector('#folder input[type=file]').webkitdirectory"
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

## manual
#' `auto_upload = FALSE` keeps the files until `submit()` sends them: from
#' the browser, `$find(id).submit()`, as upstream's `ref`; from the
#' server, `call_el()`.
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
