# Lay a component out under (or beside) a label

Element's own form-item markup – `.el-form-item__label` and
`.el-form-item__content` – so the label looks as it does in an
[`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md),
laid out with flexbox rather than Element's floats, which assume an
enclosing form. It is the template's root, inside the host: hiding or
removing the component by its id takes the label with it.

## Usage

``` r
.el_labelled(container_id, id, label, position, markup)
```

## Arguments

- container_id:

  The root's id, `<id>_container`.

- id:

  The component's id.

- label:

  Text or a tag.

- position:

  `"top"` or `"left"`.

- markup:

  The component's Element markup.

## Value

A tag.
