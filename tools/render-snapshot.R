# Render every help page's examples and every demo block to text, with
# deterministic ids, and each demo's resolved dependencies -- for comparing a
# refactor's output before and after, byte for byte.
#
#   Rscript tools/render-snapshot.R /tmp/before.txt   # at the parent commit
#   Rscript tools/render-snapshot.R /tmp/after.txt    # with the change
#   cmp /tmp/before.txt /tmp/after.txt
#
# Run from the package root. Help pages without examples still get their
# "=====" heading, so a renamed internal page shows as a heading change only.
args <- commandArgs(TRUE)
out <- args[1]
suppressMessages({
  library(shiny)
  pkgload::load_all(".", quiet = TRUE)
})
n <- 0L
assignInNamespace(
  "UUIDgenerate",
  function(...) {
    n <<- n + 1L
    sprintf("00000000-0000-0000-0000-%012d", n)
  },
  "uuid"
)
dep_line <- function(deps) {
  paste(
    "DEPS:",
    paste(
      vapply(
        deps,
        function(d) {
          files <- c(
            unlist(lapply(d$script, function(s) if (is.list(s)) s$src else s)),
            d$stylesheet
          )
          paste0(d$name, "@", d$version, "[", paste(files, collapse = ","), "]")
        },
        ""
      ),
      collapse = " "
    )
  )
}
rds <- sort(list.files("man", "[.]Rd$", full.names = TRUE))
con <- file(out, "w")
for (rd in rds) {
  n <<- 0L
  txt <- tryCatch(
    utils::capture.output(suppressWarnings(suppressMessages(
      pkgload::run_example(rd, run_donttest = TRUE, quiet = TRUE)
    ))),
    error = function(e) paste("ERROR:", conditionMessage(e))
  )
  writeLines(c(paste("=====", basename(rd)), txt), con)
}
for (f in sort(list.files("tools/demos", "[.]R$", full.names = TRUE))) {
  src <- readLines(f)
  starts <- grep("^## ", src)
  ends <- c(starts[-1] - 1L, length(src))
  for (i in seq_along(starts)) {
    n <<- 0L
    code <- src[starts[i]:ends[i]]
    if (any(grepl("!skip", code[1]))) {
      next
    }
    env <- new.env(parent = globalenv())
    res <- tryCatch(
      {
        v <- withVisible(eval(parse(text = code), env))
        if (
          inherits(v$value, c("shiny.tag", "shiny.tag.list", "el_component"))
        ) {
          r <- htmltools::renderTags(v$value)
          c(as.character(r$html), dep_line(r$dependencies))
        } else {
          "<not ui>"
        }
      },
      error = function(e) paste("ERROR:", conditionMessage(e))
    )
    writeLines(c(paste("=====", basename(f), code[1]), res), con)
  }
}
close(con)
unlink("Rplots.pdf")
cat("done", length(rds), "Rd\n")
