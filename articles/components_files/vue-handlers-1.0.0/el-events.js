// Element UI's side of the bridge.
//
// Mounting, the Shiny binding, serialising values and forwarding events are
// shiny-vue.js's, and know nothing of Element. What is here is Element's:
// where a table row sits, which prop a table column shows. shinyElement.*
// keeps the names the package's generated code has always called.
(function () {
  var se = window.shinyElement = window.shinyElement || {};
  var sv = window.shinyVue = window.shinyVue || {};

  se.plain = sv.plain;
  se.serialisable = sv.serialisable;
  se.emit = sv.emit;
  se.find = sv.find;
  se.mount = sv.mount;

  // A validation message from shinyvalidate, drawn as Element draws a
  // failed el-form rule: the control framed in red, the message under it.
  // Element's rules hang off .el-form-item.is-error, so the host takes those
  // classes -- it generates no box, but descendant selectors still match.
  sv.setInvalid = function (host, message) {
    host.classList.add('el-form-item', 'is-error');
    var box = host.querySelector(':scope > .el-form-item__error');
    if (!box) {
      box = document.createElement('div');
      box.className = 'el-form-item__error';
      // Element positions it under a form item's box; the host has none
      box.style.position = 'static';
      box.style.paddingTop = '4px';
      host.appendChild(box);
    }
    box.textContent = message;
  };
  sv.clearInvalid = function (host) {
    host.classList.remove('el-form-item', 'is-error');
    var box = host.querySelector(':scope > .el-form-item__error');
    if (box) box.parentNode.removeChild(box);
  };

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
