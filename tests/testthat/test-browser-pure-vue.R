`%||%` <- function(a, b) if (is.null(a)) b else a

# The Vue layer on its own: no Element Plus on the page.

test_that("vue_app() works without Element Plus", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "pure-vue.R")
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
      options(shiny.element.dev = TRUE)
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
  b <- chromote::ChromoteSession$new(width = 1000, height = 900)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(
    "window.__w = []; ['warn', 'error'].forEach(function(k) {
       var o = console[k];
       console[k] = function() { window.__w.push(Array.prototype.join.call(arguments, ' ')); return o.apply(console, arguments); };
     });"
  )
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  js <- function(x) b$Runtime$evaluate(x, awaitPromise = TRUE)$result$value
  Sys.sleep(6)

  # nothing of Element on the page
  expect_false(js("!!window.ElementPlus"))
  expect_false(js(
    "!!document.querySelector('link[href*=element-plus], script[src*=element-plus], script[src*=el-events]')"
  ))

  # input is input$<id>; a data.frame is rows for v-for
  expect_equal(js("Shiny.shinyapp.$inputValues.counter"), 1)
  expect_equal(
    js(
      "document.querySelector('#counter .rows').parentNode.textContent.replace(/\\s+/g, '')"
    ),
    "+1a;b;"
  )
  js("document.querySelector('#counter .inc').click()")
  Sys.sleep(0.8)
  expect_equal(js("Shiny.shinyapp.$inputValues.counter"), 2)
  # $emit('picked', row) is input$counter_picked, as Element's events are
  js("document.querySelectorAll('#counter .rows')[1].click()")
  Sys.sleep(0.8)
  expect_equal(
    js("JSON.stringify(Shiny.shinyapp.$inputValues.counter_picked)"),
    '{"name":"b"}'
  )

  # an input of two fields is one value, a named list
  expect_equal(
    js("JSON.stringify(Shiny.shinyapp.$inputValues.range)"),
    '{"from":1,"to":9}'
  )
  js(
    "var i = document.querySelector('#range .to'); i.value = '7'; i.dispatchEvent(new Event('input'));"
  )
  Sys.sleep(0.8)
  expect_equal(
    js("JSON.stringify(Shiny.shinyapp.$inputValues.range)"),
    '{"from":1,"to":7}'
  )

  # a plugin of the page's own, installed by name
  expect_equal(
    js("document.querySelector('#greet .hello').textContent"),
    "hi Ada"
  )
  # ... and with options
  expect_equal(
    js("document.querySelector('#greet2 .hello').textContent"),
    "hello Alan"
  )

  # a store: two apps share it at once, without the server; its input is
  # input$cart; the server sets a field with an update
  js(
    "document.querySelector('#sa .sa').click(); document.querySelector('#sa .sa').click();"
  )
  expect_equal(js("document.querySelector('#sb .sb').textContent"), "2|")
  Sys.sleep(0.8)
  expect_equal(js("Shiny.shinyapp.$inputValues.cart"), 2)
  js("document.querySelector('#counter .inc').click()")
  Sys.sleep(1.2)
  expect_equal(js("document.querySelector('#sb .sb').textContent"), "2|from R")

  # setup() state: reported as the input, and set by update_vue(value =)
  expect_equal(js("document.querySelector('#st .st').textContent"), "1/2")
  expect_equal(js("Shiny.shinyapp.$inputValues.st"), 1)
  js("Shiny.setInputValue('set_st', 1)")
  Sys.sleep(1)
  expect_equal(js("document.querySelector('#st .st').textContent"), "5/10")
  expect_equal(js("Shiny.shinyapp.$inputValues.st"), 5)

  # render_vue() with a component of the layer's own
  js("document.getElementById('rv_app').__mark = 1")
  expect_match(js("document.querySelector('#rv .rv').textContent"), "n is 3")
  js("document.querySelector('#counter .inc').click()")
  Sys.sleep(1.2)
  expect_match(js("document.querySelector('#rv .rv').textContent"), "n is 4")
  expect_equal(js("document.getElementById('rv_app').__mark"), 1)

  # $emit(): several arguments an object, none TRUE, a single null NULL
  js("document.querySelector('#em .pair').click()")
  js("document.querySelector('#em .bare').click()")
  js("document.querySelector('#em .nil').click()")
  js("document.querySelector('#em .mix').click()")
  Sys.sleep(0.8)
  # a null keeps its place among several
  expect_equal(
    js("JSON.stringify(Shiny.shinyapp.$inputValues.em_mix)"),
    '{"arg1":null,"arg2":2}'
  )
  expect_equal(
    js("JSON.stringify(Shiny.shinyapp.$inputValues.em_pair)"),
    '{"arg1":"left","arg2":2}'
  )
  expect_true(js("Shiny.shinyapp.$inputValues.em_bare"))
  expect_true(js(
    "Shiny.shinyapp.$inputValues.em_nil === null"
  ))

  # a child registered as todo_item renders as <todo-item>, and its event
  # reaches the parent
  expect_equal(js("document.querySelectorAll('#todo li.item').length"), 2)
  expect_false(js("!!document.querySelector('#todo todo-item')"))
  js("document.querySelector('#todo li.item').click()")
  Sys.sleep(0.8)
  expect_equal(js("Shiny.shinyapp.$inputValues.todo"), 1)

  # data outputs: each field follows its output (the counter is at 4 here)
  expect_equal(
    js("document.querySelector('#dout .dout').textContent.trim()"),
    "8 4 f1"
  )
  glob <- function() js("document.querySelector('#glob .glob').textContent")
  # $inputs follows another component's input
  expect_match(
    glob(),
    paste0("^", js("Shiny.shinyapp.$inputValues.counter"), "\\|idle\\|ok$")
  )
  js("Shiny.setInputValue('dslow', true)")
  Sys.sleep(0.8)
  # $busy while the server works
  expect_match(glob(), "|busy|", fixed = TRUE)
  expect_equal(
    js("document.querySelector('#dout .dout').getAttribute('data-busy')"),
    "yes"
  )
  Sys.sleep(2.5)
  expect_equal(
    js("document.querySelector('#dout .dout').getAttribute('data-busy')"),
    "no"
  )
  expect_match(glob(), "|idle|", fixed = TRUE)
  # $errors: a data output's error, then gone once it renders
  js("Shiny.setInputValue('dfail', true)")
  Sys.sleep(1.5)
  expect_match(glob(), "|it broke$")
  js("Shiny.setInputValue('dfail', false)")
  Sys.sleep(1.5)
  expect_match(glob(), "|ok$")

  # held back while hidden: rendered once shown
  expect_equal(js("document.querySelector('#dhid .dhid').textContent"), "")
  js("document.querySelectorAll('.nav-tabs a')[1].click()")
  Sys.sleep(1.5)
  expect_equal(js("document.querySelector('#dhid .dhid').textContent"), "1")

  # a throttled event: at once, then at most once per wait, the last always
  sent <- js(
    "new Promise(function(done) {
       var seen = [], set = Shiny.setInputValue;
       Shiny.setInputValue = function(name, value) {
         if (name === 'thr_tick') seen.push(value);
         return set.apply(this, arguments);
       };
       var i = 0, timer = setInterval(function() {
         shinyVue.emit('thr', 'tick', [++i], 200);
         if (i === 30) {
           clearInterval(timer);
           setTimeout(function() {
             Shiny.setInputValue = set;
             done(JSON.stringify(seen));
           }, 400);
         }
       }, 20);
     })"
  )
  sent <- jsonlite::fromJSON(sent)
  expect_equal(sent[1], 1)
  expect_equal(sent[length(sent)], 30)
  expect_lte(length(sent), 6)

  # type: the value arrives as a Date, through Shiny's own handler
  expect_match(
    js("document.getElementById('vals').textContent"),
    "typed = Date 2026-01-31",
    fixed = TRUE
  )
  # rate: typed into, it waits for the user to stop
  js(
    "var i = document.querySelector('#typed .typed');
     i.value = '2026-02-01'; i.dispatchEvent(new Event('input'));"
  )
  Sys.sleep(0.3)
  expect_match(
    js("document.getElementById('vals').textContent"),
    "2026-01-31",
    fixed = TRUE
  )
  Sys.sleep(1.5)
  expect_match(
    js("document.getElementById('vals').textContent"),
    "typed = Date 2026-02-01",
    fixed = TRUE
  )
  # a list changed in place: inserted, set by path, deleted and replaced
  # by key -- in order
  js("Shiny.setInputValue('items_ops', 1)")
  Sys.sleep(1.5)
  expect_equal(
    js(
      "Array.from(document.querySelectorAll('#items li')).map(function(l) { return l.textContent; }).join(',')"
    ),
    "Z,A+,B2"
  )
  # setup()'s composables
  comp <- js("document.querySelector('#comp .comp').textContent")
  n <- js("Shiny.shinyapp.$inputValues.counter")
  expect_equal(comp, sprintf("a|%s|%s|false", n, n * 2))
  expect_equal(js("Shiny.shinyapp.$inputValues.comp_pick"), "a")

  # vue_app(events =, on =) on the template's root
  js(
    "var b = document.querySelector('#evt .evtb'); b.click(); b.dispatchEvent(new MouseEvent('dblclick', {bubbles: true}));"
  )
  Sys.sleep(1)
  expect_equal(js("Shiny.shinyapp.$inputValues.evt_clicked"), 1)
  expect_true(js("Shiny.shinyapp.$inputValues.evt_dblclick"))
  # a plugin written in R
  expect_equal(
    js("document.querySelector('#inline .inline').textContent"),
    "inline"
  )

  expect_equal(
    js(
      "window.__w.filter(function(w){ return /Vue warn|shiny-vue/.test(w); }).length"
    ),
    0
  )
})
