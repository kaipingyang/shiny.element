# The articles as the site serves them: no Shiny on the page.
#
#   Rscript tools/live-pages.R                  # every component page
#   Rscript tools/live-pages.R dialog table     # these
#
# tools/article-shots.R runs each example inside a Shiny app; the site has
# no Shiny, and its examples are live. Each page is rendered as pkgdown
# renders it (IN_PKGDOWN=true: UI examples placed live, apps as pictures),
# served over HTTP -- headless Chrome fails some file:// scripts with
# net::ERR_FAILED, which reads like a missing dependency -- and opened in
# a browser: every host must mount, and the page must log no [Vue warn],
# [shiny-vue] message or exception, on load and after each example's first
# control is clicked (one at a time, a moment apart; a tour takes Element a
# few seconds to open in headless Chrome).
#
# Exits non-zero when a page has a problem.

suppressMessages({
  library(chromote)
})
PKG <- normalizePath(".")
wanted <- commandArgs(TRUE)
src_dir <- file.path(PKG, "vignettes", "articles", "components")
slugs <- if (length(wanted)) {
  wanted
} else {
  sub("[.]Rmd$", "", list.files(src_dir, "[.]Rmd$"))
}
out <- tempfile("live-pages-")
dir.create(out)

# Render each page into `out`, its libraries beside it
render <- callr::r(
  function(pkg, slugs, src_dir, out) {
    Sys.setenv(IN_PKGDOWN = "true")
    suppressMessages(pkgload::load_all(pkg, quiet = TRUE, helpers = FALSE))
    shots <- file.path(pkg, "vignettes", "shots.R")
    done <- character()
    for (slug in slugs) {
      src <- file.path(src_dir, paste0(slug, ".Rmd"))
      if (!file.exists(src)) {
        src <- file.path(pkg, "vignettes", "articles", paste0(slug, ".Rmd"))
      }
      if (!file.exists(src)) {
        next
      }
      txt <- readLines(src, warn = FALSE)
      txt <- gsub(
        'source(file.path("..", "..", "shots.R"))',
        sprintf('source("%s")', shots),
        txt,
        fixed = TRUE
      )
      txt <- gsub(
        'source(file.path("..", "shots.R"))',
        sprintf('source("%s")', shots),
        txt,
        fixed = TRUE
      )
      # the API tables read a file beside the article: not needed here
      txt <- sub('api_tables("', '# api_tables("', txt, fixed = TRUE)
      rmd <- file.path(out, paste0(slug, ".Rmd"))
      writeLines(txt, rmd)
      ok <- tryCatch(
        {
          rmarkdown::render(
            rmd,
            output_format = rmarkdown::html_document(
              self_contained = FALSE,
              lib_dir = "lib"
            ),
            quiet = TRUE,
            envir = new.env()
          )
          TRUE
        },
        error = function(e) conditionMessage(e)
      )
      done[slug] <- if (isTRUE(ok)) "" else ok
    }
    done
  },
  args = list(pkg = PKG, slugs = slugs, src_dir = src_dir, out = out)
)

port <- httpuv::randomPort()
server <- httpuv::startServer(
  "127.0.0.1",
  port,
  list(staticPaths = list("/" = httpuv::staticPath(out)))
)
on.exit(httpuv::stopServer(server), add = TRUE)

capture <- paste0(
  "window.__L = []; window.confirm = function() { return true; };",
  "['error','warn'].forEach(function(k){ var o = console[k]; console[k] = function(){",
  " try { __L.push(Array.prototype.slice.call(arguments).map(String).join(' ').slice(0, 240)); } catch (e) {}",
  " o.apply(console, arguments); }; });",
  "window.addEventListener('error', function(e){ __L.push('exception: ' + e.message); });"
)
problems <- character()
for (slug in names(render)) {
  if (nzchar(render[[slug]])) {
    problems <- c(
      problems,
      sprintf("%s: did not render: %s", slug, render[[slug]])
    )
    next
  }
  b <- ChromoteSession$new(width = 1280, height = 900)
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(source = capture)
  b$Page$navigate(sprintf("http://127.0.0.1:%d/%s.html", port, slug))
  Sys.sleep(5)
  ev <- function(js, timeout = 20) {
    r <- tryCatch(
      b$Runtime$evaluate(js, returnByValue = TRUE, timeout = timeout),
      error = function(e) NULL
    )
    if (is.null(r)) NA else r$result$value
  }
  n <- ev("document.querySelectorAll('.el-demo').length")
  unmounted <- ev(paste0(
    "Array.from(document.querySelectorAll('[data-shiny-vue]')).filter(function(h){",
    " return !h._shinyVue && !h.closest('[data-shiny-vue-islands]'); }).map(function(h){ return h.id; }).join(',')"
  ))
  for (i in seq_len(if (is.na(n)) 0 else n) - 1) {
    ev(sprintf(
      paste0(
        "setTimeout(function(){ var d = document.querySelectorAll('.el-demo')[%d];",
        " var c = d && d.querySelector('button, .el-radio, .el-switch, .el-checkbox, .el-radio-button');",
        " if (c) c.click(); }, 0); 1"
      ),
      i
    ))
    Sys.sleep(0.8)
    # close what opened: Escape, an overlay's cross, a message box's
    ev(paste0(
      "setTimeout(function(){ document.dispatchEvent(new KeyboardEvent('keydown', {key: 'Escape', bubbles: true}));",
      " document.querySelectorAll('.el-overlay .el-dialog__headerbtn, .el-overlay .el-drawer__close-btn, .el-message-box__headerbtn, .el-tour__closebtn')",
      ".forEach(function(x){ if (x.offsetParent) x.click(); }); }, 0); 1"
    ))
    Sys.sleep(0.5)
  }
  Sys.sleep(3)
  logs <- unlist(ev("__L", timeout = 60))
  # "ResizeObserver loop completed with undelivered notifications" is the
  # browser's, harmless: layout changed while observers ran (a carousel, a
  # panel measuring itself)
  bad <- logs[
    grepl("Vue warn|shiny-vue|exception", logs) &
      !grepl("ResizeObserver loop", logs, fixed = TRUE)
  ]
  cat(sprintf(
    "%-20s examples %3s  hosts unmounted: %-6s  warnings: %d\n",
    slug,
    if (is.na(n)) "?" else n,
    if (is.na(unmounted)) {
      "?"
    } else if (nzchar(unmounted)) {
      "yes"
    } else {
      "none"
    },
    length(bad)
  ))
  if (is.na(n)) {
    problems <- c(problems, sprintf("%s: the page did not answer", slug))
  }
  if (!is.na(unmounted) && nzchar(unmounted)) {
    problems <- c(problems, sprintf("%s: not mounted: %s", slug, unmounted))
  }
  for (w in unique(bad)) {
    problems <- c(problems, sprintf("%s: %s", slug, w))
  }
  b$close()
}

if (length(problems)) {
  cat("\n", length(problems), " problem(s):\n", sep = "")
  cat(paste0("  ", problems), sep = "\n")
  quit(status = 1)
}
cat("\nevery page clean\n")
