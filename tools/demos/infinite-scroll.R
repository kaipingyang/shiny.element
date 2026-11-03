## basic
#' Reaching the bottom asks for more: the `load` handler adds to a store's
#' count, which the list's `v_for()` follows -- upstream's `count += 2`.
#' The server hears it too, as `input$<id>_load`.
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

## disable-loading
#' `disabled` follows the store: while a load is under way, and once there
#' is nothing more -- upstream's `computed(() => loading || noMore)`.
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
