## layout-hm
el_container(el_header("Header"), el_main("Main"))

## layout-hmf
el_container(el_header("Header"), el_main("Main"), el_footer("Footer"))

## layout-am
el_container(el_aside(width = "200px", "Aside"), el_main("Main"), el_aside(width = "200px", "Aside"))

## layout-ham
el_container(el_header("Header"),
             el_container(el_aside(width = "200px", "Aside"), el_main("Main")))

## layout-hamf
el_container(el_header("Header"),
  el_container(el_aside(width = "200px", "Aside"),
               el_container(el_main("Main"), el_footer("Footer"))))

## layout-ahm
el_container(el_aside(width = "200px", "Aside"),
             el_container(el_header("Header"), el_main("Main")))

## layout-ahmf
el_container(el_aside(width = "200px", "Aside"),
             el_container(el_header("Header"), el_main("Main"), el_footer("Footer")))

## example
el_container(style = "height: 400px; border: 1px solid var(--el-border-color)",
  el_aside(width = "200px",
    el_menu("ctr_menu", active = "1-1", items = list(
      list(index = "1", title = "Navigator One", icon = "Message", children = list(
        list(index = "1-1", label = "Option 1"), list(index = "1-2", label = "Option 2"))),
      list(index = "2", title = "Navigator Two", icon = "Menu", children = list(
        list(index = "2-1", label = "Option 1")))))),
  el_container(
    el_header(style = "text-align: right; font-size: 12px", tags$span("Tom")),
    el_main(el_table("ctr_tbl", data = data.frame(
      Date = rep("2016-05-02", 4), Name = rep("Tom", 4),
      Address = rep("No. 189, Grove St, Los Angeles", 4))))))
