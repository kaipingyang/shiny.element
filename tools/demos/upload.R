## basic
#' The files go through Shiny's own upload channel, so `input$<id>` is the
#' data frame `fileInput()` gives -- `name`, `size`, `type`, `datapath` --
#' while Element Plus draws the list and the progress. `limit` caps the
#' number of files; `on_exceed` hears when there are more.
ui <- el_page(
  el_upload(
    "docs",
    button_label = "Click to upload",
    multiple = TRUE,
    limit = 3,
    tip = "jpg/png files with a size less than 500kb",
    on_exceed = JS(
      "function(files, list) {",
      "  ElementPlus.ElMessage.warning('3 files at most');",
      "}"
    )
  ),
  tableOutput("files")
)

server <- function(input, output, session) {
  output$files <- renderTable(input$docs[, c("name", "size", "type")])
}

shinyApp(ui, server)

## limit-cover
#' With `limit = 1`, one file at a time: `on_exceed` hears the next, and
#' the server clears the list with `el_upload_clear()` so a new one can come.
ui <- el_page(
  el_upload(
    "one",
    limit = 1,
    auto_upload = FALSE,
    button_label = "Select file",
    tip = "limit 1 file, clear it to choose another",
    on_exceed = JS(
      "function() { ElementPlus.ElMessage.warning('Clear the file first'); }"
    )
  ),
  el_button("clear", "Clear", size = "small")
)

server <- function(input, output, session) {
  observeEvent(input$clear, el_upload_clear(id = "one"))
}

shinyApp(ui, server)

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
#' card's preview button reports the file through `on_preview`, and the
#' server shows it in a dialog.
#| shot_js = c("document.querySelector('#photos .el-upload-list__item-preview').click()")
#| shot_wait = 2
#| shot_sel = ".el-overlay"
#| shot_expect = "document.querySelector('#photo_dialog img').src.indexOf('4e7f3a15429bfda99bce42a18cdd1jpeg') >= 0"
food <- "https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg"
plant <- "https://element-plus.org/images/plant-1.png"
ui <- el_page(
  el_upload(
    "photos",
    list_type = "picture-card",
    accept = "image/*",
    multiple = TRUE,
    file_list = list(
      list(name = "food.jpeg", url = food),
      list(name = "plant-1.png", url = plant),
      list(name = "food.jpeg", url = food)
    ),
    on_preview = JS(
      "function(file) { Shiny.setInputValue('photos_preview', file.url, {priority: 'event'}); }"
    ),
    slots = list(default = el_icon("Plus"))
  ),
  el_dialog("photo_dialog", content = uiOutput("photo_shown"))
)
server <- function(input, output, session) {
  output$photo_shown <- renderUI({
    req(input$photos_preview)
    tags$img(
      style = "width: 100%",
      src = input$photos_preview,
      alt = "Preview Image"
    )
  })
  observeEvent(input$photos_preview, {
    update_el_dialog(session, "photo_dialog", visible = TRUE)
  })
}
shinyApp(ui, server)

## custom-thumbnail
#' The `file` slot, scoped with `file`, draws each card, with buttons of
#' its own: zoom reports the file and the server shows it in a dialog.
#| shot_js = "document.querySelector('#thumbs .el-upload-list__item-preview').click()"
#| shot_wait = 2
#| shot_sel = ".el-overlay"
#| shot_expect = "document.querySelector('#thumb_dialog img').src.indexOf('4e7f3a15429bfda99bce42a18cdd1jpeg') >= 0"
ui <- el_page(
  el_upload(
    "thumbs",
    list_type = "picture-card",
    auto_upload = FALSE,
    accept = "image/*",
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
              `@click` = "$setInput('thumbs_preview', file.url)",
              el_icon("ZoomIn")
            ),
            tags$span(
              class = "el-upload-list__item-delete",
              `@click` = "$setInput('thumbs_download', file.name)",
              el_icon("Download")
            ),
            tags$span(
              class = "el-upload-list__item-delete",
              `@click` = "$setInput('thumbs_remove', file.name)",
              el_icon("Delete")
            )
          )
        )
      )
    )
  ),
  el_dialog("thumb_dialog", content = uiOutput("thumb_shown"))
)
server <- function(input, output, session) {
  output$thumb_shown <- renderUI({
    req(input$thumbs_preview)
    tags$img(
      style = "width: 100%",
      src = input$thumbs_preview,
      alt = "Preview Image"
    )
  })
  observeEvent(input$thumbs_preview, {
    update_el_dialog(session, "thumb_dialog", visible = TRUE)
  })
}
shinyApp(ui, server)

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
#' `auto_upload = FALSE` keeps the files until `submit()` sends them -- from
#' the server, with `call_el()`.
ui <- el_page(
  el_upload(
    "queued",
    auto_upload = FALSE,
    multiple = TRUE,
    button_label = "Select file",
    tip = "Chosen files wait for the button"
  ),
  el_button("send", "Upload to server", type = "success", size = "small"),
  tableOutput("arrived")
)

server <- function(input, output, session) {
  observeEvent(input$send, call_el(id = "queued", method = "submit"))
  output$arrived <- renderTable(input$queued[, c("name", "size")])
}

shinyApp(ui, server)
