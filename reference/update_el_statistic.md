# Update Element Plus Statistic

Server-side update for
[`el_statistic()`](https://kaipingyang.github.io/shiny.element/reference/el_statistic.md)
and
[`el_countdown()`](https://kaipingyang.github.io/shiny.element/reference/el_statistic.md).

## Usage

``` r
update_el_statistic(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  title = NULL,
  prefix = NULL,
  suffix = NULL,
  precision = NULL,
  decimal_separator = NULL,
  group_separator = NULL,
  value_style = NULL,
  formatter = NULL
)

update_el_countdown(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  title = NULL,
  prefix = NULL,
  suffix = NULL,
  format = NULL,
  value_style = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component ID (un-namespaced).

- value, title, prefix, suffix:

  New values; `NULL` leaves one unchanged.

- precision:

  Decimal places to show.

- decimal_separator:

  Decimal point. Default `"."`.

- group_separator:

  Separator between digit groups. Default `","`.

- value_style:

  CSS for the number, as a string or a named list.

- formatter:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(value)` returning the text to show, in place of
  Element's formatting.

- format:

  For a countdown, the format of the time left: `"HH:mm:ss"`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_statistic()`](https://kaipingyang.github.io/shiny.element/reference/el_statistic.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observe(update_el_statistic(session, "users", value = n_users()))
}
```
