# vueuse_dependency(): VueUse's files, after Vue, shared before core

test_that("VueUse comes after Vue, its shared part before its core", {
  deps <- vueuse_dependency()
  names <- vapply(deps, `[[`, "", "name")
  expect_equal(names, c("vue", "vueuse-shared", "vueuse-core"))
  for (d in deps[-1]) {
    expect_true(file.exists(system.file(
      d$src$file,
      d$script,
      package = "shiny.element"
    )))
  }
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
