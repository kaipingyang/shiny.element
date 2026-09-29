# Reset an Element UI Form

Restores every field to the `value` it was declared with and clears the
validation state. Note this is Element UI's `resetFields()`: it restores
the *initial* values, not empty ones, so a field declared with
`value = 18` resets to 18.

## Usage

``` r
el_form_reset(session, id)
```

## Arguments

- session:

  Shiny session object.

- id:

  Form ID (un-namespaced).

## Value

Called for its side effect; returns `NULL` invisibly.
