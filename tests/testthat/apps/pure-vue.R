# Fixture for test-browser-pure-vue.R: the Vue layer with no Element Plus
# on the page -- a plain fluidPage, components written with vue_app(), a
# plugin of the page's own, a store, and render_vue().
library(shiny)

ui <- fluidPage(
  # a Vue plugin, as a library would ship one: registers <hello-x>
  tags$script(HTML(
    "window.HelloPlugin = { install: function(app) {
       var greeting = (arguments[1] && arguments[1].greeting) || 'hi';
       app.component('hello-x', { props: ['name'], template: '<b class=\"hello\">' + greeting + ' {{ name }}</b>' });
     } };"
  )),
  # the store first or last: stores mount before the components reading them
  vue_app(
    "sa",
    tags$button(class = "sa", `@click` = "$store.cart.count++", "add")
  ),
  vue_app(
    "sb",
    tags$span(class = "sb", "{{ $store.cart.count }}|{{ $store.cart.note }}")
  ),
  vue_store("cart", data = list(count = 0, note = ""), input = "count"),
  # input is input$<id>; $emit() sends input$<id>_<event>
  vue_app(
    "counter",
    tags$div(
      tags$button(class = "inc", `@click` = "n++", "+"),
      tags$span(class = "n", "{{ n }}"),
      tags$span(
        class = "rows",
        `v-for` = "r in rows",
        `@click` = "$emit('picked', r)",
        "{{ r.name }};"
      )
    ),
    data = list(n = 1, rows = data.frame(name = c("a", "b"))),
    emits = "picked",
    input = "n"
  ),
  # one value of two fields, as dateRangeInput() gives
  vue_app(
    "range",
    tags$div(
      tags$input(class = "from", `v-model.number` = "from"),
      tags$input(class = "to", `v-model.number` = "to")
    ),
    data = list(from = 1, to = 9),
    input = c("from", "to")
  ),
  vue_app(
    "greet",
    tags$div(htmltools::tag("hello-x", list(`:name` = "who"))),
    data = list(who = "Ada"),
    use = "HelloPlugin"
  ),
  vue_app(
    "greet2",
    tags$div(htmltools::tag("hello-x", list(`:name` = "who"))),
    data = list(who = "Alan"),
    use = list(HelloPlugin = list(greeting = "hello"))
  ),
  # Composition API: state from setup(), reported and set from the server
  vue_app(
    "st",
    tags$span(class = "st", "{{ k }}/{{ twice }}"),
    setup = JS(
      "function() {
        const k = Vue.ref(1);
        const twice = Vue.computed(() => k.value * 2);
        return { k, twice };
      }"
    ),
    input = "k"
  ),
  # $emit() with no argument, several, and null
  vue_app(
    "em",
    tags$div(
      tags$button(class = "pair", `@click` = "$emit('pair', 'left', 2)"),
      tags$button(class = "bare", `@click` = "$emit('bare')"),
      tags$button(class = "nil", `@click` = "$emit('nil', null)"),
      tags$button(class = "mix", `@click` = "$emit('mix', null, 2)")
    ),
    emits = c("pair", "bare", "nil", "mix")
  ),
  # a child registered in snake_case, used in kebab-case
  vue_app(
    "todo",
    tags$ul(
      htmltools::tag(
        "todo-item",
        list(
          `v-for` = "t in items",
          `:text` = "t",
          `@toggle` = "done++"
        )
      )
    ),
    data = list(items = list("milk", "bread"), done = 0),
    components = list(
      todo_item = vue_component(
        tags$li(class = "item", `@click` = "$emit('toggle')", "{{ text }}"),
        props = "text",
        emits = "toggle"
      )
    ),
    input = "done"
  ),
  vue_output("rv"),
  # fields the server fills from outputs: a list, a data.frame's rows, a
  # function; $recalculating while the server works
  vue_app(
    "dout",
    tags$div(
      tags$p(
        class = "dout",
        `:data-busy` = "$recalculating.dstats ? 'yes' : 'no'",
        "{{ stats && stats.twice }} {{ rows && rows.length }} {{ fmt ? fmt(1) : '' }}"
      )
    ),
    outputs = c(stats = "dstats", rows = "drows", fmt = "dfmt")
  ),
  # one in a hidden tab is held back until shown
  tabsetPanel(
    tabPanel("shown", "first"),
    tabPanel(
      "hidden",
      vue_app(
        "dhid",
        tags$i(class = "dhid", "{{ runs }}"),
        outputs = c(runs = "druns")
      )
    )
  ),
  verbatimTextOutput("vals")
)

server <- function(input, output, session) {
  output$dstats <- render_vue_data({
    if (isTRUE(input$dslow)) {
      Sys.sleep(2)
    }
    list(twice = (input$counter %||% 0) * 2)
  })
  output$drows <- render_vue_data(head(mtcars, input$counter %||% 1))
  output$dfmt <- render_vue_data(JS("function(x) { return 'f' + x; }"))
  runs <- 0
  output$druns <- render_vue_data({
    runs <<- runs + 1
    runs
  })
  output$rv <- render_vue(
    vue_app(
      "rv_app",
      tags$i(class = "rv", "{{ label }}"),
      data = list(label = paste("n is", input$counter))
    )
  )
  observeEvent(input$set_st, update_vue(session, "st", value = 5))
  observeEvent(input$counter, {
    if (input$counter >= 3) {
      update_vue(session, "cart", note = "from R")
    }
  })
  output$vals <- renderText(paste("counter =", input$counter))
}

shinyApp(ui, server)
