#' Element Plus Carousel
#'
#' A slideshow of items, horizontal or vertical.
#'
#' @param id Carousel ID (auto-generated if NULL).
#' @param items A list of slides, each an [el_carousel_item()] -- or a list
#'   with `content` (a tag,
#'   tagList or string) and optionally `name`, used as the value reported when
#'   that slide is showing, and `label`, shown on its indicator. A slide's
#'   content may hold this package's components: they are folded into the
#'   carousel's own Vue instance and keep reporting their inputs.
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
#' @param card_scale When type is card, scaled size of secondary cards.
#'   Element Plus's `card-scale` (number).
#' @param motion_blur Infuse dynamism and smoothness into the carousel.
#'   Element Plus's `motion-blur` (boolean).
#' @param pause_on_hover Pause autoplay when hover. Element Plus's
#'   `pause-on-hover` (boolean).
#' @param session In `el_carousel()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_carousel()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Shiny inputs:
#' `input$<id>` holds the index of the slide currently showing, 0-based, and
#' `input$<id>_name` its `name` if one was given. Both are reported on load and
#' whenever the slide changes.
#'
#' @section Element methods:
#' Callable with [call_el()]:
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
#'     list(name = "one", content = shiny::tags$h3("First slide")),
#'     list(name = "two", content = shiny::tags$h3("Second slide")),
#'     list(name = "three", content = shiny::tags$h3("Third slide"))
#'   )
#' )
#'
#' # Card layout, switching on click rather than hover
#' el_carousel(
#'   id = "cards",
#'   type = "card",
#'   trigger = "click",
#'   height = "180px",
#'   items = lapply(1:4, function(i) list(content = paste("Card", i)))
#' )
el_carousel <- function(
  id = NULL,
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
  card_scale = NULL,
  motion_blur = NULL,
  pause_on_hover = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  .el_check_items(items, "items", c("content", "name"))
  .el_check_choices("el_carousel", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_carousel")
  }
  ns_id <- .el_ui_id(id, session)

  # Slides are generated in R rather than with v-for so their content can be
  # any htmltools markup rather than a string.
  # A component on a slide is folded into the carousel's own Vue instance
  # rather than nested in it, so it keeps reporting -- see .el_absorb().
  inners <- lapply(items, function(item) .el_absorb(item$content))

  carousel_attrs <- list(
    ref = "carousel",
    ":height" = "height",
    ":initial-index" = "initialIndex",
    ":autoplay" = "autoplay",
    ":interval" = "interval",
    ":trigger" = "trigger",
    ":arrow" = "arrow",
    ":loop" = "loop",
    ":direction" = "direction",
    ":indicator-position" = .el_optional_bind("indicatorPosition"),
    ":type" = .el_optional_bind("carouselType"),
    "@change" = "handleChange"
  )

  names_vec <- vapply(
    items,
    function(item) {
      if (is.null(item$name)) "" else as.character(item$name)
    },
    character(1)
  )

  vue_data <- list(
    height = height,
    initialIndex = initial_index,
    autoplay = autoplay,
    interval = interval,
    trigger = trigger,
    arrow = arrow,
    loop = loop,
    direction = direction,
    indicatorPosition = if (is.null(indicator_position)) {
      NA
    } else {
      indicator_position
    },
    carouselType = if (is.null(type)) NA else type,
    itemNames = as.list(names_vec),
    active = initial_index,
    activeName = if (length(names_vec) > initial_index + 1L) {
      names_vec[initial_index + 1L]
    } else {
      ""
    }
  )

  own <- list(
    markup = NULL,
    data = vue_data,
    methods = list(),
    watch = list(),
    computed = list(),
    dependencies = list(),
    mounted = .el_mounted_init(stats::setNames(
      c("active", "activeName"),
      paste0(ns_id, c("", "_name"))
    ))
  )
  own$methods <- list(
    handleChange = JS(sprintf(
      paste0(
        "function(index) { var self = this; self.active = index; ",
        "self.activeName = self.itemNames[index] || ''; ",
        "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%1$s', index); ",
        "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%1$s_name', self.activeName); }"
      ),
      ns_id
    ))
  )
  merged <- do.call(.el_absorb_merge, c(list(own), inners))

  item_tags <- Map(
    function(item, content) {
      # name lets setActiveItem() pick a slide by name; label is shown on its
      # indicator
      attrs <- list()
      if (!is.null(item$name)) {
        attrs$name <- item$name
      }
      if (!is.null(item$label)) {
        attrs$label <- item$label
      }
      attrs$style <- item$style
      attrs$class <- item$class
      htmltools::tag("el-carousel-item", c(attrs, list(content)))
    },
    items,
    merged$markups[-1]
  )

  el_widget(
    props = .el_props(
      prefix = "carousel",
      list(
        card_scale = card_scale,
        motion_blur = motion_blur,
        pause_on_hover = pause_on_hover
      )
    ),
    id = ns_id,
    markup = htmltools::tag(
      "el-carousel",
      c(carousel_attrs, unname(item_tags))
    ),
    data = merged$data,
    # update_el_carousel(active =) moves the carousel rather than set a field
    methods = c(
      merged$methods,
      list(
        shinyVueReceive = JS(paste0(
          "function(d) { if ('active' in d) { ",
          "if (this.$refs.carousel) this.$refs.carousel.setActiveItem(d.active); ",
          "delete d.active; } return d; }"
        ))
      )
    ),
    watch = merged$watch,
    computed = merged$computed,
    # The carousel's own hook and those of any component on a slide
    mounted = merged$mounted,
    width = width,
    slots = slots,
    dependency = merged$dependencies
  )
}

#' @rdname el_carousel
#' @section Updating from the server:
#' `update_el_carousel()` changes the component from the server.
#'
#' Every other argument of [el_carousel()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_carousel()` is called for its side effect and returns `NULL` invisibly.
#' @param active Index of the slide to show, 0-based.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_carousel(session, "banner", active = 2)
#'   })
#' }
#' @export
update_el_carousel <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  active = NULL,
  autoplay = NULL,
  interval = NULL,
  height = NULL,
  initial_index = NULL,
  trigger = NULL,
  indicator_position = NULL,
  arrow = NULL,
  loop = NULL,
  direction = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  # `initial-index` is read once at mount and has no watcher, so moving to a
  # slide is a method call; the handler does that part.
  if (!is.null(active)) {
    msg$active <- active
  }
  if (!is.null(autoplay)) {
    msg$autoplay <- autoplay
  }
  if (!is.null(interval)) {
    msg$interval <- interval
  }
  msg <- c(
    msg,
    .el_update_props(
      "el_carousel",
      Filter(
        Negate(is.null),
        list(
          height = height,
          initial_index = initial_index,
          trigger = trigger,
          indicator_position = indicator_position,
          arrow = arrow,
          loop = loop,
          direction = direction
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
