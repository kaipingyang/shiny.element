# Element UI Confirmation Bubble

A small confirmation prompt anchored to the element that triggers it,
for actions that warrant a check but not a dialog.

## Usage

``` r
el_popconfirm(
  id = NULL,
  reference = NULL,
  title = NULL,
  confirm_button_text = NULL,
  cancel_button_text = NULL,
  confirm_button_type = NULL,
  cancel_button_type = NULL,
  icon = NULL,
  icon_color = NULL,
  hide_icon = NULL,
  width = NULL,
  slots = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Popconfirm ID. Auto-generated if `NULL`.

- reference:

  The element that opens the prompt. Any Shiny UI, including another
  shiny.element component – that component is folded into this one's Vue
  instance rather than nested inside it, so its inputs keep reporting.
  Its `update_el_*()` no longer reaches it, though.

- title:

  The question.

- confirm_button_text, cancel_button_text:

  Button labels.

- confirm_button_type, cancel_button_type:

  Button types, as in
  [`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md).
  Default `"primary"` and `"text"`.

- icon:

  Icon class shown beside the question.

- icon_color:

  Colour of that icon.

- hide_icon:

  Whether to leave the icon out. Default `FALSE`.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_confirm` – fires when the user confirms.

- `input$<id>_cancel` – fires when the user backs out.

Both are event inputs, so read them with
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html).

## Examples

``` r
el_popconfirm("del",
  reference = el$button(type = "danger", "Delete"),
  title = "Delete this row?"
)
#> <div id="del_container" style="display: contents">
#>   <el-popconfirm :title="pcTitle === null ? undefined : pcTitle" :confirm-button-text="pcConfirmButtonText === null ? undefined : pcConfirmButtonText" :cancel-button-text="pcCancelButtonText === null ? undefined : pcCancelButtonText" :confirm-button-type="pcConfirmButtonType === null ? undefined : pcConfirmButtonType" :cancel-button-type="pcCancelButtonType === null ? undefined : pcCancelButtonType" :icon="pcIcon === null ? undefined : pcIcon" :icon-color="pcIconColor === null ? undefined : pcIconColor" :hide-icon="pcHideIcon === null ? undefined : pcHideIcon" @onConfirm="handleConfirm" @onCancel="handleCancel">
#>     <span slot="reference">
#>       <el-button type="danger">Delete</el-button>
#>     </span>
#>   </el-popconfirm>
#> </div>
#> <div id="del" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="del">{"x":{"el":"#del_container","data":{"pcTitle":"Delete this row?","pcConfirmButtonText":null,"pcCancelButtonText":null,"pcConfirmButtonType":null,"pcCancelButtonType":null,"pcIcon":null,"pcIconColor":null,"pcHideIcon":null},"methods":{"handleConfirm":"function() { Shiny.setInputValue('del_confirm', true, {priority: 'event'}); }","handleCancel":"function() { Shiny.setInputValue('del_cancel', true, {priority: 'event'}); }"}},"evals":["methods.handleConfirm","methods.handleCancel"],"jsHooks":[]}</script>

if (interactive()) {
  library(shiny)
  ui <- el_page(
    el_popconfirm("del",
      reference = el$button(type = "danger", "Delete"),
      title = "Delete this row?")
  )
  server <- function(input, output, session) {
    observeEvent(input$del_confirm, {
      showNotification("Deleted")
    })
  }
  shinyApp(ui, server)
}
```
