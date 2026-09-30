# Update Element UI Avatar

Server-side update for
[`el_avatar()`](https://kaipingyang.github.io/shiny.element/reference/el_avatar.md).

## Usage

``` r
update_el_avatar(
  session,
  id,
  content = NULL,
  src = NULL,
  icon = NULL,
  size = NULL,
  shape = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Avatar ID (un-namespaced).

- content, src, icon, size, shape:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$sign_in, {
    update_el_avatar(session, "me", src = user_photo())
  })
}
```
