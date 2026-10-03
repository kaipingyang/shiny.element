#' Answer a component that asked the server for data
#'
#' Element loads some components a piece at a time: a lazy tree its nodes'
#' children, a lazy cascader its next column, a lazy tree table its rows'
#' children. Upstream, a JavaScript function you write fetches them. Here
#' the server does: the component asks through an input -- `input$<id>_load`
#' for a tree or table, `input$<id>_lazy_load` for a cascader -- and waits
#' until this function answers.
#'
#' Each question carries a `request` number, so answers find their way back
#' even when several are open at once; pass the question back whole.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id The component's ID (un-namespaced).
#' @param request The question, as it arrived in `input$<id>_load` or
#'   `input$<id>_lazy_load` -- or just its `request` number.
#' @param children What to load. For a tree, nodes such as `list(id =,
#'   label =, leaf = TRUE)`; for a cascader, options such as `list(value =,
#'   label =, leaf = TRUE)`; for a table, rows, as a data.frame or a list.
#'   An empty list means there is nothing below.
#' @param reject `TRUE` to answer that the load failed, Element Plus's
#'   `reject()`: a tree node stops spinning and can be loaded again when it
#'   is next expanded. A cascader or table takes it as nothing below.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   ui <- el_page(el_tree(
#'     "files",
#'     lazy = TRUE,
#'     node_key = "id",
#'     is_leaf_field = "leaf"
#'   ))
#'   server <- function(input, output, session) {
#'     observeEvent(input$files_load, {
#'       q <- input$files_load
#'       dir <- if (q$level == 0) "~" else q$key
#'       entries <- list.files(dir, full.names = TRUE)
#'       el_load_children(
#'         id = "files",
#'         request = q,
#'         children = lapply(entries, function(f) {
#'           list(id = f, label = basename(f), leaf = !dir.exists(f))
#'         })
#'       )
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_load_children <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  request,
  children = list(),
  reject = FALSE
) {
  .el_check_session(session)
  number <- if (is.list(request)) request$request else request
  if (is.null(number)) {
    stop(
      "`request` must be the question the component asked, or its number.",
      call. = FALSE
    )
  }
  children <- if (is.data.frame(children)) {
    .el_table_rows(children)
  } else {
    unname(children)
  }
  .el_send_update(
    session,
    list(
      id = session$ns(id),
      .resolve = if (isTRUE(reject)) {
        list(request = number, failed = TRUE)
      } else {
        list(
          request = number,
          value = if (length(children)) children else list()
        )
      }
    )
  )
  invisible(NULL)
}


#' A component's props, with the server answering lazyLoad
#'
#' el-cascader and el-cascader-panel take their loader inside `props`, so a
#' computed property adds one that asks the server -- unless the user gave
#' their own, or the cascader is not lazy.
#'
#' @param ns_id The component's id.
#' @return A JS function, the computed property.
#' @keywords internal
.el_lazy_props <- function(ns_id) {
  JS(sprintf(
    paste0(
      "function() {\n",
      "  var p = this.props;\n",
      "  if (p === null) return undefined;\n",
      "  if (!p.lazy || p.lazyLoad) return p;\n",
      "  var vm = this;\n",
      "  return Object.assign({}, p, {lazyLoad: function(node, resolve) {\n",
      "    window.shinyVue.ask('%s_lazy_load', {level: node.level,\n",
      "      value: node.level ? node.value : null, path: node.level ? node.pathValues : []}, vm)\n",
      "      .then(function(children) { resolve(children || []); },\n",
      "            function() { resolve([]); });\n",
      "  }});\n",
      "}"
    ),
    ns_id
  ))
}


#' The loader a lazy tree or tree table uses when none is given
#'
#' @param ns_id The component's id.
#' @param kind `"tree"` -- `load(node, resolve)` -- or `"table"` --
#'   `load(row, treeNode, resolve)`.
#' @return A JS function, a method of the component.
#' @keywords internal
.el_lazy_load_method <- function(ns_id, kind = c("tree", "table")) {
  kind <- match.arg(kind)
  JS(switch(
    kind,
    tree = sprintf(
      paste0(
        "function(node, resolve, reject) {\n",
        "  var key = node.level && this.nodeKey ? node.data[this.nodeKey] : null;\n",
        "  window.shinyVue.ask('%s_load', {level: node.level, key: key,\n",
        "      data: node.level ? node.data : null}, this)\n",
        "    .then(function(children) { resolve(children || []); },\n",
        "          function() { if (reject) reject(); else resolve([]); });\n",
        "}"
      ),
      ns_id
    ),
    table = sprintf(
      paste0(
        "function(row, treeNode, resolve) {\n",
        "  var key = this.rowKey && typeof this.rowKey === 'string' ? row[this.rowKey] : null;\n",
        "  window.shinyVue.ask('%s_load', {key: key, row: row, level: treeNode ? treeNode.level : null}, this)\n",
        "    .then(function(children) { resolve(children || []); },\n",
        "          function() { resolve([]); });\n",
        "}"
      ),
      ns_id
    )
  ))
}
