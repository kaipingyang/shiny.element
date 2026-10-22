# The id a UI function gives its component

A UI function does not namespace its `id`, any more than
[`shiny::textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html)
does: inside a module the caller writes `ns("name")`. Namespacing from
the default reactive domain, as every component once did, namespaced
twice whenever UI was built inside a module's server –
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) – turning
`ns("name")` into `"mod-mod-name"`, an input that never reported and
said nothing about it.

## Usage

``` r
.el_ui_id(id, session = NULL)
```

## Arguments

- id:

  The id as given.

- session:

  `NULL`, or a session passed by the caller.

## Value

The id the component uses.

## Details

A session given explicitly is still honoured, with a warning, for code
written against the old behaviour.
