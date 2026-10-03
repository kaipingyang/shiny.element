# Element Plus Confirmation Bubble

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
  effect = NULL,
  hide_after = NULL,
  persistent = NULL,
  teleported = NULL,
  width = NULL,
  slots = NULL,
  session = NULL,
  placement = NULL
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

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- hide_after:

  Delay of disappear, in millisecond. Element Plus's `hide-after`
  (number).

- persistent:

  When popconfirm inactive and `persistent` is `false` , popconfirm will
  be destroyed. Element Plus's `persistent` (boolean).

- teleported:

  Whether popconfirm is teleported to the body. Element Plus's
  `teleported` (boolean).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

- placement:

  Where the popup goes: `"top"`, `"bottom-start"` and the rest of the
  tooltip's placements. Passed through to its tooltip, as upstream
  passes it. Default `"bottom"`.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_confirm` – fires when the user confirms.

- `input$<id>_cancel` – fires when the user backs out.

Both are event inputs, so read them with
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html).

## Examples

``` r
el_popconfirm(
  "del",
  reference = el$button(type = "danger", "Delete"),
  title = "Delete this row?"
)
#> <div id="del" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="del_container" style="display: contents">
#>   <el-popconfirm :title="pcTitle === null ? undefined : pcTitle" :confirm-button-text="pcConfirmButtonText === null ? undefined : pcConfirmButtonText" :cancel-button-text="pcCancelButtonText === null ? undefined : pcCancelButtonText" :confirm-button-type="pcConfirmButtonType === null ? undefined : pcConfirmButtonType" :cancel-button-type="pcCancelButtonType === null ? undefined : pcCancelButtonType" :icon="pcIcon === null ? undefined : pcIcon" :icon-color="pcIconColor === null ? undefined : pcIconColor" :hide-icon="pcHideIcon === null ? undefined : pcHideIcon" @confirm="handleConfirm" @cancel="handleCancel" :effect="pcEffect === null ? undefined : pcEffect" :hide-after="pcHideAfter === null ? undefined : pcHideAfter" :persistent="pcPersistent === null ? undefined : pcPersistent" :teleported="pcTeleported === null ? undefined : pcTeleported" :placement="pcPlacement === null ? undefined : pcPlacement">
#>     <template v-slot:reference>
#>       <span>
#>         <el-button type="danger">Delete</el-button>
#>       </span>
#>     </template>
#>   </el-popconfirm>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"pcTitle":"Delete this row?","pcConfirmButtonText":null,"pcCancelButtonText":null,"pcConfirmButtonType":null,"pcCancelButtonType":null,"pcIcon":null,"pcIconColor":null,"pcHideIcon":null,"pcEffect":null,"pcHideAfter":null,"pcPersistent":null,"pcTeleported":null,"pcPlacement":null},"methods":{"handleConfirm":"function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('del_confirm', true, {priority: 'event'}); }","handleCancel":"function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('del_cancel', true, {priority: 'event'}); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleConfirm","options.methods.handleCancel"]}</script>
#> </div>

if (interactive()) {
  library(shiny)
  ui <- el_page(
    el_popconfirm(
      "del",
      reference = el$button(type = "danger", "Delete"),
      title = "Delete this row?"
    )
  )
  server <- function(input, output, session) {
    observeEvent(input$del_confirm, {
      showNotification("Deleted")
    })
  }
  shinyApp(ui, server)
}
```
