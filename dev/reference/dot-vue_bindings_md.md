# A component's help-page sentence on bindings

Every argument can follow
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
but those it names: R's markup, with the why; data, with the form a
binding gives. Written from the kinds, so the page says what the
component does.

## Usage

``` r
.vue_bindings_md(args, kinds, skip, library = "the library's")
```

## Arguments

- args:

  The function's arguments' names.

- kinds:

  Their kinds.

- skip:

  Arguments of the component's frame.

- library:

  Whose form a binding gives, in words: `"the library's"`.

## Value

A markdown sentence.
