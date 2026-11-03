# Whether Vue takes `@event="<code>"` as a handler rather than a statement

Vue's compiler (compiler-core, `transformOn`) calls a method path –
`save`, `$vueStore.cart.add` – or a function expression –
`(a, b) => ...`, `function (a) { ... }` – with all the event's
arguments, and runs anything else as a statement with `$event`. The same
test, its `isMemberExpression` and `fnExpRE`, so a handler in `on` acts
as it would in a template. The bridge has the same for `v_on(ns =)`.

## Usage

``` r
.vue_is_handler(code)
```

## Arguments

- code:

  The code, a string.

## Value

`TRUE` or `FALSE`.
