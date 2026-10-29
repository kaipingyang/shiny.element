## basic-usage
el_skeleton()

## configurable-rows
el_skeleton(rows = 5)

## animation
el_skeleton(rows = 5, animated = TRUE)

## customized-template
el_skeleton(
  width = "240px",
  slots = list(
    template = tagList(
      el$skeleton_item(
        variant = "image",
        style = "width: 240px; height: 240px"
      ),
      tags$div(
        style = "padding: 14px",
        el$skeleton_item(variant = "p", style = "width: 50%"),
        tags$div(
          style = "display: flex; align-items: center; justify-items: space-between; margin-top: 16px; height: 16px",
          el$skeleton_item(variant = "text", style = "margin-right: 16px"),
          el$skeleton_item(variant = "text", style = "width: 30%")
        )
      )
    )
  )
)

## loading-state
#' The switch turns the placeholder off and on: `loading` follows it in
#' the browser, [vue_bind()].
#| shot_js = "document.querySelector('#sk_switch .el-switch').click()"
#| shot_expect = "document.querySelector('#sk_load .el-card img') && !document.querySelector('#sk_load .el-skeleton__item')"
hamburger <- "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
placeholder <- function(height = "240px") {
  tagList(
    el$skeleton_item(
      variant = "image",
      style = paste0("width: 240px; height: ", height)
    ),
    tags$div(
      style = "padding: 14px",
      el$skeleton_item(variant = "h3", style = "width: 50%"),
      tags$div(
        style = "display: flex; align-items: center; justify-items: space-between; margin-top: 16px; height: 16px",
        el$skeleton_item(variant = "text", style = "margin-right: 16px"),
        el$skeleton_item(variant = "text", style = "width: 30%")
      )
    )
  )
}
card <- function(src, name, button = "Operation button") {
  el_card(
    body_style = list(padding = "0px", marginBottom = "1px"),
    tags$img(src = src, style = "width: 100%; display: block"),
    tags$div(
      style = "padding: 14px",
      tags$span(name),
      tags$div(
        style = "margin-top: 13px; line-height: 12px; display: flex; justify-content: space-between; align-items: center",
        tags$div(
          style = "font-size: 12px; color: #999",
          format(Sys.Date(), "%a %b %d %Y")
        ),
        el_button(label = button, text = TRUE)
      )
    )
  )
}
switch_ui <- function(id, value) {
  tags$div(
    tags$label(style = "margin-right: 16px", "Switch Loading"),
    el_switch(id, value = value)
  )
}
tags$div(
  style = "display: flex; flex-direction: column; align-items: flex-start; gap: 8px",
  switch_ui("sk_switch", TRUE),
  el_skeleton(
    "sk_load",
    loading = vue_bind("$inputs.sk_switch"),
    animated = TRUE,
    style = "width: 240px",
    card(hamburger, "Delicious hamburger"),
    slots = list(template = placeholder())
  )
)

## rendering-with-data
#' The button shows the placeholders again for two seconds, as a reload
#' would: a store's action sets `loading`, [vue_bind()], and clears it.
#| shot_js = "document.querySelector('#sk_reload button').click()"
#| shot_wait = 0.5
#| shot_expect = "document.querySelectorAll('#sk_list .el-skeleton__image').length === 3"
pictures <- c(
  Deer = "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
  Horse = "https://fuss10.elemecdn.com/1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg",
  "Mountain Lion" = "https://fuss10.elemecdn.com/0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg"
)
card <- function(src, name) {
  el_card(
    body_style = list(padding = "0px", marginBottom = "1px"),
    style = "flex: 1",
    tags$img(src = src, style = "max-width: 100%; display: block"),
    tags$div(
      style = "padding: 14px",
      tags$span(name),
      tags$div(
        style = "margin-top: 13px; line-height: 12px; display: flex; justify-content: space-between; align-items: center",
        tags$div(
          style = "font-size: 12px; color: #999",
          format(Sys.Date(), "%a %b %d %Y")
        ),
        el_button(label = "Operation button", text = TRUE)
      )
    )
  )
}
vue_store(
  "reloading",
  state = list(loading = FALSE),
  actions = list(
    reload = JS(
      "function() {
        var s = this;
        s.loading = true;
        setTimeout(function() { s.loading = false; }, 2000);
      }"
    )
  )
)
tags$div(
  style = "display: flex; flex-direction: column; gap: 8px",
  tags$div(
    el_button(
      "sk_reload",
      "Click me to reload",
      on = list(click = "$store.reloading.reload()")
    )
  ),
  el_skeleton(
    "sk_list",
    loading = vue_bind("$store.reloading.loading"),
    animated = TRUE,
    count = 3,
    style = "display: flex; gap: 8px",
    tags$div(
      style = "display: flex; gap: 8px",
      unname(Map(card, pictures, names(pictures)))
    ),
    slots = list(
      template = tags$div(
        style = "flex: 1",
        el$skeleton_item(variant = "image", style = "height: 240px"),
        tags$div(
          style = "padding: 14px",
          el$skeleton_item(variant = "h3", style = "width: 50%"),
          tags$div(
            style = "display: flex; align-items: center; justify-items: space-between; margin-top: 16px; height: 16px",
            el$skeleton_item(variant = "text", style = "margin-right: 16px"),
            el$skeleton_item(variant = "text", style = "width: 30%")
          )
        )
      )
    )
  )
)

## avoiding-rendering-bouncing
#' The placeholder shows only when loading lasts longer than `throttle`: switch it on and off quickly, and it never appears.
#| shot_js = "document.querySelector('#sk_throttle_switch .el-switch').click()"
#| shot_wait = 1.5
#| shot_expect = "document.querySelector('#sk_throttle .el-skeleton__item')"
hamburger <- "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
tags$div(
  style = "display: flex; flex-direction: column; align-items: flex-start; gap: 8px",
  tags$div(
    tags$label(style = "margin-right: 16px", "Switch Loading"),
    el_switch("sk_throttle_switch", value = FALSE)
  ),
  el_skeleton(
    "sk_throttle",
    loading = vue_bind("$inputs.sk_throttle_switch"),
    animated = TRUE,
    throttle = 500,
    style = "width: 240px",
    el_card(
      body_style = list(padding = "0px", marginBottom = "1px"),
      tags$img(src = hamburger, style = "width: 100%; display: block"),
      tags$div(
        style = "padding: 14px",
        tags$span("Delicious hamburger"),
        tags$div(
          style = "margin-top: 13px; line-height: 12px; display: flex; justify-content: space-between; align-items: center",
          tags$div(
            style = "font-size: 12px; color: #999",
            format(Sys.Date(), "%a %b %d %Y")
          ),
          el_button(label = "operation button", text = TRUE)
        )
      )
    ),
    slots = list(
      template = tagList(
        el$skeleton_item(
          variant = "image",
          style = "width: 240px; height: 265px"
        ),
        tags$div(
          style = "padding: 14px",
          el$skeleton_item(variant = "h3", style = "width: 50%"),
          tags$div(
            style = "display: flex; align-items: center; justify-items: space-between; margin-top: 16px; height: 16px",
            el$skeleton_item(variant = "text", style = "margin-right: 16px"),
            el$skeleton_item(variant = "text", style = "width: 30%")
          )
        )
      )
    )
  )
)

## initial-rendering-loading
#' `initVal = TRUE` shows the placeholder from the start; afterwards it appears only after the leading delay.
#| shot_js = "document.querySelector('#sk_initial_switch .el-switch').click()"
#| shot_wait = 1.5
#| shot_expect = "document.querySelector('#sk_initial .el-card img')"
hamburger <- "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
tags$div(
  style = "display: flex; flex-direction: column; align-items: flex-start; gap: 8px",
  tags$div(
    tags$label(style = "margin-right: 16px", "Switch Loading"),
    el_switch("sk_initial_switch", value = TRUE)
  ),
  el_skeleton(
    "sk_initial",
    loading = vue_bind("$inputs.sk_initial_switch"),
    animated = TRUE,
    throttle = list(leading = 500, initVal = TRUE),
    style = "width: 240px",
    el_card(
      body_style = list(padding = "0px", marginBottom = "1px"),
      tags$img(src = hamburger, style = "width: 100%; display: block"),
      tags$div(
        style = "padding: 14px",
        tags$span("Delicious hamburger"),
        tags$div(
          style = "margin-top: 13px; line-height: 12px; display: flex; justify-content: space-between; align-items: center",
          tags$div(
            style = "font-size: 12px; color: #999",
            format(Sys.Date(), "%a %b %d %Y")
          ),
          el_button(label = "operation button", text = TRUE)
        )
      )
    ),
    slots = list(
      template = tagList(
        el$skeleton_item(
          variant = "image",
          style = "width: 240px; height: 265px"
        ),
        tags$div(
          style = "padding: 14px",
          el$skeleton_item(variant = "h3", style = "width: 50%"),
          tags$div(
            style = "display: flex; align-items: center; justify-items: space-between; margin-top: 16px; height: 16px",
            el$skeleton_item(variant = "text", style = "margin-right: 16px"),
            el$skeleton_item(variant = "text", style = "width: 30%")
          )
        )
      )
    )
  )
)

## leading-trailing-without-bouncing
#' `leading` delays the placeholder, `trailing` keeps it a while after loading ends.
#| shot_js = "document.querySelector('#sk_lt_switch .el-switch').click()"
#| shot_wait = 1.5
#| shot_expect = "document.querySelector('#sk_lt .el-skeleton__item')"
hamburger <- "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
tags$div(
  style = "display: flex; flex-direction: column; align-items: flex-start; gap: 8px",
  tags$div(
    tags$label(style = "margin-right: 16px", "Switch Loading"),
    el_switch("sk_lt_switch", value = FALSE)
  ),
  el_skeleton(
    "sk_lt",
    loading = vue_bind("$inputs.sk_lt_switch"),
    animated = TRUE,
    throttle = list(leading = 500, trailing = 500, initVal = TRUE),
    style = "width: 240px",
    el_card(
      body_style = list(padding = "0px", marginBottom = "1px"),
      tags$img(src = hamburger, style = "width: 100%; display: block"),
      tags$div(
        style = "padding: 14px",
        tags$span("Delicious hamburger"),
        tags$div(
          style = "margin-top: 13px; line-height: 12px; display: flex; justify-content: space-between; align-items: center",
          tags$div(
            style = "font-size: 12px; color: #999",
            format(Sys.Date(), "%a %b %d %Y")
          ),
          el_button(label = "operation button", text = TRUE)
        )
      )
    ),
    slots = list(
      template = tagList(
        el$skeleton_item(
          variant = "image",
          style = "width: 240px; height: 265px"
        ),
        tags$div(
          style = "padding: 14px",
          el$skeleton_item(variant = "h3", style = "width: 50%"),
          tags$div(
            style = "display: flex; align-items: center; justify-items: space-between; margin-top: 16px; height: 16px",
            el$skeleton_item(variant = "text", style = "margin-right: 16px"),
            el$skeleton_item(variant = "text", style = "width: 30%")
          )
        )
      )
    )
  )
)
