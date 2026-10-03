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

# Where the screenshots are, from the page: articles/<x>.html or, for a
# component page, articles/components/<x>.html
shot_dir <- function() {
  input <- knitr::current_input(dir = TRUE)
  if (!is.null(input) && basename(dirname(input)) == "components") {
    "../../shots"
  } else {
    "../shots"
  }
}

# A component page's API section: Element's own tables, read from api.json
# (written by tools/api-coverage.py --write-api), with where each entry is
# in R. Blank where there is none.
`%||%` <- function(a, b) if (is.null(a)) b else a

api_tables <- function(slug) {
  path <- file.path(dirname(knitr::current_input(dir = TRUE)), "api.json")
  api <- jsonlite::fromJSON(path, simplifyVector = FALSE)[[slug]]
  if (is.null(api)) {
    return(invisible())
  }
  cell <- function(x) gsub("\\|", "\\\\|", gsub("\n", " ", x))
  for (sec in api) {
    cat("\n### ", sec$title, "\n\n", sep = "")
    if (sec$kind %in% c("Attributes")) {
      cat(
        "| Element | In R | Description | Type | Accepted | Default |\n",
        "|------|------|----------------|----|------|----|\n",
        sep = ""
      )
      for (r in sec$rows) {
        cat(
          "| `",
          r$name,
          "` | ",
          r$r,
          " | ",
          cell(r$desc),
          " | ",
          cell(r$type),
          " | ",
          cell(r$accepted %||% ""),
          " | ",
          cell(r$default),
          " |\n",
          sep = ""
        )
      }
    } else {
      cat(
        "| Element | In R | Description |\n|------|--------|----------------|\n"
      )
      for (r in sec$rows) {
        cat("| `", r$name, "` | ", r$r, " | ", cell(r$desc), " |\n", sep = "")
      }
    }
  }
  cat("\n")
  invisible()
}

is_live <- function(options) {
  in_pkgdown() &&
    is.null(options$file) &&
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
    if (
      v$visible && inherits(v$value, c("shiny.tag", "shiny.tag.list", "html"))
    ) {
      ui <- c(ui, list(v$value))
    }
  }

  base <- if (is.null(shot_env$loaded)) {
    shot_env$loaded <- TRUE
    list(use_element())
  }
  rendered <- htmltools::renderTags(
    htmltools::tagList(base, htmltools::tags$div(class = "el-demo", ui))
  )
  # pkgdown's own page already loads jQuery and Bootstrap
  deps <- Filter(
    function(d) !d$name %in% c("jquery", "bootstrap"),
    rendered$dependencies
  )
  knitr::knit_meta_add(deps)
  paste0("\n\n```{=html}\n", rendered$html, "\n```\n\n")
}

knitr::knit_hooks$set(shot = function(before, options) {
  if (before || !isTRUE(options$shot)) {
    return(NULL)
  }
  if (is_live(options)) {
    return(live_demo(options))
  }
  file <- sprintf("%s-%s.png", shot_article(), options$label)
  if (in_pkgdown()) {
    # Raw HTML: pandoc turns a lone markdown image into a figure whose <img>
    # has an empty alt, which pkgdown reports
    sprintf(
      "\n\n```{=html}\n<img src=\"%s/%s\" alt=\"The %s example, running\" style=\"max-width: 100%%\">\n```\n\n",
      shot_dir(),
      file,
      options$label
    )
  } else {
    sprintf(
      "\n\n[Screenshot](https://kaipingyang.github.io/shiny.element/shots/%s)\n\n",
      file
    )
  }
})
