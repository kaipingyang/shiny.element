# Element UI Dialog Component

Creates an Element UI dialog (modal) with Vue instance. The dialog
visibility can be controlled from the server via
[`update_el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/update_el_dialog.md).

## Usage

``` r
el_dialog(
  id = NULL,
  title = "",
  content = NULL,
  footer = NULL,
  visible = FALSE,
  width = "50%",
  fullscreen = FALSE,
  close_on_click_modal = TRUE,
  close_on_press_escape = TRUE,
  show_close = TRUE,
  center = FALSE,
  destroy_on_close = FALSE,
  append_to_body = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Dialog ID. Auto-generated UUID if `NULL`.

- title:

  Dialog title text. Default `""`.

- content:

  Optional tagList/tag for the dialog body. `NULL` for empty.

- footer:

  Optional tagList/tag for the dialog footer slot. `NULL` for none.

- visible:

  Whether the dialog is initially visible. Default `FALSE`.

- width:

  Dialog width. Default `"50%"`.

- fullscreen:

  Whether the dialog occupies the full screen. Default `FALSE`.

- close_on_click_modal:

  Whether clicking the overlay closes the dialog. Default `TRUE`.

- close_on_press_escape:

  Whether pressing Escape closes the dialog. Default `TRUE`.

- show_close:

  Whether to show the close button in the header. Default `TRUE`.

- center:

  Whether to align the header and footer to center. Default `FALSE`.

- destroy_on_close:

  Whether to destroy child components on close. Default `FALSE`.

- append_to_body:

  Whether to append the dialog to `document.body`. Default `FALSE`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed dialog component.

## Shiny input

`input$<id>_visible` — Logical (`TRUE` when dialog opens, `FALSE` when
it closes).

## Examples

``` r
# Basic dialog (initially hidden)
el_dialog(
  id      = "dlg1",
  title   = "My Dialog",
  content = shiny::tags$p("Dialog body text."),
  footer  = shiny::tagList(
    el_button("dlg_ok",  "OK",     type = "primary"),
    el_button("dlg_cancel", "Cancel")
  )
)
#> <div id="dlg1_container">
#>   <el-dialog :title="title" :visible.sync="visible" :width="width" :fullscreen="fullscreen" :close-on-click-modal="closeOnClickModal" :close-on-press-escape="closeOnPressEscape" :show-close="showClose" :center="center" :destroy-on-close="destroyOnClose" :append-to-body="appendToBody" @open="handleOpen" @close="handleClose">
#>     <p>Dialog body text.</p>
#>     <span slot="footer">
#>       <div id="dlg_ok_container">
#>         <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick">{{label}}</el-button>
#>       </div>
#>       <div class="vue html-widget html-fill-item" id="dlg_ok" style="width:960px;height:500px;"></div>
#>       <script type="application/json" data-for="dlg_ok">{"x":{"el":"#dlg_ok_container","data":{"label":"OK","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","count":0},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('dlg_ok', this.count); } }"}},"evals":["methods.handleClick"],"jsHooks":[]}</script>
#>       <div id="dlg_cancel_container">
#>         <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick">{{label}}</el-button>
#>       </div>
#>       <div class="vue html-widget html-fill-item" id="dlg_cancel" style="width:960px;height:500px;"></div>
#>       <script type="application/json" data-for="dlg_cancel">{"x":{"el":"#dlg_cancel_container","data":{"label":"Cancel","type":"default","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","count":0},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('dlg_cancel', this.count); } }"}},"evals":["methods.handleClick"],"jsHooks":[]}</script>
#>     </span>
#>   </el-dialog>
#> </div>
#> <div class="vue html-widget html-fill-item" id="dlg1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="dlg1">{"x":{"el":"#dlg1_container","data":{"title":"My Dialog","visible":false,"width":"50%","fullscreen":false,"closeOnClickModal":true,"closeOnPressEscape":true,"showClose":true,"center":false,"destroyOnClose":false,"appendToBody":false},"methods":{"handleOpen":"function() { Shiny.setInputValue('dlg1_visible', true); }","handleClose":"function() { Shiny.setInputValue('dlg1_visible', false); this.visible = false; }"}},"evals":["methods.handleOpen","methods.handleClose"],"jsHooks":[]}</script>

# Controlled open/close from server
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_button("open_btn", "Open Dialog", type = "primary"),
    el_dialog(
      id      = "dlg1",
      title   = "Confirm",
      content = shiny::tags$p("Are you sure?"),
      footer  = el_button("confirm_btn", "Yes", type = "danger")
    ),
    verbatimTextOutput("state")
  )
  server <- function(input, output, session) {
    observeEvent(input$open_btn, {
      update_el_dialog(session, "dlg1", visible = TRUE)
    })
    observeEvent(input$confirm_btn, {
      update_el_dialog(session, "dlg1", visible = FALSE)
    })
    output$state <- renderPrint(input$dlg1_visible)
  }
  shinyApp(ui, server)
}
```
