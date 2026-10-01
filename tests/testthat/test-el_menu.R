render_html <- function(tag) {
  # .el_menu_nodes() returns a bare list of tags, which as.character() would
  # deparse rather than render.
  if (is.list(tag) && !inherits(tag, c("shiny.tag", "shiny.tag.list"))) {
    tag <- htmltools::tagList(tag)
  }
  paste(as.character(tag), collapse = "")
}

sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- list(type = type, msg = msg)
  )
  expr(session)
  captured
}

demo_items <- list(
  list(index = "home", label = "Home", icon = "el-icon-house"),
  list(index = "products", label = "Products", children = list(
    list(index = "p-all", label = "All"),
    list(index = "p-old", label = "Old", disabled = TRUE)
  )),
  list(index = "grp", label = "Group", group = TRUE, children = list(
    list(index = "g1", label = "In group")
  ))
)

# ── .el_menu_nodes ────────────────────────────────────────────────────────────

test_that(".el_menu_nodes: a leaf becomes an el-menu-item", {
  html <- render_html(.el_menu_nodes(list(list(index = "a", label = "A"))))
  expect_match(html, '<el-menu-item index="a"')
  expect_match(html, "<span>A</span>", fixed = TRUE)
})

test_that(".el_menu_nodes: an item with children becomes a submenu", {
  html <- render_html(.el_menu_nodes(list(demo_items[[2]])))
  expect_match(html, '<el-submenu index="products"')
  # Element takes a submenu's own label from a named slot, not its body.
  expect_match(html, '<template slot="title">', fixed = TRUE)
  expect_match(html, '<el-menu-item index="p-all"')
})

test_that(".el_menu_nodes: group = TRUE becomes a titled group, not a submenu", {
  html <- render_html(.el_menu_nodes(list(demo_items[[3]])))
  expect_match(html, '<el-menu-item-group title="Group"')
  expect_false(grepl("<el-submenu", html, fixed = TRUE))
  # A group is a label, so it carries no index and cannot be selected.
  expect_false(grepl('el-menu-item-group index=', html, fixed = TRUE))
})

test_that(".el_menu_nodes: a group's title falls back to its label", {
  explicit <- render_html(.el_menu_nodes(list(
    list(group = TRUE, label = "L", title = "T", children = list())
  )))
  expect_match(explicit, 'title="T"')

  implicit <- render_html(.el_menu_nodes(list(
    list(group = TRUE, label = "L", children = list())
  )))
  expect_match(implicit, 'title="L"')
})

test_that(".el_menu_nodes: icons and disabled are emitted only when asked", {
  with_icon <- render_html(.el_menu_nodes(list(demo_items[[1]])))
  expect_match(with_icon, '<i class="el-icon-house"')

  plain <- render_html(.el_menu_nodes(list(list(index = "a", label = "A"))))
  expect_false(grepl("<i class=", plain, fixed = TRUE))
  expect_false(grepl("disabled", plain, fixed = TRUE))

  expect_match(render_html(.el_menu_nodes(list(demo_items[[2]]$children[[2]]))),
               "disabled")
})

test_that(".el_menu_nodes: nests to arbitrary depth", {
  # Generated in R rather than with v-for, which can only repeat one level.
  deep <- list(list(index = "1", label = "L1", children = list(
    list(index = "2", label = "L2", children = list(
      list(index = "3", label = "L3", children = list(
        list(index = "4", label = "L4")
      ))
    ))
  )))
  html <- render_html(.el_menu_nodes(deep))
  expect_equal(lengths(regmatches(html, gregexpr("<el-submenu", html, fixed = TRUE)))[[1]], 3L)
  expect_match(html, '<el-menu-item index="4"')
})

test_that(".el_menu_nodes: no items gives no tags", {
  expect_length(.el_menu_nodes(list()), 0)
})

# ── el_menu ───────────────────────────────────────────────────────────────────

test_that("el_menu: returns a tagList with the container id", {
  m <- el_menu(id = "nav", items = demo_items)
  expect_true(inherits(m, "shiny.tag.list"))
  expect_match(render_html(m), 'id="nav_container"')
})

test_that("el_menu: attaches its own handler dependency", {
  deps <- htmltools::findDependencies(el_menu(id = "nav", items = demo_items))
  expect_true("el-menu-handler" %in% vapply(deps, function(d) d$name, character(1)))
})

test_that("el_menu: active and layout options reach the Vue data", {
  html <- render_html(el_menu(id = "nav", items = demo_items, active = "home",
                              mode = "horizontal", collapse = TRUE,
                              unique_opened = TRUE))
  expect_match(html, ':default-active="active"')
  expect_match(html, '"active":"home"')
  expect_match(html, '"mode":"horizontal"')
  expect_match(html, '"collapse":true')
  expect_match(html, '"uniqueOpened":true')
})

test_that("el_menu: colours fall back to Element's defaults when unset", {
  html <- render_html(el_menu(id = "nav", items = demo_items))
  for (f in c("backgroundColor", "textColor", "activeTextColor")) {
    expect_match(html, sprintf('"%s":null', f), fixed = TRUE)
    expect_match(html, .el_optional_bind(f), fixed = TRUE)
  }

  themed <- render_html(el_menu(id = "nav", items = demo_items,
                                background_color = "#545c64"))
  expect_match(themed, '"backgroundColor":"#545c64"')
})

test_that("el_menu: reports the index and its full path", {
  html <- render_html(el_menu(id = "nav", items = demo_items))
  # The path tells a nested item apart from a top-level one of the same index.
  expect_match(html, "nav_path", fixed = TRUE)
  expect_match(html, "indexPath", fixed = TRUE)
  expect_match(html, '"mounted"')
})

test_that("el_menu: an empty menu still renders", {
  html <- render_html(el_menu(id = "nav"))
  expect_match(html, "<el-menu")
  expect_false(grepl("<el-menu-item", html, fixed = TRUE))
})

# ── update_el_menu ────────────────────────────────────────────────────────────

test_that("update_el_menu: sends under the right message type", {
  out <- sent_message(function(s) update_el_menu(s, "nav", active = "home"))
  expect_equal(out$type, "updateElMenu")
  expect_equal(out$msg$id, "nav")
  expect_equal(out$msg$active, "home")
})

test_that("update_el_menu: collapse passes through", {
  out <- sent_message(function(s) update_el_menu(s, "nav", collapse = TRUE))
  expect_true(out$msg$collapse)
})

test_that("update_el_menu: NULL fields are excluded", {
  out <- sent_message(function(s) update_el_menu(s, "nav", active = "a"))
  expect_null(out$msg$collapse)
})

test_that("an item's title is taken as its label, as Element names it", {
  html <- paste(as.character(el_menu("m", items = list(
    list(index = "a", title = "Alpha"),
    list(index = "b", title = "Beta", children = list(list(index = "b1", title = "One")))
  ))), collapse = "")
  for (txt in c("<span>Alpha</span>", "<span>Beta</span>", "<span>One</span>")) {
    expect_match(html, txt, fixed = TRUE)
  }
})

test_that("an item with nothing to show is an error, not a blank entry", {
  expect_error(el_menu("m", items = list(list(index = "a"))), "neither a `label`")
  # An icon alone is enough
  expect_no_error(el_menu("m", items = list(list(index = "a", icon = "el-icon-house"))))
})

test_that("a menu with no active item reports NULL rather than an empty string", {
  # "" would fire observeEvent(input$<id>) on load for every such menu
  p <- vue_payload_of(el_menu("m", items = list(list(index = "a", label = "A"))))
  expect_match(p$mounted, 'Shiny.setInputValue("m", self.active || null)', fixed = TRUE)
})
