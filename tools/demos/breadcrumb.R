## basic
el_breadcrumb(
  "crumbs",
  separator = "/",
  items = list(
    el_breadcrumb_item("homepage", to = "/"),
    el_breadcrumb_item("promotion management"),
    el_breadcrumb_item("promotion list"),
    el_breadcrumb_item("promotion detail")
  )
)

## icon
el_breadcrumb(
  "crumbs_icon",
  separator_icon = "ArrowRight",
  items = list(
    el_breadcrumb_item("homepage", to = "/"),
    el_breadcrumb_item("promotion management"),
    el_breadcrumb_item("promotion list"),
    el_breadcrumb_item("promotion detail")
  )
)
