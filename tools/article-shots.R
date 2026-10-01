# Screenshot every example in the articles, from the articles' own code.
#
#   Rscript tools/article-shots.R                 # every article
#   Rscript tools/article-shots.R forms tables    # just these
#   Rscript tools/article-shots.R forms:choices   # one example
#
# An example is a knitr chunk marked `shot = TRUE`:
#
#   ```{r choices, eval = FALSE, shot = TRUE}
#   el_select("city", choices = c("Beijing", "Shanghai"))
#   ```
#
# Its code is run as it stands and the result is captured to
# pkgdown/assets/shots/<article>-<label>.png, which the hook in
# vignettes/shots.R places under the chunk. There is no second copy of the
# code to drift away from the first.
#
# A chunk's code can be UI -- every visible value is collected, so a chunk
# holding three calls shows three components -- or a whole app ending in
# shinyApp(ui, server), whose server runs too.
#
# Options a chunk may carry:
#   shot_js    JavaScript to run before capturing: open a dialog, hover a
#              tooltip, click a button so the server answers.
#   shot_sel   Extra selectors to include, for overlays Element appends to
#              <body> rather than inside the component.
#   shot_wait  Seconds to wait after shot_js. Default 1.5.
#
# Every example is also checked: code that fails to run, a page that logs
# a [Vue warn] under Vue's development build, or a menu entry, tab or tag
# drawn with no label, is reported and the script exits non-zero.

suppressMessages({
  library(chromote)
  library(callr)
})

PKG    <- normalizePath(".")
OUTDIR <- file.path(PKG, "pkgdown", "assets", "shots")
PORT   <- httpuv::randomPort()

# ── reading the articles ─────────────────────────────────────────────────────

parse_header <- function(header) {
  args <- eval(parse(text = sprintf("alist(%s)", header)))
  nms <- names(args) %||% rep("", length(args))
  label <- if (any(!nzchar(nms))) {
    gsub(" ", "", paste(deparse(args[[which(!nzchar(nms))[1]]]), collapse = ""))
  } else NA_character_
  opts <- lapply(args[nzchar(nms)], eval)
  list(label = label, opts = opts)
}

`%||%` <- function(a, b) if (is.null(a)) b else a

read_shots <- function(path) {
  lines <- readLines(path, warn = FALSE)
  article <- sub("[.]Rmd$", "", basename(path))
  starts <- grep("^```\\{r(.*)\\}\\s*$", lines)
  out <- list()
  for (s in starts) {
    header <- sub("^```\\{r\\s*,?\\s*(.*)\\}\\s*$", "\\1", lines[s])
    end <- s + which(grepl("^```\\s*$", lines[(s + 1):length(lines)]))[1]
    chunk <- parse_header(header)
    if (!isTRUE(chunk$opts$shot)) next
    key <- paste0(article, "-", chunk$label)
    # A chunk may show a file instead -- knitr's `file` option -- so that a
    # whole app lives once, under inst/examples, and the article shows it.
    code <- if (!is.null(chunk$opts$file)) {
      paste(readLines(file.path(dirname(path), chunk$opts$file), warn = FALSE),
            collapse = "\n")
    } else {
      paste(lines[(s + 1):(end - 1)], collapse = "\n")
    }
    out[[key]] <- list(
      key  = key,
      code = code,
      js   = chunk$opts$shot_js,
      sel  = chunk$opts$shot_sel,
      wait = chunk$opts$shot_wait %||% 1.5
    )
  }
  out
}

articles <- list.files(file.path(PKG, "vignettes"), pattern = "[.]Rmd$",
                       full.names = TRUE)
shots <- do.call(c, unname(lapply(articles, read_shots)))

wanted <- commandArgs(TRUE)
if (length(wanted)) {
  keep <- vapply(names(shots), function(k) {
    any(vapply(wanted, function(w) {
      if (grepl(":", w)) k == sub(":", "-", w) else startsWith(k, paste0(w, "-"))
    }, logical(1)))
  }, logical(1))
  shots <- shots[keep]
}
if (!length(shots)) stop("no example chunks matched")
message(sprintf("%d examples", length(shots)))

# ── one app serving every example ────────────────────────────────────────────

spec_file <- tempfile(fileext = ".rds")
saveRDS(shots, spec_file)

app_file <- tempfile(fileext = ".R")
writeLines(c(
  "suppressMessages({library(shiny); library(htmltools)})",
  sprintf("pkgload::load_all(%s, quiet = TRUE, helpers = FALSE)", shQuote(PKG)),
  "library(shiny.element)",
  # Vue's development build, so a template error is logged rather than lost
  "options(shiny.element.dev = TRUE)",
  "shots <- readRDS(Sys.getenv('EL_SHOT_SPEC'))",
  "",
  "run_chunk <- function(code) {",
  "  env <- new.env(parent = globalenv())",
  "  # An example ending in shinyApp(ui, server) is taken apart, not launched",
  "  env$shinyApp <- function(ui, server, ...) structure(",
  "    list(ui = ui, server = server), class = 'shot_app')",
  "  ui <- list(); server <- function(input, output, session) NULL",
  "  for (e in parse(text = code)) {",
  "    v <- withVisible(eval(e, env))",
  "    if (inherits(v$value, 'shot_app')) {",
  "      ui <- list(v$value$ui); server <- v$value$server",
  "    } else if (v$visible && inherits(v$value,",
  "               c('shiny.tag', 'shiny.tag.list', 'htmlwidget', 'html'))) {",
  "      ui <- c(ui, list(v$value))",
  "    }",
  "  }",
  "  list(ui = ui, server = server)",
  "}",
  "",
  "built <- lapply(shots, function(s) tryCatch(run_chunk(s$code),",
  "  error = function(e) list(error = conditionMessage(e))))",
  "",
  "ui <- function(req) {",
  "  key <- parseQueryString(req$QUERY_STRING)$shot",
  "  b <- built[[key]]",
  "  if (!is.null(b$error)) return(tags$pre(id = 'shot-error', b$error))",
  "  content <- lapply(b$ui, function(u) if (is.function(u)) u(req) else u)",
  "  el_page(tags$div(id = 'shot',",
  "    style = 'padding:24px; max-width:860px; display:flow-root', content))",
  "}",
  "",
  "server <- function(input, output, session) {",
  "  key <- isolate(parseQueryString(session$clientData$url_search))$shot",
  "  b <- built[[key]]",
  "  if (is.null(b$error)) b$server(input, output, session)",
  "}",
  "shinyApp(ui, server)"
), app_file)

proc <- callr::r_bg(function(app, port, spec) {
  Sys.setenv(EL_SHOT_SPEC = spec)
  shiny::runApp(app, host = "127.0.0.1", port = port, launch.browser = FALSE)
}, args = list(app = app_file, port = PORT, spec = spec_file),
   stdout = "/tmp/article-shots.log", stderr = "2>&1")
on.exit(proc$kill(), add = TRUE)

for (i in 1:120) {
  Sys.sleep(1)
  if (!proc$is_alive()) stop(paste(readLines("/tmp/article-shots.log"), collapse = "\n"))
  if (any(grepl("Listening", readLines("/tmp/article-shots.log", warn = FALSE)))) break
}

# ── capturing ────────────────────────────────────────────────────────────────

chromote::set_chrome_args(c(chromote::default_chrome_args(),
  "--disable-dev-shm-usage", "--no-sandbox", "--disable-gpu",
  "--force-device-scale-factor=1"))
b <- ChromoteSession$new(width = 1000, height = 900)
on.exit(try(b$parent$get_browser()$get_process()$kill(), silent = TRUE), add = TRUE)

# Console messages, per page. Runtime has to be enabled before the page
# loads, or nothing is reported -- which reads exactly like a clean page.
console <- character(0)
invisible(b$Runtime$enable())
b$Runtime$consoleAPICalled(callback = function(msg) {
  text <- paste(vapply(msg$args, function(a) as.character(a$value %||% ""),
                       character(1)), collapse = " ")
  console <<- c(console, text)
})

js <- function(expr) b$Runtime$evaluate(expr)$result$value

wait_for <- function(expr, timeout = 20) {
  for (i in seq_len(timeout * 4)) {
    if (isTRUE(js(expr))) return(TRUE)
    Sys.sleep(0.25)
  }
  FALSE
}

dir.create(OUTDIR, showWarnings = FALSE, recursive = TRUE)
problems <- character(0)

for (s in shots) {
  console <- character(0)
  # Listen before navigating: a fast page can finish loading before a
  # listener attached afterwards starts waiting, and then it waits forever.
  loaded <- b$Page$loadEventFired(wait_ = FALSE)
  b$Page$navigate(sprintf("http://127.0.0.1:%d/?shot=%s", PORT, s$key),
                  wait_ = FALSE)
  b$wait_for(loaded)

  err <- js("(document.getElementById('shot-error') || {}).innerText || ''")
  if (nzchar(err %||% "")) {
    problems <- c(problems, sprintf("%s: the code did not run: %s", s$key, err))
    message(sprintf("  x %-34s the code did not run", s$key))
    next
  }

  ok <- wait_for("!!(window.Shiny && Shiny.shinyapp && Shiny.shinyapp.isConnected())")
  if (!ok) {
    problems <- c(problems, sprintf("%s: Shiny never connected", s$key))
    next
  }
  Sys.sleep(1.5)   # Vue instances mount after the widgets are bound

  # Two components in one example sharing an id leave one of them blank, and
  # nothing logs it -- the gallery's first version did this with three
  # el_avatar("me") calls in one chunk.
  dup <- js("(function(){ var seen = {}, dup = [];
    document.querySelectorAll('[data-shiny-vue]').forEach(function(e){
      if (seen[e.id]) dup.push(e.id); seen[e.id] = true; });
    return dup.join(', '); })()")
  if (nzchar(dup %||% "")) {
    problems <- c(problems, sprintf("%s: duplicate component ids: %s", s$key, dup))
    message(sprintf("  x %-34s duplicate ids: %s", s$key, dup))
    next
  }

  if (!is.null(s$js)) {
    # A selector that matches nothing throws, the interaction never happens,
    # and the picture shows the untouched page -- so a throw is a failure.
    res <- b$Runtime$evaluate(s$js)
    if (!is.null(res$exceptionDetails)) {
      problems <- c(problems, sprintf("%s: shot_js threw: %s", s$key,
        res$exceptionDetails$exception$description %||% res$exceptionDetails$text))
      message(sprintf("  x %-34s shot_js threw", s$key))
      next
    }
    Sys.sleep(s$wait)
  }

  # A server that errors while handling the example's own interaction greys
  # the page out and the screenshot still gets taken -- the first version of
  # the row-click example did exactly that and was reported as clean.
  if (isTRUE(js("!!document.getElementById('shiny-disconnected-overlay')"))) {
    log_tail <- grep("Error|error", readLines("/tmp/article-shots.log", warn = FALSE),
                     value = TRUE)
    problems <- c(problems, sprintf("%s: the server disconnected: %s", s$key,
                                    substr(paste(tail(log_tail, 1), collapse = ""), 1, 160)))
    message(sprintf("  x %-34s the server disconnected", s$key))
    next
  }

  # A raw Element tag outside any Vue instance is never compiled: it stays an
  # unknown <el-button> element and shows as bare text. The raw-tag example
  # in the limitations article did exactly that, under a sentence saying it
  # worked.
  raw <- js("(function(){ var t = {};
    document.querySelectorAll('*').forEach(function(e){
      if (/^EL-/.test(e.tagName)) t[e.tagName.toLowerCase()] = 1; });
    return Object.keys(t).join(', '); })()")
  if (nzchar(raw %||% "")) {
    problems <- c(problems, sprintf("%s: uncompiled Element tags: %s", s$key, raw))
    message(sprintf("  x %-34s uncompiled tags: %s", s$key, raw))
  }

  # An item whose label went nowhere renders as a blank entry, and nothing
  # logs it -- the navigation menu was written with `title =` where the
  # package reads `label =`, and its screenshot showed an icon and an arrow.
  blank <- js("(function(){
    var sel = ['.el-menu-item', '.el-submenu__title', '.el-tabs__item',
               '.el-breadcrumb__inner', '.el-step__title', '.el-radio__label',
               '.el-checkbox__label', '.el-tag', '.el-dropdown-menu__item',
               '.el-collapse-item__header', '.el-select-dropdown__item',
               '.el-descriptions-item__label', '.el-timeline-item__content'];
    var out = [];
    sel.forEach(function(q){
      document.querySelectorAll(q).forEach(function(e){
        if (e.innerText.trim() || e.querySelector('i, img, svg, input')) return;
        if (!e.getBoundingClientRect().width) return;
        // A fixed table column is drawn twice, its copy in the main table
        // kept hidden -- empty to innerText, and not a blank entry
        if (e.checkVisibility && !e.checkVisibility({visibilityProperty: true})) return;
        out.push(q);
      });
    });
    return Array.from(new Set(out)).join(', ');
  })()")
  if (nzchar(blank %||% "")) {
    problems <- c(problems, sprintf("%s: blank items: %s", s$key, blank))
    message(sprintf("  x %-34s blank items: %s", s$key, blank))
  }

  # A modal's mask is position: fixed, so it covers the viewport and no
  # more; a page longer than the viewport came out with its lower part
  # unmasked under an open dialog. Grow the viewport to the page first.
  page_h <- js("Math.max(document.documentElement.scrollHeight, document.body.scrollHeight)")
  tall <- !is.null(page_h) && page_h > 900
  if (tall) {
    b$Emulation$setDeviceMetricsOverride(width = 1000, height = page_h,
                                         deviceScaleFactor = 1, mobile = FALSE)
    Sys.sleep(0.5)
  }

  selectors <- c("#shot", s$sel)
  present <- Filter(function(sel) isTRUE(js(sprintf(
    "!!document.querySelector(%s)", jsonlite::toJSON(sel, auto_unbox = TRUE)))),
    selectors)

  out <- file.path(OUTDIR, paste0(s$key, ".png"))
  # The frame is worked out here, as the union of every element matched,
  # rather than left to chromote: given several selectors it framed only the
  # first, so a message box -- appended to <body>, centred on screen -- was
  # dropped from its own screenshot. Scroll offsets are added because
  # getBoundingClientRect() is relative to the viewport and the clip is not.
  rect <- jsonlite::fromJSON(js(sprintf("(function(sels){
    var l = Infinity, t = Infinity, r = -Infinity, b = -Infinity;
    sels.forEach(function(sel){
      document.querySelectorAll(sel).forEach(function(e){
        var x = e.getBoundingClientRect();
        if (!x.width || !x.height) return;
        l = Math.min(l, x.left); t = Math.min(t, x.top);
        r = Math.max(r, x.right); b = Math.max(b, x.bottom);
      });
    });
    return JSON.stringify({x: l + window.scrollX, y: t + window.scrollY,
                           w: r - l, h: b - t});
  })(%s)", jsonlite::toJSON(present))))
  b$screenshot(out, cliprect = c(rect$x, rect$y, rect$w, rect$h), scale = 2)
  # Back to the session's own size -- clearing the override instead drops
  # to the bare window, shorter than the one the session was opened with
  if (tall) b$Emulation$setDeviceMetricsOverride(width = 1000, height = 900,
                                                  deviceScaleFactor = 1, mobile = FALSE)

  # Vue's warnings, and the package's own -- an update sent to a widget that
  # is not there, a method that does not exist. Both mean the example does
  # not do what it shows.
  warns <- console[grepl("[Vue warn]", console, fixed = TRUE) |
                   grepl("[shiny.element]", console, fixed = TRUE)]
  if (length(warns)) {
    problems <- c(problems, sprintf("%s: %s", s$key, substr(warns[1], 1, 160)))
  }
  message(sprintf("  %s %-34s %s", if (length(warns)) "!" else " ", s$key,
                  if (length(warns)) "Vue warned" else ""))
}

# Screenshots nothing refers to any more
if (!length(wanted)) {
  stale <- setdiff(list.files(OUTDIR, pattern = "[.]png$"),
                   paste0(names(shots), ".png"))
  if (length(stale)) {
    file.remove(file.path(OUTDIR, stale))
    message("removed ", length(stale), " stale screenshot(s)")
  }
}

if (length(problems)) {
  message("\n", length(problems), " problem(s):\n  ", paste(problems, collapse = "\n  "))
  quit(status = 1)
}
message("\nall ", length(shots), " examples ran cleanly")
