# Popover

A floating card, on hover, click, focus or by hand. `reference` is what
it hangs off; `content` its text, or `body` any markup, components
included.

## Basic usage

``` r

tagList(lapply(c("hover", "click", "focus"), function(t)
  el_popover(paste0("p_", t), reference = el$button(paste("Activated by", t)), trigger = t,
             title = "Title", popover_width = 200, placement = "top-start",
             content = "this is content, this is content, this is content")))
```

## Nested information

``` r

el_popover("addr", reference = el$button("Click to activate"), trigger = "click",
           popover_width = 400, placement = "right",
           body = el_table("addresses", data = data.frame(
             date = c("2016-05-02", "2016-05-04"), name = c("Jack", "Jack"),
             address = c("New York City", "New York City"))))
```

## Nested operation

`update_el_popover(value =)` shows and hides a manual one.

``` r

ui <- el_page(el_popover("confirm", trigger = "manual", popover_width = 160, placement = "top",
  reference = el_button("delete", "Delete"),
  body = tagList(tags$p("Are you sure to delete this?"),
                 el_button("no", "cancel", size = "mini", type = "text"),
                 el_button("yes", "confirm", size = "mini", type = "primary"))))

server <- function(input, output, session) {
  observeEvent(input$delete, update_el_popover(id = "confirm", value = TRUE))
  observeEvent(c(input$no, input$yes), update_el_popover(id = "confirm", value = FALSE), ignoreInit = TRUE)
}

shinyApp(ui, server)
```

![The operation example, running](../../shots/popover-operation.png)

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `trigger` | `trigger` | how the popover is triggered | string | click/focus/hover/manual | click |
| `title` | `title` | popover title | string | — | — |
| `content` | `content` | popover content, can be replaced with a default `slot` | string | — | — |
| `width` | `popover_width` | popover width | string, number | — | Min width 150px |
| `placement` | `placement` | popover placement | string | top/top-start/top-end/bottom/bottom-start/bottom-end/left/left-start/left-end/right/right-start/right-end | bottom |
| `disabled` | `disabled` | whether Popover is disabled | boolean | — | false |
| `value` | `update_el_popover(value =)` | whether popover is visible | Boolean | — | false |
| `offset` | `offset` | popover offset | number | — | 0 |
| `transition` | `transition` | popover transition animation | string | — | el-fade-in-linear |
| `visible-arrow` | `visible_arrow` | whether a tooltip arrow is displayed or not. For more info, please refer to [Vue-popper](https://github.com/element-component/vue-popper) | boolean | — | true |
| `popper-options` | `popper_options` | parameters for [popper.js](https://popper.js.org/docs/v2/) | object | please refer to [popper.js](https://popper.js.org/docs/v2/) | `{ boundariesElement: 'body', gpuAcceleration: false }` |
| `popper-class` | `popper_class` | custom class name for popover | string | — | — |
| `open-delay` | `open_delay` | delay before appearing when `trigger` is hover, in milliseconds | number | — | — |
| `close-delay` | `close_delay` | delay before disappearing when `trigger` is hover, in milliseconds | number | — | 200 |
| `tabindex` | `tabindex` | [tabindex](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/tabindex) of Popover | number | — | 0 |

### Slot

| Element | In R | Description |
|----|----|----|
| `reference` | `slots = list(reference = )` | HTML element that triggers popover |

### Events

| Element | In R | Description |
|----|----|----|
| `show` | `input$<id>_show` | triggers when popover shows |
| `after-enter` | `input$<id>_after_enter` | triggers when the entering transition ends |
| `hide` | `input$<id>_hide` | triggers when popover hides |
| `after-leave` | `input$<id>_after_leave` | triggers when the leaving transition ends |
