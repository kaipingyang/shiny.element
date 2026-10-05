# Update Element Plus Rate

Server-side update for
[`el_rate()`](https://kaipingyang.github.io/shiny.element/reference/el_rate.md).

## Usage

``` r
update_el_rate(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  max = NULL,
  allow_half = NULL,
  show_text = NULL,
  show_score = NULL,
  texts = NULL,
  text_color = NULL,
  score_template = NULL,
  void_color = NULL,
  disabled_void_color = NULL,
  low_threshold = NULL,
  high_threshold = NULL,
  aria_label = NULL,
  clearable = NULL,
  disabled_void_icon = NULL,
  icons = NULL,
  size = NULL,
  void_icon = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Rate ID (un-namespaced).

- value:

  New rating value.

- disabled:

  New disabled state.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

- max:

  Maximum number of stars. Default `5`.

- allow_half:

  Whether to allow half-star selection. Default `FALSE`.

- show_text:

  Whether to show descriptive text beside the stars. Uses the `texts`
  vector. Default `FALSE`.

- show_score:

  Whether to show the numeric score. Default `FALSE`.

- texts:

  Character vector of length `max` used when `show_text = TRUE`. `NULL`
  takes Element Plus's: "Extremely bad", "Disappointed", "Fair",
  "Satisfied", "Surprise".

- text_color:

  Colour of the text or score. `NULL` takes Element Plus's, from its CSS
  variables.

- score_template:

  Template for score display. `{value}` is replaced. Default
  `"{value}"`.

- void_color:

  Colour of unselected icons.

- disabled_void_color:

  Colour of unselected icons when `disabled = TRUE`.

- low_threshold:

  Scores at or below this use the first colour and icon. Default `2`.

- high_threshold:

  Scores above this use the third colour and icon. Default `4`.

- aria_label:

  Same as `aria-label` in Rate. Element Plus's `aria-label` (string).

- clearable:

  Whether value can be reset to `0`. Element Plus's `clearable`
  (boolean).

- disabled_void_icon:

  Component of unselected read-only icons. Element Plus's
  `disabled-void-icon` (string / Component). An icon's name, such as
  `"Search"`.

- icons:

  Icon components. If array, it should have 3 elements, each of which
  corresponds with a score level, else if object, the key should be
  threshold value between two levels, and the value should be
  corresponding icon component. Element Plus's `icons`
  (`string[] | Component[] / Record<number, string | Component>`). An
  icon's name, such as `"Search"`.

- size:

  Size of Rate. Element Plus's `size` ('large' \| 'default' \| 'small').

- void_icon:

  Component of unselected icons. Element Plus's `void-icon` (string /
  Component). An icon's name, such as `"Search"`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_rate()`](https://kaipingyang.github.io/shiny.element/reference/el_rate.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_rate(session, "stars", value = 5)
  })
}
```
