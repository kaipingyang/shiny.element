# The events forwarded: those on by default and those asked for

The events forwarded: those on by default and those asked for

## Usage

``` r
.vue_events_check(
  asked,
  known,
  default = character(),
  what = "the component",
  see = NULL
)
```

## Arguments

- asked:

  The user's `events`, in snake_case or kebab-case.

- known:

  The component's events, kebab-case.

- default:

  Those reported unasked.

- what:

  The component, for the error: `"my_table()"`.

- see:

  Where to read about them, appended to the error.

## Value

The events, kebab-case.
