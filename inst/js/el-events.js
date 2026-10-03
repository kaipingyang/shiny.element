// Element UI's side of the bridge.
//
// Mounting, the Shiny binding, serialising values and forwarding events are
// shiny-vue.js's (window.shinyVue), and know nothing of Element. What is
// here is Element's: how an error and a label are drawn, where a table row
// sits, which prop a table column shows (window.shinyElement).
(function () {
  var se = window.shinyElement = window.shinyElement || {};
  var sv = window.shinyVue = window.shinyVue || {};

  // Every component is an app of its own in Vue 3, so Element Plus -- with
  // the page's config: locale, size, z-index -- and its icons are installed
  // on each. Element's z-index counter is shared between them all.
  // The services -- message, notification, message box, loading -- under
  // the names the feedback handler calls them by
  if (window.ElementPlus && !window.ELEMENT) {
    window.ELEMENT = {
      Message: ElementPlus.ElMessage, Notification: ElementPlus.ElNotification,
      MessageBox: ElementPlus.ElMessageBox, Loading: ElementPlus.ElLoading
    };
  }

  sv.install = function (app) {
    if (!window.ElementPlus) return;
    var cfg = window.shinyElementConfig || {};
    var opts = {};
    if (cfg.locale) opts.locale = cfg.locale;
    if (cfg.size) opts.size = cfg.size;
    if (cfg.zIndex) opts.zIndex = cfg.zIndex;
    app.use(window.ElementPlus, opts);
    var icons = window.ElementPlusIconsVue || {};
    Object.keys(icons).forEach(function (name) {
      if (name.charAt(0) === name.charAt(0).toUpperCase()) app.component(name, icons[name]);
    });
  };

  // A validation message from shinyvalidate, drawn as Element draws a
  // failed el-form rule: the control framed in red, the message under it.
  // Element's rules hang off .el-form-item.is-error. A labelled component is
  // a form item already -- its root, inside the host -- and the message goes
  // in its content, under the control; an unlabelled one has the host take
  // the classes, which generates no box, but descendant selectors match.
  function formItem(host) {
    return host.querySelector(':scope > .el-form-item, :scope > [data-shiny-vue-root] > .el-form-item') || host;
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
    var suffix = label.getAttribute('data-suffix') || '';
    if (text && typeof text === 'object' && typeof text.html === 'string') {
      label.innerHTML = text.html;
      label.appendChild(document.createTextNode(suffix));
    } else {
      label.textContent = String(text) + suffix;
    }
  };

  // el_call() arguments that stand for an object: el_table_row(3) is the
  // third row the table holds (Element compares rows by identity, so a copy
  // from R would not do); el_upload_file("a.csv") is that file in the list.
  sv.refs.row = function(i, vm) {
    var rows = vm.tableData || [];
    return rows[i - 1];
  };
  sv.refs.file = function(name, vm, target) {
    var files = (target && target.uploadFiles) || [];
    for (var i = 0; i < files.length; i++) if (files[i].name === name) return files[i];
    return undefined;
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

// A raw Element tag -- el$button() -- is compiled only inside a Vue instance.
// Placed anywhere else it stays an unknown <el-button> element and shows its
// bare text, with nothing said. Say it, once per tag, after the page and
// after each piece of UI the server renders.
(function() {
  var warned = {};
  function check() {
    var all = document.getElementsByTagName('*');
    for (var i = 0; i < all.length; i++) {
      var tag = all[i].tagName;
      if (tag.indexOf('EL-') !== 0 || warned[tag]) continue;
      warned[tag] = true;
      console.warn('[shiny.element] <' + tag.toLowerCase() + '> is outside any ' +
        'component and was not rendered. Raw el$ tags work inside one -- ' +
        'el_widget(markup =), template(), a slot, a table cell, a wrapper\'s ' +
        'trigger; at the top level use the component function instead.');
    }
  }
  function later() { setTimeout(check, 500); }
  if (document.readyState === 'complete') later();
  else window.addEventListener('load', later);
  if (window.jQuery) jQuery(document).on('shiny:value', later);
})();
