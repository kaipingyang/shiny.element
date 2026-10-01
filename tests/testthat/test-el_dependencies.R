# ── element_ui_dependency ─────────────────────────────────────────────────────

test_that("element_ui_dependency: serves from the package by default", {
  # A runtime CDN dependency leaves the page blank on an intranet or offline,
  # so the bundled copy is the default.
  dep <- element_ui_dependency()
  expect_equal(dep$name, "element-ui")
  expect_equal(dep$version, "2.15.14")
  expect_false(grepl("unpkg", paste(unlist(dep$src), collapse = " ")))
  expect_true(dir.exists(unname(dep$src[["file"]])))
})

test_that("element_ui_dependency: offline = FALSE falls back to the CDN", {
  dep <- element_ui_dependency(offline = FALSE)
  expect_match(unname(dep$src[["href"]]), "^https://unpkg\\.com/element-ui@2\\.15\\.14/")
})

test_that("element_ui_dependency: serves the whole directory", {
  # index.css references fonts/element-icons.woff relatively; naming only the
  # script and stylesheet would leave every icon as a blank box.
  expect_true(element_ui_dependency()$all_files)
})

test_that("element_ui_dependency: the bundled files are actually there", {
  root <- system.file("element-ui", package = "shiny.element")
  for (f in c("index.js", "theme-chalk/index.css",
              "theme-chalk/fonts/element-icons.woff",
              "theme-chalk/fonts/element-icons.ttf")) {
    expect_true(file.exists(file.path(root, f)), info = f)
  }
})

test_that("element_ui_dependency: the bundled files are not truncated", {
  root <- system.file("element-ui", package = "shiny.element")
  expect_gt(file.size(file.path(root, "index.js")), 400 * 1024)
  expect_gt(file.size(file.path(root, "theme-chalk/index.css")), 150 * 1024)
  expect_gt(file.size(file.path(root, "theme-chalk/fonts/element-icons.woff")), 20 * 1024)
})

test_that("element_ui_dependency: the stylesheet keeps its relative font paths", {
  css <- readLines(
    system.file("element-ui", "theme-chalk", "index.css", package = "shiny.element"),
    warn = FALSE, n = 200
  )
  css <- paste(css, collapse = "\n")
  expect_match(css, "fonts/element-icons.woff", fixed = TRUE)
  # An absolute or CDN-rooted url() would defeat bundling them.
  expect_false(grepl("url\\(['\"]?https?://", css))
})

# ── wiring ────────────────────────────────────────────────────────────────────

test_that("el_page: passes offline through to the dependency", {
  local_src <- function(tags) {
    deps <- htmltools::findDependencies(tags)
    dep  <- Filter(function(d) identical(d$name, "element-ui"), deps)[[1]]
    paste(unlist(dep$src), collapse = " ")
  }
  expect_false(grepl("unpkg", local_src(el_page())))
  expect_true(grepl("unpkg", local_src(el_page(offline = FALSE))))
})

test_that("use_element: passes offline through to the dependency", {
  src_of <- function(tags) {
    deps <- htmltools::findDependencies(tags)
    dep  <- Filter(function(d) identical(d$name, "element-ui"), deps)[[1]]
    paste(unlist(dep$src), collapse = " ")
  }
  expect_false(grepl("unpkg", src_of(use_element())))
  expect_true(grepl("unpkg", src_of(use_element(offline = FALSE))))
})

test_that("Vue is bundled, in the version Element UI 2 runs on", {
  for (dev in c(FALSE, TRUE)) {
    dep <- .el_vue_dependency(dev = dev)
    expect_equal(dep$package, "shiny.element")
    expect_true(file.exists(system.file(dep$src$file, dep$script, package = "shiny.element")))
  }
  head <- readLines(system.file("vue", "vue.min.js", package = "shiny.element"), n = 3)
  expect_match(paste(head, collapse = " "), "v2.7.14", fixed = TRUE)
  # The development build outranks the production copy every component
  # brings, so el_page(dev = TRUE) gets it rather than Vue twice
  expect_gt(package_version(.el_vue_dependency(TRUE)$version),
            package_version(.el_vue_dependency(FALSE)$version))
})

test_that("every handler dependency resolves to files that exist", {
  fns <- ls(asNamespace("shiny.element"), pattern = "^el_.*_handler_dependency$")
  expect_gt(length(fns), 20)

  for (fn in fns) {
    for (dep in do.call(fn, list())) {
      # jQuery comes from jquerylib, its src relative to that package
      dir <- unname(dep$src[["file"]])
      if (!is.null(dep$package)) dir <- system.file(dir, package = dep$package)
      expect_true(
        file.exists(file.path(dir, dep$script)),
        info = paste(fn, "->", dep$script)
      )
    }
  }
})

test_that("every handler dependency carries the shared scripts too", {
  # The shared scripts have to be present and load before the component's own
  # handler; relying on el_page() to provide them would break a page assembled
  # some other way.
  fns <- ls(asNamespace("shiny.element"), pattern = "^el_.*_handler_dependency$")

  for (fn in fns) {
    deps  <- do.call(fn, list())
    names <- vapply(deps, function(d) d$name, character(1))
    # jQuery first: every script after it is written against it
    expect_equal(names[1:4], c("jquery", "el-invoke", "el-events", "el-update"),
                 info = fn)
    expect_length(deps, 5)
  }
})

test_that("the shared updater checks each key against the component's data", {
  js <- paste(readLines(
    system.file("js", "el-update.js", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  # This check is the whole point: writing a field the component never declared
  # is a silent no-op in Vue 2, which is how el-table's handler shipped three
  # assignments that could never have worked.
  expect_match(js, "in vm.$data", fixed = TRUE)
  expect_match(js, "console.warn", fixed = TRUE)
})

test_that("component handlers delegate to the shared updater", {
  js_dir <- system.file("js", package = "shiny.element")
  handlers <- setdiff(
    list.files(js_dir, pattern = "-handler\\.js$"),
    # These do more than assign fields: feedback calls Message and
    # Notification, form calls validate/resetFields/clearValidate, and tree
    # calls setCheckedKeys because assigning default-checked-keys only ever
    # adds to the selection.
    c("el-feedback-handler.js", "el-form-handler.js", "el-tree-handler.js",
      "el-carousel-handler.js")
  )
  expect_gt(length(handlers), 20)

  for (h in handlers) {
    js <- paste(readLines(file.path(js_dir, h), warn = FALSE), collapse = "\n")
    expect_match(js, "elRegisterUpdate", fixed = TRUE, info = h)
    expect_false(grepl("!== undefined", js, fixed = TRUE), info = h)
  }
})

# ── layout stylesheet ─────────────────────────────────────────────────────────

test_that("el-layout.css applies nothing automatically", {
  # It used to ship Element UI's container demo, whose placeholder styles are
  # written to make empty boxes visible on that one documentation page:
  # line-height 160-320px, text-align center and a grey-blue palette, forced
  # onto .el-main / .el-aside / .el-header of every app that loaded it. A
  # showcase page measured 4524px tall instead of 1444px.
  css <- paste(readLines(
    system.file("css", "el-layout.css", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")

  # Strip comments before looking for rules.
  rules <- gsub("/\\*.*?\\*/", "", css)

  expect_false(grepl("^\\.el-[a-z-]+[ ,{]", rules),
               info = "no selector may target an Element UI class directly")
  for (prop in c("line-height", "text-align", "background-color", "margin-bottom")) {
    expect_false(grepl(paste0("\\.el-[a-z-]+[^{]*\\{[^}]*", prop), rules),
                 info = prop)
  }
  # The position-dependent selectors were the worst of it: what a component
  # looked like depended on where it happened to sit in the document.
  expect_false(grepl("nth-child", rules, fixed = TRUE))
})

test_that("el-layout.css keeps its opt-in helper classes", {
  css <- paste(readLines(
    system.file("css", "el-layout.css", package = "shiny.element"), warn = FALSE
  ), collapse = "\n")
  for (cls in c(".bg-purple", ".grid-content", ".row-bg")) {
    expect_match(css, cls, fixed = TRUE)
  }
})

# ── locale ────────────────────────────────────────────────────────────────────

test_that("el_locale_dependency: the built-in locale needs nothing extra", {
  # Element UI's bundle already carries Simplified Chinese.
  expect_null(el_locale_dependency())
  expect_null(el_locale_dependency("zh-CN"))
})

test_that("el_locale_dependency: 'en' loads the file and applies it", {
  deps <- el_locale_dependency("en")
  expect_length(deps, 2)
  expect_equal(deps[[1]]$script, "locale/en.js")
  # The locale file only registers ELEMENT.lang.en; a second dependency calls
  # ELEMENT.locale() after both it and element-ui have loaded.
  expect_match(deps[[2]]$head, "ELEMENT.locale", fixed = TRUE)
  expect_match(deps[[2]]$head, "ELEMENT.lang['en']", fixed = TRUE)
})

test_that("el_locale_dependency: the bundled locale file is really there", {
  p <- system.file("element-ui", "locale", "en.js", package = "shiny.element")
  expect_true(file.exists(p))
  expect_gt(file.size(p), 2000)
  js <- paste(readLines(p, warn = FALSE), collapse = "\n")
  expect_match(js, "ELEMENT.lang.en", fixed = TRUE)
})

test_that("el_locale_dependency: an unknown locale fails naming the real ones", {
  expect_error(el_locale_dependency("xx"), "No bundled locale")
  expect_error(el_locale_dependency("xx"), "zh-TW")
})

test_that("every locale Element ships is bundled", {
  expect_gte(length(el_locales()), 50)
  expect_true(all(c("en", "fr", "ja", "zh-CN", "zh-TW") %in% el_locales()))
  expect_type(el_locale_dependency("fr"), "list")
})

test_that("el_page speaks English unless told otherwise", {
  # Element's own default is Simplified Chinese, which put the select
  # placeholder of every example in this package's English docs in Chinese.
  names_of <- function(tags) {
    vapply(htmltools::findDependencies(tags), function(d) d$name, character(1))
  }
  expect_true("element-ui-locale-en" %in% names_of(el_page()))
  expect_true("element-ui-locale-en" %in% names_of(use_element()))

  # and the option switches it for a whole session
  withr::with_options(list(shiny.element.locale = "zh-CN"), {
    expect_false(any(grepl("locale", names_of(el_page()))))
  })
  withr::with_options(list(shiny.element.locale = "fr"), {
    expect_true("element-ui-locale-fr" %in% names_of(el_page()))
  })
})

test_that("el_page and use_element pass locale through", {
  names_of <- function(tags) {
    vapply(htmltools::findDependencies(tags), function(d) d$name, character(1))
  }
  expect_false(any(grepl("locale", names_of(el_page(locale = "zh-CN")))))
  expect_true("element-ui-locale-ja" %in% names_of(el_page(locale = "ja")))
  expect_true("element-ui-locale-en" %in% names_of(use_element(locale = "en")))
})

test_that("the locale is applied after element-ui itself has loaded", {
  # Ordering matters: ELEMENT.locale() does not exist until element-ui runs.
  names <- vapply(htmltools::findDependencies(el_page(locale = "en")),
                  function(d) d$name, character(1))
  expect_lt(which(names == "element-ui"), which(names == "element-ui-locale-en"))
  expect_lt(which(names == "element-ui-locale-en"),
            which(names == "element-ui-locale-apply-en"))
})

test_that("every generated call to Shiny is guarded, so components work without it", {
  # A static page -- R Markdown, Quarto, the package's website -- has no
  # Shiny; an unguarded call threw on every change a user made.
  ui <- htmltools::tagList(
    el_input("i"), el_select("s", choices = "a"), el_table("t", data = head(iris, 1)),
    el_menu("m", items = list(list(index = "a", label = "A"))),
    el_pagination("p", total = 10), el_tree("tr", data = list(list(label = "x")))
  )
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  n_all     <- lengths(regmatches(html, gregexpr("Shiny[.]setInputValue[(]", html)))
  n_guarded <- lengths(regmatches(html, gregexpr("Shiny[.]setInputValue && Shiny[.]setInputValue[(]", html)))
  expect_gt(n_all, 0)
  expect_equal(n_guarded, n_all)
})
