# Update Element UI Table

Update Element UI Table

## Usage

``` r
update_el_table(
  session,
  id,
  data = NULL,
  columns = NULL,
  border = NULL,
  selection = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Table ID (un-namespaced).

- data:

  New data: a data.frame or a list of rows.

- columns:

  New column configs; inferred from `data` when omitted.

- border:

  New border state.

- selection:

  New row-selection state.

## Value

Called for its side effect; returns `NULL` invisibly.
