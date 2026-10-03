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
#' `list_type = "picture-card"`: each file a card with its thumbnail, drawn
#' in the browser from the file itself.
el_upload(
  "photos",
  list_type = "picture-card",
  accept = "image/*",
  multiple = TRUE,
  file_list = list(list(
    name = "food.jpeg",
    url = "https://fuss10.elemecdn.com/3/63/4e7f3a15429bfda99bce42a18cdd1jpeg.jpeg"
  ))
)

## custom-thumbnail
#' The `file` slot, scoped with `file`, draws each card.
el_upload(
  "thumbs",
  list_type = "picture-card",
  auto_upload = FALSE,
  accept = "image/*",
  slots = list(
    default = el_icon("Plus"),
    file = template(
      tags$div(
        tags$img(
          class = "el-upload-list__item-thumbnail",
          `:src` = "file.url",
          alt = ""
        ),
        tags$span(
          class = "el-upload-list__item-actions",
          tags$span(class = "el-upload-list__item-delete", "{{ file.name }}")
        )
      ),
      slot = "file",
      scope = "{ file }"
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
#' `directory = TRUE` picks a folder, and uploads every file in it.
el_upload("folder", directory = TRUE, button_label = "Upload directory")

## manual
#' `auto_upload = FALSE` keeps the files until `submit()` sends them -- from
#' the server, with `el_call()`.
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
  observeEvent(input$send, el_call(id = "queued", method = "submit"))
  output$arrived <- renderTable(input$queued[, c("name", "size")])
}

shinyApp(ui, server)
