#' Load All Element-UI Dependencies
#'
#' Convenience function to load Vue, Element-UI, and layout CSS dependencies.
#' Use this when you want to use Element-UI components in non-el_page layouts
#' (e.g., bslib::page_sidebar, shiny::navbarPage).
#'
#' @param theme CSS dependency function or list (optional, default is el_layout_css_dependency())
#' @param offline Serve Element UI from the copy bundled with this package
#'   rather than the unpkg CDN. See [element_ui_dependency()].
#' @param dev Load the development build of Vue instead of `vue.min.js`, so
#'   Vue's warnings are not stripped. Defaults to
#'   `getOption("shiny.element.dev", FALSE)`.
#' @param locale Language for Element UI's built-in text. English by default,
#'   or `getOption("shiny.element.locale")` when set. See
#'   [el_locale_dependency()].
#' @return A list of htmlDependency objects
#' @export
#' @examples
#' \dontrun{
#' library(bslib)
#' ui <- page_sidebar(
#'   use_element(),
#'   el_button("btn1", "Click me")
#' )
#' }
use_element <- function(theme = el_layout_css_dependency(), offline = TRUE,
                        dev = getOption("shiny.element.dev", FALSE),
                        locale = getOption("shiny.element.locale", "en")) {
  deps <- c(
    list(
      .el_vue_dependency(dev = dev),
      vue_handler_dependency(),
      element_ui_dependency(offline = offline)
    ),
    el_locale_dependency(locale),
    list(el_feedback_dependency())
  )

  if (!is.null(theme)) {
    deps <- c(deps, list(theme))
  }

  htmltools::tagList(deps)
}

#' Element UI Locale Dependency
#'
#' Element UI's own build defaults to Simplified Chinese for every
#' component's built-in text -- a pagination control's total, a date picker's
#' buttons, a select's placeholder, a table's empty message. Loading a locale
#' file and calling `ELEMENT.locale()` switches all of it.
#'
#' [el_page()] and [use_element()] ask for English unless told otherwise, so
#' a page built from this package's English documentation reads in English.
#' All 59 of Element's locales are bundled; `el_locales()` lists them.
#'
#' @param locale Language to switch to, such as `"en"`, `"fr"` or `"zh-TW"`.
#'   `NULL` or `"zh-CN"` leaves Element's built-in Simplified Chinese.
#' @return A list of htmlDependency objects, or `NULL` for the built-in locale.
#' @export
#' @examples
#' el_locales()
#'
#' # English is the default
#' el_page(el_select("city", choices = c("Beijing", "Shanghai")))
#'
#' # Anything Element ships
#' el_page(locale = "ja", el_select("city", choices = c("Beijing", "Shanghai")))
#'
#' # Or set it for the whole session
#' options(shiny.element.locale = "zh-CN")
el_locale_dependency <- function(locale = NULL) {
  if (is.null(locale) || identical(locale, "zh-CN")) return(NULL)

  root <- system.file("element-ui", package = "shiny.element")
  if (!file.exists(file.path(root, "locale", paste0(locale, ".js")))) {
    stop("No bundled locale '", locale, "'. Element ships these: ",
         paste(el_locales(), collapse = ", "), ".", call. = FALSE)
  }

  list(
    htmltools::htmlDependency(
      name      = paste0("element-ui-locale-", locale),
      version   = "2.15.14",
      src       = root,
      script    = paste0("locale/", locale, ".js"),
      all_files = FALSE
    ),
    # The locale file only registers ELEMENT.lang.<locale>; this applies it.
    # It has to run after both element-ui and the locale file, which is why it
    # is a dependency of its own rather than part of either.
    htmltools::htmlDependency(
      name    = paste0("element-ui-locale-apply-", locale),
      version = "2.15.14",
      src     = root,
      head    = sprintf(
        paste0("<script>if (window.ELEMENT && ELEMENT.locale && ELEMENT.lang && ",
               "ELEMENT.lang['%1$s']) { ELEMENT.locale(ELEMENT.lang['%1$s']); }</script>"),
        locale
      )
    )
  )
}

#' Vue Handler Dependency
#'
#' Registers custom JavaScript handlers for Shiny-to-Vue communication.
#' This dependency loads `vue_handlers.js`, which enables R to update Vue component fields or entire data objects
#' via `update_vue_component` and `update_vue_data` custom messages.
#' It should be included in the UI (typically via `use_element()`) to ensure all Vue update handlers are available.
#'
#' @return An htmlDependency object for vue_handlers.js
#' @export
#' @examples
#' vue_handler_dependency()
#' @export
vue_handler_dependency <- function() {
  htmltools::htmlDependency(
    name = "vue-handlers",
    version = "1.0.0",
    src = system.file("js", package = "shiny.element"),
    script = "vue-handlers.js"
  )
}
#' Element UI Dependency
#'
#' @param offline Serve Element UI from the copy bundled with this package
#'   (the default) instead of the unpkg CDN. The bundled files are
#'   byte-identical to the CDN's. A runtime CDN dependency leaves the page
#'   blank on an intranet, offline, or whenever unpkg is unreachable, so the
#'   local copy is the safer default; pass `FALSE` to trade that for a smaller
#'   deployment bundle.
#' @return An htmlDependency object for Element UI.
#' @examples
#' element_ui_dependency()
#' element_ui_dependency(offline = FALSE)
#' @export
element_ui_dependency <- function(offline = TRUE) {
  src <- if (offline) {
    system.file("element-ui", package = "shiny.element")
  } else {
    c(href = "https://unpkg.com/element-ui@2.15.14/lib/")
  }

  htmltools::htmlDependency(
    name       = "element-ui",
    version    = "2.15.14",
    src        = src,
    script     = "index.js",
    stylesheet = "theme-chalk/index.css",
    # The stylesheet references fonts/element-icons.woff relatively, so the
    # whole directory has to be served, not just the two named files.
    all_files  = TRUE,
    head       = .el_css_fixes()
  )
}


#' Corrections to Element's own stylesheet
#'
#' Carried in the dependency's `head`, so they apply whether Element is
#' served from the package or from the CDN.
#'
#' * 2.15 gave every table cell `.el-table .el-table__cell { padding: 12px
#'   0 }`. It outranks the expanded row's `.el-table__expanded-cell[class*=cell]
#'   { padding: 20px 50px }` -- the same specificity, later in the file -- so
#'   an expanded row's content sat flush against the table's edge.
#'
#' @return A `<style>` element, as text.
#' @keywords internal
.el_css_fixes <- function() {
  paste0(
    "<style>",
    ".el-table .el-table__expanded-cell[class*=cell]{padding:20px 50px}",
    "</style>"
  )
}

#' Element UI Layout CSS Dependency
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
    name    = "el-feedback-handler",
    version = "1.0.0",
    src     = system.file("js", package = "shiny.element"),
    script  = "el-feedback-handler.js"
  )
}

#' Button Handler Dependency
#' @keywords internal
el_button_handler_dependency <- function() {
  .el_handler_dependency("button")
}

#' Cascader Handler Dependency
#' @keywords internal
el_cascader_handler_dependency <- function() {
  .el_handler_dependency("cascader")
}

#' Table Handler Dependency
#' @keywords internal
el_table_handler_dependency <- function() {
  .el_handler_dependency("table")
}

#' Calendar Handler Dependency
#' @keywords internal
el_calendar_handler_dependency <- function() {
  .el_handler_dependency("calendar")
}

#' Steps Handler Dependency
#' @keywords internal
el_steps_handler_dependency <- function() {
  .el_handler_dependency("steps")
}

#' Tag Handler Dependency
#' @keywords internal
el_tag_handler_dependency <- function() {
  .el_handler_dependency("tag")
}

#' Alert Handler Dependency
#' @keywords internal
el_alert_handler_dependency <- function() {
  .el_handler_dependency("alert")
}

#' Collapse Handler Dependency


#' Rate Handler Dependency
#' @keywords internal
el_rate_handler_dependency <- function() {
  .el_handler_dependency("rate")
}

#' Input Number Handler Dependency
#' @keywords internal
el_input_number_handler_dependency <- function() {
  .el_handler_dependency("input-number")
}

#' Color Picker Handler Dependency
#' @keywords internal
el_color_picker_handler_dependency <- function() {
  .el_handler_dependency("color-picker")
}


#' Dropdown Handler Dependency
#' @keywords internal
el_dropdown_handler_dependency <- function() {
  .el_handler_dependency("dropdown")
}

#' Form Handler Dependency
#' @keywords internal
el_form_handler_dependency <- function() {
  .el_handler_dependency("form")
}

#' Menu Handler Dependency
#' @keywords internal
el_menu_handler_dependency <- function() {
  .el_handler_dependency("menu")
}

#' Tree Handler Dependency
#' @keywords internal
el_tree_handler_dependency <- function() {
  .el_handler_dependency("tree")
}

#' Upload Handler Dependency
#' @keywords internal
el_upload_handler_dependency <- function() {
  .el_handler_dependency("upload")
}

#' Carousel Handler Dependency
#' @keywords internal
el_carousel_handler_dependency <- function() {
  .el_handler_dependency("carousel")
}

#' Timeline Handler Dependency
#' @keywords internal
el_timeline_handler_dependency <- function() {
  .el_handler_dependency("timeline")
}


#' Languages Element UI can use for its built-in text
#'
#' @return A character vector of locale codes, such as `"en"` and `"zh-TW"`,
#'   any of which can be passed as `locale` to [el_page()].
#' @export
#' @examples
#' el_locales()
el_locales <- function() {
  root <- system.file("element-ui", "locale", package = "shiny.element")
  sort(sub("[.]js$", "", list.files(root, pattern = "[.]js$")))
}
