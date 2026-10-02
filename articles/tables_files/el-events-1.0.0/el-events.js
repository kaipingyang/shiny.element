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
  // Element's rules hang off .el-form-item.is-error. A labelled component is
  // a form item already -- its root, inside the host -- and the message goes
  // in its content, under the control; an unlabelled one has the host take
  // the classes, which generates no box, but descendant selectors match.
  function formItem(host) {
    return host.querySelector(':scope > .el-form-item') || host;
  }
  function messageParent(item, host) {
    return item === host ? host : item.querySelector(':scope > .el-form-item__content');
  }
  sv.setInvalid = function (host, message) {
    var item = formItem(host), where = messageParent(item, host);
    item.classList.add('el-form-item', 'is-error');
    // A message given with `error` is the page's first state; as in Element,
    // validation replaces it
    var own = where.querySelector(':scope > .el-form-item__error:not([data-shiny-vue-invalid])');
    if (own) own.parentNode.removeChild(own);
    var box = where.querySelector(':scope > [data-shiny-vue-invalid]');
    if (!box) {
      box = document.createElement('div');
      box.className = 'el-form-item__error';
      box.setAttribute('data-shiny-vue-invalid', '');
      // Element positions it under a form item's box; here it flows
      box.style.position = 'static';
      box.style.display = 'block';
      box.style.paddingTop = '4px';
      where.appendChild(box);
    }
    box.textContent = message;
  };
  sv.clearInvalid = function (host) {
    var item = formItem(host), where = messageParent(item, host);
    item.classList.remove('is-error');
    if (item === host) item.classList.remove('el-form-item');
    // The message given with `error` goes too: the field has been judged
    // since, and passed
    where.querySelectorAll(':scope > .el-form-item__error').forEach(function (e) {
      e.parentNode.removeChild(e);
    });
  };

  // update_el_*(error =): Element's error prop, set from the server -- a
  // check only the server can make, such as whether a name is taken. ""
  // clears it.
  sv.hooks['.error'] = function (host, message) {
    if (message === null || message === undefined || message === '') sv.clearInvalid(host);
    else sv.setInvalid(host, String(message));
  };

  // update_el_*(label =), as Shiny's update*Input(label =). The suffix the
  // label was built with stays.
  sv.hooks['.label'] = function (host, text) {
    var label = document.getElementById(host.id + '-label');
    if (!label) {
      if (window.console) console.warn('[shiny-vue] update: "' + host.id +
        '" was built without a label, so there is none to change');
      return;
    }
    label.textContent = String(text) + (label.getAttribute('data-suffix') || '');
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
