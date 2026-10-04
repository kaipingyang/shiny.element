# Fixture for test-browser-templates.R: Vue template syntax written with
# htmltools tags rather than as a string. Each case is a component whose
# rendered text the test reads; data-expect holds what Vue should draw.
library(shiny)

case <- function(
  id,
  markup,
  data = list(),
  expect,
  methods = NULL,
  mounted = NULL
) {
  tags$div(
    class = "case",
    `data-case` = id,
    `data-expect` = expect,
    el_widget(
      id,
      markup = markup,
      data = data,
      methods = methods,
      mounted = mounted
    )
  )
}

ui <- el_page(
  dev = TRUE,
  # 1. expressions full of characters htmltools escapes: < > & ' "
  case(
    "c_expr",
    tags$span(
      `:title` = "a < b && c ? \"lt\" : 'ge'",
      "{{ a < b && c ? \"lt\" : 'ge' }}|{{ s }}"
    ),
    data = list(a = 1, b = 2, c = TRUE, s = "it's <b>"),
    expect = "lt|it's <b>"
  ),
  # 2. directive modifiers and shorthands
  case(
    "c_mod",
    tags$div(
      tags$button(class = "go", `@click.stop.prevent` = "n++", "go"),
      tags$input(class = "num", `v-model.number` = "x", type = "text"),
      tags$span("{{ n }}:{{ typeof x }}")
    ),
    data = list(n = 0, x = 1),
    expect = "go1:number",
    mounted = JS(
      "function() { var s = this; setTimeout(function(){ s.$el.querySelector('.go').click(); }, 50); }"
    )
  ),
  # 3. dynamic arguments
  case(
    "c_dyn",
    tags$span(`:[attr]` = "val", `@[evt]` = "hit = true", "{{ hit }}"),
    data = list(attr = "data-dyn", val = "yes", evt = "click", hit = FALSE),
    expect = "true",
    mounted = JS(
      "function() { var s = this; setTimeout(function(){ s.$el.querySelector('[data-dyn]').click(); }, 50); }"
    )
  ),
  # 4. v-bind and v-on with objects
  case(
    "c_obj",
    tags$span(
      `v-bind` = "attrs",
      `v-on` = "{ click: () => clicked++ }",
      "{{ clicked }}"
    ),
    data = list(attrs = list(`data-obj` = "1", title = "t"), clicked = 0),
    expect = "1",
    mounted = JS(
      "function() { var s = this; setTimeout(function(){ s.$el.querySelector('[data-obj]').click(); }, 50); }"
    )
  ),
  # 5. v-for with a key, v-if / v-else-if / v-else, v-show
  case(
    "c_for",
    tags$div(
      tags$span(
        `v-for` = "(it, i) in items",
        `:key` = "it.id",
        tags$b(`v-if` = "it.n > 1", "{{ i }}big "),
        tags$b(`v-else-if` = "it.n === 1", "{{ i }}one "),
        tags$b(`v-else` = NA, "{{ i }}none ")
      ),
      tags$i(`v-show` = "false", "hidden")
    ),
    data = list(
      items = list(
        list(id = "a", n = 2),
        list(id = "b", n = 1),
        list(id = "c", n = 0)
      )
    ),
    expect = "0big 1one 2none hidden"
  ),
  # 6. Element components: hyphenated names, camelCase props, booleans
  case(
    "c_el",
    tags$div(
      el$input_number(
        `v-model` = "v",
        `:min` = "0",
        controlsPosition = "right"
      ),
      el$tag(`:disableTransitions` = "true", round = TRUE, "{{ v }}")
    ),
    data = list(v = 3),
    expect = "3"
  ),
  # 7. slots: named (#), scoped with destructuring, dynamic name
  case(
    "c_slot",
    el$table(
      `:data` = "rows",
      el$table_column(
        prop = "a",
        tags$template(`#header` = NA, "Head"),
        tags$template(
          `#default` = "{ row, $index }",
          "{{ $index }}-{{ row.a }}"
        )
      ),
      el$table_column(
        tags$template(`v-slot:[slotName]` = "{ row }", "[{{ row.b }}]")
      )
    ),
    data = list(rows = list(list(a = "x", b = "y")), slotName = "default"),
    expect = "Head 0-x [y]"
  ),
  # 8. refs and a method called from the template
  case(
    "c_ref",
    tags$div(
      el$input(ref = "box", `v-model` = "t"),
      tags$span("{{ t }}")
    ),
    data = list(t = ""),
    methods = list(
      fill = JS("function() { this.t = 'via ref ' + !!this.$refs.box; }")
    ),
    expect = "via ref true",
    mounted = JS("function() { this.fill(); }")
  ),
  # 9. user text holding {{ }}: tags escape < > & but not braces
  case(
    "c_inject",
    tags$div(tags$span("{{ 6 * 7 }}"), tags$span(`v-pre` = NA, "{{ 6 * 7 }}")),
    expect = "42{{ 6 * 7 }}"
  ),
  # 10. v-html and v-text
  case(
    "c_html",
    tags$div(tags$span(`v-html` = "h"), tags$span(`v-text` = "h")),
    data = list(h = "<b>B</b>"),
    expect = "B<b>B</b>"
  ),
  # 11. composed in R: NULL children dropped, tagList spliced, attributes
  # added afterwards with tagAppendAttributes()
  case(
    "c_compose",
    htmltools::tagAppendAttributes(
      tags$div(
        NULL,
        tagList(tags$span("{{ p }}"), if (FALSE) tags$span("no")),
        lapply(1:2, function(i) tags$span(sprintf("{{ q[%d] }}", i - 1)))
      ),
      `:data-p` = "p"
    ),
    data = list(p = "P", q = list("Q1", "Q2")),
    expect = "PQ1Q2"
  )
)

shinyApp(ui, function(input, output, session) {})
