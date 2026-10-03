## basic
types <- c("default", "primary", "success", "info", "warning", "danger")
label <- function(t) tools::toTitleCase(t)
row <- function(...) tags$div(style = "margin-bottom: 16px", ...)
tagList(
  row(lapply(types, function(t) {
    el_button(paste0("b_", t), label(t), type = t)
  })),
  row(lapply(types, function(t) {
    el_button(paste0("p_", t), label(t), type = t, plain = TRUE)
  })),
  row(lapply(types, function(t) {
    el_button(paste0("r_", t), label(t), type = t, round = TRUE)
  })),
  row(lapply(types, function(t) {
    el_button(paste0("d_", t), label(t), type = t, dashed = TRUE)
  })),
  row(Map(
    function(t, i) {
      el_button(paste0("c_", t), NULL, type = t, circle = TRUE, icon = i)
    },
    types,
    c("Search", "Edit", "Check", "Message", "Star", "Delete")
  ))
)

## disabled
types <- c("default", "primary", "success", "info", "warning", "danger")
tagList(
  tags$div(
    style = "margin-bottom: 16px",
    lapply(types, function(t) {
      el_button(
        paste0("dis_", t),
        tools::toTitleCase(t),
        type = t,
        disabled = TRUE
      )
    })
  ),
  lapply(types, function(t) {
    el_button(
      paste0("disp_", t),
      tools::toTitleCase(t),
      type = t,
      plain = TRUE,
      disabled = TRUE
    )
  })
)

## link
types <- c("default", "primary", "success", "info", "warning", "danger")
tagList(
  tags$p("Basic link button"),
  tags$div(lapply(types, function(t) {
    el_button(paste0("l_", t), t, type = t, link = TRUE)
  })),
  tags$p("Disabled link button"),
  tags$div(lapply(types, function(t) {
    el_button(paste0("ld_", t), t, type = t, link = TRUE, disabled = TRUE)
  }))
)

## text
types <- c("default", "primary", "success", "info", "warning", "danger")
tagList(
  tags$p("Basic text button"),
  tags$div(lapply(types, function(t) {
    el_button(paste0("t_", t), t, type = t, text = TRUE)
  })),
  tags$p("Background color always on"),
  tags$div(lapply(types, function(t) {
    el_button(paste0("tb_", t), t, type = t, text = TRUE, bg = TRUE)
  })),
  tags$p("Disabled text button"),
  tags$div(lapply(types, function(t) {
    el_button(paste0("td_", t), t, type = t, text = TRUE, disabled = TRUE)
  }))
)

## icon
tagList(
  el_button("i1", NULL, type = "primary", icon = "Edit"),
  el_button("i2", NULL, type = "primary", icon = "Share"),
  el_button("i3", NULL, type = "primary", icon = "Delete"),
  el_button("i4", "Search", type = "primary", icon = "Search"),
  el_button("i5", "Upload", type = "primary", icon = "Upload")
)

## group
#' The group's direction set in R; Element Plus's demo switches it with a radio.
tagList(
  el_button_group(
    el_button("prev", "Previous Page", type = "primary", icon = "ArrowLeft"),
    el_button("next", "Next Page", type = "primary", icon = "ArrowRight")
  ),
  tags$br(),
  tags$br(),
  el_button_group(
    direction = "vertical",
    el_button("g1", NULL, type = "primary", icon = "House"),
    el_button("g2", NULL, type = "primary", icon = "Operation"),
    el_button("g3", NULL, type = "primary", icon = "Notification")
  )
)

## loading
tagList(
  el_button("ld1", "Loading", type = "primary", loading = TRUE),
  el_button(
    "ld2",
    "Loading",
    type = "primary",
    loading = TRUE,
    loading_icon = "Eleme"
  )
)

## size
row <- function(...) {
  tags$div(
    style = "margin-bottom: 16px; display: flex; align-items: center; gap: 12px",
    ...
  )
}
sizes <- c(large = "Large", default = "Default", small = "Small")
tagList(
  row(
    Map(
      function(s, l) el_button(paste0("s_", s), l, size = s),
      names(sizes),
      sizes
    ),
    Map(
      function(s) {
        el_button(paste0("si_", s), "Search", size = s, icon = "Search")
      },
      names(sizes)
    )
  ),
  row(
    Map(
      function(s, l) el_button(paste0("sr_", s), l, size = s, round = TRUE),
      names(sizes),
      sizes
    ),
    Map(
      function(s) {
        el_button(
          paste0("sri_", s),
          "Search",
          size = s,
          icon = "Search",
          round = TRUE
        )
      },
      names(sizes)
    )
  ),
  row(Map(
    function(s) {
      el_button(
        paste0("sc_", s),
        NULL,
        size = s,
        icon = "Search",
        circle = TRUE
      )
    },
    names(sizes)
  ))
)

## tag
tagList(
  el_button("tag1", "button"),
  el_button("tag2", "div", tag = "div")
)

## custom
#' `color` makes the hover and active shades for it; `dark` for a dark page.
opts <- list(
  list("Default"),
  list("Plain", plain = TRUE),
  list("Link", link = TRUE),
  list("Text", text = TRUE),
  list("Text BG", text = TRUE, bg = TRUE)
)
tagList(
  lapply(seq_along(opts), function(i) {
    do.call(
      el_button,
      c(list(paste0("cc", i), opts[[i]][[1]], color = "#626aef"), opts[[i]][-1])
    )
  }),
  lapply(seq_along(opts), function(i) {
    do.call(
      el_button,
      c(
        list(
          paste0("ccd", i),
          paste("Disabled", opts[[i]][[1]]),
          color = "#626aef",
          disabled = TRUE
        ),
        opts[[i]][-1]
      )
    )
  })
)
