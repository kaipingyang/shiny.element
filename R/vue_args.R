#' An id for a component given none
#'
#' Drawn at random, and marked as such: [render_vue()] does not take a new
#' one, each render, for another component, as it does an id the author
#' gave.
#'
#' @param prefix The component's function name.
#' @return The id, with attribute `generated`.
#' @keywords internal
.vue_auto_id <- function(prefix) {
  structure(paste0(prefix, "_", uuid::UUIDgenerate()), generated = TRUE)
}

#' The id a UI function gives its component
#'
#' A UI function does not namespace its `id`, any more than
#' [shiny::textInput()] does: inside a module the caller writes `ns("name")`.
#' Namespacing from the default reactive domain, as every component once did,
#' namespaced twice whenever UI was built inside a module's server --
#' `renderUI()` -- turning `ns("name")` into `"mod-mod-name"`, an input that
#' never reported and said nothing about it.
#'
#' A session given explicitly is still honoured, with a warning, for code
#' written against the old behaviour.
#'
#' @param id The id as given.
#' @param session `NULL`, or a session passed by the caller.
#' @return The id the component uses.
#' @keywords internal
.vue_ui_id <- function(id, session = NULL) {
  if (is.numeric(id) && length(id) == 1L && !is.na(id)) {
    id <- as.character(id)
  }
  if (!is.character(id) || length(id) != 1L || is.na(id)) {
    # A component given first lands here, the id being the first argument
    stop(
      "`id` must be a single string, not ",
      if (inherits(id, c("shiny.tag", "shiny.tag.list"))) {
        "a tag: name the argument it is meant for"
      } else {
        class(id)[1]
      },
      ".",
      call. = FALSE
    )
  }
  generated <- attr(id, "generated")
  # Set by the package's own articles, which render many examples on one page:
  # two that both use "city" would otherwise share one id.
  prefix <- getOption(
    "shiny.vue.id_prefix",
    getOption("shiny.element.id_prefix")
  )
  if (!is.null(prefix)) {
    id <- paste0(prefix, id)
  }
  attr(id, "generated") <- generated
  if (is.null(session)) {
    return(id)
  }
  warning(
    "`session` is deprecated in UI functions. Inside a module, wrap ",
    "the id in ns() instead, as for any Shiny input.",
    call. = FALSE
  )
  session$ns(id)
}

#' Take an argument given under either of its two names
#'
#' The choice components take Shiny's names, `choices` and `selected`, and
#' the component library's, `options` and `value`. Given both, the two must agree: letting
#' one silently win, as `colour <- color %||% colour` does, hides a call
#' that says two different things.
#'
#' @param main,alias The argument's values under each name.
#' @param main_name,alias_name The names, for the error message.
#' @return Whichever was given; `main` when neither was.
#' @keywords internal
.vue_alias <- function(main, alias, main_name, alias_name) {
  if (is.null(alias)) {
    return(main)
  }
  if (!is.null(main) && !identical(main, alias)) {
    stop(
      sprintf(
        "`%s` and `%s` are the same argument; give one of them.",
        main_name,
        alias_name
      ),
      call. = FALSE
    )
  }
  alias
}

#' Normalise `choices` into option configs
#'
#' Accepts a named vector (`c(Label = value)`), an unnamed vector, or a list
#' already shaped as `list(value = , label = )` items, and returns the list
#' form a select's options, a radio group or a checkbox group iterate over.
#'
#' The named branch deliberately does not require a character vector. It used
#' to, so `c(Beijing = 1, Shanghai = 2)` fell through to the unnamed branch:
#' the labels were lost (rendered as "1" and "2") and the surviving names
#' turned the serialised JSON into an object rather than the array `v-for`
#' expects.
#'
#' @param choices A named vector, an unnamed vector, or a list of configs.
#' @return An unnamed list of `list(value = , label = )` items.
#' @keywords internal
.vue_choices <- function(choices) {
  # A list is assumed to be in option shape already.
  if (is.list(choices)) {
    return(choices)
  }

  if (!is.null(names(choices))) {
    return(mapply(
      function(label, value) list(value = value, label = label),
      names(choices),
      unname(choices),
      SIMPLIFY = FALSE,
      USE.NAMES = FALSE
    ))
  }

  lapply(choices, function(x) list(value = x, label = as.character(x)))
}
