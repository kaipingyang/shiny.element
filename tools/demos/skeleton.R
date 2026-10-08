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
#' The switch turns the placeholder off and on with
#' `update_el_skeleton(loading =)`.
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
ui <- el_page(
  tags$div(
    style = "display: flex; flex-direction: column; align-items: flex-start; gap: 8px",
    switch_ui("sk_switch", TRUE),
    el_skeleton(
      "sk_load",
      loading = TRUE,
      animated = TRUE,
      style = "width: 240px",
      card(hamburger, "Delicious hamburger"),
      slots = list(template = placeholder())
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$sk_switch, ignoreInit = TRUE, {
    update_el_skeleton(session, "sk_load", loading = input$sk_switch)
  })
}
shinyApp(ui, server)

## rendering-with-data
#' The button shows the placeholders again for two seconds, as a reload
#' would.
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
ui <- el_page(
  tags$div(
    style = "display: flex; flex-direction: column; gap: 8px",
    tags$div(el_button("sk_reload", "Click me to reload")),
    el_skeleton(
      "sk_list",
      loading = FALSE,
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
)
server <- function(input, output, session) {
  observeEvent(input$sk_reload, {
    update_el_skeleton(session, "sk_list", loading = TRUE)
    later::later(
      function() update_el_skeleton(session, "sk_list", loading = FALSE),
      2
    )
  })
}
shinyApp(ui, server)

## avoiding-rendering-bouncing
#' The placeholder shows only when loading lasts longer than `throttle`: switch it on and off quickly, and it never appears.
#| shot_js = "document.querySelector('#sk_throttle_switch .el-switch').click()"
#| shot_wait = 1.5
#| shot_expect = "document.querySelector('#sk_throttle .el-skeleton__item')"
hamburger <- "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
ui <- el_page(
  tags$div(
    style = "display: flex; flex-direction: column; align-items: flex-start; gap: 8px",
    tags$div(
      tags$label(style = "margin-right: 16px", "Switch Loading"),
      el_switch("sk_throttle_switch", value = FALSE)
    ),
    el_skeleton(
      "sk_throttle",
      loading = FALSE,
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
)
server <- function(input, output, session) {
  observeEvent(input$sk_throttle_switch, ignoreInit = TRUE, {
    update_el_skeleton(
      session,
      "sk_throttle",
      loading = input$sk_throttle_switch
    )
  })
}
shinyApp(ui, server)

## initial-rendering-loading
#' `initVal = TRUE` shows the placeholder from the start; afterwards it appears only after the leading delay.
#| shot_js = "document.querySelector('#sk_initial_switch .el-switch').click()"
#| shot_wait = 1.5
#| shot_expect = "document.querySelector('#sk_initial .el-card img')"
hamburger <- "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
ui <- el_page(
  tags$div(
    style = "display: flex; flex-direction: column; align-items: flex-start; gap: 8px",
    tags$div(
      tags$label(style = "margin-right: 16px", "Switch Loading"),
      el_switch("sk_initial_switch", value = TRUE)
    ),
    el_skeleton(
      "sk_initial",
      loading = TRUE,
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
)
server <- function(input, output, session) {
  observeEvent(input$sk_initial_switch, ignoreInit = TRUE, {
    update_el_skeleton(session, "sk_initial", loading = input$sk_initial_switch)
  })
}
shinyApp(ui, server)

## leading-trailing-without-bouncing
#' `leading` delays the placeholder, `trailing` keeps it a while after loading ends.
#| shot_js = "document.querySelector('#sk_lt_switch .el-switch').click()"
#| shot_wait = 1.5
#| shot_expect = "document.querySelector('#sk_lt .el-skeleton__item')"
hamburger <- "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
ui <- el_page(
  tags$div(
    style = "display: flex; flex-direction: column; align-items: flex-start; gap: 8px",
    tags$div(
      tags$label(style = "margin-right: 16px", "Switch Loading"),
      el_switch("sk_lt_switch", value = FALSE)
    ),
    el_skeleton(
      "sk_lt",
      loading = FALSE,
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
)
server <- function(input, output, session) {
  observeEvent(input$sk_lt_switch, ignoreInit = TRUE, {
    update_el_skeleton(session, "sk_lt", loading = input$sk_lt_switch)
  })
}
shinyApp(ui, server)
