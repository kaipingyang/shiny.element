# What each component's argument is, where it is not a prop of Element's:
# the Element layer's facts, read through the Vue layer's mechanism
# (R/vue_bindings.R: .vue_check_bindings(), .vue_bindings_md()), as
# R/el_events_registry.R's events are read through R/vue_events.R.
# Written first by tools/args-registry.R from what the components did;
# kept by hand since -- what an argument is, is a decision of ours.

# The exported functions that make a component, whose arguments are checked
.el_arg_components <- function() {
  fns <- grep("^el_", getNamespaceExports("shiny.element"), value = TRUE)
  not <- c(
    "el_widget",
    "el_page",
    "el_theme",
    "el_events",
    "el_locales",
    "el_locale_dependency",
    "el_layout_css_dependency",
    "el_feedback_dependency",
    "el_table_output",
    "el_calendar_output",
    "el_table_data",
    "el_calendar_events",
    "el_table_row",
    "el_upload_file",
    "el_load_children",
    "el_upload_clear"
  )
  service <- "^el_(message|notification|loading|form_(validate|reset|clear_validate))"
  sort(setdiff(fns, c(not, grep(service, fns, value = TRUE))))
}

# Arguments no component binds, being the component's frame: its id, its
# content, its events and handlers, the session
.el_arg_skip <- c("id", "...", "session", "events", "on", "slots")

# Arguments every component built by el_widget() with a form item has: the
# form item around it is R's markup; update_*() sets `label` and `error`
# through hooks, not fields.
.el_arg_widget <- c(
  label = "markup: the form item around the component, drawn by R",
  label_position = "markup: the form item around the component, drawn by R",
  label_width = "markup: the form item around the component, drawn by R",
  label_suffix = "markup: the form item around the component, drawn by R",
  required = "markup: the form item around the component, drawn by R",
  error = "markup: the form item around the component, drawn by R",
  show_message = "markup: the form item around the component, drawn by R",
  inline_message = "markup: the form item around the component, drawn by R",
  width = "markup: the mount point's style"
)

# By component: an argument's kind where it is not a prop -- `markup: why`
# (R draws with it: refused), `data[:shape]` (R converts it; a binding is
# Element's form), `stands:a,b` (one argument for several fields),
# `alias:x` (another name of x). One string for a whole function: every
# argument is markup, for that reason.
.el_arg_registry <- list(
  el_checkbox = c(
    width = "markup: the mount point's style"
  ),
  el_tag = c(
    width = "markup: the mount point's style"
  ),
  el_affix = c(
    width = "markup: the mount point's style"
  ),
  el_alert = c(
    width = "markup: the mount point's style"
  ),
  el_anchor = c(
    links = "markup: the links, drawn by R",
    width = "markup: the mount point's style"
  ),
  el_aside = "markup: a layout drawn as markup by R",
  el_autocomplete = c(
    fetch_suggestions = "markup: picks how suggestions are fetched",
    remote = "markup: picks how suggestions are fetched",
    suggestions = "data:records"
  ),
  el_avatar = c(
    class = "markup: the root's attribute, drawn by R",
    style = "markup: the root's attribute, drawn by R",
    width = "markup: the mount point's style"
  ),
  el_avatar_group = c(
    width = "markup: the mount point's style"
  ),
  el_backtop = c(
    content = "markup: content drawn by R",
    width = "markup: the mount point's style"
  ),
  el_breadcrumb = c(
    width = "markup: the mount point's style"
  ),
  el_button = c(
    circle = "markup: drawn by R as the button's shape",
    class = "markup: the root's attribute, drawn by R",
    style = "markup: the root's attribute, drawn by R",
    task = "markup: makes it a task button, bslib's protocol",
    width = "markup: the mount point's style"
  ),
  el_button_group = c(
    width = "markup: the mount point's style"
  ),
  el_calendar = c(
    calendars = "markup: read by R to draw the planner",
    editable = "markup: draws the planner's dialog",
    event_labels = "markup: the planner's words, drawn by R",
    first_day_of_week = "markup: set on Day.js as the calendar is drawn",
    range = "markup: picks the calendar's markup",
    use_detail_popup = "markup: draws the planner's popup",
    visible_event_count = "markup: read by R to draw the planner",
    workweek = "markup: picks the days drawn"
  ),
  el_card = c(
    body_class = "markup: drawn by R",
    body_style = "markup: drawn by R",
    class = "markup: the root's attribute, drawn by R",
    footer = "markup: content drawn by R",
    footer_class = "markup: drawn by R",
    header = "markup: content drawn by R",
    header_class = "markup: drawn by R",
    shadow = "markup: drawn by R",
    style = "markup: the root's attribute, drawn by R"
  ),
  el_carousel = c(
    initial_index = "markup: read by R as the slides are drawn",
    items = "markup: the slides, drawn by R",
    width = "markup: the mount point's style"
  ),
  el_carousel_item = "markup: a slide is drawn by el_carousel() from R",
  el_cascader = c(
    level_inputs = "markup: names inputs of the server's"
  ),
  el_cascader_panel = c(
    level_inputs = "markup: names inputs of the server's"
  ),
  el_checkbox_group = c(
    button = "markup: picks el-checkbox or el-checkbox-button",
    choices = "data:records",
    options = "alias:choices",
    value = "alias:selected"
  ),
  el_col = "markup: a layout drawn as markup by R",
  el_collapse = c(
    items = "markup: the panels, drawn by R"
  ),
  el_config_provider = c(
    locale = "data",
    width = "markup: the mount point's style"
  ),
  el_container = "markup: a layout drawn as markup by R",
  el_countdown = c(
    width = "markup: the mount point's style"
  ),
  el_descriptions = c(
    width = "markup: the mount point's style"
  ),
  el_dialog = c(
    append_to = "markup: set once, as the overlay is drawn",
    append_to_body = "markup: set once, as the overlay is drawn",
    before_close = "markup: set once, as the overlay is drawn",
    body_class = "markup: set once, as the overlay is drawn",
    close_delay = "markup: set once, as the overlay is drawn",
    close_icon = "markup: set once, as the overlay is drawn",
    content = "markup: content drawn by R",
    custom_class = "markup: set once, as the overlay is drawn",
    destroy_on_close = "markup: set once, as the overlay is drawn",
    footer = "markup: content drawn by R",
    footer_class = "markup: set once, as the overlay is drawn",
    header_aria_level = "markup: set once, as the overlay is drawn",
    header_class = "markup: set once, as the overlay is drawn",
    modal_class = "markup: set once, as the overlay is drawn",
    modal_penetrable = "markup: set once, as the overlay is drawn",
    open_delay = "markup: set once, as the overlay is drawn",
    transition = "markup: set once, as the overlay is drawn",
    z_index = "markup: set once, as the overlay is drawn"
  ),
  el_divider = "markup: a divider is drawn as markup by R",
  el_drawer = c(
    append_to = "markup: set once, as the overlay is drawn",
    append_to_body = "markup: set once, as the overlay is drawn",
    before_close = "markup: set once, as the overlay is drawn",
    body_class = "markup: set once, as the overlay is drawn",
    close_delay = "markup: set once, as the overlay is drawn",
    content = "markup: content drawn by R",
    custom_class = "markup: set once, as the overlay is drawn",
    destroy_on_close = "markup: set once, as the overlay is drawn",
    footer = "markup: content drawn by R",
    footer_class = "markup: set once, as the overlay is drawn",
    header_aria_level = "markup: set once, as the overlay is drawn",
    header_class = "markup: set once, as the overlay is drawn",
    modal_class = "markup: set once, as the overlay is drawn",
    modal_penetrable = "markup: set once, as the overlay is drawn",
    open_delay = "markup: set once, as the overlay is drawn",
    resizable = "markup: set once, as the overlay is drawn",
    z_index = "markup: set once, as the overlay is drawn"
  ),
  el_dropdown = c(
    items = "markup: the items, drawn by R",
    trigger_label = "markup: content drawn by R",
    width = "markup: the mount point's style"
  ),
  el_empty = c(
    width = "markup: the mount point's style"
  ),
  el_footer = "markup: a layout drawn as markup by R",
  el_form = c(
    width = "markup: the mount point's style"
  ),
  el_form_field = "markup: a field is drawn into its form by R",
  el_form_item = c(
    gutter = "markup: the columns' layout, drawn by R",
    label = "markup: the form item's label, drawn by R",
    required = "markup: the form item's asterisk, drawn by R",
    spans = "markup: the columns' layout, drawn by R"
  ),
  el_header = "markup: a layout drawn as markup by R",
  el_icon = "markup: an icon is drawn by R",
  el_image = c(
    class = "markup: the root's attribute, drawn by R",
    style = "markup: the root's attribute, drawn by R",
    width = "markup: the mount point's style"
  ),
  el_image_viewer = c(
    url_list = "data",
    width = "markup: the mount point's style"
  ),
  el_infinite_scroll = c(
    height = "markup: the scrolling area's style",
    width = "markup: the mount point's style"
  ),
  el_link = c(
    underline = "markup: drawn by R as the link's class"
  ),
  el_main = "markup: a layout drawn as markup by R",
  el_mention = c(
    options = "data:records"
  ),
  el_menu = c(
    class = "markup: the root's attribute, drawn by R",
    items = "markup: the items, drawn by R",
    style = "markup: the root's attribute, drawn by R",
    width = "markup: the mount point's style"
  ),
  el_page_header = c(
    width = "markup: the mount point's style"
  ),
  el_pagination = c(
    page_sizes = "data",
    width = "markup: the mount point's style"
  ),
  el_popconfirm = c(
    reference = "markup: content drawn by R",
    width = "markup: the mount point's style"
  ),
  el_popover = c(
    body = "markup: content drawn by R",
    reference = "markup: content drawn by R",
    width = "markup: the mount point's style"
  ),
  el_radio_group = c(
    button = "markup: picks el-radio or el-radio-button",
    choices = "data:records",
    options = "alias:choices",
    value = "alias:selected"
  ),
  el_result = c(
    width = "markup: the mount point's style"
  ),
  el_row = "markup: a layout drawn as markup by R",
  el_rule = "markup: a rule goes to Element's validator as R writes it",
  el_scrollbar = c(
    width = "markup: the mount point's style"
  ),
  el_segmented = c(
    options = "data"
  ),
  el_select = c(
    choices = "data:records",
    multiple = "markup: one value or an array picks the template",
    option_template = "markup: drawn into each option by R",
    options = "alias:choices",
    props = "markup: renames the options' fields in R",
    value = "alias:selected"
  ),
  el_select_v2 = c(
    options = "data:records"
  ),
  el_skeleton = c(
    class = "markup: the root's attribute, drawn by R",
    style = "markup: the root's attribute, drawn by R",
    width = "markup: the mount point's style"
  ),
  el_skeleton_item = "markup: drawn by R",
  el_slider = c(
    range = "markup: one value or two picks the template",
    vertical = "markup: picks the template's layout"
  ),
  el_space = c(
    width = "markup: the mount point's style"
  ),
  el_splitter = c(
    width = "markup: the mount point's style"
  ),
  el_splitter_panel = c(
    width = "markup: the mount point's style"
  ),
  el_statistic = c(
    width = "markup: the mount point's style"
  ),
  el_step = "markup: a step is drawn by el_steps() from R",
  el_steps = c(
    steps = "markup: the steps, drawn by R",
    width = "markup: the mount point's style"
  ),
  el_table = c(
    columns = "data:records",
    loading = "markup: the output's mask, set from R",
    loading_options = "markup: the mask's attributes, set from R",
    rownames = "markup: read by R from the data",
    width = "markup: the mount point's style"
  ),
  el_table_column = "markup: a column is drawn from R; bind the table's `columns` instead",
  el_table_v2 = c(
    auto_resize = "markup: picks the template",
    methods = "markup: functions R places on the component",
    width = "markup: the mount point's style"
  ),
  el_tabs = c(
    add_icon = "markup: drawn by R",
    before_leave = "markup: set once, as the tabs are drawn",
    editable = "stands:closable,addable",
    tabs = "markup: the panes, drawn by R",
    value = "alias:selected"
  ),
  el_text = c(
    width = "markup: the mount point's style"
  ),
  el_timeline = c(
    html = "markup: picks how entries are drawn",
    items = "data:records",
    width = "markup: the mount point's style"
  ),
  el_tooltip = c(
    reference = "markup: content drawn by R",
    width = "markup: the mount point's style"
  ),
  el_tour = c(
    steps = "markup: the steps, drawn by R",
    width = "markup: the mount point's style"
  ),
  el_tour_step = "markup: a step is drawn by el_tour() from R",
  el_tree = c(
    props = "markup: renames the nodes' fields in R"
  ),
  el_tree_v2 = c(
    width = "markup: the mount point's style"
  ),
  el_upload = c(
    action = "markup: picks how files travel",
    name = "markup: the field files travel under",
    tip = "markup: drawn by R"
  ),
  el_watermark = c(
    width = "markup: the mount point's style"
  )
)

# An Element component's kinds: the form item's arguments where it has one
# (an `error`), then its own entry, which wins
.el_arg_kinds <- function(fn) {
  own <- .el_arg_registry[[fn]]
  if (length(own) == 1L && is.null(names(own))) {
    return(own)
  }
  args <- names(formals(get(fn, envir = asNamespace("shiny.element"))))
  widget <- if ("error" %in% args) {
    .el_arg_widget[intersect(names(.el_arg_widget), args)]
  }
  kinds <- c(widget, own)
  kinds[!duplicated(names(kinds), fromLast = TRUE)]
}

# Run first in an Element component: an argument R draws with refuses a
# binding, with the registry's why
.el_check_bindings <- function(fn, env) {
  .vue_check_bindings(fn, env, .el_arg_kinds(fn))
}

# The arguments of a component drawn as markup (a dialog, tabs) its binding
# follows: what is not markup, data, an alias or several fields in one
.el_bindable <- function(fn) {
  .vue_bindable(
    names(formals(get(fn, envir = asNamespace("shiny.element")))),
    .el_arg_kinds(fn),
    .el_arg_skip
  )
}

# A help page's sentence on bindings, as .el_events_md() writes its inputs
.el_args_md <- function(fn) {
  .vue_bindings_md(
    names(formals(get(fn, envir = asNamespace("shiny.element")))),
    .el_arg_kinds(fn),
    .el_arg_skip,
    library = "Element's"
  )
}
