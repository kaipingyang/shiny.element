#' Load All Element-UI Dependencies
#'
#' Convenience function to load Vue, Element-UI, and layout CSS dependencies.
#' Use this when you want to use Element-UI components in non-el_page layouts
#' (e.g., bslib::page_sidebar, shiny::navbarPage).
#'
#' @param theme The page's theme -- an [el_theme()] or any
#'   [bslib::bs_theme()] -- for Element's components to follow: its colours,
#'   and any Element variable given to [el_theme()]'s `element`. It styles
#'   Element only; the page function that owns the page applies it to
#'   Bootstrap. `NULL` leaves Element as it ships.
#' @param layout_css Element's layout CSS, [el_layout_css_dependency()];
#'   `NULL` leaves it out.
#' @param offline Serve Element Plus from the copy bundled with this package
#'   rather than the unpkg CDN. See [element_plus_dependency()].
#' @param dev Load the development build of Vue instead of `vue.min.js`, so
#'   Vue's warnings are not stripped. Defaults to
#'   `getOption("shiny.element.dev", FALSE)`.
#' @param locale Language for Element Plus's built-in text. English by default,
#'   or `getOption("shiny.element.locale")` when set. See
#'   [el_locale_dependency()].
#' @param size,z_index Element Plus's global config, as `app.use()` gives it:
#'   the size of every component not given one of its own
#'   (`"large"`, `"default"` or `"small"`), and the z-index its popups start
#'   from (2000 by default). `NULL` leaves Element's default.
#' @return A list of htmlDependency objects
#' @export
#' @examples
#' \dontrun{
#' library(bslib)
#' theme <- el_theme(primary = "#7c3aed")
#' ui <- page_sidebar(
#'   theme = theme,
#'   use_element(theme = theme),
#'   el_button("btn1", "Click me")
#' )
#' }
use_element <- function(
  theme = NULL,
  offline = TRUE,
  dev = getOption("shiny.element.dev", FALSE),
  locale = getOption("shiny.element.locale", "en"),
  size = NULL,
  z_index = NULL,
  layout_css = el_layout_css_dependency()
) {
  deps <- c(
    list(.el_vue_dependency(dev = dev)),
    element_plus_dependency(offline = offline),
    # the bridge and Element's side of it, which checks for raw el$ tags
    # left outside any component -- a page may hold nothing else
    .el_vue_dependencies(),
    el_locale_dependency(locale),
    .el_config_dependency(size, z_index),
    Filter(
      Negate(is.null),
      list(.el_themed_dependency(.el_element_vars(theme)))
    ),
    list(el_feedback_dependency())
  )

  if (!is.null(layout_css)) {
    deps <- c(deps, list(layout_css))
  }

  htmltools::tagList(deps)
}

#' Element Plus Locale Dependency
#'
#' Element Plus's own build is in English: a pagination control's total, a
#' date picker's buttons, a select's placeholder, a table's empty message.
#' Loading a locale file and handing it to Element Plus, as
#' `app.use(ElementPlus, {locale})` does, switches all of it.
#'
#' All 67 of Element Plus's locales are bundled; `el_locales()` lists them.
#' Codes are matched without regard to case, so Element UI's `"zh-CN"` is
#' Element Plus's `"zh-cn"`.
#'
#' @param locale Language to switch to, such as `"fr"`, `"zh-cn"` or
#'   `"pt-br"`. `NULL` or `"en"` leaves Element Plus's built-in English.
#' @return A list of htmlDependency objects, or `NULL` for the built-in locale.
#' @export
#' @examples
#' el_locales()
#'
#' # English is Element Plus's own
#' el_page(el_select("city", choices = c("Beijing", "Shanghai")))
#'
#' # Anything Element Plus ships
#' el_page(locale = "ja", el_select("city", choices = c("Beijing", "Shanghai")))
#'
#' # Or set it for the whole session
#' options(shiny.element.locale = "zh-cn")
el_locale_dependency <- function(locale = NULL) {
  if (is.null(locale)) {
    return(NULL)
  }
  code <- tolower(locale)
  if (identical(code, "en")) {
    return(NULL)
  }
  root <- system.file("element-plus", package = "shiny.element")
  if (
    !file.exists(file.path(root, "dist", "locale", paste0(code, ".min.js")))
  ) {
    stop(
      "No bundled locale '",
      locale,
      "'. Element Plus ships these: ",
      paste(el_locales(), collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  # The file defines ElementPlusLocale<Code>: "pt-br" is ElementPlusLocalePtBr
  parts <- strsplit(code, "-", fixed = TRUE)[[1]]
  global <- paste0(
    "ElementPlusLocale",
    paste0(toupper(substring(parts, 1, 1)), substring(parts, 2), collapse = "")
  )
  list(
    htmltools::htmlDependency(
      name = paste0("element-plus-locale-", code),
      version = "2.14.7",
      src = root,
      script = paste0("dist/locale/", code, ".min.js"),
      all_files = FALSE
    ),
    # Every component is an app of its own, given the locale as it installs
    # Element Plus; this hands it over. It runs after the locale file.
    htmltools::htmlDependency(
      name = paste0("element-plus-locale-apply-", code),
      version = "2.14.7",
      src = root,
      head = sprintf(
        paste0(
          "<script>window.shinyElementConfig = window.shinyElementConfig || {};",
          "if (window.%1$s) shinyElementConfig.locale = window.%1$s;</script>"
        ),
        global
      )
    )
  )
}

#' Element Plus Dependency
#'
#' Element Plus's script and stylesheets -- its components, its dark mode
#' variables and its display classes (`hidden-xs-only`, ...) -- and its icons,
#' which are components registered on every app by name.
#'
#' @param offline Serve Element Plus from the copy bundled with this package
#'   (the default) instead of the unpkg CDN. The bundled files are
#'   byte-identical to the CDN's. A runtime CDN dependency leaves the page
#'   blank on an intranet, offline, or whenever unpkg is unreachable, so the
#'   local copy is the safer default; pass `FALSE` to trade that for a smaller
#'   deployment bundle.
#' @return A list of htmlDependency objects.
#' @examples
#' element_plus_dependency()
#' element_plus_dependency(offline = FALSE)
#' @export
element_plus_dependency <- function(offline = TRUE) {
  local <- system.file("element-plus", package = "shiny.element")
  list(
    htmltools::htmlDependency(
      name = "element-plus",
      version = "2.14.7",
      src = if (offline) {
        local
      } else {
        c(href = "https://unpkg.com/element-plus@2.14.7/")
      },
      script = "dist/index.full.min.js",
      stylesheet = c(
        "theme-chalk/index.css",
        "theme-chalk/dark/css-vars.css",
        "theme-chalk/display.css"
      ),
      all_files = FALSE,
      head = .el_css_fixes()
    ),
    htmltools::htmlDependency(
      name = "element-plus-icons",
      version = "2.3.2",
      src = if (offline) {
        local
      } else {
        c(href = "https://unpkg.com/@element-plus/icons-vue@2.3.2/dist/")
      },
      script = if (offline) "icons-vue.iife.min.js" else "index.iife.min.js",
      all_files = FALSE
    )
  )
}


#' Corrections to Element's own stylesheet
#'
#' Carried in the dependency's `head`, so they apply whether Element is
#' served from the package or from the CDN. None are needed for Element
#' Plus 2.14.7; the hook stays for the next one.
#'
#' @return A `<style>` element, as text, or `NULL`.
#' @keywords internal
.el_css_fixes <- function() {
  NULL
}

#' Element Plus Layout CSS Dependency
#'
#' Provides default CSS styles for Element-UI layout and grid components,
#' including el-container, el-header, el-main, el-footer, el-aside, el-row, el-col, etc.
#' This dependency is automatically attached by el_page() for consistent layout appearance.
#'
#' @return An htmlDependency object.
#' @examples
#' el_layout_css_dependency()
#' @export
el_layout_css_dependency <- function() {
  htmltools::htmlDependency(
    name = "el-layout-css",
    version = "1.0.0",
    src = c(file = "css"),
    stylesheet = "el-layout.css",
    package = "shiny.element"
  )
}

#' Feedback Handler Dependency
#'
#' Loads the JavaScript handlers for [el_notification()] and [el_message()].
#' Automatically included by [use_element()] and [el_page()].
#'
#' @return An htmlDependency object.
#' @examples
#' el_feedback_dependency()
#' @export
el_feedback_dependency <- function() {
  htmltools::htmlDependency(
    name = "el-feedback-handler",
    version = "1.0.0",
    src = system.file("js", package = "shiny.element"),
    script = "el-feedback-handler.js"
  )
}


#' Collapse Handler Dependency

#' Languages Element Plus can use for its built-in text
#'
#' @return A character vector of locale codes, such as `"en"` and `"zh-TW"`,
#'   any of which can be passed as `locale` to [el_page()].
#' @export
#' @examples
#' el_locales()
el_locales <- function() {
  root <- system.file(
    "element-plus",
    "dist",
    "locale",
    package = "shiny.element"
  )
  sort(sub("[.]min[.]js$", "", list.files(root, pattern = "[.]min[.]js$")))
}


#' Element's global config
#'
#' Element reads `Vue.prototype.$ELEMENT` for the size a component takes when
#' it is given none, and for the z-index its popups start from. Element sets
#' it when it installs itself; this runs after and overrides it.
#'
#' @param size `"large"`, `"default"`, `"small"`, or `NULL`.
#' @param z_index A number, or `NULL`.
#' @return A list holding one htmlDependency, or `NULL` when there is nothing
#'   to set.
#' @keywords internal
.el_config_dependency <- function(size = NULL, z_index = NULL) {
  if (is.null(size) && is.null(z_index)) {
    return(NULL)
  }
  if (!is.null(size)) {
    size <- match.arg(size, c("large", "default", "small"))
  }
  if (!is.null(z_index) && (!is.numeric(z_index) || length(z_index) != 1)) {
    stop("`z_index` must be a single number.", call. = FALSE)
  }
  config <- jsonlite::toJSON(
    Filter(Negate(is.null), list(size = size, zIndex = z_index)),
    auto_unbox = TRUE
  )
  list(htmltools::htmlDependency(
    name = "element-plus-config",
    version = "2.14.7",
    src = system.file("element-plus", package = "shiny.element"),
    head = sprintf(
      paste0(
        "<script>window.shinyElementConfig = Object.assign(",
        "window.shinyElementConfig || {}, %s);</script>"
      ),
      config
    ),
    all_files = FALSE
  ))
}
