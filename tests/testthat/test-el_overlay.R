render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

sent_input <- function(expr) {
  sent <- NULL
  session <- list(
    ns = function(id) id,
    sendInputMessage = function(id, msg) sent <<- list(id = id, msg = msg),
    sendCustomMessage = function(type, msg) stop("should not be used")
  )
  expr(session)
  sent
}

# ── markup ────────────────────────────────────────────────────────────────────

test_that("el_dialog and el_drawer render markup with no Vue instance", {
  for (html in list(render_html(el_dialog("d1", title = "T", content = "body")),
                    render_html(el_drawer("w1", title = "T", content = "body")))) {
    expect_false(grepl("application/json", html, fixed = TRUE))
    expect_false(grepl("html-widget", html, fixed = TRUE))
  }
  expect_false(grepl("<el-dialog", render_html(el_dialog("d1")), fixed = TRUE))
  expect_false(grepl("<el-drawer", render_html(el_drawer("w1")), fixed = TRUE))
})

test_that("el_dialog reproduces Element's structure", {
  html <- render_html(el_dialog("d1", title = "T", content = "body",
                                footer = "f"))
  for (cls in c("el-dialog__wrapper", "el-dialog__header", "el-dialog__title",
                "el-dialog__headerbtn", "el-dialog__body", "el-dialog__footer")) {
    expect_match(html, cls, fixed = TRUE)
  }
  expect_match(html, 'role="dialog"', fixed = TRUE)
  expect_match(html, 'aria-modal="true"', fixed = TRUE)
})

test_that("el_drawer reproduces Element's structure", {
  html <- render_html(el_drawer("w1", title = "T", content = "body"))
  for (cls in c("el-drawer__wrapper", "el-drawer__container", "el-drawer__header",
                "el-drawer__close-btn", "el-drawer__body")) {
    expect_match(html, cls, fixed = TRUE)
  }
  expect_match(html, 'role="document"', fixed = TRUE)
})

test_that("both start hidden unless told otherwise", {
  expect_match(render_html(el_dialog("d1")), 'style="display:none"', fixed = TRUE)
  expect_false(grepl("display:none", render_html(el_dialog("d1", visible = TRUE)),
                     fixed = TRUE))
})

test_that("a visible drawer starts with the slide-in class", {
  # el-drawer__open is what plays the animation; without it the panel sits
  # outside the viewport.
  expect_match(render_html(el_drawer("w1", visible = TRUE)),
               "el-drawer__container el-drawer__open", fixed = TRUE)
  expect_false(grepl("el-drawer__open", render_html(el_drawer("w1")), fixed = TRUE))
})

test_that("the content stays in the document while closed", {
  # Removing it would unmount any nested component between openings.
  html <- render_html(el_dialog("d1", content = shiny::tags$p("kept")))
  expect_match(html, "<p>kept</p>", fixed = TRUE)
})

test_that("both load the shared overlay binding", {
  for (tag in list(el_dialog("d1"), el_drawer("w1"))) {
    names <- vapply(htmltools::findDependencies(tag), function(d) d$name, character(1))
    expect_true("el-overlay-binding" %in% names)
  }
})

test_that("nested components keep their own dependencies", {
  names <- vapply(
    htmltools::findDependencies(el_dialog("d1", content = el_switch("sw"))),
    function(d) d$name, character(1)
  )
  expect_true("shiny-vue" %in% names)
  expect_true("el-overlay-binding" %in% names)
})

# ── behaviour flags reach the binding ─────────────────────────────────────────

test_that("dialog flags are exposed to the binding as data attributes", {
  html <- render_html(el_dialog("d1", modal = FALSE, close_on_click_modal = FALSE,
                                close_on_press_escape = FALSE))
  expect_match(html, 'data-modal="false"', fixed = TRUE)
  expect_match(html, 'data-mask-close="false"', fixed = TRUE)
  expect_match(html, 'data-esc-close="false"', fixed = TRUE)
})

test_that("clicking the backdrop needs a backdrop to click", {
  # modal = FALSE draws none, so close_on_click_modal cannot apply.
  html <- render_html(el_dialog("d1", modal = FALSE, close_on_click_modal = TRUE))
  expect_match(html, 'data-mask-close="false"', fixed = TRUE)
})

test_that("dialog sizing options are applied inline", {
  html <- render_html(el_dialog("d1", width = "600px", top = "5vh"))
  expect_match(html, "margin-top: 5vh; width: 600px;", fixed = TRUE)

  # Fullscreen drops them; the class does the work.
  full <- render_html(el_dialog("d1", fullscreen = TRUE))
  expect_match(full, "is-fullscreen", fixed = TRUE)
  expect_false(grepl("margin-top", full, fixed = TRUE))
})

test_that("centre and close-button options are respected", {
  expect_match(render_html(el_dialog("d1", center = TRUE)),
               "el-dialog--center", fixed = TRUE)
  expect_false(grepl("el-dialog__headerbtn",
                     render_html(el_dialog("d1", show_close = FALSE)), fixed = TRUE))
})

test_that("drawer direction drives both the class and which axis is sized", {
  for (d in c("rtl", "ltr")) {
    html <- render_html(el_drawer("w1", direction = d, size = "40%"))
    expect_match(html, paste("el-drawer", d), fixed = TRUE)
    expect_match(html, "width: 40%;", fixed = TRUE)
  }
  for (d in c("ttb", "btt")) {
    html <- render_html(el_drawer("w1", direction = d, size = "40%"))
    expect_match(html, paste("el-drawer", d), fixed = TRUE)
    expect_match(html, "height: 40%;", fixed = TRUE)
  }
})

test_that("drawer header can be dropped entirely", {
  expect_false(grepl("el-drawer__header",
                     render_html(el_drawer("w1", with_header = FALSE)), fixed = TRUE))
})

# ── update functions ──────────────────────────────────────────────────────────

test_that("update_el_dialog sends an input message keyed by the element id", {
  # Shiny routes input messages by looking up the element whose id matches,
  # not by asking bindings for a getId(), so the input is the element's id.
  out <- sent_input(function(s) update_el_dialog(s, "d1", visible = TRUE))
  expect_equal(out$id, "d1")
  expect_true(out$msg$visible)
})

test_that("update_el_dialog: closing is sent, not treated as absent", {
  out <- sent_input(function(s) update_el_dialog(s, "d1", visible = FALSE))
  expect_false(out$msg$visible)
})

test_that("update_el_dialog: title and width pass through", {
  out <- sent_input(function(s) update_el_dialog(s, "d1", title = "New", width = "70%"))
  expect_equal(out$msg$title, "New")
  expect_equal(out$msg$width, "70%")
  expect_null(out$msg$visible)
})

test_that("update_el_drawer sends visible, title and size", {
  out <- sent_input(function(s) {
    update_el_drawer(s, "w1", visible = TRUE, title = "New", size = "50%")
  })
  expect_equal(out$id, "w1")
  expect_true(out$msg$visible)
  expect_equal(out$msg$size, "50%")
})

# ── the shared binding ────────────────────────────────────────────────────────

test_that("the overlay binding manages the backdrop and the scroll lock", {
  js <- paste(readLines(
    system.file("js", "el-overlay-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  expect_match(js, "v-modal", fixed = TRUE)
  # Element's own class for locking body scroll.
  expect_match(js, "el-popup-parent--hidden", fixed = TRUE)
  # Stacked overlays need increasing z-indexes.
  expect_match(js, "nextZ", fixed = TRUE)
  # Escape closes the topmost only.
  expect_match(js, "Escape", fixed = TRUE)
  expect_match(js, "elOverlayChange", fixed = TRUE)
})

test_that("the binding degrades gracefully outside Shiny", {
  js <- paste(readLines(
    system.file("js", "el-overlay-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  # Without Shiny it binds itself, so it still works on a static page
  expect_match(js, "function standalone(binding)", fixed = TRUE)
  expect_match(js, "else standalone(binding)", fixed = TRUE)
  expect_false(grepl("[^&] Shiny[.]setInputValue[(]", js))
})

# ── behaviour carried over from the Vue implementation ────────────────────────
# test-el_dialog.R used to cover these against Vue data and bindings; the
# component is markup now, so the same guarantees are checked on the output.

test_that("el_dialog: an id is generated when none is given", {
  html <- render_html(el_dialog())
  expect_match(html, 'id="el_dialog_', fixed = TRUE)
})

test_that("el_dialog: the footer only appears when there is one", {
  expect_match(render_html(el_dialog("d1", footer = shiny::tags$p("f"))),
               "el-dialog__footer", fixed = TRUE)
  expect_false(grepl("el-dialog__footer", render_html(el_dialog("d1")), fixed = TRUE))
})

test_that("el_dialog: the title appears in the header and the aria label", {
  html <- render_html(el_dialog("d1", title = "My dialog"))
  expect_match(html, '<span class="el-dialog__title">My dialog</span>', fixed = TRUE)
  expect_match(html, 'aria-label="My dialog"', fixed = TRUE)
})

test_that("update_el_dialog: NULL fields are excluded", {
  out <- sent_input(function(s) update_el_dialog(s, "d1", visible = TRUE))
  expect_null(out$msg$title)
  expect_null(out$msg$width)
})

test_that("el_drawer: an id is generated when none is given", {
  expect_match(render_html(el_drawer()), 'id="el_drawer_', fixed = TRUE)
})

test_that("update_el_drawer: NULL fields are excluded", {
  out <- sent_input(function(s) update_el_drawer(s, "w1", visible = FALSE))
  expect_false(out$msg$visible)
  expect_null(out$msg$title)
  expect_null(out$msg$size)
})

# ── Element's further dialog and drawer attributes ────────────────────────────

test_that("dialog and drawer pass Element's behaviour flags to the binding", {
  for (html in list(
    render_html(el_dialog("d1", append_to_body = TRUE, modal_append_to_body = FALSE,
                          destroy_on_close = TRUE, custom_class = "wide")),
    render_html(el_drawer("w1", append_to_body = TRUE, modal_append_to_body = FALSE,
                          destroy_on_close = TRUE, custom_class = "wide")))) {
    expect_match(html, 'data-append-to-body="true"', fixed = TRUE)
    expect_match(html, 'data-modal-append-to-body="false"', fixed = TRUE)
    expect_match(html, 'data-destroy-on-close="true"', fixed = TRUE)
    expect_match(html, "wide", fixed = TRUE)
  }
  expect_match(render_html(el_dialog("d1", lock_scroll = FALSE)),
               'data-lock-scroll="false"', fixed = TRUE)
})

test_that("before_close travels as source for the binding", {
  fn <- htmlwidgets::JS("function(done) { done(); }")
  expect_match(render_html(el_dialog("d1", before_close = fn)),
               'data-before-close="function(done) { done(); }"', fixed = TRUE)
  expect_match(render_html(el_drawer("w1", before_close = fn)),
               'data-before-close="function(done) { done(); }"', fixed = TRUE)
  expect_false(grepl("data-before-close", render_html(el_dialog("d1")), fixed = TRUE))
})

test_that("destroy_on_close keeps a pristine copy to rebuild from", {
  closed <- render_html(el_dialog("d1", content = shiny::tags$p("body"),
                                  destroy_on_close = TRUE))
  expect_match(closed, '<template data-el-pristine="true">', fixed = TRUE)
  expect_false(grepl("data-el-live", closed, fixed = TRUE))

  open <- render_html(el_dialog("d1", content = shiny::tags$p("body"),
                                destroy_on_close = TRUE, visible = TRUE))
  expect_match(open, 'data-el-live="true"', fixed = TRUE)

  # Without it the content is rendered once and simply hidden
  plain <- render_html(el_dialog("d1", content = shiny::tags$p("body")))
  expect_false(grepl("data-el-pristine", plain, fixed = TRUE))
})

test_that("the binding reports the four open/close events", {
  js <- paste(readLines(
    system.file("js", "el-overlay-binding.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  for (ev in c("'_open'", "'_opened'", "'_close'", "'_closed'")) {
    expect_match(js, ev, fixed = TRUE)
  }
  expect_match(js, "closeDrawer", fixed = TRUE)
})
