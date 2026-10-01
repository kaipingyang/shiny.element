// Element UI's side of the bridge.
//
// Mounting, the Shiny binding, serialising values and forwarding events are
// shiny-vue.js's, and know nothing of Element. What is here is Element's:
// where a table row sits, which prop a table column shows. shinyElement.*
// keeps the names the package's generated code has always called.
(function () {
  var se = window.shinyElement = window.shinyElement || {};
  var sv = window.shinyVue || {};

  se.plain = sv.plain;
  se.serialisable = sv.serialisable;
  se.emit = sv.emit;
  se.find = sv.find;
  se.mount = sv.mount;

  // Where a table row sits, 1-based, so R can index its own data with it.
  se.rowIndex = function (vm, row) {
    if (!row || !vm || !vm.tableData) return null;
    var i = vm.tableData.indexOf(row);
    return i < 0 ? null : i + 1;
  };

  // An Element table column object is mostly render machinery; what R wants
  // is the prop it shows.
  se.colProp = function (column) {
    return column ? (column.property || column.label || null) : null;
  };
})();
