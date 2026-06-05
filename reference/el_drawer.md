# Element UI Drawer

A panel that slides in from the edge of the screen. Behaviour and API
mirror
[`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md)
but with a directional slide animation.

## Usage

``` r
el_drawer(
  id = NULL,
  title = "",
  content = NULL,
  visible = FALSE,
  direction = "rtl",
  size = "30%",
  modal = TRUE,
  with_header = TRUE,
  show_close = TRUE,
  wrapper_closable = TRUE,
  close_on_press_escape = TRUE,
  destroy_on_close = FALSE,
  append_to_body = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Drawer ID. Auto-generated UUID if `NULL`.

- title:

  Drawer title text. Default `""`.

- content:

  Content for the drawer body (tag or tagList). `NULL` for empty.

- visible:

  Whether the drawer is initially visible. Default `FALSE`.

- direction:

  Slide direction: `"rtl"` (right-to-left, default), `"ltr"`, `"ttb"`
  (top-to-bottom), `"btt"`.

- size:

  Drawer width (horizontal) or height (vertical). Numeric pixels or CSS
  string. Default `"30%"`.

- modal:

  Whether to show a background overlay. Default `TRUE`.

- with_header:

  Whether to render the header bar. Default `TRUE`.

- show_close:

  Whether to show the × close button. Default `TRUE`.

- wrapper_closable:

  Whether clicking the overlay closes the drawer. Default `TRUE`.

- close_on_press_escape:

  Whether pressing Escape closes the drawer. Default `TRUE`.

- destroy_on_close:

  Whether to destroy child components on close. Default `FALSE`.

- append_to_body:

  Whether to append the drawer to `document.body`. Default `FALSE`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed drawer component.

## Shiny input

`input$<id>_visible` — Logical (`TRUE` when the drawer opens, `FALSE`
when it closes).

## Examples

``` r
el_drawer("drw1", title = "Settings", content = shiny::tags$p("Settings here."))
#> <div id="drw1_container">
#>   <el-drawer :title="title" :visible.sync="visible" :direction="direction" :size="size" :modal="modal" :with-header="withHeader" :show-close="showClose" :wrapper-closable="wrapperClosable" :close-on-press-escape="closeOnPressEscape" :destroy-on-close="destroyOnClose" :append-to-body="appendToBody" @open="handleOpen" @close="handleClose">
#>     <p>Settings here.</p>
#>   </el-drawer>
#> </div>
#> <div class="vue html-widget html-fill-item" id="drw1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="drw1">{"x":{"el":"#drw1_container","data":{"title":"Settings","visible":false,"direction":"rtl","size":"30%","modal":true,"withHeader":true,"showClose":true,"wrapperClosable":true,"closeOnPressEscape":true,"destroyOnClose":false,"appendToBody":false},"methods":{"handleOpen":"function() { Shiny.setInputValue('drw1_visible', true); }","handleClose":"function() { Shiny.setInputValue('drw1_visible', false); this.visible = false; }"}},"evals":["methods.handleOpen","methods.handleClose"],"jsHooks":[]}</script>
```
