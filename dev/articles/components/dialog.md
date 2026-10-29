# Dialog

Informs users while preserving the current page state.

## Basic usage

Dialog pops up a dialog box, and it’s quite customizable.

Set `model-value / v-model` attribute with a `Boolean`, and Dialog shows
when it is `true`. The Dialog has two parts: `body` and `footer`, and
the latter requires a `slot` named `footer`. The optional `title`
attribute (empty by default) is for defining a title. Finally, this
example demonstrates how `before-close` is used.

The dialog’s `visible` follows a store’s field, \[vue_bind()\]: the
button sets it, and closing the dialog – its cross, Escape, the mask, a
button in its footer – sets it back, in the browser. `before_close`, a
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
function, may hold the close back. In an app the server opens it too,
`update_el_dialog(visible = TRUE)`, and `input$<id>` is whether it is
open.

``` r

vue_store("basic", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open the Dialog",
  plain = TRUE,
  on = list(click = "$store.basic.visible = true")
)
el_dialog(
  "tips",
  title = "Tips",
  width = "500px",
  visible = vue_bind("$store.basic.visible"),
  content = tags$span("This is a message"),
  before_close = JS(
    "function(done) { if (confirm('Are you sure to close this dialog?')) done(); }"
  ),
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$store.basic.visible = false")
    ),
    el_button(
      "confirm",
      "Confirm",
      type = "primary",
      on = list(click = "$store.basic.visible = false")
    )
  )
)
```

Tips

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

This is a message

> **Tip**
>
> `before-close` only works when user clicks the close icon or the
> backdrop. If you have buttons that close the Dialog in the `footer`
> named slot, you can add what you would do with `before-close` in the
> buttons’ click event handler.

## Customized Content

The content of Dialog can be anything, even a table or a form. This
example shows how to use Element Plus Table and Form with Dialog.

``` r

vue_store("form_dialog", state = list(visible = FALSE))
el_button(
  "open",
  "Open a Form nested Dialog",
  plain = TRUE,
  on = list(click = "$store.form_dialog.visible = true")
)
el_dialog(
  "shipping",
  title = "Shipping address",
  width = "500px",
  visible = vue_bind("$store.form_dialog.visible"),
  content = tagList(
    el_input(
      "name",
      label = "Promotion name",
      label_position = "left",
      label_width = "140px"
    ),
    el_select(
      "zone",
      choices = c("Zone No.1" = "shanghai", "Zone No.2" = "beijing"),
      placeholder = "Please select a zone",
      label = "Zones",
      label_position = "left",
      label_width = "140px"
    )
  ),
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$store.form_dialog.visible = false")
    ),
    el_button(
      "confirm",
      "Confirm",
      type = "primary",
      on = list(click = "$store.form_dialog.visible = false")
    )
  )
)
```

Shipping address

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

## Customized Header

The `header` slot can be used to customize the area where the title is
displayed. In order to maintain accessibility, use the `title` attribute
in addition to using this slot, or use the `titleId` slot property to
specify which element should be read out as the dialog title.

The title takes markup: a header of your own.

``` r

vue_store("header_dialog", state = list(visible = FALSE))
el_button(
  "open",
  "Open Dialog with customized header",
  plain = TRUE,
  on = list(click = "$store.header_dialog.visible = true")
)
el_dialog(
  "custom",
  show_close = FALSE,
  width = "500px",
  visible = vue_bind("$store.header_dialog.visible"),
  title = tags$div(
    style = "display: flex; justify-content: space-between; align-items: center",
    tags$h4("This is a custom header!"),
    el_button(
      "close",
      "Close",
      type = "danger",
      icon = "CircleCloseFilled",
      on = list(click = "$store.header_dialog.visible = false")
    )
  ),
  content = "This is dialog content."
)
```

#### This is a custom header!

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

This is dialog content.

## Nested Dialog

If a Dialog is nested in another Dialog, `append-to-body` is required.

Normally we do not recommend using nested Dialog. If you need multiple
Dialogs rendered on the page, you can simply flat them so that they’re
siblings to each other. If you must nest a Dialog inside another Dialog,
set `append-to-body` of the nested Dialog to true, and it will append to
body instead of its parent node, so both Dialogs can be correctly
rendered.

``` r

vue_store("nested", state = list(outer = FALSE, inner = FALSE))
el_button(
  "open",
  "Open the outer Dialog",
  plain = TRUE,
  on = list(click = "$store.nested.outer = true")
)
el_dialog(
  "outer",
  title = "Outer Dialog",
  width = "800px",
  visible = vue_bind("$store.nested.outer"),
  content = tagList(
    tags$span("This is the outer Dialog"),
    el_dialog(
      "inner",
      title = "Inner Dialog",
      width = "500px",
      append_to_body = TRUE,
      visible = vue_bind("$store.nested.inner"),
      content = "This is the inner Dialog"
    )
  ),
  footer = el_button(
    "inner_open",
    "Open the inner Dialog",
    type = "primary",
    on = list(click = "$store.nested.inner = true")
  )
)
```

Outer Dialog

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

This is the outer Dialog

Inner Dialog

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

This is the inner Dialog

## Centered content

Dialog’s content can be centered.

Setting `center` to `true` will center dialog’s header and footer
horizontally. `center` only affects Dialog’s header and footer. The body
of Dialog can be anything, so sometimes it may not look good when
centered. You need to write some CSS if you wish to center the body as
well.

``` r

vue_store("centered", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open the Dialog",
  plain = TRUE,
  on = list(click = "$store.centered.visible = true")
)
el_dialog(
  "warn",
  title = "Warning",
  width = "500px",
  center = TRUE,
  visible = vue_bind("$store.centered.visible"),
  content = "It should be noted that the content will not be aligned in center by default",
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$store.centered.visible = false")
    ),
    el_button(
      "confirm",
      "Confirm",
      type = "primary",
      on = list(click = "$store.centered.visible = false")
    )
  )
)
```

Warning

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

It should be noted that the content will not be aligned in center by
default

> **Tip**
>
> The content of Dialog is lazily rendered, which means the default slot
> is not rendered onto the DOM until it is firstly opened. Therefore, if
> you need to perform a DOM manipulation or access a component using
> `ref`, do it in the `open` event callback.

## Align Center dialog

Open dialog from the center of the screen.

Setting `align-center` to `true` will center the dialog both
horizontally and vertically. The prop `top` will not work at the same
time because the dialog is vertically centered in a flexbox.

``` r

vue_store("aligned", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open the Dialog",
  plain = TRUE,
  on = list(click = "$store.aligned.visible = true")
)
el_dialog(
  "warn",
  title = "Warning",
  width = "500px",
  align_center = TRUE,
  visible = vue_bind("$store.aligned.visible"),
  content = "Open the dialog from the center from the screen",
  footer = tagList(
    el_button(
      "cancel",
      "Cancel",
      on = list(click = "$store.aligned.visible = false")
    ),
    el_button(
      "confirm",
      "Confirm",
      type = "primary",
      on = list(click = "$store.aligned.visible = false")
    )
  )
)
```

Warning

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

Open the dialog from the center from the screen

## Destroy on Close

When this is feature is enabled, the content under default slot will be
destroyed with a `v-if` directive. Enable this when you have perf
concerns.

Note that by enabling this feature, the content will not be rendered
before `transition.beforeEnter` dispatched, there will only be `overlay`
`header(if any)` `footer(if any)`.

Its content made again each time it opens: inputs inside start fresh.

``` r

vue_store("notice_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open Dialog",
  plain = TRUE,
  on = list(click = "$store.notice_ui.visible = true")
)
el_dialog(
  "notice",
  title = "Notice",
  width = "500px",
  destroy_on_close = TRUE,
  center = TRUE,
  visible = vue_bind("$store.notice_ui.visible"),
  content = tagList(
    tags$p(
      "Notice: before dialog gets opened for the first time this node and the one below will not be rendered"
    ),
    el_input("note", placeholder = "starts empty each time")
  )
)
```

Notice

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

Notice: before dialog gets opened for the first time this node and the
one below will not be rendered

## Draggable Dialog

Try to drag the `header` part.

Set `draggable` to `true` to drag. Set `overflow` 2.5.4 to `true` can
drag overflow the viewport.

``` r

vue_store("drag_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Click to open Dialog",
  plain = TRUE,
  on = list(click = "$store.drag_ui.visible = true")
)
el_dialog(
  "drag",
  title = "Tips",
  width = "500px",
  draggable = TRUE,
  visible = vue_bind("$store.drag_ui.visible"),
  content = "It's a draggable Dialog"
)
```

Tips

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

It's a draggable Dialog

> **Tip**
>
> When using `modal` = false, please make sure that `append-to-body` was
> set to **true**, because `Dialog` was positioned by
> `position: relative`, when `modal` gets removed, `Dialog` will
> position itself based on the current position in the DOM, instead of
> `Document.Body`, thus the style will be messed up.

## Fullscreen

Set the `fullscreen` attribute to open fullscreen dialog.

``` r

vue_store("full_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Open the fullscreen Dialog",
  plain = TRUE,
  on = list(click = "$store.full_ui.visible = true")
)
el_dialog(
  "full",
  title = "Tips",
  fullscreen = TRUE,
  visible = vue_bind("$store.full_ui.visible"),
  content = "It's a fullscreen Dialog"
)
```

Tips

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

It's a fullscreen Dialog

> **Tip**
>
> If `fullscreen` is true, `width` `top` `draggable` attributes don’t
> work.

## Modal

Setting `modal` to `false` will hide modal (overlay) of dialog.

Starting from version 2.10.5, `modal-penetrable` attribute is added,
which can be penetrable.

Without a backdrop the page beneath stays in view, and with
`modal_penetrable` it can be used too.

``` r

vue_store("nomodal_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Open the modal-less Dialog",
  plain = TRUE,
  on = list(click = "$store.nomodal_ui.visible = true")
)
el_dialog(
  "nomodal",
  title = "Tips",
  width = "500px",
  modal = FALSE,
  modal_penetrable = TRUE,
  visible = vue_bind("$store.nomodal_ui.visible"),
  content = "It's a modal-less Dialog"
)
```

Tips

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

It's a modal-less Dialog

## Custom Animation

Customize dialog animation through the `transition` attribute, which
accepts either:

- ​Transition name​​ (string)

- ​​Vue transition configuration​​ (object)

Examples include scale, slide, fade, bounce animations and object-based
configurations with custom event handlers.

`transition` names a CSS animation of your own, as Element Plus’s does.

``` r

tags$style(".dialog-bounce-enter-active { animation: dialog-fade-in .5s; }")
vue_store("anim_ui", state = list(visible = FALSE))
el_button(
  "open",
  "Open the Dialog",
  plain = TRUE,
  on = list(click = "$store.anim_ui.visible = true")
)
el_dialog(
  "anim",
  title = "Custom animation",
  width = "500px",
  transition = "dialog-bounce",
  visible = vue_bind("$store.anim_ui.visible"),
  content = "This dialog plays an animation of its own."
)
```

Custom animation

*![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxMDI0IDEwMjQiPjxwYXRoIGZpbGw9ImN1cnJlbnRDb2xvciIgZD0iTTc2NC4yODggMjE0LjU5MiA1MTIgNDY2Ljg4IDI1OS43MTIgMjE0LjU5MmEzMS45MzYgMzEuOTM2IDAgMCAwLTQ1LjEyIDQ1LjEyTDQ2Ni43NTIgNTEyIDIxNC41MjggNzY0LjIyNGEzMS45MzYgMzEuOTM2IDAgMSAwIDQ1LjEyIDQ1LjE4NEw1MTIgNTU3LjE4NGwyNTIuMjg4IDI1Mi4yODhhMzEuOTM2IDMxLjkzNiAwIDAgMCA0NS4xMi00NS4xMkw1NTcuMTIgNTEyLjA2NGwyNTIuMjg4LTI1Mi4zNTJhMzEuOTM2IDMxLjkzNiAwIDEgMC00NS4xMi00NS4xODR6IiAvPjwvc3ZnPg==)*

This dialog plays an animation of its own.

> **Tip**
>
> Animation classes are dynamically generated based on the transition
> name. For granular control over animation behavior, you may explicitly
> define these classes. Refer to
> [custom-transition-classes](https://vuejs.org/guide/built-ins/transition.html#custom-transition-classes)
> for details.

## Events

Open developer console (ctrl + shift + J), to see order of events.

`input$<id>_closed` is reported unasked; `_open`, `_opened`, `_close`,
`_open_auto_focus` and `_close_auto_focus` when asked for, with
`events`.

``` r

ui <- el_page(
  el_button("open", "Open the Dialog", plain = TRUE),
  el_dialog(
    "ev",
    title = "Events",
    width = "500px",
    events = c("open", "opened", "close"),
    content = verbatimTextOutput("log")
  )
)
server <- function(input, output, session) {
  seen <- reactiveVal(character())
  for (e in c("open", "opened", "close", "closed")) {
    local({
      e <- e
      observeEvent(input[[paste0("ev_", e)]], seen(c(seen(), e)))
    })
  }
  output$log <- renderText(paste(seen(), collapse = "\n"))
  observeEvent(input$open, update_el_dialog(id = "ev", visible = TRUE))
}
shinyApp(ui, server)
```

![The events example, running](../../shots/dialog-events.png)

## In Shiny

From the server, `update_el_dialog(visible = TRUE)` opens a dialog after
the server’s work – here, once a row is picked to edit – and
`input$<id>` is whether it is open, closed by its user or by the server.

``` r

ui <- el_page(
  el_button("edit", "Edit the record", type = "primary"),
  el_dialog(
    "editor",
    title = "Edit",
    width = "500px",
    content = el_input("record", label = "Name"),
    footer = el_button("save", "Save", type = "primary")
  ),
  verbatimTextOutput("open_seen")
)
server <- function(input, output, session) {
  observeEvent(input$edit, {
    update_el_input(session, "record", value = "Tom") # read from the data
    update_el_dialog(session, "editor", visible = TRUE)
  })
  observeEvent(input$save, {
    # ... saved by the server ...
    update_el_dialog(session, "editor", visible = FALSE)
    el_message(session, paste("Saved", input$record), type = "success")
  })
  output$open_seen <- renderPrint(input$editor)
}
shinyApp(ui, server)
```

![The shiny-output example,
running](../../shots/dialog-shiny-output.png)

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `visible`; `input$<id>` | visibility of Dialog | [^1] |  | false |
| `title` | `title` | title of Dialog. Can also be passed with a named slot (see the following table) | [^2] |  | ’’ |
| `width` | `width` | width of Dialog, default is 50% | [^3] / [^4] |  | ’’ |
| `fullscreen` | `fullscreen` | whether the Dialog takes up full screen | [^5] |  | false |
| `top` | `top` | value for `margin-top` of Dialog CSS, default is 15vh | [^6] |  | ’’ |
| `modal` | `modal` | whether a mask is displayed | [^7] |  | true |
| `modal-penetrable` | `modal_penetrable` | whether the mask is penetrable. The modal attribute must be `false`. | [^8] |  | false |
| `modal-class` | `modal_class` | custom class names for mask | [^9] |  | — |
| `header-class` | `header_class` | custom class names for header wrapper | [^10] |  | — |
| `body-class` | `body_class` | custom class names for body wrapper | [^11] |  | — |
| `footer-class` | `footer_class` | custom class names for footer wrapper | [^12] |  | — |
| `append-to-body` | `append_to_body` | whether to append Dialog itself to body. A nested Dialog should have this attribute set to `true` | [^13] |  | false |
| `append-to` | `append_to` | which element the Dialog appends to. Will override `append-to-body` | [^14] / [^15] |  | body |
| `lock-scroll` | `lock_scroll` | whether scroll of body is disabled while Dialog is displayed | [^16] |  | true |
| `open-delay` | `open_delay` | the Time(milliseconds) before open | [^17] |  | 0 |
| `close-delay` | `close_delay` | the Time(milliseconds) before close | [^18] |  | 0 |
| `close-on-click-modal` | `close_on_click_modal` | whether the Dialog can be closed by clicking the mask | [^19] |  | true |
| `close-on-press-escape` | `close_on_press_escape` | whether the Dialog can be closed by pressing ESC | [^20] |  | true |
| `show-close` | `show_close` | whether to show a close button | [^21] |  | true |
| `before-close` | `before_close` | callback before Dialog closes, and it will prevent Dialog from closing, use done to close the dialog | [^22]`(done: DoneFn) => void` |  | — |
| `draggable` | `draggable` | enable dragging feature for Dialog | [^23] |  | false |
| `overflow` | `overflow` | draggable Dialog can overflow the viewport | [^24] |  | false |
| `center` | `center` | whether to align the header and footer in center | [^25] |  | false |
| `align-center` | `align_center` | whether to align the dialog both horizontally and vertically | [^26] |  | false |
| `destroy-on-close` | `destroy_on_close` | destroy elements in Dialog when closed | [^27] |  | false |
| `close-icon` | `close_icon` | custom close icon, default is Close | [^28] / [^29] |  | — |
| `z-index` | `z_index` | same as z-index in native CSS, z-order of dialog | [^30] |  | — |
| `header-aria-level` | `header_aria_level` | header’s `aria-level` attribute | [^31] |  | 2 |
| `transition` | `transition` | custom transition configuration for dialog animation. Can be a string (transition name) or an object with Vue transition props | [^32] / [^33]`TransitionProps` |  | dialog-fade |
| `custom-class` | `custom_class` | custom class names for Dialog | [^34] |  | ’’ |

### Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | default content of Dialog |
| `header` | `slots = list(header = )` | content of the Dialog header; Replacing this removes the title, but does not remove the close button. |
| `footer` | `slots = list(footer = )` | content of the Dialog footer |
| `title` | `slots = list(title = )` | works the same as the header slot. Use that instead. |

### Events

| Element | In R | Description |
|----|----|----|
| `open` | `input$<id>_open`, with `events = "open"` | triggers when the Dialog opens |
| `opened` | `input$<id>_opened`, with `events = "opened"` | triggers when the Dialog opening animation ends |
| `close` | `input$<id>_close`, with `events = "close"` | triggers when the Dialog closes |
| `closed` | `input$<id>_closed` | triggers when the Dialog closing animation ends |
| `open-auto-focus` | `input$<id>_open_auto_focus`, with `events = "open_auto_focus"` | triggers after Dialog opens and content focused |
| `close-auto-focus` | `input$<id>_close_auto_focus`, with `events = "close_auto_focus"` | triggers after Dialog closed and content focused |

### Exposes

| Element         | In R                                    | Description    |
|-----------------|-----------------------------------------|----------------|
| `resetPosition` | `call_el(session, id, "resetPosition")` | reset position |
| `handleClose`   | `call_el(session, id, "handleClose")`   | close dialog   |

[^1]: boolean

[^2]: string

[^3]: string

[^4]: number

[^5]: boolean

[^6]: string

[^7]: boolean

[^8]: boolean

[^9]: string

[^10]: string

[^11]: string

[^12]: string

[^13]: boolean

[^14]: CSSSelector

[^15]: HTMLElement

[^16]: boolean

[^17]: number

[^18]: number

[^19]: boolean

[^20]: boolean

[^21]: boolean

[^22]: Function

[^23]: boolean

[^24]: boolean

[^25]: boolean

[^26]: boolean

[^27]: boolean

[^28]: string

[^29]: Component

[^30]: number

[^31]: string

[^32]: string

[^33]: object

[^34]: string
