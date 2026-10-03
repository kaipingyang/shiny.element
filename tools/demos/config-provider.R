## usage
#' The page's language and z-index are `el_page(locale =, z_index =)`, given
#' to every component; a config provider sets the rest for what is inside it
#' -- here the size of a table's pagination and input.
el_config_provider(size = "small",
  el_input("cfg_inp", placeholder = "Small, from the provider"),
  el_pagination("cfg_pg", total = 100))

## button
el_config_provider(button = list(autoInsertSpace = TRUE, plain = TRUE, round = TRUE, type = "primary"),
  el_button("cfg_b1", "中文"), el_button("cfg_b2", "Button"))

## link
el_config_provider(link = list(type = "success", underline = "always"),
  el_link("Link", id = "cfg_link"))

## card
el_config_provider(card = list(shadow = "hover"), el_card("Card desu!"))

## dialog
#| shot_js = "document.querySelector('#shot .el-button').click()", shot_sel = ".el-overlay"
el_config_provider(dialog = list(alignCenter = TRUE, draggable = TRUE),
  el_button("cfg_open", "Open dialog"),
  el_dialog("cfg_dlg", title = "Tips", content = "This is a message"))

## message !skip
A message sent with `el_message()` is not inside any component, so a config
provider's `message` settings do not reach it; give `el_message()` its
`plain`, `placement` and `grouping` instead.

## empty-values
el_config_provider(value_on_clear = NULL, empty_values = list(NULL),
  el_select("cfg_sel", choices = c("Option1", "Option2", "Option3"), clearable = TRUE,
            placeholder = "Select", width = "240px"))

## table
el_config_provider(table = list(showOverflowTooltip = TRUE, tooltipEffect = "light"),
  el_table("cfg_t2", data = data.frame(date = "2016-05-03", name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a very long address that overflows")))
