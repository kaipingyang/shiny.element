# Validate an Element UI Form from the server

Runs the form's rules and reports the outcome the same way a submit
does, so the same `observeEvent` handles both. Use it when the form has
no submit button of its own (`submit_label = NULL`).

## Usage

``` r
el_form_validate(session, id)
```

## Arguments

- session:

  Shiny session object.

- id:

  Form ID (un-namespaced).

## Value

Called for its side effect; returns `NULL` invisibly.
