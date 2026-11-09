# What each component's argument does with a v_bind(), measured.
#
#   Rscript tools/args-registry.R          # the arguments that are not props
#
# Gives every argument of every component a v_bind() and sorts the outcome:
# bound (a prop, the default), refused ("R reads it to draw"), or failing
# some other way (an argument the registry should name). Used to write the
# first R/el_args_registry.R; afterwards it is a report to compare the
# registry with -- the tests hold the two together.

suppressMessages(pkgload::load_all(".", quiet = TRUE, helpers = FALSE))
fixtures <- NULL
for (e in parse("tools/api-coverage.R")) {
  if (
    is.call(e) &&
      identical(e[[1]], as.name("<-")) &&
      identical(e[[2]], as.name("fixtures"))
  ) {
    fixtures <- eval(e[[3]])
  }
}
ns <- asNamespace("shiny.element")
fns <- .el_arg_components()
rows <- list()
for (fn in fns) {
  f <- get(fn, envir = ns)
  base <- fixtures[[fn]] %||% list()
  if (length(base) && (is.null(names(base)) || !nzchar(names(base)[1]))) {
    names(base)[1] <- names(formals(f))[1]
  }
  if ("id" %in% names(formals(f)) && is.null(base$id)) {
    base$id <- "x"
  }
  if (inherits(try(do.call(f, base), silent = TRUE), "try-error")) {
    next
  }
  for (a in setdiff(names(formals(f)), c(.el_arg_skip, names(base)))) {
    args <- base
    args[[a]] <- v_bind("$vueStore.s.f")
    outcome <- tryCatch(
      {
        x <- do.call(f, args)
        html <- paste(
          as.character(htmltools::renderTags(htmltools::as.tags(x))$html),
          collapse = ""
        )
        if (
          grepl('"bound"', html, fixed = TRUE) ||
            grepl("data-shiny-vue-bind", html, fixed = TRUE)
        ) {
          "bound"
        } else {
          "DROPPED"
        }
      },
      error = function(e) {
        m <- conditionMessage(e)
        if (grepl("cannot follow v_bind", m)) "refused" else paste("fails:", m)
      }
    )
    rows[[length(rows) + 1]] <- data.frame(fn = fn, arg = a, outcome = outcome)
  }
}
d <- do.call(rbind, rows)
cat(sprintf(
  "%d components, %d arguments: %s\n\n",
  length(unique(d$fn)),
  nrow(d),
  paste(
    names(table(substr(d$outcome, 1, 7))),
    table(substr(d$outcome, 1, 7)),
    collapse = ", "
  )
))
for (fn in unique(d$fn)) {
  x <- d[d$fn == fn & d$outcome != "bound", ]
  if (!nrow(x)) {
    next
  }
  cat(fn, "\n")
  for (i in seq_len(nrow(x))) {
    cat(sprintf("  %-26s %s\n", x$arg[i], substr(x$outcome[i], 1, 100)))
  }
}
