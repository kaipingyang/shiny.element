## basic
el_mention("mention", value = "@", width = "320px", placeholder = "Please input",
           options = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"))

## props
el_mention("mention_props", value = "@", width = "320px", placeholder = "Please input",
           props = list(label = "name", value = "id", disabled = "unable"),
           options = list(list(name = "Fuphoenixes", id = "1"), list(name = "kooriookami", id = "2"),
                          list(name = "Jeremy", id = "3", unable = TRUE)))

## textarea
el_mention("mention_area", type = "textarea", width = "320px", placeholder = "Please input",
           options = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"))

## label
el_mention("mention_label", width = "320px", placeholder = "Please input",
  options = c("Fuphoenixes", "kooriookami", "Jeremy", "btea"),
  slots = list(label = template(htmltools::HTML(
    "<div style=\"display: flex; align-items: center\"><el-avatar :size=\"24\" style=\"margin-right: 8px\">{{ item.label.charAt(0) }}</el-avatar><span>{{ item.label }}</span></div>"),
    slot = "label", scope = "{ item }")))

## loading
#' `input$<id>_search` is the text after the trigger, as it is typed; the
#' server answers with `update_el_mention()` and `loading`.
el_mention("mention_load", width = "320px", placeholder = "Please input", loading = TRUE)

## prefix
el_mention("mention_prefix", width = "320px", placeholder = "Please input",
           prefix = c("@", "#"), options = c("Fuphoenixes", "kooriookami", "Jeremy"))

## whole
el_mention("mention_whole", value = "@Fuphoenixes ", whole = TRUE, width = "320px",
           options = c("Fuphoenixes", "kooriookami", "Jeremy"))

## form
el_form(id = "mention_form", submit_label = "Submit", label_width = "auto", width = "480px",
  el_form_field("message", "input", label = "Message",
                rules = el_rule(required = TRUE, message = "Please input a message")))
