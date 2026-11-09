# The arguments registry (R/el_args_registry.R) against what the
# components do: every argument either follows a binding or refuses it
# with the registry's reason, and what an update sets binds unless the
# registry says why not.

fixtures <- function() {
  src <- testthat::test_path("..", "..", "tools", "api-coverage.R")
  skip_if_not(file.exists(src), "tools/ is not in the built package")
  for (e in parse(src)) {
    if (
      is.call(e) &&
        identical(e[[1]], as.name("<-")) &&
        identical(e[[2]], as.name("fixtures"))
    ) {
      return(eval(e[[3]]))
    }
  }
}

test_that("the registry names components and their arguments", {
  ns <- asNamespace("shiny.element")
  comps <- .el_arg_components()
  expect_true(all(names(.el_arg_registry) %in% comps))
  for (fn in names(.el_arg_registry)) {
    k <- .el_arg_registry[[fn]]
    if (is.null(names(k))) {
      expect_match(k, "^markup: ", info = fn)
      next
    }
    expect_true(
      all(names(k) %in% names(formals(get(fn, envir = ns)))),
      info = fn
    )
    expect_true(
      all(grepl(
        "^(markup: .+|data(:records)?|stands:[a-z_,]+|alias:[a-z_]+)$",
        k
      )),
      info = fn
    )
  }
})

test_that("every argument binds, or refuses with the registry's reason", {
  fx <- fixtures()
  ns <- asNamespace("shiny.element")
  wrong <- character()
  for (fn in .el_arg_components()) {
    f <- get(fn, envir = ns)
    base <- fx[[fn]] %||% list()
    if (length(base) && (is.null(names(base)) || !nzchar(names(base)[1]))) {
      names(base)[1] <- names(formals(f))[1]
    }
    if ("id" %in% names(formals(f)) && is.null(base$id)) {
      base$id <- "x"
    }
    if (inherits(try(do.call(f, base), silent = TRUE), "try-error")) {
      next
    }
    kinds <- .el_arg_kinds(fn)
    for (a in setdiff(names(formals(f)), c(.el_arg_skip, names(base)))) {
      k <- .vue_arg_kind(kinds, a)
      args <- base
      args[[a]] <- v_bind("$vueStore.s.f")
      got <- tryCatch(
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
            "dropped"
          }
        },
        error = function(e) conditionMessage(e)
      )
      ok <- if (k$kind == "markup") {
        grepl(
          paste0(
            "of ",
            fn,
            "() cannot follow v_bind() or v_model(): ",
            k$detail
          ),
          got,
          fixed = TRUE
        )
      } else {
        identical(got, "bound") || k$kind == "alias"
      }
      if (!ok) wrong <- c(wrong, sprintf("%s(%s) [%s]: %s", fn, a, k$kind, got))
    }
  }
  expect_equal(wrong, character())
})

test_that("what an update sets binds, or the registry says why not", {
  ns <- asNamespace("shiny.element")
  # set by an update through a hook or by redrawing in R -- decided, each
  # with its reason in the registry
  decided <- c(
    "el_button(circle)",
    "el_calendar(range)",
    "el_calendar(editable)",
    "el_calendar(event_labels)",
    "el_calendar(calendars)",
    "el_calendar(visible_event_count)",
    "el_calendar(use_detail_popup)",
    "el_calendar(first_day_of_week)",
    "el_calendar(workweek)",
    "el_carousel(initial_index)",
    "el_link(underline)",
    "el_select(multiple)",
    "el_slider(vertical)",
    "el_table(loading)",
    "el_table(loading_options)",
    "el_tree(props)"
  )
  undecided <- character()
  for (fn in .el_arg_components()) {
    u <- paste0("update_", fn)
    if (!exists(u, envir = ns)) {
      next
    }
    for (a in setdiff(names(formals(get(u, envir = ns))), c("session", "id"))) {
      k <- .vue_arg_kind(.el_arg_kinds(fn), a)$kind
      # the form item's label and message: updated through hooks
      if (k == "markup" && !a %in% c("label", "error")) {
        undecided <- c(undecided, sprintf("%s(%s)", fn, a))
      }
    }
  }
  expect_setequal(undecided, decided)
})

test_that("a help page says which arguments bind", {
  md <- .el_args_md("el_select")
  expect_match(md, "^Every argument can follow")
  expect_match(
    md,
    "`multiple` (one value or an array picks the template)",
    fixed = TRUE
  )
  expect_match(md, "`choices` takes Element's records", fixed = TRUE)
  expect_match(.el_args_md("el_rule"), "^No argument follows")
})
