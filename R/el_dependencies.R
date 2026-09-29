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
#' @param locale Language for Element UI's built-in text. See
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
                        locale = NULL) {
  deps <- c(
    list(
      vueR::html_dependency_vue(minified = !dev),
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
#' Element UI's bundled build ships Simplified Chinese, and that is what every
#' component's built-in text uses — a pagination control reads "共 200 条" and
#' a date picker's buttons are "清空" and "确定". Loading a locale file and
#' calling `ELEMENT.locale()` switches all of it.
#'
#' @param locale Language to switch to. `NULL` (the default) keeps Element
#'   UI's built-in Simplified Chinese. `"en"` is bundled with this package.
#'   Any other value loads `locale/<locale>.js` from the package, which you
#'   would have to add yourself.
#' @return A list of htmlDependency objects, or `NULL` for the built-in locale.
#' @export
#' @examples
#' # English built-in text
#' el_page(locale = "en")
el_locale_dependency <- function(locale = NULL) {
  if (is.null(locale) || identical(locale, "zh-CN")) return(NULL)

  root <- system.file("element-ui", package = "shiny.element")
  if (!file.exists(file.path(root, "locale", paste0(locale, ".js")))) {
    stop("No bundled locale '", locale, "'. Only 'en' ships with the package; ",
         "add locale/", locale, ".js from element-ui to use another.",
         call. = FALSE)
  }

  list(
    htmltools::htmlDependency(
      name      = paste0("element-ui-locale-", locale),
      version   = "2.13.2",
      src       = root,
      script    = paste0("locale/", locale, ".js"),
      all_files = FALSE
    ),
    # The locale file only registers ELEMENT.lang.<locale>; this applies it.
    # It has to run after both element-ui and the locale file, which is why it
    # is a dependency of its own rather than part of either.
    htmltools::htmlDependency(
      name    = paste0("element-ui-locale-apply-", locale),
      version = "2.13.2",
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
#' @export
element_ui_dependency <- function(offline = TRUE) {
  src <- if (offline) {
    system.file("element-ui", package = "shiny.element")
  } else {
    c(href = "https://unpkg.com/element-ui@2.13.2/lib/")
  }

  htmltools::htmlDependency(
    name       = "element-ui",
    version    = "2.13.2",
    src        = src,
    script     = "index.js",
    stylesheet = "theme-chalk/index.css",
    # The stylesheet references fonts/element-icons.woff relatively, so the
    # whole directory has to be served, not just the two named files.
    all_files  = TRUE
  )
}

#' Element UI Layout CSS Dependency
#'
#' Provides default CSS styles for Element-UI layout and grid components,
#' including el-container, el-header, el-main, el-footer, el-aside, el-row, el-col, etc.
#' This dependency is automatically attached by el_page() for consistent layout appearance.
#'
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
#' @export
el_button_handler_dependency <- function() {
  .el_handler_dependency("button")
}

#' Cascader Handler Dependency
#' @export
el_cascader_handler_dependency <- function() {
  .el_handler_dependency("cascader")
}

#' Table Handler Dependency
#' @export
el_table_handler_dependency <- function() {
  .el_handler_dependency("table")
}

#' Calendar Handler Dependency
#' @export
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
#' @keywords internal
el_collapse_handler_dependency <- function() {
  .el_handler_dependency("collapse")
}

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

#' Drawer Handler Dependency
#' @keywords internal
el_drawer_handler_dependency <- function() {
  .el_handler_dependency("drawer")
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
