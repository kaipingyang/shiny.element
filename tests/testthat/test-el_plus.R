# Components Element Plus added, and the props it renamed: each renders its
# own tag, reports what it should, and takes R's forms of its arguments.

html_of <- function(ui) paste(as.character(htmltools::renderTags(ui)$html), collapse = "")

test_that("each new component renders Element Plus's tag", {
  cases <- list(
    "el-input-otp"  = el_input_otp("a"),
    "el-input-tag"  = el_input_tag("a"),
    "el-segmented"  = el_segmented("a", options = c("x", "y")),
    "el-select-v2"  = el_select_v2("a", options = c("x", "y")),
    "el-mention"    = el_mention("a", options = c("x", "y")),
    "el-tree-select" = el_tree_select("a"),
    "el-color-picker-panel" = el_color_picker_panel("a"),
    "el-date-picker-panel"  = el_date_picker_panel("a"),
    "el-check-tag"  = el_check_tag("a", "A"),
    "el-anchor"     = el_anchor("a", links = list(list(title = "T", href = "#t"))),
    "el-tour"       = el_tour("a", steps = list(list(title = "S"))),
    "el-affix"      = el_affix("x"),
    "el-space"      = el_space("x", "y"),
    "el-scrollbar"  = el_scrollbar("x"),
    "el-watermark"  = el_watermark("x", content = "W"),
    "el-text"       = el_text("x"),
    "el-avatar-group" = el_avatar_group(el_avatar("a")),
    "el-splitter"   = el_splitter(el_splitter_panel("L"), el_splitter_panel("R")),
    "el-image-viewer" = el_image_viewer("a", url_list = "a.png"),
    "el-table-v2"   = el_table_v2("a", data = data.frame(x = 1)),
    "el-tree-v2"    = el_tree_v2("a", data = list(list(id = 1, label = "a"))),
    "el-countdown"  = el_countdown("a", value = 1),
    "el-config-provider" = el_config_provider("x", size = "small")
  )
  for (tag in names(cases)) {
    expect_match(html_of(cases[[tag]]), paste0("<", tag), fixed = TRUE, info = tag)
  }
})

test_that("components with a value report it as input$<id>", {
  for (ui in list(el_input_otp("a"), el_input_tag("a"), el_segmented("a"),
                  el_select_v2("a"), el_mention("a"), el_tree_select("a"),
                  el_color_picker_panel("a"), el_date_picker_panel("a"),
                  el_check_tag("a", "A"))) {
    # the bridge's input binding reports the field named here
    expect_equal(vue_spec_of(ui)$input, "value")
  }
  expect_equal(vue_data_of(el_input_tag("a", value = c("x", "y")))$value, list("x", "y"))
  expect_true(vue_data_of(el_check_tag("a", "A", value = TRUE))$value)
})

test_that("options take R's named vectors, as the choice components do", {
  opts <- vue_data_of(el_segmented("a", options = c(Day = "d", Week = "w")))$options
  expect_equal(opts[[1]]$label, "Day")
  expect_equal(opts[[2]]$value, "w")
  expect_equal(vue_data_of(el_select_v2("a", options = c("x", "y")))$options[[2]]$value, "y")
})

test_that("a virtualized table takes a data.frame, with a column per variable", {
  d <- vue_data_of(el_table_v2("a", data = data.frame(a.b = 1:2, c = c("x", "y"))))
  expect_length(d$data, 2)
  expect_equal(d$columns[[1]]$dataKey, "a_b")
  expect_equal(d$columns[[1]]$title, "a.b")
  # Element Plus needs its size as numbers
  expect_equal(d$width, 700)
  expect_equal(d$height, 400)
})

test_that("a watermark's own width is not the component's", {
  ui <- el_watermark("x", watermark_width = 200, width = "50%")
  html <- html_of(ui)
  expect_match(html, ':width="width === null ? undefined : width"', fixed = TRUE)
  expect_equal(vue_data_of(ui)$width, 200)
})

test_that("the image viewer opens and closes, reporting the close", {
  ui <- el_image_viewer("a", url_list = c("a.png", "b.png"))
  expect_match(html_of(ui), 'v-if="visible"', fixed = TRUE)
  expect_false(vue_data_of(ui)$visible)
  expect_equal(vue_data_of(ui)$urlList, list("a.png", "b.png"))
  expect_match(html_of(ui), "a_close", fixed = TRUE)
})

test_that("tour steps and anchor links become Element Plus's child tags", {
  tour <- html_of(el_tour("t", steps = list(
    list(target = "#a", title = "A", header = htmltools::tags$b("H")),
    list(title = "B"))))
  expect_equal(lengths(regmatches(tour, gregexpr("<el-tour-step", tour, fixed = TRUE))), 2L)
  expect_match(tour, "<template v-slot:header>", fixed = TRUE)
  expect_match(tour, 'v-model:current="current"', fixed = TRUE)
  anchor <- html_of(el_anchor("n", links = list(list(title = "A", href = "#a",
    children = list(list(title = "B", href = "#b"))))))
  expect_equal(lengths(regmatches(anchor, gregexpr("<el-anchor-link", anchor, fixed = TRUE))), 2L)
  expect_match(anchor, "v-slot:sub-link", fixed = TRUE)
})

test_that("containers fold this package's components into one instance", {
  ui <- el_space(el_input("x"), el_switch("y"))
  html <- html_of(ui)
  expect_equal(lengths(regmatches(html, gregexpr("data-shiny-vue ", html, fixed = TRUE))), 1L)
  expect_match(html, "<el-input", fixed = TRUE)
  expect_match(html, "<el-switch", fixed = TRUE)
})

test_that("the remaining services' options travel as Element Plus names them", {
  sent <- NULL
  s <- list(ns = identity, sendCustomMessage = function(type, msg) sent <<- msg)
  el_message_box(s, "q", "Sure?", draggable = TRUE, confirm_button_type = "danger",
                 before_close = JS("function(a, i, done) { done(); }"))
  expect_true(sent$draggable)
  expect_equal(sent$confirmButtonType, "danger")
  expect_equal(as.character(sent$.functions), "beforeClose")
  el_loading(s, "l", svg = "<path/>", svg_view_box = "0 0 1 1")
  expect_equal(sent$svgViewBox, "0 0 1 1")
})
