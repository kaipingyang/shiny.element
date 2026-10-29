# vue_bind(): an argument following state in the browser -- a store's field,
# another component's value, the route -- with no round trip.

spec_of <- function(tag) {
  html <- paste(
    as.character(htmltools::renderTags(htmltools::as.tags(tag))$html),
    collapse = ""
  )
  m <- regmatches(
    html,
    gregexpr('application/json"[^>]*>.*?</script>', html, perl = TRUE)
  )[[1]]
  lapply(m, function(x) {
    jsonlite::fromJSON(
      sub("</script>$", "", sub('^application/json"[^>]*>', "", x)),
      simplifyVector = FALSE
    )
  })
}

test_that("vue_bind() takes a path under $store, $inputs or $route", {
  for (p in c(
    "$store.ui.open",
    "$store.ui.items[0].done",
    "$inputs.size",
    "$inputs['mod-size']",
    "$inputs[\"mod-size\"]",
    "$route.params.id"
  )) {
    expect_s3_class(vue_bind(p), "vue_bind")
  }
  for (p in list(
    "$store",
    "store.ui",
    "$window.x",
    "$store.ui.open; alert(1)",
    "$store.ui[open]",
    c("$store.a", "$store.b"),
    NA_character_,
    1
  )) {
    expect_error(vue_bind(p), "must start with \\$store")
  }
  expect_output(
    print(vue_bind("$store.ui.open")),
    "<vue_bind> \\$store.ui.open"
  )
})

test_that("a bound field travels as `bound`, its data a placeholder", {
  s <- spec_of(vue_app(
    "a",
    htmltools::tags$span("{{ size }}"),
    data = list(size = vue_bind("$inputs.size"), n = 1)
  ))[[1]]
  expect_equal(s$bound, list(size = "$inputs.size"))
  expect_null(s$options$data$size)
  expect_equal(s$options$data$n, 1)
  # no binding, no `bound`
  s <- spec_of(vue_app("b", htmltools::tags$span(), data = list(n = 1)))[[1]]
  expect_null(s$bound)
})

test_that("a component's value is bound to a store alone", {
  expect_error(
    el_switch("sw", value = vue_bind("$inputs.other")),
    "value can be bound to a store alone"
  )
  s <- spec_of(el_switch("sw", value = vue_bind("$store.ui.on")))[[1]]
  expect_equal(unlist(s$bound), c(value = "$store.ui.on"))
  # an optional prop follows anything
  s <- spec_of(el_space(
    id = "sp",
    size = vue_bind("$inputs.size"),
    el_card("A")
  ))[[1]]
  expect_true("$inputs.size" %in% unlist(s$bound))
  # a vue_app()'s value too
  expect_error(
    vue_app(
      "c",
      htmltools::tags$span(),
      data = list(v = vue_bind("$route.path")),
      input = "v"
    ),
    "store alone"
  )
})

test_that("a whole field is bound, not a part of one", {
  expect_error(
    vue_app(
      "d",
      htmltools::tags$span(),
      data = list(x = list(a = vue_bind("$store.ui.a")))
    ),
    "binds a whole field"
  )
})

test_that("arguments R draws with say so rather than drop the binding", {
  expect_error(
    el_switch("sw", label = vue_bind("$store.ui.label")),
    "'label' cannot follow vue_bind"
  )
  expect_error(
    el_card("x", class = vue_bind("$store.ui.cls")),
    "'class' cannot follow vue_bind"
  )
  expect_error(
    el_select("s", choices = "a", multiple = vue_bind("$store.ui.m")),
    "'multiple' cannot follow vue_bind"
  )
})

test_that("a list or a flag argument keeps its binding", {
  s <- spec_of(el_checkbox_group(
    "cg",
    choices = c("a", "b"),
    selected = vue_bind("$store.ui.picked")
  ))[[1]]
  expect_equal(unlist(s$bound), c(value = "$store.ui.picked"))
  s <- spec_of(el_slider("sl", value = vue_bind("$store.ui.n")))[[1]]
  expect_equal(unlist(s$bound), c(value = "$store.ui.n"))
  s <- spec_of(el_slider(
    "sl",
    value = vue_bind("$store.ui.r"),
    range = TRUE
  ))[[1]]
  expect_equal(unlist(s$bound), c(value = "$store.ui.r"))
  # a prop Element takes only as an array
  s <- spec_of(el_color_picker(
    "cp",
    predefine = vue_bind("$store.ui.colors")
  ))[[1]]
  expect_true("$store.ui.colors" %in% unlist(s$bound))
})

test_that("a badge or a link given a binding gets an instance of its own", {
  s <- spec_of(el_badge(
    el_button("b", "Mail"),
    value = vue_bind("$store.ui.n")
  ))
  expect_true("$store.ui.n" %in% unlist(lapply(s, `[[`, "bound")))
  s <- spec_of(el_link("Go", href = vue_bind("$store.ui.href")))
  expect_true("$store.ui.href" %in% unlist(lapply(s, `[[`, "bound")))
})

test_that("containers follow state through data-shiny-vue-bind", {
  bound <- function(x) {
    html <- paste(as.character(x), collapse = "")
    m <- regmatches(html, regexpr('data-shiny-vue-bind="[^"]*"', html))
    if (!length(m)) {
      return(NULL)
    }
    json <- gsub("&quot;", '"', sub('^data-shiny-vue-bind="(.*)"$', "\\1", m))
    jsonlite::fromJSON(json)
  }
  d <- el_dialog("dlg", visible = vue_bind("$store.ui.open"))
  expect_equal(bound(d), list(visible = "$store.ui.open"))
  # drawn closed, the browser opens it
  expect_match(paste(as.character(d), collapse = ""), 'data-visible="false"')
  expect_equal(
    bound(el_drawer(
      "dr",
      visible = vue_bind("$store.ui.drawer"),
      direction = vue_bind("$inputs.edge")
    )),
    list(visible = "$store.ui.drawer", direction = "$inputs.edge")
  )
  tabs <- list(list(name = "a", label = "A"), list(name = "b", label = "B"))
  expect_equal(
    bound(el_tabs(
      "t",
      tabs = tabs,
      value = vue_bind("$store.ui.tab"),
      tab_position = vue_bind("$inputs.pos")
    )),
    list(selected = "$store.ui.tab", tabPosition = "$inputs.pos")
  )
  expect_equal(
    bound(el_collapse(
      "c",
      items = list(list(name = "p", title = "P", content = "x")),
      value = vue_bind("$store.ui.open_panels"),
      expand_icon_position = vue_bind("$inputs.side")
    )),
    list(value = "$store.ui.open_panels", expandIconPosition = "$inputs.side")
  )
  expect_error(
    el_dialog("dlg", visible = vue_bind("$inputs.x")),
    "`visible` can be bound to a store alone"
  )
  # what no update can set is drawn in R
  expect_error(
    el_dialog("dlg", footer = vue_bind("$store.ui.f")),
    "'footer' cannot follow vue_bind"
  )
  expect_null(bound(el_dialog("dlg")))
})

# Every argument of every component, given vue_bind(): bound (a field the
# bridge follows, or a container's attribute), or an error -- never dropped,
# which would draw the path as text or ignore it with nothing said. The
# components' minimal calls are tools/api-coverage.R's fixtures.
test_that("no argument of any component drops a binding", {
  src <- testthat::test_path("..", "..", "tools", "api-coverage.R")
  skip_if_not(file.exists(src), "tools/ is not in the built package")
  fixtures <- NULL
  for (e in parse(src)) {
    if (
      is.call(e) &&
        identical(e[[1]], as.name("<-")) &&
        identical(e[[2]], as.name("fixtures"))
    ) {
      fixtures <- eval(e[[3]])
    }
  }
  expect_true(is.list(fixtures))
  ns <- asNamespace("shiny.element")
  fns <- sort(grep("^el_", getNamespaceExports("shiny.element"), value = TRUE))
  not_components <- c(
    "el_widget",
    "el_page",
    "el_theme",
    "el_events",
    "el_locales",
    "el_locale_dependency",
    "el_layout_css_dependency",
    "el_feedback_dependency",
    "el_table_output",
    "el_calendar_output",
    "el_table_data",
    "el_calendar_events",
    "el_table_row",
    "el_upload_file",
    "el_load_children",
    "el_upload_clear"
  )
  fns <- setdiff(
    fns,
    c(
      not_components,
      grep(
        "^el_(message|notification|loading|form_(validate|reset|clear_validate))",
        fns,
        value = TRUE
      )
    )
  )
  skip_args <- c("id", "...", "session", "events", "on", "slots")
  dropped <- character()
  for (fn in fns) {
    f <- get(fn, envir = ns)
    base <- fixtures[[fn]] %||% list()
    if (length(base) && (is.null(names(base)) || !nzchar(names(base)[1]))) {
      names(base)[1] <- names(formals(f))[1]
    }
    # with an id and without: some draw plain markup without one
    for (with_id in c(TRUE, FALSE)) {
      b <- base
      if (with_id && "id" %in% names(formals(f)) && is.null(b$id)) {
        b$id <- "x"
      }
      if (inherits(try(do.call(f, b), silent = TRUE), "try-error")) {
        next
      }
      for (a in setdiff(names(formals(f)), c(skip_args, names(b)))) {
        args <- b
        args[[a]] <- vue_bind("$store.s.f")
        out <- tryCatch(
          {
            x <- do.call(f, args)
            html <- paste(
              as.character(htmltools::renderTags(htmltools::as.tags(x))$html),
              collapse = ""
            )
            grepl('"bound"', html, fixed = TRUE) ||
              grepl("data-shiny-vue-bind", html, fixed = TRUE)
          },
          error = function(e) TRUE
        )
        if (!out) dropped <- c(dropped, paste0(fn, "(", a, ")"))
      }
    }
  }
  expect_equal(unique(dropped), character())
})

test_that("an input's id is prefixed as the articles prefix components'", {
  withr::local_options(shiny.vue.id_prefix = "ex-")
  expect_equal(unclass(vue_bind("$inputs.size")), "$inputs['ex-size']")
  expect_equal(unclass(vue_bind("$inputs['a-b'].x")), "$inputs['ex-a-b'].x")
  # a store is the page's, by its own name
  expect_equal(unclass(vue_bind("$store.ui.open")), "$store.ui.open")
})
