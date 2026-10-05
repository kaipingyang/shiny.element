# Update Element Plus Mention

Server-side update for
[`el_mention()`](https://kaipingyang.github.io/shiny.element/reference/el_mention.md).

## Usage

``` r
update_el_mention(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  props = NULL,
  prefix = NULL,
  split = NULL,
  filter_option = NULL,
  placement = NULL,
  show_arrow = NULL,
  offset = NULL,
  whole = NULL,
  check_is_whole = NULL,
  loading = NULL,
  popper_class = NULL,
  popper_style = NULL,
  popper_options = NULL,
  placeholder = NULL,
  type = NULL,
  rows = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component ID (un-namespaced).

- value, disabled:

  New values; `NULL` leaves one unchanged.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component; `""` clears it.

- props:

  Configuration options. Element Plus's `props` (MentionOptionProps).

- prefix:

  Prefix character to trigger mentions. The string length must be
  exactly 1. Element Plus's `prefix` (`string / string[]`).

- split:

  Character to split mentions. The string length must be exactly

  1.  Element Plus's `split` (string).

- filter_option:

  Customize filter option logic. Element Plus's `filter-option` (false /
  (pattern: string, option: MentionOption) =\> boolean). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- placement:

  Set popup placement. Element Plus's `placement` ('bottom' \| 'top').

- show_arrow:

  Whether the dropdown panel has an arrow. Element Plus's `show-arrow`
  (boolean).

- offset:

  Offset of the dropdown panel. Element Plus's `offset` (number).

- whole:

  When backspace is pressed to delete, whether the mention content is
  deleted as a whole. Element Plus's `whole` (boolean).

- check_is_whole:

  When backspace is pressed to delete, check if the mention is a whole.
  Element Plus's `check-is-whole` ((pattern: string, prefix: string) =\>
  boolean). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- loading:

  Whether the dropdown panel of mentions is in a loading state. Element
  Plus's `loading` (boolean).

- popper_class:

  Custom class name for dropdown panel. Element Plus's `popper-class`
  (string / object).

- popper_style:

  Custom style for dropdown panel. Element Plus's `popper-style` (string
  / object).

- popper_options:

  Popper.js parameters. Element Plus's `popper-options` (object).

- placeholder, type, rows:

  As for
  [`el_mention()`](https://kaipingyang.github.io/shiny.element/reference/el_mention.md).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_mention()`](https://kaipingyang.github.io/shiny.element/reference/el_mention.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_mention(session, "x", value = NULL))
}
```
