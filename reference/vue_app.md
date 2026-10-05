# A Vue component, as Shiny UI

`vue_app()` writes a Vue 3 component in R and places it on the page: the
arguments are Vue's own options, under Vue's own names, and the browser
creates and mounts it with `Vue.createApp()`. Three things are added, as
Shiny needs them: `id`, where it goes and what the server calls it;
`input`, the field that is `input$<id>`; and `dependencies`. `use` is
Vue's `app.use()`.

## Usage

``` r
vue_app(
  id,
  template,
  data = list(),
  methods = NULL,
  computed = NULL,
  watch = NULL,
  emits = NULL,
  setup = NULL,
  components = NULL,
  ...,
  input = NULL,
  use = NULL,
  dependencies = NULL
)
```

## Arguments

- id:

  The component's id: `input$<id>`, and what
  [`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
  and
  [`call_vue()`](https://kaipingyang.github.io/shiny.element/reference/call_vue.md)
  name. Inside a module, `ns("id")`.

- template:

  The template: htmltools tags, or a string.

- data:

  Named list: the initial state. A data.frame in it is rows.

- methods, computed, watch:

  Named lists of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions.

- emits:

  Names of the events the component sends with `$emit()`.

- setup:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function: Vue's Composition API.

- components:

  Named list of
  [`vue_component()`](https://kaipingyang.github.io/shiny.element/reference/vue_component.md)s,
  for the template.

- ...:

  Any other option of Vue's, by Vue's name or its snake_case:
  `mounted = JS(...)`, `before_unmount = JS(...)`, `provide = JS(...)`.

- input:

  The field whose value is `input$<id>`, or several, for one value made
  of them. `NULL`: the component reports no value.

- use:

  Vue plugins to install, by the global name each is loaded under:
  `"MyPlugin"`, or with options, `list(MyPlugin = list(...))`.

- dependencies:

  [`htmltools::htmlDependency()`](https://rstudio.github.io/htmltools/reference/htmlDependency.html)s
  the component needs: the plugins' scripts and stylesheets.

## Value

A tag, with its dependencies.

## What goes where

|  |  |
|----|----|
| Vue | Here |
| `createApp(options).mount('#app')` | `vue_app(id, ...)` |
| [`data()`](https://rdrr.io/r/utils/data.html), `methods`, `computed`, `watch`, `setup()`, `emits`, hooks | the same names; functions as [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md) |
| `beforeUnmount`, `inheritAttrs`, ... | Vue's name, or snake_case: `before_unmount` |
| `app.use(Plugin, options)` | `use = list(Plugin = options)` |
| `v-model` on the component (its value) | `input = "<field>"`: `input$<id>` |
| `this.$emit("picked", x)` | `input$<id>_picked`, for an event in `emits` |

Every function – a method, a watcher, `setup()` – is JavaScript, given
with
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).
`data` is the initial state, as R writes it: a list becomes an object, a
data.frame its rows. After that the component changes it, and the server
does with
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
or
[`render_vue()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md).

## Shiny inputs

- `input$<id>` – the `input` field, on load, on change and after an
  update; several fields give one value, a named list of them.

- `input$<id>_<event>` – each event in `emits`, sent with `$emit()`: one
  argument as it is, several as a list (`arg1`, `arg2`, ...), none as
  `TRUE`.

## Data from users

Show it through `data` – `{{ field }}`, `:prop="field"` – which Vue
renders as text. Never paste it into the template: a template is code,
and `{{ }}` in it runs.

## See also

[`vue_component()`](https://kaipingyang.github.io/shiny.element/reference/vue_component.md),
[`vue_store()`](https://kaipingyang.github.io/shiny.element/reference/vue_store.md),
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md),
[`call_vue()`](https://kaipingyang.github.io/shiny.element/reference/call_vue.md),
[`render_vue()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md).

## Examples

``` r
counter <- vue_app(
  "counter",
  template = htmltools::tags$button(`@click` = "n++", "Clicked {{ n }} times"),
  data = list(n = 0),
  input = "n"
)
if (interactive()) {
  library(shiny)
  shinyApp(
    fluidPage(counter, textOutput("n")),
    function(input, output) output$n <- renderText(input$counter)
  )
}
```
