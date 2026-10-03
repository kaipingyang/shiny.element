# ── element_plus_dependency ───────────────────────────────────────────────────

ep_dep <- function() element_plus_dependency()[[1]]

test_that("element_plus_dependency: serves from the package by default", {
  # A runtime CDN dependency leaves the page blank on an intranet or offline,
  # so the bundled copy is the default.
  dep <- ep_dep()
  expect_equal(dep$name, "element-plus")
  expect_equal(dep$version, "2.14.7")
  expect_false(grepl("unpkg", paste(unlist(dep$src), collapse = " ")))
  expect_true(dir.exists(unname(dep$src[["file"]])))
  # and its icons, which are components, with it
  expect_equal(element_plus_dependency()[[2]]$name, "element-plus-icons")
})

test_that("element_plus_dependency: offline = FALSE falls back to the CDN", {
  deps <- element_plus_dependency(offline = FALSE)
  expect_match(
    unname(deps[[1]]$src[["href"]]),
    "^https://unpkg\\.com/element-plus@2\\.14\\.7/"
  )
  expect_match(
    unname(deps[[2]]$src[["href"]]),
    "^https://unpkg\\.com/@element-plus/icons-vue@2\\.3\\.2/"
  )
})

test_that("element_plus_dependency: the bundled files are actually there", {
  root <- system.file("element-plus", package = "shiny.element")
  for (f in c(
    "dist/index.full.min.js",
    "theme-chalk/index.css",
    "theme-chalk/dark/css-vars.css",
    "theme-chalk/display.css",
    "icons-vue.iife.min.js"
  )) {
    expect_true(file.exists(file.path(root, f)), info = f)
  }
})

test_that("element_plus_dependency: the bundled files are not truncated", {
  root <- system.file("element-plus", package = "shiny.element")
  expect_gt(file.size(file.path(root, "dist/index.full.min.js")), 900 * 1024)
  expect_gt(file.size(file.path(root, "theme-chalk/index.css")), 300 * 1024)
  expect_gt(file.size(file.path(root, "icons-vue.iife.min.js")), 150 * 1024)
})

test_that("element_plus_dependency: the stylesheet needs no fonts or remote files", {
  # Element Plus's icons are SVG components: the stylesheet loads nothing
  css <- paste(
    readLines(
      system.file(
        "element-plus",
        "theme-chalk",
        "index.css",
        package = "shiny.element"
      ),
      warn = FALSE
    ),
    collapse = "\n"
  )
  expect_false(grepl("url\\(['\"]?https?://", css))
  expect_false(grepl("element-icons.woff", css, fixed = TRUE))
})

# ── wiring ────────────────────────────────────────────────────────────────────

src_of <- function(tags) {
  deps <- htmltools::findDependencies(tags)
  dep <- Filter(function(d) identical(d$name, "element-plus"), deps)[[1]]
  paste(unlist(dep$src), collapse = " ")
}

test_that("el_page: passes offline through to the dependency", {
  expect_false(grepl("unpkg", src_of(el_page())))
  expect_true(grepl("unpkg", src_of(el_page(offline = FALSE))))
})

test_that("use_element: passes offline through to the dependency", {
  expect_false(grepl("unpkg", src_of(use_element())))
  expect_true(grepl("unpkg", src_of(use_element(offline = FALSE))))
})

test_that("Vue 3 is bundled, the global build with the template compiler", {
  dep <- .el_vue_dependency()
  expect_equal(dep$package, "shiny.element")
  path <- system.file(dep$src$file, dep$script, package = "shiny.element")
  expect_true(file.exists(path))
  head <- readLines(path, n = 3, warn = FALSE)
  expect_match(paste(head, collapse = " "), "vue v3.5.43", fixed = TRUE)
  # the compiler: components compile in the browser from their x-template
  expect_match(
    paste(readLines(path, warn = FALSE), collapse = ""),
    "vuejs.org/error-reference/#compiler-",
    fixed = TRUE
  )
})

test_that("every script a component brings resolves to a file", {
  for (dep in .el_vue_dependencies()) {
    # jQuery comes from jquerylib, its src relative to that package
    dir <- unname(dep$src[["file"]])
    if (!is.null(dep$package)) {
      dir <- system.file(dir, package = dep$package)
    }
    expect_true(file.exists(file.path(dir, dep$script)), info = dep$script)
  }
})

test_that("every component brings the bridge, after jQuery and Vue", {
  names <- vapply(htmltools::findDependencies(el_input("x")), `[[`, "", "name")
  expect_equal(names[1:4], c("jquery", "vue", "shiny-vue", "el-events"))
})

test_that("the bridge checks each updated key against the component's data", {
  js <- paste(
    readLines(
      system.file("js", "shiny-vue.js", package = "shiny.element"),
      warn = FALSE
    ),
    collapse = "\n"
  )
  # Writing a field the component never declared is a silent no-op in Vue 2,
  # which is how el-table's handler shipped three assignments that could
  # never have worked.
  expect_match(js, "in vm.$data", fixed = TRUE)
  expect_match(js, "is not a field of", fixed = TRUE)
  expect_match(js, "no component with id", fixed = TRUE)
  expect_match(js, "shinyVueUpdate", fixed = TRUE)
  expect_match(js, "shinyVueCall", fixed = TRUE)
})

test_that("no component brings a handler script of its own", {
  # Forty-odd scripts each registered one message type; a component whose
  # script arrived late -- through renderUI() -- or was never attached (the
  # cascader once got the button's) heard nothing. One message, handled by
  # the bridge, replaced them. Feedback stays: it belongs to no component.
  handlers <- list.files(
    system.file("js", package = "shiny.element"),
    pattern = "-handler\\.js$"
  )
  expect_equal(handlers, "el-feedback-handler.js")
})

# ── layout stylesheet ─────────────────────────────────────────────────────────

test_that("el-layout.css applies nothing automatically", {
  # It used to ship Element UI's container demo, whose placeholder styles are
  # written to make empty boxes visible on that one documentation page:
  # line-height 160-320px, text-align center and a grey-blue palette, forced
  # onto .el-main / .el-aside / .el-header of every app that loaded it. A
  # showcase page measured 4524px tall instead of 1444px.
  css <- paste(
    readLines(
      system.file("css", "el-layout.css", package = "shiny.element"),
      warn = FALSE
    ),
    collapse = "\n"
  )

  # Strip comments before looking for rules.
  rules <- gsub("/\\*.*?\\*/", "", css)

  expect_false(
    grepl("^\\.el-[a-z-]+[ ,{]", rules),
    info = "no selector may target an Element UI class directly"
  )
  for (prop in c(
    "line-height",
    "text-align",
    "background-color",
    "margin-bottom"
  )) {
    expect_false(
      grepl(paste0("\\.el-[a-z-]+[^{]*\\{[^}]*", prop), rules),
      info = prop
    )
  }
  # The position-dependent selectors were the worst of it: what a component
  # looked like depended on where it happened to sit in the document.
  expect_false(grepl("nth-child", rules, fixed = TRUE))
})

test_that("el-layout.css keeps its opt-in helper classes", {
  css <- paste(
    readLines(
      system.file("css", "el-layout.css", package = "shiny.element"),
      warn = FALSE
    ),
    collapse = "\n"
  )
  for (cls in c(".bg-purple", ".grid-content", ".row-bg")) {
    expect_match(css, cls, fixed = TRUE)
  }
})

# ── locale ────────────────────────────────────────────────────────────────────

names_of <- function(tags) {
  vapply(htmltools::findDependencies(tags), function(d) d$name, character(1))
}

test_that("el_locale_dependency: the built-in locale needs nothing extra", {
  # Element Plus's bundle already speaks English
  expect_null(el_locale_dependency())
  expect_null(el_locale_dependency("en"))
})

test_that("el_locale_dependency: a locale loads its file and hands it over", {
  deps <- el_locale_dependency("zh-CN")
  expect_length(deps, 2)
  expect_equal(deps[[1]]$script, "dist/locale/zh-cn.min.js")
  # The file defines ElementPlusLocaleZhCn; a second dependency gives it to
  # every app as it installs Element Plus
  expect_match(deps[[2]]$head, "ElementPlusLocaleZhCn", fixed = TRUE)
  expect_match(deps[[2]]$head, "shinyElementConfig.locale", fixed = TRUE)
  expect_match(
    el_locale_dependency("pt-br")[[2]]$head,
    "ElementPlusLocalePtBr",
    fixed = TRUE
  )
})

test_that("el_locale_dependency: the bundled locale file is really there", {
  p <- system.file(
    "element-plus",
    "dist",
    "locale",
    "zh-cn.min.js",
    package = "shiny.element"
  )
  expect_true(file.exists(p))
  expect_gt(file.size(p), 2000)
  expect_match(
    paste(readLines(p, warn = FALSE), collapse = "\n"),
    "ElementPlusLocaleZhCn",
    fixed = TRUE
  )
})

test_that("el_locale_dependency: an unknown locale fails naming the real ones", {
  expect_error(el_locale_dependency("xx"), "No bundled locale")
  expect_error(el_locale_dependency("xx"), "zh-tw")
})

test_that("every locale Element Plus ships is bundled", {
  expect_equal(length(el_locales()), 67)
  expect_true(all(c("en", "fr", "ja", "zh-cn", "zh-tw") %in% el_locales()))
  expect_type(el_locale_dependency("fr"), "list")
})

test_that("el_page speaks English unless told otherwise", {
  expect_false(any(grepl("locale", names_of(el_page()))))
  expect_false(any(grepl("locale", names_of(use_element()))))
  # and the option switches it for a whole session
  withr::with_options(list(shiny.element.locale = "zh-CN"), {
    expect_true("element-plus-locale-zh-cn" %in% names_of(el_page()))
  })
  withr::with_options(list(shiny.element.locale = "fr"), {
    expect_true("element-plus-locale-fr" %in% names_of(el_page()))
  })
})

test_that("el_page and use_element pass locale through", {
  expect_true(
    "element-plus-locale-zh-cn" %in% names_of(el_page(locale = "zh-CN"))
  )
  expect_true("element-plus-locale-ja" %in% names_of(el_page(locale = "ja")))
  expect_false(any(grepl("locale", names_of(use_element(locale = "en")))))
})

test_that("the locale is handed over before any component installs Element Plus", {
  names <- names_of(el_page(locale = "ja"))
  expect_lt(
    which(names == "element-plus-locale-ja"),
    which(names == "element-plus-locale-apply-ja")
  )
})

test_that("every generated call to Shiny is guarded, so components work without it", {
  # A static page -- R Markdown, Quarto, the package's website -- has no
  # Shiny; an unguarded call threw on every change a user made.
  ui <- htmltools::tagList(
    el_input("i"),
    el_select("s", choices = "a"),
    el_table("t", data = head(iris, 1)),
    el_menu("m", items = list(list(index = "a", label = "A"))),
    el_pagination("p", total = 10),
    el_tree("tr", data = list(list(label = "x")))
  )
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  n_all <- lengths(regmatches(html, gregexpr("Shiny[.]setInputValue[(]", html)))
  n_guarded <- lengths(regmatches(
    html,
    gregexpr("Shiny[.]setInputValue && Shiny[.]setInputValue[(]", html)
  ))
  expect_gt(n_all, 0)
  expect_equal(n_guarded, n_all)
})
