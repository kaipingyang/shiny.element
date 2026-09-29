# Generates the component screenshots used by the pkgdown site.
#
# Not part of the package: run it by hand after changing a component's
# appearance, then commit the images under man/figures/.
#
#   Rscript tools/screenshots.R [name ...]
#
# Each entry below becomes one image, cropped to the component itself through
# CDP's clip rather than a full-page capture -- b$screenshot() would frame the
# html element, which cuts off anything positioned against the viewport.

library(chromote)
library(callr)

PORT   <- 8321
OUTDIR <- "man/figures"
PKG    <- normalizePath(".")

# Each demo is R code, as a string, rendering one component inside #shot.
demos <- list(
  input = 'tagList(
    el_input(ID("a"), value = "Ada Lovelace", placeholder = "your name"),
    tags$br(),
    el_input(ID("b"), type = "textarea", rows = 2, value = "multi\nline"),
    tags$br(),
    el_input(ID("c"), type = "password", value = "secret", show_password = TRUE))',

  input_number = 'el_input_number(ID("a"), value = 18, min = 0, max = 150)',

  select = 'tagList(
    el_select(ID("a"), choices = c(Beijing = "bj", Shanghai = "sh"), selected = "bj"),
    tags$br(),
    el_select(ID("b"), choices = c(A = "a", B = "b", C = "c"),
              selected = c("a", "c"), multiple = TRUE))',

  radio_group = 'tagList(
    el_radio_group(ID("a"), choices = c(Basic = "x", Pro = "y"), selected = "x"),
    tags$br(), tags$br(),
    el_radio_group(ID("b"), choices = c(Day = "d", Week = "w", Month = "m"),
                   selected = "w", button = TRUE))',

  checkbox_group = 'el_checkbox_group(ID("a"), choices = c(R = "r", Python = "p", SQL = "s"),
                                      selected = c("r", "s"))',

  switch = 'el_switch(ID("a"), value = TRUE, active_text = "on", inactive_text = "off")',

  slider = 'tagList(
    el_slider(ID("a"), value = 40),
    el_slider(ID("b"), value = c(20, 70), range = TRUE))',

  rate = 'el_rate(ID("a"), value = 3, show_text = TRUE)',

  date_picker = 'tagList(
    el_date_picker(ID("a"), value = "2026-03-01"),
    tags$br(), tags$br(),
    el_date_picker(ID("b"), type = "daterange"))',

  color_picker = 'el_color_picker(ID("a"), value = "#409EFF")',

  cascader = 'el_cascader(ID("a"), value = list("zj", "hz"), options = list(
    list(value = "zj", label = "Zhejiang", children = list(
      list(value = "hz", label = "Hangzhou"),
      list(value = "nb", label = "Ningbo")))))',

  upload = 'el_upload(ID("a"), drag = TRUE, multiple = TRUE,
                      tip = "Files arrive as fileInput() would deliver them")',

  button = 'tagList(
    el_button(ID("a"), "Default"), el_button(ID("b"), "Primary", type = "primary"),
    el_button(ID("c"), "Success", type = "success"),
    el_button(ID("d"), "Warning", type = "warning"),
    el_button(ID("e"), "Danger", type = "danger"),
    tags$br(), tags$br(),
    el_button(ID("f"), "Round", type = "primary", round = TRUE),
    el_button(ID("g"), "Plain", type = "primary", plain = TRUE),
    el_button(ID("h"), "Loading", type = "primary", loading = TRUE),
    el_button(ID("i"), "Disabled", disabled = TRUE))',

  tag = 'tagList(
    el_tag(ID("a"), label = "default"),
    el_tag(ID("b"), label = "success", type = "success"),
    el_tag(ID("c"), label = "warning", type = "warning", closable = TRUE))',

  alert = 'tagList(
    el_alert(ID("a"), title = "info", type = "info", show_icon = TRUE,
             description = "with a description"),
    el_alert(ID("b"), title = "success", type = "success", show_icon = TRUE),
    el_alert(ID("c"), title = "warning", type = "warning", show_icon = TRUE),
    el_alert(ID("d"), title = "error",   type = "error",   show_icon = TRUE))',

  progress = 'tagList(
    el_progress(ID("a"), percentage = 70),
    el_progress(ID("b"), percentage = 70, status = "success"),
    tags$div(style = "display:flex; gap:20px; margin-top:12px",
      el_progress(ID("c"), percentage = 70, type = "circle"),
      el_progress(ID("d"), percentage = 70, type = "dashboard")))',

  badge = 'tagList(
    el_badge(el_button(ID("a"), "messages"), value = 12),
    tags$span(style = "display:inline-block; width:24px"),
    el_badge(el_button(ID("b"), "capped"), value = 200, max = 99),
    tags$span(style = "display:inline-block; width:24px"),
    el_badge(el_button(ID("c"), "dot"), is_dot = TRUE))',

  card = 'el_card(header = "Card header", "Cards nest any content,
                  including other components.")',

  table = 'el_table(id = "a", data = head(iris, 4), selection = TRUE)',

  pagination = 'el_pagination(ID("a"), total = 200, page_size = 20, current_page = 3)',

  timeline = 'el_timeline(ID("a"), items = list(
    list(content = "Order placed",  timestamp = "2026-03-01", type = "primary"),
    list(content = "Shipped",       timestamp = "2026-03-02", type = "success",
         icon = "el-icon-check", size = "large"),
    list(content = "In transit",    timestamp = "2026-03-03", color = "#0bbd87")))',

  carousel = 'el_carousel(ID("a"), height = "160px", autoplay = FALSE, items = lapply(
    list(c("First", "#409EFF"), c("Second", "#67C23A"), c("Third", "#E6A23C")),
    function(s) list(content = tags$div(
      style = sprintf("height:100%%; display:flex; align-items:center;
                       justify-content:center; background:%s; color:#fff;
                       font:600 20px sans-serif", s[2]), s[1]))))',

  tabs = 'el_tabs(ID("a"), selected = "x", tabs = list(
    list(name = "x", label = "Inputs",
         content = tagList(el_input(ID("i"), value = "live inside a pane"),
                           el_rate(ID("r"), value = 3))),
    list(name = "y", label = "Second", content = "Panes hold components."),
    list(name = "z", label = "Disabled", content = "", disabled = TRUE)))',

  collapse = 'el_collapse(ID("a"), value = "p1", items = list(
    list(name = "p1", title = "A panel holding components",
         content = tagList(el_input(ID("i"), value = "still live"),
                           el_rate(ID("r"), value = 4))),
    list(name = "p2", title = "Plain text", content = "Just text.")))',

  steps = 'el_steps(ID("a"), active = 1, finish_status = "success", steps = list(
    list(title = "Pick", description = "choose a plan"),
    list(title = "Pay",  description = "enter card"),
    list(title = "Done", description = "all set")))',

  menu = 'tags$div(style = "width:220px", el_menu(ID("a"), active = "home", items = list(
    list(index = "home", label = "Home", icon = "el-icon-house"),
    list(index = "data", label = "Data", icon = "el-icon-document", children = list(
      list(index = "all",  label = "All records"),
      list(index = "new",  label = "Recent"))),
    list(index = "help", label = "Help", icon = "el-icon-question",
         disabled = TRUE))))',

  tree = 'tags$div(style = "width:260px", el_tree(ID("a"), show_checkbox = TRUE,
    checked = c("apple", "cherry"), expanded = "fruit", data = list(
      list(id = "fruit", label = "Fruit", children = list(
        list(id = "apple",  label = "Apple"),
        list(id = "cherry", label = "Cherry"),
        list(id = "plum",   label = "Plum", disabled = TRUE))),
      list(id = "veg", label = "Vegetables", children = list(
        list(id = "leek", label = "Leek"))))))',

  form = 'el_form(id = "a", label_width = "110px", reset_label = "Reset",
    el_form_field("name", "input", label = "Name",
                  rules = el_rule(required = TRUE, message = "Name is required")),
    el_form_field("email", "input", label = "Email",
                  rules = el_rule(type = "email", message = "Not a valid email")),
    el_form_field("age", "input-number", label = "Age", value = 18),
    el_form_field("city", "select", label = "City",
                  choices = c(Beijing = "bj", Shanghai = "sh")))',

  dropdown = 'el_dropdown(ID("a"), trigger_label = "Actions", items = list(
    list(command = "edit", label = "Edit"),
    list(command = "copy", label = "Duplicate"),
    list(command = "del",  label = "Delete")))',

  layout = 'tagList(
    el_row(gutter = 20,
      el_col(span = 12, tags$div(class = "grid-content bg-purple",
                                 style = "padding:14px", "span = 12")),
      el_col(span = 12, tags$div(class = "grid-content bg-purple-light",
                                 style = "padding:14px", "span = 12"))),
    tags$br(),
    el_row(gutter = 20,
      el_col(span = 8, tags$div(class = "grid-content bg-purple",
                                style = "padding:14px", "span = 8")),
      el_col(span = 8, tags$div(class = "grid-content bg-purple-light",
                                style = "padding:14px", "span = 8")),
      el_col(span = 8, tags$div(class = "grid-content bg-purple",
                                style = "padding:14px", "span = 8"))))',

  container = 'tags$div(style = "height:220px; border:1px solid #EBEEF5",
    el_container(
      el_header(tags$div(style = "background:#B3C0D1; height:100%;
                                  line-height:60px; text-align:center", "Header")),
      el_container(
        el_aside(width = "160px", tags$div(style = "background:#D3DCE6;
                 height:100%; text-align:center; padding-top:20px", "Aside")),
        el_main(tags$div(style = "background:#E9EEF3; height:100%;
                text-align:center; padding-top:20px", "Main")))))',

  divider = 'tagList(
    tags$p("Above the divider"),
    el_divider(),
    tags$p("Below it"))',

  link = 'tagList(
    el_link("plain link"), tags$span(style = "display:inline-block;width:16px"),
    el_link("primary", type = "primary"),
    tags$span(style = "display:inline-block;width:16px"),
    el_link("disabled", disabled = TRUE))',

  icon = 'tags$div(style = "font-size:22px; display:flex; gap:18px",
    tags$i(class = "el-icon-edit"), tags$i(class = "el-icon-share"),
    tags$i(class = "el-icon-delete"), tags$i(class = "el-icon-search"),
    tags$i(class = "el-icon-star-on"), tags$i(class = "el-icon-upload"))'
)

# Components that only exist while open are shown by opening them first.
opens <- list(
  dialog = list(
    ui  = 'tagList(el_button(ID("open"), "Open dialog", type = "primary"),
            el_dialog(ID("d"), title = "A dialog holding components", width = "440px",
              content = tagList(el_input(ID("i"), value = "still connected"),
                                el_rate(ID("r"), value = 3)),
              footer = el_button(ID("ok"), "OK", type = "primary")))',
    js  = "document.querySelectorAll('#open_container button')[0].click()",
    sel = ".el-dialog"
  ),
  drawer = list(
    ui  = 'tagList(el_button(ID("open"), "Open drawer", type = "primary"),
            el_drawer(ID("w"), title = "A drawer", size = "320px",
              content = tagList(el_switch(ID("s"), value = TRUE),
                                tags$p("Drawers nest components too."))))',
    js  = "document.querySelectorAll('#open_container button')[0].click()",
    sel = ".el-drawer"
  )
)

wanted <- commandArgs(TRUE)
if (length(wanted)) {
  demos <- demos[intersect(names(demos), wanted)]
  opens <- opens[intersect(names(opens), wanted)]
}

app_file <- tempfile(fileext = ".R")
writeLines(c(
  "library(shiny); library(shiny.element)",
  sprintf('pkgload::load_all(%s, quiet = TRUE, helpers = FALSE)', shQuote(PKG)),
  "specs <- readRDS(Sys.getenv('EL_SHOT_SPEC'))",
  "# Every demo lives on one page, so their ids have to be kept apart -- two",
  "# widgets sharing an id leaves one of them blank.",
  "render_demo <- function(n) {",
  "  e <- new.env(parent = globalenv())",
  "  e$ID <- function(x) paste0(n, '_', x)",
  "  tags$div(`data-shot` = n, style = 'margin-bottom:40px',",
  "           eval(parse(text = specs[[n]]), envir = e))",
  "}",
  "ui <- el_page(title = NULL, tags$div(style = 'padding:24px; max-width:860px',",
  "  tags$div(id = 'shot', lapply(names(specs), render_demo))))",
  "shinyApp(ui, function(input, output, session) {})"
), app_file)

shot_one <- function(b, name, selector) {
  exists <- b$Runtime$evaluate(sprintf(
    "String(!!document.querySelector(%s))", shQuote(selector, type = "cmd")
  ))$result$value
  if (!identical(exists, "true")) { message("  missing: ", name); return(invisible(FALSE)) }

  out <- file.path(OUTDIR, paste0("component-", gsub("_", "-", name), ".png"))
  # chromote's own selector capture works out the clip itself. Computing it by
  # hand from getBoundingClientRect() is viewport-relative while CDP's clip is
  # page-relative, and the two drift apart as soon as anything scrolls.
  b$screenshot(out, selector = selector, scale = 2)
  message(sprintf("  %-16s %s", name, out))
  invisible(TRUE)
}

run <- function(specs, opens) {
  spec_file <- tempfile(fileext = ".rds")
  saveRDS(specs, spec_file)

  proc <- callr::r_bg(function(app, port, spec) {
    Sys.setenv(EL_SHOT_SPEC = spec)
    shiny::runApp(app, host = "127.0.0.1", port = port, launch.browser = FALSE)
  }, args = list(app = app_file, port = PORT, spec = spec_file),
     stdout = "/tmp/elshots.log", stderr = "2>&1")

  on.exit(proc$kill(), add = TRUE)
  for (i in 1:90) {
    Sys.sleep(1)
    if (!proc$is_alive()) stop(paste(readLines("/tmp/elshots.log"), collapse = "\n"))
    if (any(grepl("Listening", readLines("/tmp/elshots.log", warn = FALSE)))) break
  }

  chromote::set_chrome_args(c(chromote::default_chrome_args(),
    "--disable-dev-shm-usage", "--no-sandbox", "--disable-gpu",
    "--force-device-scale-factor=1"))
  b <- ChromoteSession$new(width = 1000, height = 900)
  on.exit(try(b$parent$get_browser()$get_process()$kill(), silent = TRUE), add = TRUE)

  b$Page$navigate(sprintf("http://127.0.0.1:%d/", PORT))
  b$Page$loadEventFired()
  Sys.sleep(8)

  for (n in names(specs)) {
    # Show one demo at a time at the top of the page. Scrolling to a component
    # and capturing by selector puts the wrong thing in the frame: the clip is
    # worked out in page coordinates while the rect is viewport-relative, so
    # every shot after the first lands on a later component.
    b$Runtime$evaluate(sprintf(
      "(function(){
         document.querySelectorAll('[data-shot]').forEach(function(e){
           e.style.display = (e.getAttribute('data-shot') === %s) ? '' : 'none';
         });
         window.scrollTo(0, 0);
       })()", shQuote(n, type = "cmd")))
    Sys.sleep(0.6)
    shot_one(b, n, sprintf("[data-shot=%s]", shQuote(n, type = "cmd")))
  }
  b$close()
}

dir.create(OUTDIR, showWarnings = FALSE, recursive = TRUE)
if (length(demos)) {
  message("Static components:")
  run(demos, list())
}
