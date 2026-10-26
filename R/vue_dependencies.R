# The scripts a page loads for Vue hosts, and the package's files they
# come from, each made once per R session.

#' Whether to load Vue's development build
#'
#' `options(shiny.vue.dev = TRUE)`, or `shiny.element.dev` as before.
#'
#' @return `TRUE` or `FALSE`.
#' @keywords internal
.vue_dev <- function() {
  isTRUE(getOption("shiny.vue.dev", getOption("shiny.element.dev", FALSE)))
}

#' jQuery, which the bridge's scripts are written against
#'
#' A Shiny page always has it; a page without Shiny -- R Markdown, a saved
#' file -- may not. jquerylib's, under the name Shiny's own uses, so a Shiny
#' page still loads one copy.
#'
#' @return An htmlDependency object.
#' @keywords internal
.vue_jquery_dependency <- function() {
  jquerylib::jquery_core(3)
}

#' Vue core, as bundled with the package
#'
#' Vue 3 itself (vuejs/core), the global build with the template compiler, from `inst/vue3`:
#' components are compiled in the browser from their x-template. The
#' development build keeps Vue's warnings (`[Vue warn]`), which the production
#' build strips. It is versioned one step above the production build, so on a
#' page holding both, htmltools keeps the development one.
#'
#' The development build is in the package's sources but not in what is
#' built from them for CRAN, to keep the package small: installed from
#' CRAN, it is loaded from the unpkg CDN, the same build unminified.
#'
#' @param dev Load `vue.global.js` rather than `vue.global.prod.js`.
#' @return An htmlDependency object.
#' @keywords internal
.vue_core_dependency <- function(dev = .vue_dev()) {
  if (!isTRUE(dev)) {
    return(htmltools::htmlDependency(
      name = "vue",
      version = "3.5.43",
      src = "vue3",
      package = "shiny.element",
      script = "vue.global.prod.js",
      all_files = FALSE
    ))
  }
  local <- .vue_file("vue3", "vue.global.js")
  htmltools::htmlDependency(
    name = "vue",
    version = "3.5.43.1",
    src = if (nzchar(local)) {
      c(file = dirname(local))
    } else {
      c(href = "https://unpkg.com/vue@3.5.43/dist/")
    },
    script = "vue.global.js",
    all_files = FALSE
  )
}

#' The bridge between Vue and Shiny
#'
#' `shiny-vue.js`: it mounts each host's Vue app, registers the `shiny.vue`
#' input binding, serialises values, forwards events and applies updates.
#'
#' @return An htmlDependency object.
#' @keywords internal
.vue_bridge_dependency <- function() {
  htmltools::htmlDependency(
    "shiny-vue",
    "1.0.0",
    src = .vue_file("js"),
    script = "shiny-vue.js",
    all_files = FALSE
  )
}

#' What every Vue host needs
#'
#' jQuery, Vue core and the bridge, in load order: the scripts a page
#' needs for any host on it. Made once per R session and mode.
#'
#' @return A list of htmlDependency objects.
#' @keywords internal
.vue_host_dependencies <- function() {
  .vue_memo(paste("vue_host_dependencies", .vue_dev()), function() {
    list(
      .vue_jquery_dependency(),
      .vue_core_dependency(),
      .vue_bridge_dependency()
    )
  })
}

#' A value made once per R session
#'
#' Every component carries its dependencies, and making them looks up the
#' package's files on disk -- [system.file()], `find.package()` -- each
#' time: some 40% of building a component. They are values that do not
#' change while R runs, so each is made once and kept here.
#'
#' @param key What it is, with whatever it depends on (`dev`, `offline`).
#' @param make A function making it.
#' @return The value.
#' @keywords internal
.vue_memo <- function(key, make) {
  value <- .vue_memo_env[[key]]
  if (is.null(value)) {
    value <- make()
    assign(key, value, envir = .vue_memo_env)
  }
  value
}

.vue_memo_env <- new.env(parent = emptyenv())

#' A path in the installed package, looked up once
#'
#' @param ... Path components, as for [system.file()].
#' @return The path; `""` when there is none.
#' @keywords internal
.vue_file <- function(...) {
  parts <- c(...)
  .vue_memo(
    paste(c("file", parts), collapse = "/"),
    function() {
      do.call(system.file, c(as.list(parts), package = "shiny.element"))
    }
  )
}
