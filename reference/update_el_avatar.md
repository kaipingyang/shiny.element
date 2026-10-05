# Update Element Plus Avatar

Server-side update for
[`el_avatar()`](https://kaipingyang.github.io/shiny.element/reference/el_avatar.md).

## Usage

``` r
update_el_avatar(
  session = shiny::getDefaultReactiveDomain(),
  id,
  content = NULL,
  src = NULL,
  icon = NULL,
  size = NULL,
  shape = NULL,
  fit = NULL,
  src_set = NULL,
  alt = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Avatar ID (un-namespaced).

- content, src, icon, size, shape:

  New values; `NULL` leaves one unchanged.

- fit:

  How an image fills the avatar: `"cover"` (default), `"fill"`,
  `"contain"`, `"none"` or `"scale-down"`.

- src_set:

  Candidate image sources, as a `srcset` string.

- alt:

  Alternative text for the image.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_avatar()`](https://kaipingyang.github.io/shiny.element/reference/el_avatar.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$sign_in, {
    update_el_avatar(session, "me", src = user_photo())
  })
}
```
