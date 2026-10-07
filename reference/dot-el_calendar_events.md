# A calendar's events, as rows for the browser

A calendar's events, as rows for the browser

## Usage

``` r
.el_calendar_events(events, arg = NULL)
```

## Arguments

- events:

  `NULL`, a data.frame or a list of rows, with `date` and `title`;
  `end`, `type` and `id` optional, any other column kept.

## Value

Rows, each with an `id` (the row's number when none is given) and dates
as `"YYYY-MM-DD"`.
