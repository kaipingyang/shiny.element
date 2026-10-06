# The cell template of an editable column

The value as text; double-clicked, Element's editor for it, which Enter
or leaving it commits, Escape abandons and Tab commits, moving to the
next editable cell. The table's `startEdit()`, `commitEdit()` and
`cancelEdit()` do the rest.

## Usage

``` r
.el_table_editor(prop, editable, editor = NULL)
```

## Arguments

- prop:

  The column's prop, sanitised.

- editable:

  `TRUE` or the editor: `"input"`, `"number"`, `"select"` or `"date"`.

- editor:

  Props of the editor, `choices` for a select.

## Value

Markup, the column's `cell`.
