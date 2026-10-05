# Inline style for a component's Vue mount point

Vue mounts onto the `<div id="<id>_container">` each component renders,
but it does not remove that div: it stays in the document as a
block-level box. Every component therefore started on its own line, so
two buttons or two tags could never sit side by side without wrapping
them in a grid.

## Usage

``` r
.el_host_style()
```

## Value

A CSS declaration string.

## Details

`display: contents` makes the box itself generate no layout, leaving the
component to take part in the surrounding flow with its own display –
inline for a button, block for an alert. The style is inline rather than
in a stylesheet so it cannot be switched off with
`el_page(theme_css = NULL)`.
