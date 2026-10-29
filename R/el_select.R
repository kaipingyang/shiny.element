# Private dependency loader (not exported)

#' Element Plus Select Component
#'
#' Creates an Element Plus `<el-select>` component backed by a Vue instance.
#' Supports single and multiple selection, filtering, and all standard
#' Element Plus select props.
#'
#' @param id Input ID. Auto-generated UUID if `NULL`.
#' @param choices,options The choices: a named character vector
#'   (`c(Label = value)`), a list of [el_option()]s (or of `list(value =
#'   ..., label = ...)`), or a list of [el_option_group()]s (or a named list
#'   of options) for option groups. Unnamed vectors are allowed;
#'   the element is used as both value and label. `choices` is Shiny's name
#'   for it, `options` Element's; give either. Empty by default, for a
#'   select whose options arrive later (`remote = TRUE`).
#' @param selected,value Initially selected value(s); a character vector for
#'   multiple selection. `selected` is Shiny's name, `value` Element's
#'   (its `v-model`); give either.
#' @param multiple Whether multiple items can be selected. Default `FALSE`.
#' @param placeholder Placeholder text shown when nothing is selected.
#' @param disabled Whether the select is disabled. Default `FALSE`.
#' @param clearable Whether to show a clear button. Default `FALSE`.
#' @param filterable Whether typing filters the options. Default `FALSE`.
#' @param size Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or the page.
#' @param multiple_limit Maximum number of items that can be selected when
#'   `multiple = TRUE`. `0` means unlimited. Default `0`.
#' @param collapse_tags Whether to collapse selected tags into a summary when
#'   `multiple = TRUE`. Default `FALSE`.
#' @param append_to Which element the select dropdown appends to. Element
#'   Plus's `append-to` (CSSSelector / HTMLElement).
#' @param aria_label Same as `aria-label` in native input. Element Plus's
#'   `aria-label` (string).
#' @param clear_icon Custom clear icon component. Element Plus's `clear-icon`
#'   (string / Component). An icon's name, such as `"Search"`.
#' @param collapse_tags_tooltip Whether show all selected tags when mouse
#'   hover text of collapse-tags. To use this, `collapse-tags` must be true.
#'   Element Plus's `collapse-tags-tooltip` (boolean).
#' @param debounce Debounce delay during remote search, in milliseconds.
#'   Element Plus's `debounce` (number).
#' @param effect Tooltip theme, built-in theme: `dark` / `light`. Element
#'   Plus's `effect` ('dark' | 'light' / string).
#' @param empty_values Empty values of component, see config-provider. Element
#'   Plus's `empty-values` (array).
#' @param fallback_placements List of possible positions for dropdown
#'   popper.js. Element Plus's `fallback-placements` (`Placement[]`).
#' @param fit_input_width Whether the width of the dropdown is the same as the
#'   input. Element Plus's `fit-input-width` (boolean).
#' @param max_collapse_tags The max tags number to be shown. To use this,
#'   `collapse-tags` must be true. Element Plus's `max-collapse-tags`
#'   (number).
#' @param offset Offset of the dropdown. Element Plus's `offset` (number).
#' @param persistent When select dropdown is inactive and `persistent` is
#'   `false`, select dropdown will be destroyed. Element Plus's `persistent`
#'   (boolean).
#' @param placement Position of dropdown. Element Plus's `placement` (enum).
#' @param popper_options Popper.js parameters. Element Plus's `popper-options`
#'   (object).
#' @param popper_style Custom style for Select's dropdown and tags' tooltip.
#'   Element Plus's `popper-style` (string / object).
#' @param remote_show_suffix In remote search method show suffix icon. Element
#'   Plus's `remote-show-suffix` (boolean).
#' @param show_arrow Whether the dropdown has an arrow. Element Plus's
#'   `show-arrow` (boolean).
#' @param suffix_icon Custom suffix icon component. Element Plus's
#'   `suffix-icon` (string / Component). An icon's name, such as `"Search"`.
#' @param suffix_transition Animation when dropdown appears/disappears icon.
#'   Element Plus's `suffix-transition` (boolean).
#' @param tabindex Tabindex for input. Element Plus's `tabindex` (string /
#'   number).
#' @param tag_effect Tag effect. Element Plus's `tag-effect` ('' | 'light' |
#'   'dark' | 'plain').
#' @param props Which field of an option holds what, when the options are
#'   records named otherwise: `list(value =, label =, disabled =, options =)`,
#'   Element Plus's `props`.
#' @param tag_tooltip Settings for the tooltip listing collapsed tags, with
#'   `collapse_tags` and `collapse_tags_tooltip`: a named list of tooltip
#'   attributes (`placement`, `effect`, ...). Element Plus's `tag-tooltip`.
#' @param tag_type Tag type. Element Plus's `tag-type` ('' | 'success' |
#'   'info' | 'warning' | 'danger').
#' @param teleported Whether select dropdown is teleported, if `true` it will
#'   be teleported to where `append-to` sets. Element Plus's `teleported`
#'   (boolean).
#' @param validate_event Whether to trigger form validation. Element Plus's
#'   `validate-event` (boolean).
#' @param value_on_clear Clear return value, see config-provider. Element
#'   Plus's `value-on-clear` (string / number / boolean / Function, or `null`,
#'   which its documentation names): a value as it is, a function as [JS()],
#'   `null` as `JS("null")`. `NULL` leaves Element's default.
#' @param session In `el_select()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_select()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param value_key Key that identifies an option when values are objects. Default `"value"`.
#' @param name Native `name` attribute.
#' @param autocomplete Native `autocomplete` attribute. Default `"off"`.
#' @param automatic_dropdown Whether a filterable select opens its menu on focus.
#' @param allow_create Whether the user may create options not in the list. Needs `filterable = TRUE`.
#' @param loading Whether to show the loading state while options are being fetched.
#' @param loading_text Text shown while loading. Default `"Loading"`.
#' @param no_match_text Text shown when filtering matches nothing.
#' @param no_data_text Text shown when there are no options at all.
#' @param popper_class Extra class name for the dropdown panel.
#' @param reserve_keyword Whether a multiple filterable select keeps the search term after selecting.
#' @param default_first_option Whether Enter picks the first matching option.
#' @param remote Whether options are fetched from the server as the user
#'   types. Needs `filterable = TRUE`; see "Shiny inputs".
#' @param filter_method `JS()` function filtering the options as the user types.
#' @param remote_method `JS()` function fetching options in the
#'   browser instead of from the server. Needs `remote = TRUE`.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param option_template Markup drawn inside each option, in place of its
#'   label -- Element's "custom template". The option is in reach as `opt`,
#'   with any field its choice carries -- `{{ opt.label }}`, `{{ opt.code }}` --
#'   for choices given as `list(value =, label =, code =)`. See the example.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @template events
#' @template on
#' @section Element methods:
#' Callable with [call_el()]:
#'
#' - `blur()` -- Blur the Input component, and hide the dropdown
#' - `focus()` -- Focus the Input component
#'
#' @return An `htmltools` tagList containing the Vue-managed select component.
#'
#' @section Shiny inputs:
#' `r .el_events_md("el_select")`
#'
#' With `remote = TRUE`, `filterable = TRUE` and no `remote_method` of your
#' own, the server does the search, as `selectizeInput()`'s server mode
#' does: `input$<id>_query` is the text typed, and [update_el_select()]
#' with the matching `choices` answers it -- the select shows Element's
#' loading text until then, or for 30 seconds at most.
#'
#' @examples
#' # Each option drawn with a second field beside its label
#' el_select(
#'   "city",
#'   choices = list(
#'     list(value = "bj", label = "Beijing", code = "PEK"),
#'     list(value = "sh", label = "Shanghai", code = "SHA")
#'   ),
#'   option_template = htmltools::tagList(
#'     htmltools::tags$span(style = "float: left", "{{ opt.label }}"),
#'     htmltools::tags$span(
#'       style = "float: right; color: #8492a6",
#'       "{{ opt.code }}"
#'     )
#'   )
#' )
#'
#' # Single-select from a named vector
#' el_select(
#'   "sel1",
#'   choices = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
#'   selected = "banana"
#' )
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_select(
#'       "fruit",
#'       choices = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
#'       selected = "apple",
#'       clearable = TRUE
#'     ),
#'     verbatimTextOutput("selected")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected <- renderPrint(input$fruit)
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_select <- function(
  id = NULL,
  choices = NULL,
  selected = NULL,
  multiple = FALSE,
  placeholder = NULL,
  disabled = FALSE,
  clearable = FALSE,
  filterable = FALSE,
  size = NULL,
  multiple_limit = 0,
  collapse_tags = FALSE,
  value_key = NULL,
  name = NULL,
  autocomplete = NULL,
  automatic_dropdown = NULL,
  allow_create = NULL,
  loading = NULL,
  loading_text = NULL,
  no_match_text = NULL,
  no_data_text = NULL,
  popper_class = NULL,
  reserve_keyword = NULL,
  default_first_option = NULL,
  remote = NULL,
  filter_method = NULL,
  remote_method = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  option_template = NULL,
  slots = NULL,
  value = NULL,
  options = NULL,
  append_to = NULL,
  aria_label = NULL,
  clear_icon = NULL,
  collapse_tags_tooltip = NULL,
  debounce = NULL,
  effect = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  fit_input_width = NULL,
  max_collapse_tags = NULL,
  offset = NULL,
  persistent = NULL,
  placement = NULL,
  popper_options = NULL,
  popper_style = NULL,
  remote_show_suffix = NULL,
  show_arrow = NULL,
  suffix_icon = NULL,
  suffix_transition = NULL,
  tabindex = NULL,
  tag_effect = NULL,
  tag_type = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  props = NULL,
  tag_tooltip = NULL,
  events = NULL,
  on = NULL,
  session = NULL
) {
  .el_check_choices("el_select", environment())
  # R reads these to draw the component
  .vue_unbound(
    choices = choices,
    multiple = multiple,
    option_template = option_template,
    props = props
  )
  selected <- .vue_alias(selected, value, "selected", "value")
  choices <- .vue_alias(choices, options, "choices", "options")
  # Options are drawn here, not by Element Plus from an `options` prop, so
  # `props` renames their fields here
  choices <- .el_rename_option_fields(choices, props)
  if (is.null(choices)) {
    choices <- list()
  }
  if (is.null(id)) {
    id <- .vue_auto_id("el_select")
  }
  ns_id <- .vue_ui_id(id, session)

  # Options are rendered with v-for so update_el_select() can replace them.
  # Each carries its own `disabled`: the select's `disabled` argument turns off
  # the whole control, not one choice.
  # option_template is Element's "custom template": markup inside each
  # el-option, with the option in reach as `opt`
  option_tag <- function(each) {
    htmltools::tag(
      "el-option",
      c(
        list(
          "v-for" = each,
          ":key" = "opt.value",
          ":value" = "opt.value",
          ":label" = "opt.label",
          ":disabled" = "opt.disabled"
        ),
        if (!is.null(option_template)) list(option_template)
      )
    )
  }
  option_slot <- list(
    option_tag("opt in options"),
    htmltools::tag(
      "el-option-group",
      list(
        "v-for" = "g in groups",
        ":key" = "g.label",
        ":label" = "g.label",
        ":disabled" = "g.disabled",
        option_tag("opt in g.options")
      )
    )
  )

  # Build el-select attributes
  select_attrs <- list(
    "v-model" = "value",
    ":multiple" = "multiple",
    ":disabled" = "disabled",
    ":clearable" = "clearable",
    ":filterable" = "filterable",
    ":multiple-limit" = "multipleLimit",
    ":collapse-tags" = "collapseTags",
    "@change" = "handleChange"
  )
  # The server answers by default: input$<id>_query, then update_el_select()
  select_attrs[[
    ":remote-method"
  ]] <- "remoteMethod === null ? elRemoteQuery : remoteMethod"

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(
    ns_id,
    "el_select",
    events,
    on = on,
    shapes = list(
      "popup-scroll" = paste0(
        "function(e) { ",
        "return {scroll_left: e.scrollLeft, scroll_top: e.scrollTop}; }"
      )
    ),
    # fires on every frame of a scroll
    throttle = "popup-scroll"
  )
  select_attrs <- c(select_attrs, events$attrs)
  # Build Vue data
  vue_data <- list(
    # A multiple select's value is an array, one choice or several
    value = if (is.null(selected)) {
      if (multiple) list() else ""
    } else if (isTRUE(multiple)) {
      as.list(unname(selected))
    } else {
      selected
    },
    options = .el_select_choices(choices)$options,
    groups = .el_select_choices(choices)$groups,
    multiple = multiple,
    disabled = disabled,
    clearable = clearable,
    filterable = filterable,
    multipleLimit = multiple_limit,
    collapseTags = collapse_tags
  )
  vue_data$remoteMethod <- .vue_or_na(remote_method)
  el_widget(
    props = .el_props(list(
      placeholder = placeholder,
      size = size,
      value_key = value_key,
      name = name,
      autocomplete = autocomplete,
      automatic_dropdown = automatic_dropdown,
      allow_create = allow_create,
      loading = loading,
      loading_text = loading_text,
      no_match_text = no_match_text,
      no_data_text = no_data_text,
      popper_class = popper_class,
      reserve_keyword = reserve_keyword,
      default_first_option = default_first_option,
      remote = remote,
      filter_method = filter_method,
      append_to = append_to,
      aria_label = aria_label,
      clear_icon = .el_icon_name(clear_icon),
      collapse_tags_tooltip = collapse_tags_tooltip,
      debounce = debounce,
      effect = effect,
      empty_values = empty_values,
      fallback_placements = fallback_placements,
      fit_input_width = fit_input_width,
      max_collapse_tags = max_collapse_tags,
      offset = offset,
      persistent = persistent,
      placement = placement,
      popper_options = popper_options,
      popper_style = popper_style,
      remote_show_suffix = remote_show_suffix,
      show_arrow = show_arrow,
      suffix_icon = .el_icon_name(suffix_icon),
      suffix_transition = suffix_transition,
      tabindex = tabindex,
      tag_effect = tag_effect,
      tag_type = tag_type,
      tag_tooltip = tag_tooltip,
      teleported = teleported,
      validate_event = validate_event,
      value_on_clear = value_on_clear
    )),
    label = label,
    label_position = label_position,
    label_width = label_width,
    label_suffix = label_suffix,
    required = required,
    error = error,
    show_message = show_message,
    inline_message = inline_message,
    id = ns_id,
    markup = htmltools::tag("el-select", c(select_attrs, option_slot)),
    data = vue_data,
    methods = c(
      events$methods,
      list(
        # A search the server never answers stops loading after
        # shinyVue.askTimeout, as a lazy load's question settles
        elRemoteQuery = JS(sprintf(
          paste0(
            "function(query) {\n",
            "  if (!(window.Shiny && Shiny.setInputValue)) return;\n",
            "  var self = this, n = this._elQueryN = (this._elQueryN || 0) + 1;\n",
            "  this.loading = true;\n",
            "  clearTimeout(this._elQueryTimer);\n",
            "  this._elQueryTimer = setTimeout(function() {\n",
            "    if (self._elQueryN !== n || !self.loading) return;\n",
            "    self.loading = false;\n",
            "    console.warn('[shiny.element] no answer to input$%s_query within ' + window.shinyVue.askTimeout / 1000 + ' s');\n",
            "  }, window.shinyVue.askTimeout);\n",
            "  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_query', query, {priority: 'event'});\n",
            "}"
          ),
          ns_id,
          ns_id
        )),
        handleChange = JS(sprintf(
          "function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', value); }",
          ns_id
        )),
        # update_el_select(selected = "a") on a multiple select, as
        # updateSelectInput() takes it: one choice is an array of one
        shinyVueReceive = JS(paste0(
          "function(d) { var multiple = 'multiple' in d ? d.multiple : this.multiple; ",
          "if ('value' in d && multiple && d.value !== null && !Array.isArray(d.value)) ",
          "d.value = [d.value]; return d; }"
        ))
      )
    ),
    mounted = .vue_mounted_report(stats::setNames("value", ns_id)),
    width = width,
    slots = slots
  )
}


#' @rdname el_select
#' @section Updating from the server:
#' Server-side update for [el_select()]. Sends a custom message to update
#' reactive fields on the underlying Vue instance.
#'
#' Every other argument of [el_select()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_select()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_select(session, "city", selected = "sh")
#'   })
#' }
#' @export
update_el_select <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  selected = NULL,
  choices = NULL,
  disabled = NULL,
  placeholder = NULL,
  clearable = NULL,
  filterable = NULL,
  multiple_limit = NULL,
  loading = NULL,
  loading_text = NULL,
  no_match_text = NULL,
  no_data_text = NULL,
  value = NULL,
  options = NULL,
  label = NULL,
  error = NULL,
  multiple = NULL,
  size = NULL,
  collapse_tags = NULL,
  value_key = NULL,
  name = NULL,
  autocomplete = NULL,
  automatic_dropdown = NULL,
  allow_create = NULL,
  popper_class = NULL,
  reserve_keyword = NULL,
  remote = NULL,
  filter_method = NULL,
  remote_method = NULL,
  append_to = NULL,
  aria_label = NULL,
  clear_icon = NULL,
  collapse_tags_tooltip = NULL,
  debounce = NULL,
  effect = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  fit_input_width = NULL,
  max_collapse_tags = NULL,
  offset = NULL,
  persistent = NULL,
  placement = NULL,
  popper_options = NULL,
  popper_style = NULL,
  remote_show_suffix = NULL,
  show_arrow = NULL,
  suffix_icon = NULL,
  suffix_transition = NULL,
  tabindex = NULL,
  tag_effect = NULL,
  tag_type = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  tag_tooltip = NULL
) {
  .vue_check_session(session)
  selected <- .vue_alias(selected, value, "selected", "value")
  choices <- .vue_alias(choices, options, "choices", "options")
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(selected)) {
    msg$value <- selected
  }
  if (!is.null(choices)) {
    parts <- .el_select_choices(choices)
    msg$options <- parts$options
    msg$groups <- parts$groups
    # New choices answer a remote search, so it is no longer loading
    if (is.null(loading)) msg$loading <- FALSE
  }
  msg <- .el_form_item_update(msg, label, error)
  msg <- c(
    msg,
    .el_update_props(
      "el_select",
      Filter(
        Negate(is.null),
        list(
          disabled = disabled,
          placeholder = placeholder,
          clearable = clearable,
          filterable = filterable,
          multiple_limit = multiple_limit,
          loading = loading,
          loading_text = loading_text,
          no_match_text = no_match_text,
          no_data_text = no_data_text,
          multiple = multiple,
          size = size,
          collapse_tags = collapse_tags,
          value_key = value_key,
          name = name,
          autocomplete = autocomplete,
          automatic_dropdown = automatic_dropdown,
          allow_create = allow_create,
          popper_class = popper_class,
          reserve_keyword = reserve_keyword,
          remote = remote,
          filter_method = filter_method,
          remote_method = remote_method,
          append_to = append_to,
          aria_label = aria_label,
          clear_icon = clear_icon,
          collapse_tags_tooltip = collapse_tags_tooltip,
          debounce = debounce,
          effect = effect,
          empty_values = empty_values,
          fallback_placements = fallback_placements,
          fit_input_width = fit_input_width,
          max_collapse_tags = max_collapse_tags,
          offset = offset,
          persistent = persistent,
          placement = placement,
          popper_options = popper_options,
          popper_style = popper_style,
          remote_show_suffix = remote_show_suffix,
          show_arrow = show_arrow,
          suffix_icon = suffix_icon,
          suffix_transition = suffix_transition,
          tabindex = tabindex,
          tag_effect = tag_effect,
          tag_type = tag_type,
          teleported = teleported,
          validate_event = validate_event,
          value_on_clear = value_on_clear,
          tag_tooltip = tag_tooltip
        )
      )
    )
  )
  .vue_send_update(session, msg)
  invisible(NULL)
}


#' Split a select's choices into loose options and option groups
#'
#' Groups are written the way `shiny::selectInput()` takes them -- a named
#' list whose elements are vectors, `list(East = c("NY", "NJ"))` -- or as
#' `list(label =, disabled =, options =)` when a group needs its own
#' `disabled`. Anything else is an ungrouped choice.
#'
#' @param choices The choices as given.
#' @return A list of `options` and `groups`.
#' @keywords internal
.el_select_choices <- function(choices) {
  if (!is.list(choices) || !length(choices)) {
    return(list(options = .vue_choices(choices), groups = list()))
  }
  nms <- names(choices) %||% rep("", length(choices))
  is_group <- function(x, nm) {
    (is.list(x) && !is.null(x$options)) ||
      (nzchar(nm) &&
        is.atomic(x) &&
        length(x) > 0 &&
        !(identical(names(x), c("value", "label"))))
  }
  flags <- mapply(is_group, choices, nms)
  if (!any(flags)) {
    return(list(options = .vue_choices(choices), groups = list()))
  }

  groups <- Map(
    function(x, nm) {
      if (is.list(x) && !is.null(x$options)) {
        list(
          label = x$label %||% nm,
          disabled = isTRUE(x$disabled),
          options = .vue_choices(x$options)
        )
      } else {
        list(label = nm, disabled = FALSE, options = .vue_choices(x))
      }
    },
    choices[flags],
    nms[flags]
  )
  loose <- choices[!flags]
  list(
    options = if (length(loose)) {
      .vue_choices(unname(loose))
    } else {
      list()
    },
    groups = unname(groups)
  )
}

`%||%` <- function(a, b) if (is.null(a)) b else a


#' Rename the fields of record options, as Element Plus's `props` does
#'
#' @param choices The choices as given.
#' @param props `list(value =, label =, disabled =, options =)`: the fields
#'   holding each, or `NULL`.
#' @return The choices, with the fields `.el_select_choices()` reads.
#' @keywords internal
.el_rename_option_fields <- function(choices, props) {
  if (is.null(props) || !is.list(choices)) {
    return(choices)
  }
  from <- unlist(props[intersect(
    names(props),
    c("value", "label", "disabled", "options")
  )])
  rename <- function(x) {
    if (!is.list(x) || is.null(names(x))) {
      return(x)
    }
    hit <- names(x) %in% from
    names(x)[hit] <- names(from)[match(names(x)[hit], from)]
    if (is.list(x$options)) {
      x$options <- lapply(x$options, rename)
    }
    x
  }
  lapply(choices, rename)
}
