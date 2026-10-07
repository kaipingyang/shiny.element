# A calendar's events, as rows for the browser

A calendar's events, as rows for the browser

## Usage

``` r
.el_calendar_events(events, arg = NULL)
```

## Arguments

- events:

  `NULL`, a data.frame or a list of rows, with `date`; `end`, `title`,
  `body`, `type`, `color`, `calendarId`, `isReadOnly`, `isVisible` and
  `id` optional, any other column kept.

- arg:

  The update argument the rows came in, which must give ids.

## Value

Rows, each with an `id` (the row's number when none is given), days as
`"YYYY-MM-DD"` and times as `"YYYY-MM-DD HH:MM"`.
