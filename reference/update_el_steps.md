# Update Element UI Steps

Update Element UI Steps

## Usage

``` r
update_el_steps(
  session,
  id,
  active = NULL,
  process_status = NULL,
  finish_status = NULL
)
```

## Arguments

- session:

  Shiny session object

- id:

  Steps ID

- active:

  New active step index

- process_status:

  New process status

- finish_status:

  New finish status

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_steps(session, "wizard", active = 2)
  })
}
```
