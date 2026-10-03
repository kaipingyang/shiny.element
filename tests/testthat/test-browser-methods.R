`%||%` <- function(a, b) if (is.null(a)) b else a

# Every method Element Plus documents is callable by name; this runs each one
# on a live component (apps/methods.R lists them), through the channel
# el_call() uses, and fails on a method the component does not have, one that
# raises, or one that makes Vue warn.

test_that("every documented method runs on a live component", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "methods.R")
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
  b <- chromote::ChromoteSession$new(width = 1000, height = 800)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  # what the page says while every component mounts
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(
    "window.__loadWarns = []; ['warn', 'error'].forEach(function(k) {
      var o = console[k];
      console[k] = function() {
        window.__loadWarns.push(Array.prototype.join.call(arguments, ' '));
        return o.apply(console, arguments);
      };
    });"
  )
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  for (i in seq_len(60)) {
    Sys.sleep(0.5)
    ok <- b$Runtime$evaluate(
      "!!(window.Shiny && Shiny.shinyapp && Shiny.shinyapp.isConnected() && window.methodCases)"
    )$result$value
    if (isTRUE(ok)) break
  }
  Sys.sleep(2)

  # Every component mounts without a word from Vue's development build: the
  # calendar once took its value as a string where Element Plus wants a Date
  load_warns <- b$Runtime$evaluate(
    "JSON.stringify(window.__loadWarns.filter(function(w) { return /Vue warn|shiny-vue/.test(w); }).map(function(w) { return w.slice(0, 200); }))"
  )$result$value
  expect_equal(jsonlite::fromJSON(load_warns), list())

  # One at a time: what console.warn and console.error say, and anything
  # thrown, is pinned on the method that caused it
  res <- b$Runtime$evaluate(
    "(async function() {
      var cases = window.methodCases, failed = [], ran = 0;
      var seen = [], warn = console.warn, error = console.error;
      console.warn = function() { seen.push(Array.prototype.join.call(arguments, ' ')); };
      console.error = console.warn;
      var onerr = function(e) { seen.push('uncaught: ' + (e.reason || e.message || e)); };
      window.addEventListener('unhandledrejection', onerr);
      window.addEventListener('error', onerr);
      for (var i = 0; i < cases.length; i++) {
        var c = cases[i];
        seen = [];
        try { shinyVue.call({ id: c.id, component: c.component, method: c.method, args: c.args || [] }); }
        catch (e) { seen.push('threw: ' + e.message); }
        await new Promise(function(r) { setTimeout(r, 120); });
        if (seen.length) failed.push(c.id + '.' + c.method + ': ' + seen.join(' | ').slice(0, 300));
        else ran++;
      }
      console.warn = warn; console.error = error;
      window.removeEventListener('unhandledrejection', onerr);
      window.removeEventListener('error', onerr);
      return JSON.stringify({ ran: ran, total: cases.length, failed: failed });
    })()",
    awaitPromise = TRUE,
    timeout_ = 120
  )
  out <- jsonlite::fromJSON(res$result$value)
  expect_gt(out$total, 130)
  expect_length(out$failed, 0)
  if (length(out$failed)) {
    cat(unlist(out$failed), sep = "\n")
  }
  expect_equal(out$ran, out$total)

  # ── names that differ from Element Plus's, and JavaScript from R
  js <- function(x) b$Runtime$evaluate(x, awaitPromise = TRUE)$result$value
  shown <- function(text) {
    js(sprintf(
      "Array.from(document.querySelectorAll('.el-popper')).some(function(p){
        return getComputedStyle(p).display !== 'none' && p.textContent.indexOf('%s') !== -1; })",
      text
    ))
  }
  # el_tooltip(trigger = "click"): hovering does nothing, a click opens it
  js("document.querySelector('#p_tip_container button, #p_tip button').click()")
  Sys.sleep(0.8)
  expect_true(shown("clicked"))
  # popconfirm_width is the prompt's width
  js(
    "Array.from(document.querySelectorAll('button')).filter(function(x){ return x.textContent.trim() === 'wide'; })[0].click()"
  )
  Sys.sleep(0.8)
  expect_equal(
    js(
      "Math.round(Array.from(document.querySelectorAll('.el-popconfirm')).map(function(p){ return p.closest('.el-popper').getBoundingClientRect().width; }).filter(function(w){ return w > 0; })[0])"
    ),
    420
  )
  # virtual_ref: the button drawn apart opens the popover
  js("document.querySelector('#p_vbtn button').click()")
  Sys.sleep(0.8)
  expect_true(shown("virtual popover"))
  # $setInput from a slot template
  js(
    "window.__set = null; var o = Shiny.setInputValue;
     Shiny.setInputValue = function(n, v){ if (n === 'p_set') window.__set = v; return o.apply(this, arguments); };
     document.querySelectorAll('#p_tv .p-set')[1].click(); Shiny.setInputValue = o;"
  )
  expect_equal(js("window.__set"), 2)
  # a refused load: the node stops spinning and loads when expanded again
  node <- "Array.from(document.querySelectorAll('#p_lazy .el-tree-node__content')).filter(function(n){ return n.textContent.indexOf('region') !== -1; })[0]"
  js(paste0(node, ".click()"))
  Sys.sleep(1.5)
  expect_false(js("!!document.querySelector('#p_lazy .is-loading')"))
  expect_false(js(
    "document.querySelector('#p_lazy').textContent.indexOf('zone') !== -1"
  ))
  js(paste0(node, ".click()"))
  Sys.sleep(1.5)
  expect_true(js(
    "document.querySelector('#p_lazy').textContent.indexOf('zone') !== -1"
  ))
})
