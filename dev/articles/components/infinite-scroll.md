# Infinite

> **Warning**
>
> We no longer maintain this directive. It will be **removed** in 3.0.0,
> please use the [el-scrollbar infinite
> scroll](https://kaipingyang.github.io/shiny.element/dev/articles/components/scrollbar#infinite-scroll)
> instead.

## Infinite Scroll

Load more data while reach bottom of the page

### Basic usage

Add `v-infinite-scroll` to the list to automatically execute loading
method when scrolling to the bottom.

Reaching the bottom asks for more: the `load` handler adds to a store’s
count, which the list’s
[`v_for()`](https://kaipingyang.github.io/shiny.element/dev/reference/directives.md)
follows – upstream’s `count += 2`. The server hears it too, as
`input$<id>_load`.

``` r

tags$style(
  ".infinite-list-item { display: flex; align-items: center;
     justify-content: center; height: 50px; margin: 10px;
     background: var(--el-color-primary-light-9);
     color: var(--el-color-primary); }"
)
vue_store("feed_data", state = list(count = 0))
el_infinite_scroll(
  "feed",
  height = "300px",
  tags$ul(
    style = "padding: 0; margin: 0; list-style: none",
    tags$li(
      class = "infinite-list-item",
      v_for("i in $vueStore.feed_data.count", key = "i"),
      "{{ i }}"
    )
  ),
  on = list(load = "$vueStore.feed_data.count += 2")
)
```

### Disable Loading

`disabled` follows the store: while a load is under way, and once there
is nothing more – upstream’s `computed(() => loading || noMore)`.

``` r

tags$style(
  ".list-item { display: flex; align-items: center; justify-content: center;
     height: 50px; background: var(--el-color-danger-light-9);
     color: var(--el-color-danger); }
   .list-item + .list-item { margin-top: 10px; }"
)
vue_store(
  "list_data",
  state = list(count = 10, loading = FALSE),
  getters = list(
    noMore = JS("function(state) { return state.count >= 20; }"),
    disabled = JS("function() { return this.loading || this.noMore; }")
  ),
  actions = list(
    load = JS(
      "function() {",
      "  var self = this;",
      "  this.loading = true;",
      "  setTimeout(function() { self.count += 2; self.loading = false; }, 2000);",
      "}"
    )
  )
)
el_infinite_scroll(
  "list",
  height = "300px",
  disabled = v_bind("$vueStore.list_data.disabled"),
  tags$ul(
    style = "padding: 0; margin: 0; list-style: none; text-align: center",
    tags$li(
      class = "list-item",
      v_for("i in $vueStore.list_data.count", key = "i"),
      "{{ i }}"
    )
  ),
  tags$p(
    style = "text-align: center",
    v_if("$vueStore.list_data.loading"),
    "Loading..."
  ),
  tags$p(
    style = "text-align: center",
    v_if("$vueStore.list_data.noMore"),
    "No more"
  ),
  on = list(load = "$vueStore.list_data.load")
)
```

### Directives

| Name | Description | Type | Default |
|----|----|----|----|
| v-infinite-scroll | Load more data while reach bottom of the page | Function | — |
| infinite-scroll-disabled | is disabled | boolean | false |
| infinite-scroll-delay | throttle delay (ms) | number | 200 |
| infinite-scroll-distance | trigger distance (px) | number | 0 |
| infinite-scroll-immediate | Whether to execute the loading method immediately, in case the content cannot be filled up in the initial state. | boolean | true |

### API

Element Plus’s tables, and beside each entry where it is in R.
