# Does every prop an R argument sets reach Element's component?
#
#   python tools/api-coverage.py --docs && Rscript tools/api-coverage.R
#   python tools/prop-reach.py && Rscript tools/prop-reach.R
#
# tools/api-coverage.* say a prop is bound; this says it arrives: each case
# of /tmp/elapi/reach-cases.json renders a component given one prop's
# non-default value, and the browser reads the prop off Element's component
# instance (or a component under it, for a prop passed on through attrs),
# with Vue's development build, whose apps keep their instance reachable.
# A prop Element no longer declares -- documented as deprecated upstream --
# is reported as such. Containers drawn as markup (dialog, tabs, row, ...)
# have no instance: compare them with Element's own rendering instead.

suppressMessages({
  library(chromote)
  library(callr)
})
PKG <- normalizePath(".")
suppressMessages(pkgload::load_all(PKG, quiet = TRUE, helpers = FALSE))
src <- parse(file.path(PKG, "tools/api-coverage.R"))
for (e in src) {
  if (
    is.call(e) &&
      identical(e[[1]], as.name("<-")) &&
      identical(e[[2]], as.name("fixtures"))
  ) {
    eval(e)
  }
}
cases <- jsonlite::read_json("/tmp/elapi/reach-cases.json")

made <- list()
for (i in seq_along(cases)) {
  k <- cases[[i]]
  f <- getExportedValue("shiny.element", k$fn)
  base <- fixtures[[k$fn]] %||% list()
  hid <- paste0("rp", i)
  if (length(base) && (is.null(names(base)) || !nzchar(names(base)[1]))) {
    base[[1]] <- hid
  } else if ("id" %in% names(formals(f))) {
    base$id <- hid
  }
  ui <- tryCatch(
    do.call(f, c(base, stats::setNames(list(k$value), k$arg))),
    error = function(e) NULL
  )
  if (!is.null(ui)) {
    made[[length(made) + 1]] <- htmltools::tags$div(
      `data-case` = i,
      class = "rp-case",
      ui
    )
  }
}

probe <- "(function () {
  var cases = window.__cases, out = [];
  function pascal(t) { return t.split('-').map(function (s) { return s.charAt(0).toUpperCase() + s.slice(1); }).join(''); }
  function all(inst) {
    if (!inst) return []; var found = [], q = [inst.subTree];
    while (q.length && found.length < 5000) {
      var v = q.shift();
      if (!v || typeof v !== 'object') continue;
      if (v.component) { found.push(v.component); q.push(v.component.subTree); }
      if (Array.isArray(v.children)) v.children.forEach(function (c) { if (c && typeof c === 'object') q.push(c); });
      if (v.dynamicChildren) v.dynamicChildren.forEach(function (c) { q.push(c); });
    }
    return found;
  }
  document.querySelectorAll('.rp-case').forEach(function (div) {
    var i = +div.getAttribute('data-case'), k = cases[i - 1], apps = [];
    [div].concat(Array.prototype.slice.call(div.querySelectorAll('*'))).forEach(function (e) { if (e.__vue_app__) apps.push(e.__vue_app__); });
    if (!apps.length) return out.push([i, 'markup']);
    var cs = []; apps.forEach(function (a) { cs = cs.concat(all(a._instance)); });
    var own = cs.filter(function (c) { return c.type.name === pascal(k.tag); })[0];
    if (!own) return out.push([i, 'no component']);
    var want = JSON.stringify(k.value);
    if (cs.some(function (c) { return c.props && JSON.stringify(c.props[k.prop]) === want; })) return;
    var declared = Object.keys(own.type.props || {}).indexOf(k.prop) >= 0;
    out.push([i, declared ? 'not reached' : 'not declared by Element (an attr)']);
  });
  return JSON.stringify(out);
})()"

chromote::set_chrome_args(c(
  chromote::default_chrome_args(),
  "--disable-dev-shm-usage",
  "--no-sandbox",
  "--disable-gpu"
))
size <- 120
results <- list()
for (b in seq(1, length(made), by = size)) {
  part <- made[b:min(b + size - 1, length(made))]
  dir <- tempfile("reach")
  dir.create(dir)
  saveRDS(part, file.path(dir, "ui.rds"))
  writeLines(
    c(
      sprintf(
        "pkgload::load_all(%s, quiet = TRUE, helpers = FALSE)",
        shQuote(PKG)
      ),
      "shiny::shinyApp(el_page(dev = TRUE, readRDS('ui.rds')), function(input, output, session) {})"
    ),
    file.path(dir, "app.R")
  )
  port <- httpuv::randomPort()
  log <- file.path(dir, "log")
  proc <- callr::r_bg(
    function(a, p) {
      shiny::runApp(a, host = "127.0.0.1", port = p, launch.browser = FALSE)
    },
    args = list(a = dir, p = port),
    stdout = log,
    stderr = "2>&1"
  )
  for (i in 1:120) {
    Sys.sleep(1)
    if (any(grepl("Listening", readLines(log, warn = FALSE)))) break
  }
  s <- ChromoteSession$new(width = 1200, height = 900)
  s$Page$navigate(sprintf("http://127.0.0.1:%d/", port))
  Sys.sleep(15)
  s$Runtime$evaluate(paste0(
    "window.__cases = ",
    jsonlite::toJSON(cases, auto_unbox = TRUE),
    ";"
  ))
  got <- s$Runtime$evaluate(probe)
  if (is.null(got$result$value)) {
    stop(
      "the probe failed: ",
      got$exceptionDetails$exception$description %||% "no value",
      call. = FALSE
    )
  }
  results <- c(
    results,
    jsonlite::fromJSON(got$result$value, simplifyVector = FALSE)
  )
  s$close()
  proc$kill()
  cat(sprintf(
    "  %d of %d rendered\n",
    min(b + size - 1, length(made)),
    length(made)
  ))
}

cat(sprintf("\n%d cases, %d components drawn\n", length(cases), length(made)))
for (r in results) {
  k <- cases[[r[[1]]]]
  if (identical(r[[2]], "markup")) {
    next
  }
  cat(sprintf("  %-22s %-24s %s\n", k$fn, k$arg, r[[2]]))
}
