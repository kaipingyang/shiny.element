#' Element UI Carousel
#'
#' A slideshow of items, horizontal or vertical.
#'
#' @param id Carousel ID (auto-generated if NULL).
#' @param items A list of slides. Each is a list with `content` (a tag,
#'   tagList or string) and optionally `name`, used as the value reported when
#'   that slide is showing. Slides are static markup: putting one of this
#'   package's components inside will render but not stay connected to the
#'   server, since the carousel is itself a Vue instance. Compose those outside
#'   it instead.
#' @param height Slide height, e.g. `"300px"`.
#' @param initial_index Index of the slide shown first, 0-based.
#' @param autoplay Cycle through the slides on a timer.
#' @param interval Milliseconds between slides when `autoplay` is on.
#' @param trigger What switches slides when an indicator is used:
#'   `"hover"` (default) or `"click"`.
#' @param indicator_position `"outside"`, `"none"`, or NULL for inside.
#' @param arrow When to show the arrows: `"hover"` (default), `"always"` or
#'   `"never"`.
#' @param type `"card"` for the stacked card layout, or NULL for plain.
#' @param loop Return to the first slide after the last.
#' @param direction `"horizontal"` (default) or `"vertical"`.
#' @param session Shiny session for module support.
#'
#' @section Server inputs:
#' `input$<id>` holds the index of the slide currently showing, 0-based, and
#' `input$<id>_name` its `name` if one was given. Both are reported on load and
#' whenever the slide changes.
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `next()` -- Switch to the next slide
#' - `prev()` -- Switch to the previous slide
#' - `setActiveItem()` -- Manually switch slide
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_carousel(
#'   id = "banner",
#'   height = "200px",
#'   items = list(
#'     list(name = "one",   content = shiny::tags$h3("First slide")),
#'     list(name = "two",   content = shiny::tags$h3("Second slide")),
#'     list(name = "three", content = shiny::tags$h3("Third slide"))
#'   )
#' )
#'
#' # Card layout, switching on click rather than hover
#' el_carousel(
#'   id = "cards", type = "card", trigger = "click", height = "180px",
#'   items = lapply(1:4, function(i) list(content = paste("Card", i)))
#' )
el_carousel <- function(id = NULL,
                        items = list(),
                        height = "300px",
                        initial_index = 0,
                        autoplay = TRUE,
                        interval = 3000,
                        trigger = "hover",
                        indicator_position = NULL,
                        arrow = "hover",
                        type = NULL,
                        loop = TRUE,
                        direction = "horizontal",
                        session = shiny::getDefaultReactiveDomain()) {
  if (is.null(id)) id <- paste0("el_carousel_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Slides are generated in R rather than with v-for so their content can be
  # any htmltools markup rather than a string.
  item_tags <- lapply(items, function(item) {
    htmltools::tag("el-carousel-item", list(item$content))
  })

  carousel_attrs <- list(
    ref                    = "carousel",
    ":height"              = "height",
    ":initial-index"       = "initialIndex",
    ":autoplay"            = "autoplay",
    ":interval"            = "interval",
    ":trigger"             = "trigger",
    ":arrow"               = "arrow",
    ":loop"                = "loop",
    ":direction"           = "direction",
    ":indicator-position"  = .el_optional_bind("indicatorPosition"),
    ":type"                = .el_optional_bind("carouselType"),
    "@change"              = "handleChange"
  )

  names_vec <- vapply(items, function(item) {
    if (is.null(item$name)) "" else as.character(item$name)
  }, character(1))

  vue_data <- list(
    height            = height,
    initialIndex      = initial_index,
    autoplay          = autoplay,
    interval          = interval,
    trigger           = trigger,
    arrow             = arrow,
    loop              = loop,
    direction         = direction,
    indicatorPosition = if (is.null(indicator_position)) NA else indicator_position,
    carouselType      = if (is.null(type)) NA else type,
    itemNames         = as.list(names_vec),
    active            = initial_index,
    activeName        = if (length(names_vec) > initial_index + 1L) {
      names_vec[initial_index + 1L]
    } else {
      ""
    }
  )

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id, style = .el_host_style(),
      htmltools::tag("el-carousel", c(carousel_attrs, item_tags))
    ),
    vueR::vue(
      elementId = ns_id, width = 0, height = 0,
      list(
        el   = paste0("#", container_id),
        data = vue_data,
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            paste0(
              "function(index) { var self = this; self.active = index; ",
              "self.activeName = self.itemNames[index] || ''; ",
              "Shiny.setInputValue('%1$s', index); ",
              "Shiny.setInputValue('%1$s_name', self.activeName); }"
            ), ns_id
          ))
        ),
        mounted = .el_mounted_init(stats::setNames(
          c("active", "activeName"), paste0(ns_id, c("", "_name"))
        ))
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_carousel_handler_dependency())
}

#' Update an Element UI Carousel
#'
#' @param session Shiny session object.
#' @param id Carousel ID (un-namespaced).
#' @param active Index of the slide to show, 0-based.
#' @param autoplay Start or stop cycling.
#' @param interval New interval in milliseconds.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_carousel(session, "banner", active = 2)
#'   })
#' }
#' @export
update_el_carousel <- function(session, id,
                               active = NULL,
                               autoplay = NULL,
                               interval = NULL) {
  msg <- list(id = session$ns(id))
  # `initial-index` is read once at mount and has no watcher, so moving to a
  # slide is a method call; the handler does that part.
  if (!is.null(active))   msg$active   <- active
  if (!is.null(autoplay)) msg$autoplay <- autoplay
  if (!is.null(interval)) msg$interval <- interval
  session$sendCustomMessage("updateElCarousel", msg)
  invisible(NULL)
}
