# Update Element Plus Color Picker Panel

Server-side update for
[`el_color_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker_panel.md).

## Usage

``` r
update_el_color_picker_panel(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  border = NULL,
  show_alpha = NULL,
  color_format = NULL,
  predefine = NULL,
  validate_event = NULL,
  hue_slider_class = NULL,
  hue_slider_style = NULL
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

- border:

  Whether the color picker panel is bordered. Element Plus's `border`
  (boolean).

- show_alpha:

  Whether to display the alpha slider. Element Plus's `show-alpha`
  (boolean).

- color_format:

  Color format of v-model. Element Plus's `color-format` (enum).

- predefine:

  Predefined color options. Element Plus's `predefine` (string\[\]).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- hue_slider_class:

  Class names will be passed to hue-slider. Element Plus's
  `hue-slider-class` (string \| string\[\] \| Record\<string,
  boolean\>).

- hue_slider_style:

  Styles will be passed to hue-slider. Element Plus's `hue-slider-style`
  (string / StyleValue).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_color_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker_panel.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(
    input$reset,
    update_el_color_picker_panel(session, "x", value = NULL)
  )
}
```
