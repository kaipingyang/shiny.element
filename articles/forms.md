# Forms

Element’s form components each report to `input$<id>` and are set from
the server with `update_el_*()`. This covers the pieces that differ from
what you would write with Shiny’s own inputs.

## Choices

Anything taking `choices` accepts the shapes Shiny does:

``` r

el_select("city", choices = c("Beijing", "Shanghai"))            # value = label
el_select("city", choices = c(Beijing = "bj", Shanghai = "sh"))  # named
el_select("city", choices = list(
  list(value = "bj", label = "Beijing", disabled = TRUE),
  list(value = "sh", label = "Shanghai")
))
```

The third shape is how a single choice carries its own props –
`disabled`, and for a checkbox or radio group also `border` and `name`,
which Element documents on the individual item rather than the group.

``` r

el_checkbox_group("opts", choices = list(
  list(value = "a", label = "Agree", border = TRUE),
  list(value = "b", label = "Unavailable", disabled = TRUE)
))
```

## Validation

[`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
renders its own fields rather than accepting standalone input
components, because Element’s validation only works inside one component
tree: a form item finds its control through Vue’s child chain and
listens for events dispatched up it. A separate Vue instance dropped in
is not in that chain.

``` r

el_form(
  id = "signup",
  el_form_field("name", "input", label = "Name",
                rules = el_rule(required = TRUE, message = "Name is required")),
  el_form_field("age", "input-number", label = "Age", value = 18),
  el_form_field("city", "select", label = "City",
                options = c("Beijing", "Shanghai"),
                rules = el_rule(required = TRUE, message = "Pick a city"))
)
```

The form reports three inputs: `input$signup` is the model as a list,
`input$signup_valid` whether validation passed, and
`input$signup_submit` a counter.

``` r

observeEvent(input$signup_submit, {
  if (isTRUE(input$signup_valid)) {
    save_record(input$signup)
  }
})
```

Validation can also be driven from the server:

``` r

el_call(session, "signup", "validate")        # answers as input$signup_validate
el_call(session, "signup", "clearValidate")
el_call(session, "signup", "resetFields")
```

[`validate()`](https://rdrr.io/pkg/shiny/man/validate.html) returns a
promise, which resolves when the form is valid and rejects when it is
not – both arrive as `input$signup_validate`, `TRUE` or `FALSE`.

## Uploads

[`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md)
has two modes. By default it sends files through Shiny’s own upload
transport, so they land in `input$<id>` as a data.frame with the same
columns [`fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)
gives:

``` r

el_upload("docs", multiple = TRUE)

observeEvent(input$docs, {
  # name, size, type, datapath
  readr::read_csv(input$docs$datapath[1])
})
```

Pointing `action` somewhere else switches to Element’s own transport,
and the file never reaches R:

``` r

el_upload("docs", action = "https://example.org/upload",
          headers = list(Authorization = "Bearer ..."),
          extra_data = list(folder = "reports"))
```

`extra_data` is Element’s `data` prop, renamed so it is not confused
with the file itself.

## Autocomplete

Suggestions filter in the browser when passed up front:

``` r

el_autocomplete("city", suggestions = c("Beijing", "Shanghai", "Shenzhen"))
```

When the list is too large, or lives in a database, pass a JavaScript
function that calls back:

``` r

el_autocomplete("city", fetch_suggestions = htmlwidgets::JS(
  "function(query, callback) {",
  "  Shiny.setInputValue('city_query', query, {priority: 'event'});",
  "  window._cityCallback = callback;",
  "}"
))

# server
observeEvent(input$city_query, {
  session$sendCustomMessage("cities", lookup(input$city_query))
})
```

with a handler that hands the answer to the stored callback.

## Transfer

[`el_transfer()`](https://kaipingyang.github.io/shiny.element/reference/el_transfer.md)
takes a data.frame of `key` and `label`, and reports the keys on the
right:

``` r

el_transfer("cols",
            data = data.frame(key = names(iris), label = names(iris)),
            value = "Species",
            titles = c("Available", "Chosen"),
            filterable = TRUE)

observeEvent(input$cols, {
  chosen <- iris[, input$cols, drop = FALSE]
})
```

## Sizing and layout

Every component takes `width`, which behaves like the `width` of a Shiny
input. For the form as a whole, `label_width` and `label_position` do
what Element’s do:

``` r

el_form(id = "f", label_width = "120px", label_position = "left",
        el_form_field("name", "input", label = "Name"))
```
