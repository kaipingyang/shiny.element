## basic-usage
el_skeleton()

## configurable-rows
el_skeleton(rows = 5)

## animation
el_skeleton(rows = 5, animated = TRUE)

## customized-template
el_skeleton(width = "240px", slots = list(template = tagList(
  el$skeleton_item(variant = "image", style = "width: 240px; height: 240px"),
  tags$div(style = "padding: 14px",
    el$skeleton_item(variant = "p", style = "width: 50%"),
    tags$div(style = "display: flex; align-items: center; justify-items: space-between; margin-top: 16px; height: 16px",
      el$skeleton_item(variant = "text", style = "margin-right: 16px"),
      el$skeleton_item(variant = "text", style = "width: 30%"))))))

## loading-state
#' `update_el_skeleton(loading = FALSE)` swaps it for its content.
el_skeleton("sk_load", loading = TRUE, animated = TRUE,
  el_card(tags$img(src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png",
                   alt = "A hamburger", style = "width: 100%")))

## rendering-with-data
el_skeleton(count = 3, rows = 2, animated = TRUE)

## avoiding-rendering-bouncing
el_skeleton("sk_throttle", loading = TRUE, throttle = 500, animated = TRUE, "Content")

## initial-rendering-loading
el_skeleton("sk_initial", loading = TRUE, throttle = list(leading = 500, initVal = TRUE), "Content")

## leading-trailing-without-bouncing
el_skeleton("sk_lt", loading = TRUE, throttle = list(leading = 500, trailing = 500), "Content")
