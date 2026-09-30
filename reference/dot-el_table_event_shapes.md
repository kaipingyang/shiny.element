# What each table event reports

Element hands most table events the row object and its internal column
object. Sent as they are they reach R flattened into one character
vector, so each event is shaped into a named list instead: the 1-based
`row_index` to index the original data with, the `row` itself, and the
column's `prop` rather than the column object.

## Usage

``` r
.el_table_event_shapes()
```

## Value

A named list of JavaScript functions, one per event.
