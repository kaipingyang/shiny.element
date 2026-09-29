# Update an Element UI Carousel

Update an Element UI Carousel

## Usage

``` r
update_el_carousel(
  session,
  id,
  active = NULL,
  autoplay = NULL,
  interval = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Carousel ID (un-namespaced).

- active:

  Index of the slide to show, 0-based.

- autoplay:

  Start or stop cycling.

- interval:

  New interval in milliseconds.

## Value

Called for its side effect; returns `NULL` invisibly.
