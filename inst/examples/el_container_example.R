library(shiny)
library(shiny.element)

ui <- el_page(

  h3("Header + Main"),
  el_container(
    el_header("Header"),
    el_main("Main")
  ),

  h3("Header + Main + Footer"),
  el_container(
    el_header("Header"),
    el_main("Main"),
    el_footer("Footer")
  ),

  h3("Aside + Main"),
  el_container(
    el_aside("Aside", width = "200px"),
    el_main("Main")
  ),

  h3("Header + Aside + Main"),
  el_container(
    el_header("Header"),
    el_container(
      el_aside("Aside", width = "200px"),
      el_main("Main")
    )
  ),

  h3("Header + Aside + Main + Footer"),
  el_container(
    el_header("Header"),
    el_container(
      el_aside("Aside", width = "200px"),
      el_container(
        el_main("Main"),
        el_footer("Footer")
      )
    )
  ),

  h3("Aside + Header + Main"),
  el_container(
    el_aside("Aside", width = "200px"),
    el_container(
      el_header("Header"),
      el_main("Main")
    )
  ),

  h3("Aside + Header + Main + Footer"),
  el_container(
    id = "container7",
    el_aside("Aside", width = "200px"),
    el_container(
      id = "container7_inner",
      el_header("Header"),
      el_main("Main"),
      el_footer("Footer")
    )
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)
