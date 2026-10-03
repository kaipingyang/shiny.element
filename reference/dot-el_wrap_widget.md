# A component holding other UI, as one Vue instance

For Element Plus's containers – affix, space, scrollbar, watermark and
the like – whose content is arbitrary UI: each child that is a component
of this package is folded into the container's instance
([`.el_absorb()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_absorb.md)),
the rest is markup inside its template. The container's own fields are
taken first, so a child's field of the same name is the one renamed.

## Usage

``` r
.el_wrap_widget(
  tag,
  ns_id,
  children,
  props = NULL,
  events = NULL,
  attrs = list(),
  width = NULL,
  slots = NULL,
  data = list()
)
```

## Arguments

- tag:

  The Element Plus tag.

- ns_id:

  The namespaced id.

- children:

  A list of UI.

- props:

  Output of
  [`.el_props()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_props.md),
  or `NULL`.

- events:

  Output of
  [`.el_event_bindings()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_event_bindings.md),
  or `NULL`.

- attrs:

  Further attributes of the tag.

- width, slots:

  As for
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- data:

  Further fields of the container's own.

## Value

A Shiny UI element.
