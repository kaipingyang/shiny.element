# Element Plus Splitter Panel

One panel of an
[`el_splitter()`](https://kaipingyang.github.io/shiny.element/reference/el_splitter.md).

## Usage

``` r
el_splitter_panel(
  ...,
  id = NULL,
  size = NULL,
  min = NULL,
  max = NULL,
  resizable = NULL,
  collapsible = NULL,
  width = NULL,
  slots = NULL,
  on = NULL
)

update_el_splitter_panel(
  session = shiny::getDefaultReactiveDomain(),
  id,
  size = NULL,
  min = NULL,
  max = NULL,
  resizable = NULL,
  collapsible = NULL
)
```

## Arguments

- ...:

  Its content: any Shiny UI. Components of this package are folded into
  this one's Vue instance, as
  [`el_button_group()`](https://kaipingyang.github.io/shiny.element/reference/el_button_group.md)
  folds its buttons.

- id:

  Component ID. Auto-generated if `NULL`.

- size:

  Size of the panel (in pixels or percentage). Element Plus's `size`
  (string / number).

- min:

  Minimum size of the panel (in pixels or percentage). Element Plus's
  `min` (string / number).

- max:

  Maximum size of the panel (in pixels or percentage). Element Plus's
  `max` (string / number).

- resizable:

  Whether the panel can be resized. Element Plus's `resizable`
  (boolean).

- collapsible:

  Whether the panel can be collapsed. Element Plus's `collapsible`
  (boolean).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `start-collapsible`,
  `end-collapsible`. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

None: it reports nothing.

## Updating from the server

`update_el_splitter_panel()` changes a panel's settings: one inside an
[`el_splitter()`](https://kaipingyang.github.io/shiny.element/reference/el_splitter.md)
is folded into the splitter's instance and still answers to its own
`id`. One left `NULL` stays as it is; `NA` returns it to Element's
default.

`update_el_splitter_panel()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$lock, {
    update_el_splitter_panel(session, "side", resizable = !input$lock)
  })
}
```
