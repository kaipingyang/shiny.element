# vueuse_dependency(): VueUse's files, after Vue, shared before core

test_that("VueUse comes after Vue, its shared part before its core", {
  deps <- vueuse_dependency()
  names <- vapply(deps, `[[`, "", "name")
  expect_equal(names, c("vue", "vueuse-shared", "vueuse-core"))
  # packed in the package, taken out into the session's tempdir()
  for (d in deps[-1]) {
    expect_true(file.exists(file.path(d$src$file, d$script)))
    expect_true(startsWith(
      normalizePath(d$src$file),
      normalizePath(tempdir())
    ))
  }
  expect_setequal(
    utils::untar(
      system.file("vueuse", "vueuse.tar.xz", package = "shiny.element"),
      list = TRUE,
      tar = "internal"
    ),
    c("shared.iife.min.js", "core.iife.min.js")
  )
  # in a component, after the bridge's Vue as well
  ui <- vue_app("a", "<b/>", dependencies = vueuse_dependency())
  found <- vapply(
    htmltools::resolveDependencies(htmltools::findDependencies(ui)),
    `[[`,
    "",
    "name"
  )
  expect_lt(match("vue", found), match("vueuse-shared", found))
  expect_lt(match("vueuse-shared", found), match("vueuse-core", found))
})
