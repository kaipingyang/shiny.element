// Report an Element UI event to Shiny.
//
// Element's event signatures differ per event, and some arguments are DOM
// nodes or native events, which cannot cross the wire. Those are dropped;
// what is left is sent as the value, or as an array when an event carries
// more than one usable argument.
//
// The input is named <id>_<event>, with the event in snake_case so it reads
// like the rest of an R script: @row-click reaches input$<id>_row_click.
(function () {
  window.shinyElement = window.shinyElement || {};

  function serialisable(x) {
    if (x === null || x === undefined) return false;
    if (typeof Node !== "undefined" && x instanceof Node) return false;
    if (typeof Event !== "undefined" && x instanceof Event) return false;
    // Element hands the column object itself to cell-click; it carries
    // internal render functions that JSON.stringify would choke on.
    if (typeof x === "function") return false;
    if (x._isVue || x.$options) return false;
    return true;
  }

  // Element hands whole component instances and tree nodes to some events.
  // A TreeNode points at its parent and its children, so walking one without
  // a guard recurses until the stack gives out -- which is what happened the
  // first time el_tree's events were forwarded.
  var MAX_DEPTH = 6;

  function plain(x, depth, seen) {
    depth = depth || 0;
    seen = seen || [];
    if (x === null || typeof x !== "object") return x;
    if (depth >= MAX_DEPTH) return undefined;
    if (seen.indexOf(x) !== -1) return undefined;
    // A Vue instance is machinery, not data
    if (x._isVue || x.$el || x.$options) return undefined;

    seen = seen.concat([x]);
    if (Array.isArray(x)) {
      return x.map(function (v) { return plain(v, depth + 1, seen); });
    }
    var out = {};
    Object.keys(x).forEach(function (k) {
      if (k.charAt(0) === "$" || k.charAt(0) === "_") return;
      var v = x[k];
      if (typeof v === "function") return;
      if (typeof Node !== "undefined" && v instanceof Node) return;
      var p = (v !== null && typeof v === "object") ? plain(v, depth + 1, seen) : v;
      if (p !== undefined) out[k] = p;
    });
    return out;
  }

  // Shared with el-invoke.js: a method's return value needs the same
  // treatment as an event's arguments -- getCheckedNodes() hands back tree
  // nodes, which point at their parents.
  window.shinyElement.plain = plain;
  window.shinyElement.serialisable = serialisable;

  // Where a table row sits, 1-based, so R can index its own data with it.
  window.shinyElement.rowIndex = function (vm, row) {
    if (!row || !vm || !vm.tableData) return null;
    var i = vm.tableData.indexOf(row);
    return i < 0 ? null : i + 1;
  };

  // An Element table column object is mostly render machinery; what R wants
  // is the prop it shows.
  window.shinyElement.colProp = function (column) {
    return column ? (column.property || column.label || null) : null;
  };

  window.shinyElement.emit = function (id, event, args) {
    if (typeof Shiny === "undefined" || !Shiny.setInputValue) return;
    // Not .map(plain): map passes (value, index, array), which would arrive
    // as plain(x, depth, seen) -- the array as `seen` makes every value look
    // like a cycle, and each one comes back undefined.
    var usable = Array.prototype.slice.call(args)
      .filter(serialisable)
      .map(function (a) { return plain(a); })
      .filter(function (a) { return a !== undefined; });
    // Several arguments are sent as an object, never an array: Shiny unlists
    // an unnamed list, so [row, column] arrived as one flat character vector
    // with the row's and the column's fields run together and every number
    // turned into a string. Events worth reading get a shape of their own
    // (see .el_event_bindings()); this is only the fallback.
    var value;
    if (usable.length === 0) {
      value = true;
    } else if (usable.length === 1) {
      value = usable[0];
    } else {
      value = {};
      usable.forEach(function (u, i) { value["arg" + (i + 1)] = u; });
    }
    Shiny.setInputValue(id + "_" + event, value, { priority: "event" });
  };
})();
