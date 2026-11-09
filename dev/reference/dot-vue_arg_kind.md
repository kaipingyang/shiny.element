# A component's arguments, by kind: which follow state and which do not

A component library says what each argument of its components is where
it is not a prop – a named character vector, `kinds`:

## Usage

``` r
.vue_arg_kind(kinds, arg)
```

## Arguments

- kinds:

  The kinds, as above.

- arg:

  An argument's name.

## Value

`list(kind, detail)`.

## Details

- `"markup: <why>"`: R draws with it; a binding is refused, the why
  given;

- `"data"` or `"data:<shape>"`: R converts an R value; a binding is the
  library's own form (`shape` for the development build's check);

- `"stands:<field>,<field>"`: one argument for several fields;

- `"alias:<argument>"`: another name of an argument.

An argument not named is a prop: it follows a binding. One unnamed
string is the kind of every argument. The library keeps the facts; this
is the mechanism, as
[`.vue_event_bindings()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_event_bindings.md)
is for events.
