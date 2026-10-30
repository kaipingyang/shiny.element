# v_bind(), v_model(), v_on(): Vue's directives for a component's arguments,
# following the page's state in the browser with no round trip.

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

render_vue_html <- function(tag) {
  paste(as.character(htmltools::renderTags(tag)$html), collapse = "")
}

test_that("v_bind() takes an expression, v_model() a path", {
  expect_s3_class(v_bind("$inputs.fold === 'collapse'"), "v_bind")
  expect_s3_class(v_bind("$route.params.id"), "vue_binding")
  # an R value is a literal
  expect_equal(unclass(v_bind(1:2))[1], "[1,2]")
  expect_equal(unclass(v_bind(data.frame(a = 1:2)))[1], '[{"a":1},{"a":2}]')
  for (p in c(
    "$vueStore.ui.open",
    "$vueStore.ui.items[0].done",
    "$vueStore['mod-ui'].open",
    "text"
  )) {
    expect_s3_class(v_model(p), "v_model")
  }
  # v_model() assigns: a path, nothing else
  for (p in list(
    "$vueStore.ui.open; alert(1)",
    "$vueStore.ui[open]",
    "a + b",
    c("$vueStore.a.b", "$vueStore.c.d"),
    NA_character_,
    1
  )) {
    expect_error(v_model(p), "something a value can be assigned to")
  }
  # on a component's argument, a store's field
  for (p in c("$vueStore.ui", "$inputs.size", "text")) {
    expect_error(
      el_switch("sw", value = v_model(p)),
      "writes back to a store's field"
    )
  }
  for (e in list("", NA_character_, c("a", "b"))) {
    expect_error(v_bind(e), "one JavaScript expression")
  }
  for (e in list("", NA_character_, 1)) {
    expect_error(v_on(e), "handlers by event")
  }
  expect_output(
    print(v_model("$vueStore.ui.open")),
    "<v_model> \\$vueStore.ui.open"
  )
})

test_that("a bound field travels as `bound`, its data a placeholder", {
  s <- spec_of(vue_app(
    "a",
    htmltools::tags$span("{{ size }} {{ open }}"),
    data = list(
      size = v_bind("$inputs.size"),
      open = v_model("$vueStore.ui.open"),
      n = 1
    )
  ))[[1]]
  expect_equal(s$bound$size, list(expr = "$inputs.size"))
  expect_equal(s$bound$open, list(expr = "$vueStore.ui.open", model = TRUE))
  expect_null(s$options$data$size)
  expect_equal(s$options$data$n, 1)
  # no binding, no `bound`
  s <- spec_of(vue_app("b", htmltools::tags$span(), data = list(n = 1)))[[1]]
  expect_null(s$bound)
})

test_that("a module's bindings carry its namespace, the expression untouched", {
  ns <- shiny::NS("m1")
  b <- v_bind("$inputs.size === 'large'", ns = ns)
  expect_equal(unclass(b)[1], "$inputs.size === 'large'")
  expect_equal(attr(b, "scope"), list(inputs = "m1-", store = "m1-"))
  # its id works as well as its NS()
  expect_equal(
    attr(v_model("$vueStore.ui.open", ns = "m1"), "scope"),
    attr(b, "scope")
  )
  expect_error(v_bind("x", ns = 1), "NS\\(\\) function or its id")
  # the articles' prefix: components' ids, so $inputs alone
  withr::local_options(shiny.vue.id_prefix = "ex-")
  expect_equal(attr(v_bind("$inputs.size"), "scope"), list(inputs = "ex-"))
  expect_equal(
    attr(v_bind("$inputs.size", ns = ns), "scope"),
    list(inputs = "ex-m1-", store = "m1-")
  )
  s <- spec_of(vue_app(
    "c",
    htmltools::tags$span(),
    data = list(x = v_bind("$inputs.size", ns = ns))
  ))[[1]]
  expect_equal(s$bound$x$scope, list(inputs = "ex-m1-", store = "m1-"))
})

test_that("v_on() in a module is run by the bridge; elsewhere it is inline", {
  html <- render_vue_html(el_button(
    "b",
    "Add",
    on = list(click = v_on("$vueStore.ui.n++", ns = shiny::NS("m1")))
  ))
  expect_match(html, "shinyVue.run(this", fixed = TRUE)
  expect_match(html, "$vueStore.ui.n++", fixed = TRUE)
  expect_match(html, "m1-", fixed = TRUE)
  html <- render_vue_html(el_button("b", "Add", on = list(click = v_on("n++"))))
  expect_match(html, "const $event = a[0]; n++;", fixed = TRUE)
})

test_that("a component's value may be bound either way", {
  # v_bind(): controlled; v_model(): shared
  s <- spec_of(el_switch("sw", value = v_bind("$inputs.other")))[[1]]
  expect_equal(s$bound$value, list(expr = "$inputs.other"))
  s <- spec_of(el_switch("sw", value = v_model("$vueStore.ui.on")))[[1]]
  expect_equal(s$bound$value$model, TRUE)
  # an optional prop
  s <- spec_of(el_space(
    id = "sp",
    size = v_bind("$inputs.size"),
    el_card("A")
  ))[[1]]
  expect_true("$inputs.size" %in% unlist(s$bound))
})

test_that("a whole field is bound, not a part of one", {
  expect_error(
    vue_app(
      "d",
      htmltools::tags$span(),
      data = list(x = list(a = v_bind("$vueStore.ui.a")))
    ),
    "bind a whole field"
  )
})

test_that("arguments R draws with say so rather than drop the binding", {
  expect_error(
    el_switch("sw", label = v_bind("$vueStore.ui.label")),
    "'label' cannot follow v_bind\\(\\) or v_model"
  )
  expect_error(
    el_card("x", class = v_bind("$vueStore.ui.cls")),
    "'class' cannot follow"
  )
  expect_error(
    el_select("s", choices = "a", multiple = v_bind("$vueStore.ui.m")),
    "'multiple' cannot follow"
  )
})

test_that("a list or a flag argument keeps its binding", {
  s <- spec_of(el_checkbox_group(
    "cg",
    choices = c("a", "b"),
    selected = v_model("$vueStore.ui.picked")
  ))[[1]]
  expect_equal(s$bound$value$expr, "$vueStore.ui.picked")
  s <- spec_of(el_slider("sl", value = v_model("$vueStore.ui.n")))[[1]]
  expect_equal(s$bound$value$expr, "$vueStore.ui.n")
  s <- spec_of(el_slider(
    "sl",
    value = v_model("$vueStore.ui.r"),
    range = TRUE
  ))[[1]]
  expect_equal(s$bound$value$expr, "$vueStore.ui.r")
  s <- spec_of(el_color_picker(
    "cp",
    predefine = v_bind("$vueStore.ui.colors")
  ))[[1]]
  expect_true("$vueStore.ui.colors" %in% unlist(s$bound))
})

test_that("a badge or a link given a binding gets an instance of its own", {
  s <- spec_of(el_badge(
    el_button("b", "Mail"),
    value = v_bind("$vueStore.ui.n")
  ))
  expect_true("$vueStore.ui.n" %in% unlist(lapply(s, `[[`, "bound")))
  s <- spec_of(el_link("Go", href = v_bind("$vueStore.ui.href")))
  expect_true("$vueStore.ui.href" %in% unlist(lapply(s, `[[`, "bound")))
})

test_that("containers follow state through data-shiny-vue-bind", {
  bound <- function(x) {
    html <- paste(as.character(x), collapse = "")
    m <- regmatches(html, regexpr('data-shiny-vue-bind="[^"]*"', html))
    if (!length(m)) {
      return(NULL)
    }
    json <- gsub("&quot;", '"', sub('^data-shiny-vue-bind="(.*)"$', "\\1", m))
    jsonlite::fromJSON(json, simplifyVector = FALSE)
  }
  d <- el_dialog("dlg", visible = v_model("$vueStore.ui.open"))
  expect_equal(
    bound(d),
    list(visible = list(expr = "$vueStore.ui.open", model = TRUE))
  )
  # drawn closed, the browser opens it
  expect_match(paste(as.character(d), collapse = ""), 'data-visible="false"')
  expect_equal(
    bound(el_drawer(
      "dr",
      visible = v_model("$vueStore.ui.drawer"),
      direction = v_bind("$inputs.edge")
    )),
    list(
      visible = list(expr = "$vueStore.ui.drawer", model = TRUE),
      direction = list(expr = "$inputs.edge")
    )
  )
  tabs <- list(list(name = "a", label = "A"), list(name = "b", label = "B"))
  expect_equal(
    names(bound(el_tabs(
      "t",
      tabs = tabs,
      value = v_model("$vueStore.ui.tab"),
      tab_position = v_bind("$inputs.pos")
    ))),
    c("selected", "tabPosition")
  )
  expect_equal(
    names(bound(el_collapse(
      "c",
      items = list(list(name = "p", title = "P", content = "x")),
      value = v_model("$vueStore.ui.open_panels"),
      expand_icon_position = v_bind("$inputs.side")
    ))),
    c("value", "expandIconPosition")
  )
  # what no update can set is drawn in R
  expect_error(
    el_dialog("dlg", footer = v_bind("$vueStore.ui.f")),
    "'footer' cannot follow"
  )
  expect_null(bound(el_dialog("dlg")))
})

# Every argument of every component, given v_bind() or v_model(): bound (a field the
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
        args[[a]] <- v_model("$vueStore.s.f")
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

test_that("directives in a template are the attributes they stand for", {
  html <- render_vue_html(.vue_directives(htmltools::tags$div(
    htmltools::tags$li(
      v_for("item in items", key = "item.id"),
      "{{ item.name }}"
    ),
    htmltools::tags$p(v_if("ok"), "yes"),
    htmltools::tags$p(v_else_if("maybe"), "perhaps"),
    htmltools::tags$p(v_else(), "no"),
    htmltools::tags$p(v_show("seen"), v_once(), v_html("raw")),
    htmltools::tags$span(v_text("msg"), v_pre(), v_memo("[a]")),
    htmltools::tags$template(v_slot("footer", scope = "{ row }")),
    htmltools::tags$input(v_directive(
      "focus",
      arg = "x",
      modifiers = "lazy",
      value = "on"
    )),
    el$space(size = v_bind("size")),
    el$input(v_model("text", modifiers = "trim")),
    el$dialog(title = v_model("t")),
    htmltools::tags$button(v_on(click = "n++", "keyup.enter" = "go()"), "+"),
    htmltools::tags$div(v_bind("attrs"))
  )))
  for (bit in c(
    '<li v-for="item in items" :key="item.id">',
    '<p v-if="ok">yes</p>',
    '<p v-else-if="maybe">',
    '<p v-else>no</p>',
    'v-show="seen" v-once v-html="raw"',
    'v-text="msg" v-pre v-memo="[a]"',
    '<template v-slot:footer="{ row }">',
    'v-focus:x.lazy="on"',
    '<el-space :size="size">',
    '<el-input v-model.trim="text">',
    '<el-dialog v-model:title="t">',
    '@click="n++" @keyup.enter="go()"',
    '<div v-bind="attrs">'
  )) {
    expect_match(html, bit, fixed = TRUE)
  }
  # what is not a directive is left as it is
  html <- render_vue_html(.vue_directives(htmltools::tags$p(
    `v-if` = "ok",
    class = "c",
    "x"
  )))
  expect_equal(html, '<p v-if="ok" class="c">x</p>')
})

test_that("a template's directives reach vue_app(), vue_component() and slots", {
  html <- render_vue_html(vue_app(
    "d1",
    htmltools::tags$p(v_if("ok"), "{{ n }}"),
    data = list(ok = TRUE, n = 1)
  ))
  expect_match(html, 'v-if="ok"', fixed = TRUE)
  comp <- vue_component(htmltools::tags$li(
    v_for("x in xs", key = "x"),
    "{{ x }}"
  ))
  expect_match(comp$template, 'v-for="x in xs" :key="x"', fixed = TRUE)
  html <- render_vue_html(el_tooltip(
    "tip",
    el$button(v_on(click = "n++"), "Hover"),
    content = "Help"
  ))
  expect_match(html, "@click", fixed = TRUE)
})

test_that("a directive outside a template, or a module's names inside one, says so", {
  expect_error(
    render_vue_html(htmltools::tags$div(v_if("ok"))),
    "belongs in a Vue template"
  )
  expect_error(
    vue_app(
      "d2",
      htmltools::tags$p(title = v_bind("$vueStore.ui.t", ns = shiny::NS("m"))),
      data = list()
    ),
    "`ns` is for a component's argument"
  )
  expect_error(
    vue_app("d3", htmltools::tags$p(v_on("n++")), data = list()),
    "give v_on\\(\\) its event"
  )
  expect_error(
    v_on(click = "x", ns = shiny::NS("m")),
    "`ns` is for a statement"
  )
  expect_error(v_directive("bad name"), "names, as Vue writes them")
  expect_output(print(v_for("x in xs", key = "x")), 'v-for="x in xs" :key="x"')
})

test_that("vtags are Vue's built-in components", {
  expect_setequal(
    names(vtags),
    c(
      "transition",
      "transition_group",
      "keep_alive",
      "teleport",
      "suspense",
      "component",
      "slot",
      "router_view",
      "router_link"
    )
  )
  expect_equal(
    render_vue_html(.vue_directives(vtags$keep_alive(vtags$component(
      is = v_bind("view")
    )))),
    '<keep-alive>\n  <component :is="view"></component>\n</keep-alive>'
  )
})
