# v_bind() and v_model(): components following one another in the browser -- with no
# Shiny on the page, and with a server that reads and changes what they do.

bind_page_js <- function(b) {
  function(x) b$Runtime$evaluate(x, returnByValue = TRUE)$result$value
}

capture_js <- paste0(
  "window.__w = []; ['warn', 'error'].forEach(function(k) { var o = console[k]; ",
  "console[k] = function() { __w.push(Array.from(arguments).join(' ')); o.apply(console, arguments); }; });"
)
catch_warnings <- function(js) js(capture_js)

gap <- "getComputedStyle(document.querySelector('#sp .el-space')).columnGap"
checked <- function(id) {
  sprintf(
    "document.querySelector('#%s .el-switch').classList.contains('is-checked')",
    id
  )
}
dialog_open <- "document.getElementById('dlg').style.display !== 'none'"
active_tab <- "document.querySelector('#tabs .el-tabs__item.is-active').textContent.trim()"
state <- "document.querySelector('#state [data-shiny-vue-root]').textContent.trim()"

test_that("bound components follow each other on a page with no Shiny", {
  skip_if_no_browser()
  source(testthat::test_path("apps", "bind.R"), local = TRUE)
  dir <- withr::local_tempdir()
  htmltools::save_html(
    htmltools::tagList(use_element(dev = TRUE), bind_ui(), legacy_ui()),
    file.path(dir, "page.html"),
    libdir = "lib"
  )
  use_browser_args()
  b <- chromote::ChromoteSession$new(width = 1000, height = 700)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- bind_page_js(b)
  # from the first script on, so warnings made while mounting count too
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(source = capture_js)
  b$Page$navigate(paste0("file://", file.path(dir, "page.html")))
  Sys.sleep(3)
  expect_equal(js("typeof Shiny"), "undefined")
  # $inputs filled with no Shiny: the space follows the radio group
  expect_equal(js(gap), "12px")
  js("document.querySelectorAll('#sz .el-radio')[0].click()")
  Sys.sleep(0.3)
  expect_equal(js(gap), "16px")
  # a store both ways: one switch turned off, the other follows
  expect_true(js(checked("sw2")))
  js("document.querySelector('#sw .el-switch').click()")
  Sys.sleep(0.3)
  expect_false(js(checked("sw2")))
  expect_match(js(state), "on=false")
  # a container: opened by an `on` handler setting the store, closed by
  # its user, the store following
  js("document.querySelector('#open button').click()")
  Sys.sleep(0.6)
  expect_true(js(dialog_open))
  expect_match(js(state), "open=true")
  js("document.querySelector('#dlg .el-dialog__headerbtn').click()")
  Sys.sleep(0.6)
  expect_false(js(dialog_open))
  expect_match(js(state), "open=false")
  # tabs: clicked, the store follows; the store set, the tab follows
  js("document.querySelectorAll('#tabs .el-tabs__item')[1].click()")
  Sys.sleep(0.3)
  expect_match(js(state), "tab=b")
  js("shinyVue.useStore('ui').tab = 'a'")
  Sys.sleep(0.3)
  expect_equal(js(active_tab), "A")
  # a drawer's edge following a radio group, its visibility a store
  js("document.querySelectorAll('#edge .el-radio')[1].click()")
  js("shinyVue.useStore('ui').drawer = true")
  Sys.sleep(0.6)
  expect_true(js("!!document.querySelector('#drw .el-drawer.btt')"))
  expect_true(js("document.getElementById('drw').style.display !== 'none'"))
  js("document.querySelector('#drw .el-drawer__close-btn').click()")
  Sys.sleep(0.6)
  expect_false(js("shinyVue.useStore('ui').drawer"))
  # Element's message service from an `on` handler
  js("document.querySelector('#msg button').click()")
  Sys.sleep(0.4)
  expect_equal(
    js("(document.querySelector('.el-message') || {}).textContent"),
    "Hi from the page"
  )
  # $find(): a component's method from another, in the browser
  js("document.querySelector('#flt button').click()")
  Sys.sleep(0.4)
  expect_equal(
    js(
      "Array.from(document.querySelectorAll('#tr .el-tree-node')).filter(function(n){ return n.style.display !== 'none'; }).map(function(n){ return n.textContent.trim(); }).join(',')"
    ),
    "pear"
  )
  # an expression: the switch is disabled unless the size is large
  expect_false(js(sprintf(
    "document.querySelector('#big .el-switch').classList.contains('is-disabled')"
  )))
  js("document.querySelectorAll('#sz .el-radio')[1].click()")
  Sys.sleep(0.3)
  expect_true(js(
    "document.querySelector('#big .el-switch').classList.contains('is-disabled')"
  ))
  # two instances of a module: each its own store, input and handler
  count <- function(m) {
    js(sprintf(
      "document.querySelector('#%s-count [data-shiny-vue-root]').textContent.trim()",
      m
    ))
  }
  mgap <- function(m) {
    js(sprintf(
      "getComputedStyle(document.querySelector('#%s-sp .el-space')).columnGap",
      m
    ))
  }
  js("document.querySelector('#m1-add button').click()")
  js("document.querySelectorAll('#m1-size .el-radio')[0].click()")
  Sys.sleep(0.3)
  expect_equal(c(count("m1"), count("m2")), c("n=1", "n=0"))
  expect_equal(c(mgap("m1"), mgap("m2")), c("16px", "12px"))
  # $store, as 0.3.1 named it, still works, and says so once
  expect_equal(
    js(
      "document.querySelector('#legacy [data-shiny-vue-root]').textContent.trim()"
    ),
    "false"
  )
  w <- js("__w")
  expect_length(w, 1)
  expect_match(w[[1]], "$store is $vueStore now", fixed = TRUE)
})

test_that("with a server: it reads what the page did and changes it", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "bind.R")
  pkg <- normalizePath(testthat::test_path("..", ".."))
  port <- httpuv::randomPort()
  log <- tempfile(fileext = ".log")
  proc <- callr::r_bg(
    function(app, pkg, port, libs) {
      .libPaths(libs)
      pkgload::load_all(
        pkg,
        quiet = TRUE,
        helpers = FALSE,
        attach_testthat = FALSE
      )
      options(shiny.vue.dev = TRUE)
      shiny::runApp(
        app,
        host = "127.0.0.1",
        port = port,
        launch.browser = FALSE
      )
    },
    args = list(app = app, pkg = pkg, port = port, libs = .libPaths()),
    stdout = log,
    stderr = "2>&1"
  )
  on.exit(proc$kill(), add = TRUE)
  for (i in seq_len(120)) {
    Sys.sleep(0.5)
    if (any(grepl("Listening on", readLines(log, warn = FALSE)))) break
  }
  use_browser_args()
  b <- chromote::ChromoteSession$new(width = 1000, height = 700)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- bind_page_js(b)
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  Sys.sleep(5)
  catch_warnings(js)
  seen <- function() js("document.getElementById('seen').textContent")
  expect_equal(seen(), "sz=default sw=TRUE sw2=TRUE dlg=FALSE tabs=a")
  # the page changes without the server, and the server hears of it
  js("document.querySelectorAll('#sz .el-radio')[0].click()")
  js("document.querySelector('#sw .el-switch').click()")
  Sys.sleep(0.1)
  expect_equal(js(gap), "16px")
  expect_false(js(checked("sw2")))
  Sys.sleep(1)
  expect_equal(seen(), "sz=large sw=FALSE sw2=FALSE dlg=FALSE tabs=a")
  js("document.querySelector('#open button').click()")
  Sys.sleep(1)
  expect_equal(seen(), "sz=large sw=FALSE sw2=FALSE dlg=TRUE tabs=a")
  js("document.querySelector('#dlg .el-dialog__headerbtn').click()")
  Sys.sleep(1)
  expect_match(seen(), "dlg=FALSE")
  # an update of a bound field sets the store, and the other switch follows
  js("document.querySelector('#srv_on button').click()")
  Sys.sleep(1.5)
  expect_true(js(checked("sw2")))
  expect_match(js(state), "on=true")
  expect_match(seen(), "sw=TRUE sw2=TRUE")
  # a container's update too
  js("document.querySelector('#srv_tab button').click()")
  Sys.sleep(1.5)
  expect_match(js(state), "tab=b")
  expect_match(seen(), "tabs=b")
  expect_equal(js("__w.length"), 0)
})

test_that("a store named twice on the page says so", {
  skip_if_no_browser()
  # what two instances of a module do when it names its store without ns()
  dir <- withr::local_tempdir()
  htmltools::save_html(
    htmltools::tagList(
      use_element(dev = TRUE),
      shiny::tags$div(vue_store("ui", state = list(n = 1))),
      shiny::tags$div(vue_store("ui", state = list(n = 2)))
    ),
    file.path(dir, "page.html"),
    libdir = "lib"
  )
  use_browser_args()
  b <- chromote::ChromoteSession$new()
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(source = capture_js)
  b$Page$navigate(paste0("file://", file.path(dir, "page.html")))
  Sys.sleep(3)
  w <- unlist(bind_page_js(b)("__w"))
  expect_length(w, 1)
  expect_match(w, 'vue_store("ui") is on the page twice', fixed = TRUE)
})

test_that("a binding the page cannot read says so once", {
  skip_if_no_browser()
  dir <- withr::local_tempdir()
  htmltools::save_html(
    htmltools::tagList(
      use_element(dev = TRUE),
      shiny::tags$div(vue_store("ui", state = list(open = FALSE))),
      # a store the page does not have
      shiny::tags$div(vue_app(
        "bad_store",
        shiny::tags$span(class = "out", "{{ String(open) }}"),
        data = list(open = v_bind("$vueStore.uis.open"))
      )),
      # a path that runs through nothing
      shiny::tags$div(vue_app(
        "bad_path",
        shiny::tags$span(class = "out", "{{ String(open) }}"),
        data = list(open = v_bind("$vueStore.ui.absent.thing"))
      )),
      # $route, on a page with no router
      shiny::tags$div(vue_app(
        "no_router",
        shiny::tags$span(class = "out", "{{ String(id) }}"),
        data = list(id = v_bind("$route.params.id"))
      )),
      # and one that reads
      shiny::tags$div(vue_app(
        "good",
        shiny::tags$span(class = "out", "{{ String(open) }}"),
        data = list(open = v_bind("$vueStore.ui.open"))
      ))
    ),
    file.path(dir, "page.html"),
    libdir = "lib"
  )
  use_browser_args()
  b <- chromote::ChromoteSession$new()
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- bind_page_js(b)
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(source = capture_js)
  b$Page$navigate(paste0("file://", file.path(dir, "page.html")))
  Sys.sleep(3)
  out <- function(id) {
    js(sprintf("document.querySelector('#%s .out').textContent", id))
  }
  expect_equal(out("good"), "false")
  expect_equal(out("bad_store"), "undefined")
  expect_equal(out("bad_path"), "undefined")
  expect_equal(out("no_router"), "undefined")
  w <- unlist(js("__w"))
  expect_length(w, 3)
  expect_match(w[1], 'no store "uis" on the page', fixed = TRUE)
  expect_match(w[2], 'v_bind("$vueStore.ui.absent.thing")', fixed = TRUE)
  expect_match(w[3], "the page has no vue_router()", fixed = TRUE)
  # said once: a change of the store the good one follows does not repeat it
  js("shinyVue.useStore('ui').open = true")
  Sys.sleep(0.4)
  expect_equal(out("good"), "true")
  expect_length(unlist(js("__w")), 3)
})

test_that("a store or a router drawn later is waited for, not warned about", {
  skip_if_no_browser()
  # as renderUI() draws them: after the components that read them mounted
  late <- htmltools::renderTags(vue_store("late", state = list(open = TRUE)))
  dir <- withr::local_tempdir()
  htmltools::save_html(
    htmltools::attachDependencies(
      htmltools::tagList(
        use_element(dev = TRUE),
        shiny::tags$div(vue_app(
          "follower",
          shiny::tags$span(class = "out", "{{ String(open) }}"),
          data = list(open = v_bind("$vueStore.late.open"))
        )),
        shiny::tags$div(vue_app(
          "path",
          shiny::tags$span(class = "out", "{{ String(path) }}"),
          data = list(path = v_bind("$route.path"))
        )),
        el_button("plain", "Plain"),
        shiny::tags$div(id = "slot"),
        shiny::tags$script(htmltools::HTML(sprintf(
          paste0(
            "document.addEventListener('DOMContentLoaded', function() {",
            " var d = document.getElementById('slot'); d.innerHTML = %s;",
            " shinyVue.mount(d);",
            " shinyVue.createRouter({ id: 'route', history: 'hash', routes: [] });",
            " });"
          ),
          jsonlite::toJSON(as.character(late$html), auto_unbox = TRUE)
        )))
      ),
      c(list(.vue_router_dependency()), late$dependencies)
    ),
    file.path(dir, "page.html"),
    libdir = "lib"
  )
  use_browser_args()
  b <- chromote::ChromoteSession$new()
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- bind_page_js(b)
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(source = capture_js)
  b$Page$navigate(paste0("file://", file.path(dir, "page.html")))
  Sys.sleep(3)
  expect_equal(
    js("document.querySelector('#follower .out').textContent"),
    "true"
  )
  # a v_bind() of $route follows the router that came after it
  expect_equal(js("document.querySelector('#path .out').textContent"), "/")
  expect_length(unlist(js("__w")), 0)
})

test_that("a bound value reaches the component as it is; the server's edits stay its own", {
  skip_if_no_browser()
  dir <- withr::local_tempdir()
  htmltools::save_html(
    htmltools::tagList(
      use_element(dev = TRUE),
      shiny::tags$div(vue_store(
        "rows",
        state = list(list = list(list(n = 1)))
      )),
      shiny::tags$div(vue_app(
        "as_is",
        shiny::tags$span(
          class = "out",
          "{{ typeof col.fmt }} {{ when instanceof Date }} {{ !!icon.render || !!icon.setup }}"
        ),
        data = list(
          col = v_bind("({ fmt: (v) => v + '!' })"),
          when = v_bind("new Date(2026, 0, 1)"),
          icon = v_bind("ElementPlusIconsVue.Edit")
        )
      )),
      shiny::tags$div(vue_app(
        "follow",
        shiny::tags$span(class = "out", "{{ list.length }}"),
        data = list(list = v_bind("$vueStore.rows.list"))
      ))
    ),
    file.path(dir, "page.html"),
    libdir = "lib"
  )
  use_browser_args()
  b <- chromote::ChromoteSession$new()
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- bind_page_js(b)
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(source = capture_js)
  b$Page$navigate(paste0("file://", file.path(dir, "page.html")))
  Sys.sleep(3)
  # a function, a Date and a component, as upstream's :prop would give them
  expect_equal(
    js("document.querySelector('#as_is .out').textContent"),
    "function true true"
  )
  # the same object as the store's, not a copy
  expect_true(js(
    "document.getElementById('follow')._shinyVue.list === shinyVue.useStore('rows').list"
  ))
  # the server inserting a row in the follower: its own, the store untouched
  js(
    "shinyVue.update('follow', {'.edit': {field: 'list', op: 'insert', rows: [{n: 2}]}})"
  )
  Sys.sleep(0.3)
  expect_equal(js("document.querySelector('#follow .out').textContent"), "2")
  expect_equal(js("shinyVue.useStore('rows').list.length"), 1)
  expect_length(unlist(js("__w")), 0)
})
