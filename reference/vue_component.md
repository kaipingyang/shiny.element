# A Vue child component, for a template to use

Vue's component options for one component that
[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md)
registers under `components =`:
`components = list(todo_item = vue_component(...))` is `<todo-item>` in
the template, and `<todo_item>` as written. As in Vue, a child takes
`props` and sends `emits` to its parent's template (`@toggle="..."`);
`data` gives each instance its own copy.

## Usage

``` r
vue_component(
  template,
  props = NULL,
  emits = NULL,
  data = NULL,
  methods = NULL,
  computed = NULL,
  watch = NULL,
  setup = NULL,
  ...,
  dependencies = NULL
)
```

## Arguments

- template:

  The child's template: tags or a string.

- props:

  Names of its props, or Vue's object form as a list.

- emits:

  Names of the events it sends with `$emit()`.

- data:

  Named list: each instance's initial state.

- methods, computed, watch:

  Named lists of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions.

- setup:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function: Vue's Composition API.

- ...:

  Any other option of Vue's, by Vue's name or its snake_case –
  `components` for children of its own.

- dependencies:

  [`htmltools::htmlDependency()`](https://rstudio.github.io/htmltools/reference/htmlDependency.html)s
  the child needs; the
  [`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md)
  that registers it attaches them, with those its template carries.

## Value

A list of Vue options, of class `vue_component`.

## Examples

``` r
item <- vue_component(
  template = "<li @click=\"$emit('toggle')\">{{ text }}</li>",
  props = "text",
  emits = "toggle"
)
```
