#' Element Plus for a page of your own
#'
#' What [el_page()] gives a page, for other page functions --
#' [bslib::page_sidebar()], [shiny::navbarPage()]: the theme Element follows,
#' its locale and global config, the handlers of [el_message()] and the other
#' feedback services, and Element served from the CDN when `offline = FALSE`.
#' Components need none of it to work: each carries Vue and Element Plus, so
#' on a page without `use_element()` they show in English, Element's own
#' colours and sizes. Place it before the components, so its copy of
#' Element is the one kept.
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
#' @param dev Load Vue's development build (`vue.global.js`) instead of the
#'   production one, so Vue's warnings are not stripped. Defaults to
#'   `getOption("shiny.vue.dev")` (or `shiny.element.dev`), `FALSE` unless set.
#'   Installed from CRAN, the development build is loaded from the unpkg CDN.
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
#' theme <- el_theme(primary = "#7c3aed")
#' ui <- bslib::page_sidebar(
#'   theme = theme,
#'   use_element(theme = theme),
#'   el_button("btn1", "Click me")
#' )
use_element <- function(
  theme = NULL,
  offline = TRUE,
  dev = .vue_dev(),
  locale = getOption("shiny.element.locale", "en"),
  size = NULL,
  z_index = NULL,
  layout_css = el_layout_css_dependency()
) {
  deps <- c(
    list(.vue_core_dependency(dev = dev)),
    element_plus_dependency(offline = offline),
    # the bridge and Element's side of it, which checks for raw el$ tags
    # left outside any component -- a page may hold nothing else
    .el_dependencies(),
    el_locale_dependency(locale),
    .el_config_dependency(size, z_index),
    list(el_feedback_dependency())
  )

  if (!is.null(layout_css)) {
    deps <- c(deps, list(layout_css))
  }

  # the theme's variables, decided when the page is drawn
  htmltools::tagList(deps, .el_theme_tag(theme))
}

#' Element Plus Locale Dependency
#'
#' Element Plus's own build is in English: a pagination control's total, a
#' date picker's buttons, a select's placeholder, a table's empty message.
#' Loading a locale file and handing it to Element Plus, as
#' `app.use(ElementPlus, {locale})` does, switches all of it.
#'
#' All 67 of Element Plus's locales are bundled; `el_locales()` lists them.
#' The ones used most -- English, Chinese, Japanese, Korean, French, German,
#' Spanish, Portuguese (Brazil), Russian -- are files; the others are packed
#' in one archive and taken out the first time one is used in a session.
#' Codes are matched without regard to case, so Element UI's `"zh-CN"` is
#' Element Plus's `"zh-cn"`.
#'
#' Dates follow the language too: Element Plus's date and time components
#' read the week's first day and the names of months and days from Day.js,
#' whose locale, as Element Plus's guide says, has to be loaded and set
#' apart from its own. The page's Day.js locale is set with it -- a Chinese
#' calendar's week starts on Monday -- from Day.js's own files, bundled the
#' same way. Day.js has a locale for all but Kurmanji (`"ku"`) and Malagasy
#' (`"mg"`), whose dates stay in English. Day.js has one locale for the
#' page, so a config provider's own `locale` changes Element's words only.
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
#' # Or set it for the whole session, here undone afterwards
#' old <- options(shiny.element.locale = "zh-cn")
#' el_page(el_select("city", choices = c("Beijing", "Shanghai")))
#' options(old)
el_locale_dependency <- function(locale = NULL) {
  if (is.null(locale)) {
    return(NULL)
  }
  code <- tolower(locale)
  if (identical(code, "en")) {
    return(NULL)
  }
  root <- .vue_file("element-plus")
  dir <- .el_locale_dir(code)
  if (is.null(dir)) {
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
  c(
    list(htmltools::htmlDependency(
      name = paste0("element-plus-locale-", code),
      version = "2.14.7",
      src = dir,
      script = paste0(code, ".min.js"),
      all_files = FALSE
    )),
    .el_dayjs_locale_dependency(code),
    # Every component is an app of its own, given the locale as it installs
    # Element Plus; this hands it over, and sets Day.js's. It runs after the
    # locale files.
    list(htmltools::htmlDependency(
      name = paste0("element-plus-locale-apply-", code),
      version = "2.14.7",
      src = root,
      head = sprintf(
        paste0(
          "<script>window.shinyElementConfig = window.shinyElementConfig || {};",
          "if (window.%1$s) shinyElementConfig.locale = window.%1$s;%2$s</script>"
        ),
        global,
        .el_dayjs_apply(code)
      )
    ))
  )
}

#' Day.js's locale for one of Element Plus's
#'
#' Element Plus's codes and Day.js's agree but for a few: Egyptian Arabic,
#' Central Kurdish (Day.js's `ku` is Sorani), Norwegian, Punjabi, Uzbek and
#' Macanese Chinese take Day.js's nearest. Kurmanji and Malagasy have none.
#'
#' @param code An Element Plus locale code, lower case.
#' @return Day.js's locale name, or `NULL` for none (dates stay English).
#' @keywords internal
.el_dayjs_code <- function(code) {
  apart <- c(
    `ar-eg` = "ar",
    ckb = "ku",
    `nb-no` = "nb",
    no = "nb",
    pa = "pa-in",
    `uz-uz` = "uz",
    `zh-mo` = "zh-hk",
    ku = NA,
    mg = NA,
    en = NA
  )
  dj <- if (code %in% names(apart)) apart[[code]] else code
  if (is.na(dj)) NULL else dj
}

#' Day.js's locale file, and Day.js where the file looks for it
#'
#' Day.js comes inside Element Plus's build, as `ElementPlus.dayjs`; a
#' locale file of Day.js's registers itself with a global `dayjs`, given
#' here first.
#'
#' @param code An Element Plus locale code, lower case.
#' @return A list of htmlDependency objects; empty when Day.js has none.
#' @keywords internal
.el_dayjs_locale_dependency <- function(code) {
  dj <- .el_dayjs_code(code)
  if (is.null(dj)) {
    return(list())
  }
  dir <- .el_dayjs_locale_dir(dj)
  if (is.null(dir)) {
    return(list())
  }
  list(
    htmltools::htmlDependency(
      name = "dayjs-global",
      version = "1.11.20",
      src = .vue_file("dayjs"),
      head = paste0(
        "<script>if (window.ElementPlus && !window.dayjs) ",
        "window.dayjs = ElementPlus.dayjs;</script>"
      ),
      all_files = FALSE
    ),
    htmltools::htmlDependency(
      name = paste0("dayjs-locale-", dj),
      version = "1.11.20",
      src = dir,
      script = paste0(dj, ".js"),
      all_files = FALSE
    )
  )
}

#' The script that makes a Day.js locale the page's
#' @param code An Element Plus locale code, lower case.
#' @return JavaScript, or `""` when Day.js has no locale for it.
#' @noRd
.el_dayjs_apply <- function(code) {
  dj <- .el_dayjs_code(code)
  if (is.null(dj)) {
    return("")
  }
  sprintf(
    "if (window.ElementPlus && ElementPlus.dayjs) ElementPlus.dayjs.locale('%s');",
    dj
  )
}

#' Where a Day.js locale file is
#'
#' As [.el_locale_dir()] for Element Plus's: the locales used most are
#' files, the rest are in one archive, taken out into `tempdir()` the first
#' time one is used.
#'
#' @param dj Day.js's locale name.
#' @return The directory holding `<dj>.js`, or `NULL`.
#' @keywords internal
.el_dayjs_locale_dir <- function(dj) {
  file <- paste0(dj, ".js")
  root <- .vue_file("dayjs", "locale")
  if (file.exists(file.path(root, file))) {
    return(root)
  }
  archive <- file.path(root, "more.tar.gz")
  packed <- .vue_memo("dayjs_locales_packed", function() {
    if (file.exists(archive)) {
      utils::untar(archive, list = TRUE, tar = "internal")
    } else {
      character()
    }
  })
  if (!file %in% packed) {
    return(NULL)
  }
  out <- file.path(tempdir(), "shiny.element-dayjs-locale")
  if (!file.exists(file.path(out, file))) {
    utils::untar(archive, files = file, exdir = out, tar = "internal")
  }
  out
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
  local <- .vue_file("element-plus")
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
    src = .vue_file("js"),
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
  files <- c(list.files(root, pattern = "[.]min[.]js$"), .el_locales_packed())
  sort(sub("[.]min[.]js$", "", files))
}

#' Where a locale's file is
#'
#' The locales used most are files in `dist/locale`; the rest are packed in
#' `dist/locale/more.tar.gz`, which keeps the installed package small -- 56
#' files of 4KB each take far more room on disk than their bytes -- and one
#' is taken out into the session's temporary directory the first time it is
#' asked for.
#'
#' @param code A locale code, lower case: `"zh-cn"`.
#' @return The directory holding `<code>.min.js`, or `NULL` for a locale
#'   Element Plus does not ship.
#' @keywords internal
.el_locale_dir <- function(code) {
  file <- paste0(code, ".min.js")
  root <- system.file(
    "element-plus",
    "dist",
    "locale",
    package = "shiny.element"
  )
  if (file.exists(file.path(root, file))) {
    return(root)
  }
  if (!file %in% .el_locales_packed()) {
    return(NULL)
  }
  out <- file.path(tempdir(), "shiny.element-locale")
  if (!file.exists(file.path(out, file))) {
    utils::untar(
      file.path(root, "more.tar.gz"),
      files = file,
      exdir = out,
      tar = "internal"
    )
  }
  out
}

#' The locale files packed in `more.tar.gz`
#'
#' Listed once a session.
#'
#' @return File names, `"af.min.js"`.
#' @keywords internal
.el_locales_packed <- function() {
  if (is.null(.el_locale_cache$packed)) {
    archive <- system.file(
      "element-plus",
      "dist",
      "locale",
      "more.tar.gz",
      package = "shiny.element"
    )
    .el_locale_cache$packed <- if (nzchar(archive)) {
      utils::untar(archive, list = TRUE, tar = "internal")
    } else {
      character()
    }
  }
  .el_locale_cache$packed
}

.el_locale_cache <- new.env(parent = emptyenv())


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
    src = .vue_file("element-plus"),
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

#' Element's side of the bridge
#'
#' The package's own scripts for Element, in one dependency, as
#' shinyWidgets keeps its bindings in one file and bslib its components'
#' scripts: `el-events.js` (errors and labels drawn on a form item, table
#' rows, the raw-`<el-*>`-tag warning) and the input bindings of the
#' components drawn as markup rather than Vue apps -- collapse, tabs, and
#' the overlays, dialog and drawer -- so that what is inside them stays
#' mounted.
#'
#' @return An htmlDependency object.
#' @keywords internal
.el_bridge_dependency <- function() {
  htmltools::htmlDependency(
    "shiny-element",
    "1.0.0",
    src = .vue_file("js"),
    script = c(
      "el-events.js",
      "el-collapse-binding.js",
      "el-tabs-binding.js",
      "el-overlay-binding.js"
    ),
    all_files = FALSE
  )
}

#' What every component needs
#'
#' One set for every component, as bslib's components share one: the Vue
#' host's (jQuery, Vue core, the bridge), Element Plus and Element's side of
#' the bridge, in load order -- whether the component is a Vue app (input,
#' select, table) or markup with Element's classes (tabs, dialog, card,
#' row). Every component carries them, as Shiny's inputs carry selectize
#' and htmlwidgets their libraries, so it works on any page; htmltools
#' keeps one copy, the first, so a page that loads Element from the CDN
#' (`use_element(offline = FALSE)` before its components) keeps that one.
#' What belongs to the page -- its theme, locale, global config, the
#' feedback handlers -- stays with [use_element()] and [el_page()]. Made
#' once per R session and mode.
#'
#' @return A list of htmlDependency objects.
#' @keywords internal
.el_dependencies <- function() {
  .vue_memo(paste("el_dependencies", .vue_dev()), function() {
    c(
      .vue_host_dependencies(),
      element_plus_dependency(),
      list(.el_bridge_dependency())
    )
  })
}
