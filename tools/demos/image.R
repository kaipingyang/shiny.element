## basic-usage
url <- "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"
tagList(
  tags$style(
    ".demo-image .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); display: inline-block;
       width: 20%; min-width: 100px; box-sizing: border-box; vertical-align: top; }
     .demo-image .block:last-child { border-right: none; }
     .demo-image .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  tags$div(
    class = "demo-image",
    lapply(c("fill", "contain", "cover", "none", "scale-down"), function(f) {
      tags$div(
        class = "block",
        tags$span(class = "demonstration", f),
        el_image(src = url, fit = f, style = "width: 100px; height: 100px")
      )
    })
  )
)

## placeholder
#| shot_expect = "document.querySelectorAll('.demo-image__placeholder .el-image').length === 2"
src <- "https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg"
tagList(
  tags$style(
    ".demo-image__placeholder .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); display: inline-block;
       width: 49%; box-sizing: border-box; vertical-align: top; }
     .demo-image__placeholder .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }
     .demo-image__placeholder .el-image { padding: 0 5px; max-width: 300px;
       max-height: 200px; }
     .demo-image__placeholder .image-slot { display: flex; justify-content: center;
       align-items: center; width: 100%; height: 100%;
       background: var(--el-fill-color-light);
       color: var(--el-text-color-secondary); font-size: 14px; }
     .demo-image__placeholder .dot { animation: dot 2s infinite steps(3, start);
       overflow: hidden; }"
  ),
  tags$div(
    class = "demo-image__placeholder",
    tags$div(
      class = "block",
      tags$span(class = "demonstration", "Default"),
      el_image(src = src)
    ),
    tags$div(
      class = "block",
      tags$span(class = "demonstration", "Custom"),
      el_image(
        src = src,
        slots = list(
          placeholder = tags$div(
            class = "image-slot",
            "Loading",
            tags$span(class = "dot", "...")
          )
        )
      )
    )
  )
)

## load-failed
#' The third image's preview has a picture that fails to load, drawn by its
#' `viewer-error` slot; the button opens the same list in an
#' `el_image_viewer()`, with `update_el_image_viewer(visible = TRUE)`.
#| shot_js = c("document.querySelector('#err_open button').click()", "document.querySelector('.el-image-viewer__next').click()")
#| shot_sel = ".el-image-viewer__wrapper"
#| shot_wait = 2
#| shot_expect = c("document.querySelectorAll('.demo-image__error .el-image__error').length === 1", "document.querySelector('.el-image-viewer__wrapper .viewer-error').innerText.indexOf('current index: 1') >= 0")
url <- "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg"
src_list <- c(url, "https://errorSrc")
viewer_error <- template(
  slot = "viewer-error",
  scope = "{ activeIndex, src }",
  tags$div(
    class = "image-slot viewer-error",
    el_icon("Picture"),
    tags$span(
      "this is viewer-error slot. current index: {{ activeIndex }}. src:",
      "{{ src }}"
    )
  )
)
ui <- el_page(
  tags$style(
    ".demo-image__error .el-image { max-width: 300px; max-height: 200px;
       width: 100%; }
     .demo-image__error .image-slot { display: flex; justify-content: center;
       align-items: center; flex-direction: column; font-size: 30px;
       height: 200px; background: #fff; }
     .demo-image__error .image-slot .el-icon { font-size: 30px; }
     .image-viewer-slot { background: var(--el-fill-color-light); }
     .viewer-error { color: #000; }"
  ),
  tags$div(
    class = "demo-image__error",
    style = "display: flex; gap: 8px",
    el_image(),
    el_image(
      slots = list(
        error = tags$div(
          class = "image-viewer-slot image-slot",
          el_icon("Picture")
        )
      )
    ),
    el_image(
      src = url,
      preview_src_list = src_list,
      show_progress = TRUE,
      slots = list(`viewer-error` = viewer_error)
    ),
    tags$div(el_button("err_open", "preview controlled")),
    el_image_viewer(
      "err_viewer",
      url_list = src_list,
      show_progress = TRUE,
      slots = list(`viewer-error` = viewer_error)
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$err_open, {
    update_el_image_viewer(session, "err_viewer", visible = TRUE)
  })
}
shinyApp(ui, server)

## lazy-load
urls <- paste0(
  "https://fuss10.elemecdn.com/",
  c(
    "a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
    "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg",
    "0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg",
    "9/bb/e27858e973f5d7d3904835f46abbdjpeg.jpeg",
    "d/e6/c4d93a3805b3ce3f323f7974e6f78jpeg.jpeg",
    "3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg",
    "2/11/6535bcfb26e4c79b48ddde44f4b6fjpeg.jpeg"
  )
)
tagList(
  tags$style(
    ".demo-image__lazy { height: 400px; overflow-y: auto; }
     .demo-image__lazy .el-image { display: block; min-height: 200px;
       margin-bottom: 10px; }
     .demo-image__lazy .el-image:last-child { margin-bottom: 0; }"
  ),
  tags$div(
    class = "demo-image__lazy",
    lapply(urls, function(u) el_image(src = u, lazy = TRUE))
  )
)

## image-preview
#| shot_js = "document.querySelector('.demo-image__preview .el-image__inner').click()"
#| shot_sel = ".el-image-viewer__wrapper"
#| shot_wait = 2
#| shot_expect = "document.querySelector('.el-image-viewer__progress').innerText.replace(/\\s/g, '') === '5/7'"
url <- "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg"
src_list <- paste0(
  "https://fuss10.elemecdn.com/",
  c(
    "a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
    "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg",
    "0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg",
    "9/bb/e27858e973f5d7d3904835f46abbdjpeg.jpeg",
    "d/e6/c4d93a3805b3ce3f323f7974e6f78jpeg.jpeg",
    "3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg",
    "2/11/6535bcfb26e4c79b48ddde44f4b6fjpeg.jpeg"
  )
)
tags$div(
  class = "demo-image__preview",
  el_image(
    src = url,
    zoom_rate = 1.2,
    max_scale = 7,
    min_scale = 0.2,
    preview_src_list = src_list,
    show_progress = TRUE,
    initial_index = 4,
    fit = "cover",
    style = "width: 100px; height: 100px"
  )
)

## manually-preview
#' The first button opens the image's preview from the server with
#' `call_el(session, "pic", "showPreview")`; the second opens an
#' `el_image_viewer()`, the viewer alone, with
#' `update_el_image_viewer(visible = TRUE)`.
#| shot_js = "document.querySelector('#pic_open button').click()"
#| shot_sel = ".el-image-viewer__wrapper"
#| shot_wait = 2
#| shot_expect = "document.querySelector('.el-image-viewer__progress').innerText.replace(/\\s/g, '') === '1/7'"
url <- "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg"
src_list <- paste0(
  "https://fuss10.elemecdn.com/",
  c(
    "a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
    "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg",
    "0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg",
    "9/bb/e27858e973f5d7d3904835f46abbdjpeg.jpeg",
    "d/e6/c4d93a3805b3ce3f323f7974e6f78jpeg.jpeg",
    "3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg",
    "2/11/6535bcfb26e4c79b48ddde44f4b6fjpeg.jpeg"
  )
)
ui <- el_page(
  tags$div(
    style = "display: flex; gap: 48px",
    tags$div(
      style = "display: grid; gap: 12px",
      el_button("pic_open", "openPreview with showPreview method"),
      el_image(
        "pic",
        src = url,
        show_progress = TRUE,
        preview_src_list = src_list,
        fit = "cover",
        style = "width: 100px; height: 100px"
      )
    ),
    tags$div(
      el_button("viewer_open", "preview controlled"),
      el_image_viewer(
        "viewer",
        url_list = src_list,
        show_progress = TRUE,
        initial_index = 4
      )
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$pic_open, call_el(session, "pic", "showPreview"))
  observeEvent(input$viewer_open, {
    update_el_image_viewer(session, "viewer", visible = TRUE)
  })
}
shinyApp(ui, server)

## custom-toolbar
#' The `toolbar` slot's scope has the viewer's actions; the download link
#' reads the image's own `previewSrcList`.
#| shot_js = c("document.querySelector('.demo-image__custom-toolbar .el-image__inner').click()", "document.querySelectorAll('.el-image-viewer__actions .el-icon')[2].click()")
#| shot_sel = ".el-image-viewer__wrapper"
#| shot_wait = 2
#| shot_expect = c("document.querySelectorAll('.el-image-viewer__actions .el-icon').length === 9", "document.querySelector('.el-image-viewer__progress').innerText.replace(/\\s/g, '') === '7/7'")
url <- "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg"
src_list <- paste0(
  "https://fuss10.elemecdn.com/",
  c(
    "a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
    "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg",
    "0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg",
    "9/bb/e27858e973f5d7d3904835f46abbdjpeg.jpeg",
    "d/e6/c4d93a3805b3ce3f323f7974e6f78jpeg.jpeg",
    "3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg",
    "2/11/6535bcfb26e4c79b48ddde44f4b6fjpeg.jpeg"
  )
)
tags$div(
  class = "demo-image__custom-toolbar",
  el_image(
    src = url,
    preview_src_list = src_list,
    fit = "cover",
    show_progress = TRUE,
    style = "width: 100px; height: 100px",
    slots = list(
      toolbar = template(
        slot = "toolbar",
        scope = "{ actions, prev, next, reset, activeIndex, setActiveItem }",
        htmltools::HTML(paste0(
          "<el-icon @click=\"prev\"><Back /></el-icon>",
          "<el-icon @click=\"next\"><Right /></el-icon>",
          "<el-icon @click=\"setActiveItem(previewSrcList.length - 1)\">",
          "<DArrowRight /></el-icon>",
          "<el-icon @click=\"actions('zoomOut')\"><ZoomOut /></el-icon>",
          "<el-icon @click=\"actions('zoomIn', { enableTransition: false, zoomRate: 2 })\">",
          "<ZoomIn /></el-icon>",
          "<el-icon @click=\"actions('clockwise', { rotateDeg: 180, enableTransition: false })\">",
          "<RefreshRight /></el-icon>",
          "<el-icon @click=\"actions('anticlockwise')\"><RefreshLeft /></el-icon>",
          "<el-icon @click=\"reset\"><Refresh /></el-icon>",
          "<a :href=\"previewSrcList[activeIndex]\" download target=\"_blank\" ",
          "style=\"color: inherit; display: flex\">",
          "<el-icon><Download /></el-icon></a>"
        ))
      )
    )
  )
)

## custom-progress
#| shot_js = "document.querySelector('.demo-image__custom-progress .el-image__inner').click()"
#| shot_sel = ".el-image-viewer__wrapper"
#| shot_wait = 2
#| shot_expect = "document.querySelector('.el-image-viewer__progress').innerText.trim() === '1-7'"
url <- "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg"
src_list <- paste0(
  "https://fuss10.elemecdn.com/",
  c(
    "a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
    "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg",
    "0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg",
    "9/bb/e27858e973f5d7d3904835f46abbdjpeg.jpeg",
    "d/e6/c4d93a3805b3ce3f323f7974e6f78jpeg.jpeg",
    "3/28/bbf893f792f03a54408b3b7a7ebf0jpeg.jpeg",
    "2/11/6535bcfb26e4c79b48ddde44f4b6fjpeg.jpeg"
  )
)
tags$div(
  class = "demo-image__custom-progress",
  el_image(
    src = url,
    preview_src_list = src_list,
    fit = "cover",
    style = "width: 100px; height: 100px",
    slots = list(
      progress = template(
        slot = "progress",
        scope = "{ activeIndex, total }",
        htmltools::HTML("<span>{{ activeIndex + 1 + '-' + total }}</span>")
      )
    )
  )
)
