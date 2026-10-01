# Examples in these articles: live where they can be, screenshots where not.
#
# An example chunk is marked `shot = TRUE`. When pkgdown builds the site:
#
#   * an example that is UI alone is run, and the components it makes are
#     placed under its code, live -- they open, select and validate as they
#     would in an app, with no server to report to;
#   * an example that needs a server -- a whole app ending in
#     shinyApp(ui, server), or one read from a file -- shows the screenshot
#     tools/article-shots.R took of it running.
#
# Built for CRAN, every example links to the site instead: live components
# would carry Element and Vue into each article, and screenshots megabytes of
# PNG.

shot_article <- function() {
  sub("[.]Rmd$", "", basename(knitr::current_input(dir = FALSE)))
}

in_pkgdown <- function() identical(Sys.getenv("IN_PKGDOWN"), "true")

is_live <- function(options) {
  in_pkgdown() && is.null(options$file) &&
    !any(grepl("shinyApp(", options$code, fixed = TRUE))
}

# Element and Vue themselves, once per article, before the first example
shot_env <- new.env()

live_demo <- function(options) {
  suppressPackageStartupMessages({
    library(shiny)
    library(shiny.element)
  })
  # Several examples on one page reuse ids; prefix each with its chunk's
  old <- options(shiny.element.id_prefix = paste0(options$label, "-"))
  on.exit(options(old), add = TRUE)

  env <- new.env(parent = globalenv())
  ui <- list()
  for (e in parse(text = options$code)) {
    v <- withVisible(eval(e, env))
    if (v$visible && inherits(v$value, c("shiny.tag", "shiny.tag.list", "html"))) {
      ui <- c(ui, list(v$value))
    }
  }

  base <- if (is.null(shot_env$loaded)) {
    shot_env$loaded <- TRUE
    list(use_element())
  }
  rendered <- htmltools::renderTags(
    htmltools::tagList(base, htmltools::tags$div(class = "el-demo", ui)))
  # pkgdown's own page already loads jQuery and Bootstrap
  deps <- Filter(function(d) !d$name %in% c("jquery", "bootstrap"),
                 rendered$dependencies)
  knitr::knit_meta_add(deps)
  paste0("\n\n```{=html}\n", rendered$html, "\n```\n\n")
}

knitr::knit_hooks$set(shot = function(before, options) {
  if (before || !isTRUE(options$shot)) return(NULL)
  if (is_live(options)) return(live_demo(options))
  file <- sprintf("%s-%s.png", shot_article(), options$label)
  if (in_pkgdown()) {
    sprintf("\n\n![](../shots/%s)\n\n", file)
  } else {
    sprintf("\n\n[Screenshot](https://kaipingyang.github.io/shiny.element/shots/%s)\n\n",
            file)
  }
})
