# One of each component that has methods, and every method Element Plus
# documents for it, with arguments where it needs them. test-browser-methods.R
# calls each through el_call()'s channel and fails on any that is missing or
# raises.

library(shiny)

tree_nodes <- list(
  list(id = 1, label = "One", children = list(list(id = 2, label = "Two"))),
  list(id = 3, label = "Three")
)
row <- function(i) el_table_row(i)
node <- function(key) el_tree_node(key)

# id, method, arguments (a list, or NULL for none)
cases <- list(
  list(id = "m_affix", method = "update"),
  list(id = "m_affix", method = "updateRoot"),
  list(id = "m_anchor", method = "scrollTo", args = list("#m_part")),
  list(id = "m_auto", method = "focus"),
  list(id = "m_auto", method = "blur"),
  list(id = "m_auto", method = "close"),
  list(id = "m_auto", method = "highlight", args = list(0)),
  list(id = "m_auto", method = "handleKeyEnter"),
  list(id = "m_auto", method = "handleSelect", args = list(list(value = "a"))),
  list(id = "m_auto", method = "getData", args = list("a")),
  list(id = "m_cal", method = "selectDate", args = list("next-month")),
  list(id = "m_car", method = "next"),
  list(id = "m_car", method = "prev"),
  list(id = "m_car", method = "setActiveItem", args = list(1)),
  list(id = "m_casc", method = "getCheckedNodes", args = list(FALSE)),
  list(id = "m_casc", method = "togglePopperVisible", args = list(FALSE)),
  list(id = "m_casc", method = "focus"),
  list(id = "m_casc", method = "blur"),
  list(id = "m_cpanel", method = "getCheckedNodes", args = list(FALSE)),
  list(id = "m_cpanel", method = "clearCheckedNodes"),
  list(id = "m_coll", method = "setActiveNames", args = list(list("a"))),
  list(id = "m_cpp", method = "update"),
  list(id = "m_color", method = "show"),
  list(id = "m_color", method = "hide"),
  list(id = "m_color", method = "focus"),
  list(id = "m_color", method = "blur"),
  list(id = "m_date", method = "focus"),
  list(id = "m_date", method = "blur"),
  list(id = "m_date", method = "handleOpen"),
  list(id = "m_date", method = "handleClose"),
  list(id = "m_dlg", method = "resetPosition"),
  list(id = "m_dlg", method = "handleClose"),
  list(id = "m_dd", method = "handleOpen"),
  list(id = "m_dd", method = "handleClose"),
  list(id = "m_form", method = "validate"),
  list(id = "m_form", method = "validateField", args = list("name")),
  list(id = "m_form", method = "clearValidate"),
  list(id = "m_form", method = "resetFields"),
  list(id = "m_form", method = "scrollToField", args = list("name")),
  list(id = "m_form", method = "getField", args = list("name")),
  list(
    id = "m_form",
    method = "setInitialValues",
    args = list(list(name = ""))
  ),
  list(
    id = "m_form",
    component = "ElFormItem",
    method = "validate",
    args = list("")
  ),
  list(id = "m_form", component = "ElFormItem", method = "resetField"),
  list(id = "m_form", component = "ElFormItem", method = "clearValidate"),
  list(
    id = "m_form",
    component = "ElFormItem",
    method = "setInitialValue",
    args = list("")
  ),
  list(id = "m_img", method = "showPreview"),
  list(id = "m_viewer", method = "setActiveItem", args = list(1)),
  list(id = "m_input", method = "focus"),
  list(id = "m_input", method = "blur"),
  list(id = "m_input", method = "select"),
  list(id = "m_input", method = "clear"),
  list(id = "m_area", method = "resizeTextarea"),
  list(id = "m_num", method = "focus"),
  list(id = "m_num", method = "blur"),
  list(id = "m_otp", method = "focus", args = list(0)),
  list(id = "m_otp", method = "blur"),
  list(id = "m_itag", method = "focus"),
  list(id = "m_itag", method = "blur"),
  list(id = "m_menu", method = "open", args = list("sub")),
  list(id = "m_menu", method = "close", args = list("sub")),
  list(id = "m_menu", method = "handleResize"),
  list(id = "m_menu", method = "updateActiveIndex", args = list("a")),
  list(id = "m_pc", method = "hide"),
  list(id = "m_pop", method = "hide"),
  list(id = "m_rate", method = "setCurrentValue", args = list(3)),
  list(id = "m_rate", method = "resetCurrentValue"),
  list(id = "m_scroll", method = "handleScroll"),
  list(id = "m_scroll", method = "scrollTo", args = list(0, 20)),
  list(id = "m_scroll", method = "setScrollTop", args = list(10)),
  list(id = "m_scroll", method = "setScrollLeft", args = list(0)),
  list(id = "m_scroll", method = "update"),
  list(id = "m_sel", method = "focus"),
  list(id = "m_sel", method = "blur"),
  list(id = "m_selv2", method = "focus"),
  list(id = "m_selv2", method = "blur"),
  list(id = "m_switch", method = "focus"),
  list(id = "m_table", method = "toggleRowSelection", args = list(row(1))),
  list(id = "m_table", method = "getSelectionRows"),
  list(id = "m_table", method = "getHalfSelectionRows"),
  list(id = "m_table", method = "toggleAllSelection"),
  list(id = "m_table", method = "clearSelection"),
  list(id = "m_table", method = "toggleRowExpansion", args = list(row(1))),
  list(id = "m_table", method = "setCurrentRow", args = list(row(2))),
  list(id = "m_table", method = "sort", args = list("x", "ascending")),
  list(id = "m_table", method = "clearSort"),
  list(id = "m_table", method = "clearFilter"),
  list(id = "m_table", method = "doLayout"),
  list(id = "m_table", method = "scrollTo", args = list(0, 0)),
  list(id = "m_table", method = "setScrollTop", args = list(0)),
  list(id = "m_table", method = "setScrollLeft", args = list(0)),
  list(id = "m_table", method = "updateKeyChildren", args = list("1", list())),
  list(id = "m_tv2", method = "scrollTo", args = list(list(scrollTop = 40))),
  list(id = "m_tv2", method = "scrollToLeft", args = list(0)),
  list(id = "m_tv2", method = "scrollToTop", args = list(20)),
  list(id = "m_tv2", method = "scrollToRow", args = list(10)),
  list(id = "m_time", method = "focus"),
  list(id = "m_time", method = "blur"),
  list(id = "m_time", method = "handleOpen"),
  list(id = "m_time", method = "handleClose"),
  list(id = "m_tsel", method = "focus"),
  list(id = "m_tsel", method = "blur"),
  list(id = "m_tip", method = "isFocusInsideContent"),
  list(id = "m_tip", method = "updatePopper"),
  list(id = "m_tip", method = "onOpen"),
  list(id = "m_tip", method = "onClose"),
  list(id = "m_tip", method = "hide"),
  list(id = "m_tr", method = "clearQuery", args = list("left")),
  list(id = "m_tsel2", method = "focus"),
  list(id = "m_tsel2", method = "blur"),
  list(id = "m_tree", method = "filter", args = list("O")),
  list(id = "m_tree", method = "filter", args = list("")),
  list(id = "m_tree", method = "getCheckedNodes"),
  list(id = "m_tree", method = "getCheckedKeys"),
  list(id = "m_tree", method = "setCheckedKeys", args = list(list(3))),
  list(id = "m_tree", method = "setCheckedNodes", args = list(list())),
  list(id = "m_tree", method = "setChecked", args = list(3, TRUE, FALSE)),
  list(id = "m_tree", method = "getHalfCheckedNodes"),
  list(id = "m_tree", method = "getHalfCheckedKeys"),
  list(id = "m_tree", method = "setCurrentKey", args = list(1)),
  list(id = "m_tree", method = "getCurrentKey"),
  list(id = "m_tree", method = "getCurrentNode"),
  list(id = "m_tree", method = "setCurrentNode", args = list(list(id = 3))),
  list(id = "m_tree", method = "getNode", args = list(1)),
  list(id = "m_tree", method = "updateKeyChildren", args = list(3, list())),
  list(
    id = "m_tree",
    method = "append",
    args = list(list(id = 9, label = "Nine"), 3)
  ),
  list(
    id = "m_tree",
    method = "insertBefore",
    args = list(list(id = 8, label = "Eight"), 3)
  ),
  list(
    id = "m_tree",
    method = "insertAfter",
    args = list(list(id = 7, label = "Seven"), 3)
  ),
  list(id = "m_tree", method = "remove", args = list(7)),
  list(id = "m_tv", method = "filter", args = list("O")),
  list(id = "m_tv", method = "getCheckedNodes"),
  list(id = "m_tv", method = "getCheckedKeys"),
  list(id = "m_tv", method = "setCheckedKeys", args = list(list(3))),
  list(id = "m_tv", method = "setChecked", args = list(3, FALSE)),
  list(id = "m_tv", method = "setExpandedKeys", args = list(list(1))),
  list(id = "m_tv", method = "getHalfCheckedNodes"),
  list(id = "m_tv", method = "getHalfCheckedKeys"),
  list(id = "m_tv", method = "setCurrentKey", args = list(1)),
  list(id = "m_tv", method = "getCurrentKey"),
  list(id = "m_tv", method = "getCurrentNode"),
  list(id = "m_tv", method = "getNode", args = list(1)),
  list(id = "m_tv", method = "expandNode", args = list(node(1))),
  list(id = "m_tv", method = "collapseNode", args = list(node(1))),
  list(id = "m_tv", method = "setData", args = list(tree_nodes)),
  list(id = "m_tv", method = "scrollTo", args = list(0)),
  list(id = "m_tv", method = "scrollToNode", args = list(3)),
  list(
    id = "m_up",
    method = "handleRemove",
    args = list(el_upload_file("a.txt"))
  ),
  list(id = "m_up", method = "abort"),
  list(id = "m_up", method = "submit"),
  list(id = "m_up", method = "clearFiles")
)

ui <- el_page(
  dev = TRUE,
  tags$div(id = "m_part", "part"),
  el_affix(id = "m_affix", tags$span("affixed")),
  el_anchor("m_anchor", links = list(list(title = "Part", href = "#m_part"))),
  el_autocomplete("m_auto"),
  el_calendar(
    "m_cal",
    value = Sys.Date(),
    range = c("2019-03-04", "2019-03-24")
  ),
  el_carousel(
    "m_car",
    height = "80px",
    items = list(
      list(name = "a", content = "A"),
      list(name = "b", content = "B")
    )
  ),
  el_cascader(
    "m_casc",
    options = list(list(value = "a", label = "A"))
  ),
  el_cascader_panel(
    "m_cpanel",
    options = list(list(value = "a", label = "A"))
  ),
  el_collapse(
    "m_coll",
    items = list(list(name = "a", title = "A", content = "a"))
  ),
  el_color_picker_panel("m_cpp", predefine = c("#ff4500", "#1e90ff")),
  el_color_picker("m_color"),
  el_date_picker("m_date"),
  el_dialog("m_dlg", title = "Dialog", content = "body"),
  el_dropdown("m_dd", items = list(list(command = "a", label = "A"))),
  el_form(
    id = "m_form",
    el_form_field("name", "input", label = "Name", required = TRUE),
    el_form_field(
      "city",
      "select",
      label = "City",
      choices = c("Beijing", "Shanghai")
    ),
    el_form_field(
      "pick",
      "radio-group",
      label = "Pick",
      choices = c(One = "1", Two = "2")
    )
  ),
  el_image(
    "m_img",
    src = "data:image/gif;base64,R0lGODlhAQABAAAAACw=",
    preview_src_list = list("data:image/gif;base64,R0lGODlhAQABAAAAACw=")
  ),
  el_image_viewer(
    "m_viewer",
    visible = TRUE,
    url_list = c(
      "data:image/gif;base64,R0lGODlhAQABAAAAACw=",
      "data:image/gif;base64,R0lGODlhAQABAAAAACw="
    )
  ),
  el_input("m_input", value = "text"),
  el_input("m_area", type = "textarea", autosize = TRUE),
  el_input_number("m_num"),
  el_input_otp("m_otp"),
  el_input_tag("m_itag"),
  el_menu(
    "m_menu",
    items = list(
      list(index = "a", label = "A"),
      list(
        index = "sub",
        label = "Sub",
        children = list(list(index = "s1", label = "S1"))
      )
    )
  ),
  el_popconfirm("m_pc", reference = el$button("pc"), title = "Sure?"),
  el_popover("m_pop", reference = el$button("pop"), content = "c"),
  el_rate("m_rate"),
  el_scrollbar(
    id = "m_scroll",
    height = "40px",
    tags$div(style = "height: 200px", "tall")
  ),
  el_select("m_sel", choices = c("a", "b")),
  el_select_v2("m_selv2", options = list(list(value = "a", label = "A"))),
  el_switch("m_switch"),
  el_table(
    id = "m_table",
    data = data.frame(x = 1:3, y = c("a", "b", "c")),
    selection = TRUE,
    row_key = "x",
    height = 120
  ),
  el_table_v2(
    "m_tv2",
    data = data.frame(x = 1:100),
    table_v2_width = 300,
    height = 120
  ),
  el_time_picker("m_time"),
  el_time_select("m_tsel"),
  el_tooltip("m_tip", el$button("tip"), content = "hint"),
  el_transfer("m_tr", data = data.frame(key = 1:2, label = c("a", "b"))),
  el_tree_select("m_tsel2", data = list(list(value = "a", label = "A"))),
  el_tree("m_tree", data = tree_nodes, show_checkbox = TRUE),
  el_tree_v2(
    "m_tv",
    data = tree_nodes,
    show_checkbox = TRUE,
    props = list(value = "id", label = "label", children = "children"),
    height = 120
  ),
  el_upload(
    "m_up",
    auto_upload = FALSE,
    file_list = list(list(name = "a.txt", url = "a.txt"))
  ),
  # Element Plus props reached through R names that differ, and the ways
  # R stands in for what upstream writes in JavaScript
  el_tooltip(
    "p_tip",
    el$button("clickme"),
    content = "clicked",
    trigger = "click"
  ),
  el_popconfirm(
    "p_pc",
    reference = el$button("wide"),
    title = "Sure?",
    popconfirm_width = 420
  ),
  el_button("p_vbtn", "virtual"),
  el_popover(
    "p_vpop",
    content = "virtual popover",
    trigger = "click",
    virtual_ref = "#p_vbtn"
  ),
  el_table_v2(
    "p_tv",
    data = data.frame(x = 1:3),
    table_v2_width = 200,
    height = 150,
    slots = list(
      cell = template(
        HTML(
          '<button class="p-set" @click="$setInput(\'p_set\', rowData.x)">{{ rowData.x }}</button>'
        ),
        slot = "cell",
        scope = "{ rowData }"
      )
    )
  ),
  el_tree("p_lazy", lazy = TRUE, is_leaf_field = "leaf"),
  # a virtual_ref target the server draws after the tooltip has mounted
  el_tooltip(
    "p_late_tip",
    content = "late target",
    trigger = "click",
    virtual_ref = "#p_late_btn"
  ),
  uiOutput("p_late"),
  # a selector matching one target at first, a second one added later
  tags$button(class = "p-grow", "grow 1"),
  tags$div(id = "p_grow_box"),
  el_tooltip(
    "p_grow_tip",
    content = "grown",
    trigger = "click",
    virtual_ref = ".p-grow"
  ),
  el_select("p_multi", choices = c("a", "b", "c"), multiple = TRUE),
  el_table_v2(
    "p_tv_tree",
    data = list(
      list(id = "r1", x = "one", children = list(list(id = "r1c", x = "child")))
    ),
    columns = list(list(key = "x", dataKey = "x", title = "X", width = 150)),
    expand_column_key = "x",
    table_v2_width = 300,
    height = 150
  ),
  tags$script(HTML(sprintf(
    "window.methodCases = %s;",
    jsonlite::toJSON(cases, auto_unbox = TRUE, null = "null")
  )))
)

server <- function(input, output, session) {
  late <- reactiveVal(FALSE)
  later::later(function() late(TRUE), 2)
  # one value for a field that holds several
  observeEvent(input$p_do_update, {
    update_el_select(id = "p_multi", selected = "b")
    update_el_table_v2(id = "p_tv_tree", expanded_row_keys = "r1")
  })
  output$p_late <- renderUI({
    if (late()) el_button("p_late_btn", "late")
  })
  # the first load of a node fails, the second succeeds
  tries <- 0
  observeEvent(input$p_lazy_load, {
    q <- input$p_lazy_load
    if (q$level == 0) {
      el_load_children(
        id = "p_lazy",
        request = q,
        children = list(list(label = "region"))
      )
    } else {
      tries <<- tries + 1
      if (tries == 1) {
        el_load_children(id = "p_lazy", request = q, reject = TRUE)
      } else {
        el_load_children(
          id = "p_lazy",
          request = q,
          children = list(list(label = "zone", leaf = TRUE))
        )
      }
    }
  })
}

shinyApp(ui, server)
