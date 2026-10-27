# Navigate the page's router from the server

Navigate the page's router from the server

## Usage

``` r
update_vue_router(
  session = shiny::getDefaultReactiveDomain(),
  id,
  path,
  replace = FALSE
)
```

## Arguments

- session:

  The Shiny session, the current one by default.

- id:

  The router's id, as given to
  [`vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_router.md).

- path:

  The route to go to: `"/orders"`, `"/orders?page=2"`.

- replace:

  Replace the current entry of the browser's history rather than adding
  one, so that "back" skips it.

## Value

`NULL`, invisibly.

## See also

[`vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_router.md)
