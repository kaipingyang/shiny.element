## basic
circle <- "https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png"
square <- "https://cube.elemecdn.com/9/c2/f0ee8a3c7c9638a54940382568c9dpng.png"
row <- function(...) {
  tags$div(style = "display: flex; gap: 20px; align-items: center", ...)
}
el_row(
  el_col(
    span = 12,
    tags$div("circle"),
    row(
      el_avatar(src = circle, size = 50),
      lapply(c("small", "default", "large"), function(s) {
        el_avatar(src = circle, size = s)
      })
    )
  ),
  el_col(
    span = 12,
    tags$div("square"),
    row(
      el_avatar(src = square, size = 50, shape = "square"),
      lapply(c("small", "default", "large"), function(s) {
        el_avatar(src = square, size = s, shape = "square")
      })
    )
  )
)

## types
tags$div(
  style = "display: flex; gap: 20px",
  el_avatar(icon = "UserFilled"),
  el_avatar(
    src = "https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
  ),
  el_avatar(content = "user")
)

## fallback
#' What the avatar shows when its image fails to load is its content.
el_avatar(
  src = "https://empty",
  size = 60,
  content = tags$img(
    src = "https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png",
    alt = "Fallback"
  )
)

## fit
url <- "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"
tags$div(
  style = "display: flex; gap: 20px",
  lapply(c("fill", "contain", "cover", "none", "scale-down"), function(f) {
    tags$div(
      style = "text-align: center",
      tags$div(f),
      el_avatar(src = url, size = 100, shape = "square", fit = f)
    )
  })
)

## group
url <- "https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png"
five <- function() lapply(1:5, function(i) el_avatar(src = url))
tagList(
  tags$p("default"),
  el_avatar_group(five()),
  tags$p("use collapse-avatars"),
  el_avatar_group(five(), collapse_avatars = TRUE),
  tags$p("use collapse-class and collapse-style"),
  el_avatar_group(
    five(),
    collapse_avatars = TRUE,
    collapse_class = "my-collapse-avatar",
    collapse_style = list("background-color" = "#d9ecff")
  )
)
