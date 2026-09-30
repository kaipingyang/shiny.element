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
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Popconfirm ID. Auto-generated if `NULL`.

- reference:

  The element that opens the prompt. Markup only – raw Element tags from
  [el](https://kaipingyang.github.io/shiny.element/reference/el.md), or
  ordinary Shiny UI. It cannot be another shiny.element component: the
  prompt compiles this into its own Vue instance, which would discard a
  mounted one.

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
#>   <el-popconfirm :title="title === null ? undefined : title" :confirm-button-text="confirmButtonText === null ? undefined : confirmButtonText" :cancel-button-text="cancelButtonText === null ? undefined : cancelButtonText" :confirm-button-type="confirmButtonType === null ? undefined : confirmButtonType" :cancel-button-type="cancelButtonType === null ? undefined : cancelButtonType" :icon="icon === null ? undefined : icon" :icon-color="iconColor === null ? undefined : iconColor" :hide-icon="hideIcon === null ? undefined : hideIcon" @onConfirm="handleConfirm" @onCancel="handleCancel">
#>     <span slot="reference">
#>       <el-button type="danger">Delete</el-button>
#>     </span>
#>   </el-popconfirm>
#> </div>
#> <div id="del" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="del">{"x":{"el":"#del_container","data":{"title":"Delete this row?","confirmButtonText":null,"cancelButtonText":null,"confirmButtonType":null,"cancelButtonType":null,"icon":null,"iconColor":null,"hideIcon":null},"methods":{"handleConfirm":"function() { Shiny.setInputValue('del_confirm', true, {priority: 'event'}); }","handleCancel":"function() { Shiny.setInputValue('del_cancel', true, {priority: 'event'}); }"}},"evals":["methods.handleConfirm","methods.handleCancel"],"jsHooks":[]}</script>

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
