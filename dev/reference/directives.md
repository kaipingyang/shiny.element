# Vue's other directives, for a template

Attributes for a tag in a Vue template – a
[`vue_app()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_app.md)'s,
`el$` and
[vtags](https://kaipingyang.github.io/shiny.element/dev/reference/vtags.md)
tags, a slot, a table cell – given as an unnamed argument, as Vue writes
them:
`tags$li(v_for("item in items", key = "item.id"), "{{ item.name }}")` is
`<li v-for="item in items" :key="item.id">`. The expressions are Vue's,
evaluated in the component's scope – its data, `setup()`, a slot's scope
– and the page's names (`$vueStore`, `$inputs`, `$route`). Nothing else
in the tag is touched; the backtick attributes they stand for –
`` `v-if` = "ok" `` – work as well.

## Usage

``` r
v_if(expr)

v_else_if(expr)

v_else()

v_show(expr)

v_for(expr, key = NULL)

v_slot(name = "default", scope = NULL)

v_html(expr)

v_text(expr)

v_once()

v_pre()

v_memo(deps)

v_directive(name, value = NULL, arg = NULL, modifiers = NULL)
```

## Arguments

- expr:

  A JavaScript expression, a string.

- key:

  For `v_for()`, the expression of each item's key: `:key`.

- name:

  For `v_slot()`, the slot's name; for `v_directive()`, the directive's,
  without `v-`.

- scope:

  For `v_slot()`, the slot's props as a destructuring pattern:
  `"{ row }"`.

- deps:

  For `v_memo()`, an array expression: `"[item.id]"`.

- value, arg, modifiers:

  For `v_directive()`, the parts of `v-name:arg.modifiers="value"`.

## Value

Attributes for a tag, as an unnamed argument.

## Details

With them,
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md),
[`v_model()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
and
[`v_on()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_on.md)
work in a template too: as a named argument's value,
`el$space(size = v_bind("size"))` is `:size="size"`,
`el$input(value = v_model("text"))` is `v-model:value="text"`; unnamed,
`v_bind("attrs")` is `v-bind="attrs"` and `v_model("text")` is
`v-model="text"`. An R value given to
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
is a literal: `el$select(options = v_bind(df))`.

Outside a template a directive means nothing, and drawing one says so.

## See also

Other directives:
[`v_on()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_on.md)

## Examples

``` r
vue_app(
  "todo",
  htmltools::tags$div(
    htmltools::tags$input(v_model("draft"), v_on("keyup.enter" = "add()")),
    htmltools::tags$ul(
      htmltools::tags$li(v_for("t in todos", key = "t"), "{{ t }}")
    ),
    htmltools::tags$p(v_if("!todos.length"), "Nothing yet"),
    htmltools::tags$p(v_else(), "{{ todos.length }} to do")
  ),
  data = list(draft = "", todos = list()),
  methods = list(
    add = JS("function() { this.todos.push(this.draft); this.draft = ''; }")
  )
)
#> <div id="todo" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div>
#>   <input v-model="draft" @keyup.enter="add()"/>
#>   <ul>
#>     <li v-for="t in todos" :key="t">{{ t }}</li>
#>   </ul>
#>   <p v-if="!todos.length">Nothing yet</p>
#>   <p v-else>{{ todos.length }} to do</p>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"draft":"","todos":[]},"methods":{"add":"function() { this.todos.push(this.draft); this.draft = ''; }"}},"evals":["options.methods.add"]}</script>
#> </div>
```
