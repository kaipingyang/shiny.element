## basic-usage
url <- "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"
tags$div(style = "display: flex; gap: 20px",
  lapply(c("fill", "contain", "cover", "none", "scale-down"), function(f)
    tags$div(style = "text-align: center", tags$div(class = "demonstration", f),
             el_image(src = url, fit = f, alt = f, width = "100px"))))

## placeholder
src <- "https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg"
tags$div(style = "display: flex; gap: 40px",
  tags$div(tags$div(class = "demonstration", "Default"), el_image(src = src, alt = "Default")),
  tags$div(tags$div(class = "demonstration", "Custom"), el_image(src = src, alt = "Custom",
    slots = list(placeholder = tags$div(class = "image-slot", "Loading", tags$span(class = "dot", "..."))))))

## load-failed
tags$div(style = "display: flex; gap: 8px",
  el_image(alt = "Default"),
  el_image(alt = "Custom", slots = list(error = tags$div(class = "image-slot", el_icon("Picture")))))

## lazy-load
urls <- paste0("https://fuss10.elemecdn.com/", c("a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
  "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg", "0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg",
  "9/bb/e27858e973f5d7d3904835f46abbdjpeg.jpeg"))
tags$div(style = "height: 400px; overflow-y: auto",
  lapply(urls, function(u) el_image(src = u, lazy = TRUE, alt = "lazy")))

## image-preview
url <- "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg"
src_list <- paste0("https://fuss10.elemecdn.com/", c("a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
  "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg", "0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg"))
el_image(src = url, alt = "preview", fit = "cover", width = "100px", zoom_rate = 1.2,
         max_scale = 7, min_scale = 0.2, preview_src_list = src_list, initial_index = 1)

## manually-preview
#' `el_call(session, "pic", "showPreview")` opens the preview from the server;
#' `el_image_viewer()` is the viewer alone, opened with `update_el_image_viewer()`.
url <- "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg"
tagList(
  el_image("pic", src = url, alt = "preview", width = "100px", preview_src_list = list(url)),
  el_image_viewer("viewer", url_list = c(url)))

## custom-toolbar
src_list <- paste0("https://fuss10.elemecdn.com/", c("a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
  "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg"))
el_image(src = src_list[1], alt = "preview", fit = "cover", width = "100px",
  preview_src_list = src_list, show_progress = TRUE,
  slots = list(toolbar = template(htmltools::HTML(paste0(
    "<el-icon @click=\"prev\"><Back /></el-icon>",
    "<el-icon @click=\"next\"><Right /></el-icon>",
    "<el-icon @click=\"setActiveItem(0)\"><DArrowLeft /></el-icon>",
    "<el-icon @click=\"actions('zoomOut')\"><ZoomOut /></el-icon>",
    "<el-icon @click=\"actions('zoomIn')\"><ZoomIn /></el-icon>")),
    slot = "toolbar", scope = "{ actions, prev, next, setActiveItem }")))

## custom-progress
src_list <- paste0("https://fuss10.elemecdn.com/", c("a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
  "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg"))
el_image(src = src_list[1], alt = "preview", fit = "cover", width = "100px",
  preview_src_list = src_list,
  slots = list(progress = template(htmltools::HTML(
    "<span>{{ activeIndex + 1 }} / {{ total }}</span>"),
    slot = "progress", scope = "{ activeIndex, total }")))
