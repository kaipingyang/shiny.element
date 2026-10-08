// Element Plus's side of the bridge.
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

  var refState = new WeakMap();
  // Components with a virtual-ref selector. A target may come later --
  // drawn by renderUI() -- or be replaced; one observer, live while any such
  // component is, renders a component again when its target appears or the
  // one it holds leaves the page, or the number of targets changes. A
  // selector matching several targets
  // follows the pointer, through one listener for them all. An entry goes
  // when its component unmounts.
  var refTracked = new Set(), refObserver = null;
  function refAlive(st) { return !st.inst.isUnmounted; }
  // how many are being watched, for the tests
  se.refTracked = function () { refCheck(); return refTracked.size; };
  function refCheck() {
    refTracked.forEach(function (st) {
      if (!refAlive(st)) { refTracked.delete(st); return; }
      // rendered again when the target it holds has gone and another is
      // there, or when the selector now matches a different number of
      // elements -- one target becoming two makes it follow the pointer
      var held = st.el && document.contains(st.el);
      var n = document.querySelectorAll(st.sel).length;
      if ((!held && n) || n !== st.count) st.vm.$forceUpdate();
    });
    if (!refTracked.size && refObserver) { refObserver.disconnect(); refObserver = null; }
  }
  function refTrack(st) {
    refTracked.add(st);
    if (refObserver || typeof MutationObserver === 'undefined') return;
    var queued = false;
    refObserver = new MutationObserver(function () {
      if (queued) return;
      queued = true;
      requestAnimationFrame(function () { queued = false; refCheck(); });
    });
    refObserver.observe(document.documentElement, { childList: true, subtree: true });
  }
  if (typeof document !== 'undefined') {
    document.addEventListener('mouseover', function (e) {
      if (!refTracked.size || !e.target || !e.target.closest) return;
      refTracked.forEach(function (st) {
        if (!st.many || !refAlive(st)) return;
        var t = e.target.closest(st.sel);
        if (t && t !== st.cur) { st.cur = t; st.vm.$forceUpdate(); }
      });
    }, true);
  }
  // A component's host -- el_button("save") is #save -- draws no box of its
  // own (display: contents), so a popup anchored there has nowhere to go:
  // anchor it to the first element inside that does.
  function boxOf(el) {
    while (el && getComputedStyle(el).display === 'contents') {
      var next = null;
      for (var i = 0; i < el.children.length; i++) {
        var c = el.children[i];
        if (c.tagName !== 'SCRIPT' && c.tagName !== 'TEMPLATE') { next = c; break; }
      }
      el = next;
    }
    return el || undefined;
  }
  // Element Plus as a Vue plugin, for a component's `use`: Element Plus
  // itself with the page's config (locale, size, z-index, from el_page()),
  // and what this package adds to it -- the icons by name, $ELEMENT, $elRef,
  // $elDate. A component that does not ask for it does not get it.
  function localeOf(code) {
    if (!code) return undefined;
    var name = 'ElementPlusLocale' + String(code).toLowerCase().split('-').map(function (p) {
      return p.charAt(0).toUpperCase() + p.slice(1);
    }).join('');
    return window[name] || (window.ElementPlus && ElementPlus.en) || undefined;
  }
  se.plugin = { install: function (app, given) {
    if (!window.ElementPlus) return;
    var cfg = Object.assign({}, window.shinyElementConfig || {}, given || {});
    var opts = {};
    if (cfg.locale) opts.locale = cfg.locale;
    if (cfg.size) opts.size = cfg.size;
    if (cfg.zIndex) opts.zIndex = cfg.zIndex;
    // A component drawn inside a config provider after it -- by renderUI()
    // -- is an app of its own, which the provider's provide() cannot reach:
    // it takes the provider's settings from its scope, and follows them
    var host = sv.mountingHost;
    var scope = host && host.parentElement && host.parentElement.closest('.el-provider-scope');
    if (scope && window.Vue && ElementPlus.provideGlobalConfig) {
      var read = function () {
        var c = {};
        try { c = JSON.parse(scope.getAttribute('data-config') || '{}') || {}; } catch (e) {}
        var out = Object.assign({}, opts);
        Object.keys(c).forEach(function (k) { if (c[k] !== null && c[k] !== undefined) out[k] = c[k]; });
        if (typeof out.locale === 'string') out.locale = localeOf(out.locale);
        return out;
      };
      var state = Vue.ref(read());
      app.use(window.ElementPlus);
      ElementPlus.provideGlobalConfig(state, app);
      var follow = function () { state.value = read(); };
      (scope._seFollowers = scope._seFollowers || []).push(follow);
      if (typeof app.onUnmount === 'function') {
        app.onUnmount(function () {
          scope._seFollowers = scope._seFollowers.filter(function (f) { return f !== follow; });
        });
      }
    } else {
      app.use(window.ElementPlus, opts);
    }
    // The page's size, for markup around a component -- its form item --
    // to follow as Element Plus's own components do
    app.config.globalProperties.$ELEMENT = { size: cfg.size || '' };
    // A virtual-ref is an element, which R cannot send: it sends a CSS
    // selector, looked up here. An element drawn after this component -- by
    // another component, or by the server -- is looked for again on the next
    // frames, a few times, before giving up. A selector matching several
    // elements follows the pointer between them, one popup for all of them
    // (Element Plus's singleton tooltip). A JS() function is called for
    // anything else, an object with getBoundingClientRect() say.
    app.config.globalProperties.$elRef = function (sel) {
      if (sel === null || sel === undefined || sel === '') return undefined;
      if (typeof sel === 'function') return sel.call(this);
      if (typeof sel !== 'string') return sel;
      // state per component instance, kept off the proxy: an unknown key
      // read during render is a Vue warning
      var vm = this, inst = vm.$;
      var st = refState.get(inst);
      if (!st) refState.set(inst, st = { vm: vm, inst: inst });
      st.sel = sel;
      refTrack(st);
      var all = document.querySelectorAll(sel);
      st.count = all.length;
      st.many = all.length > 1;
      if (!all.length) { st.el = null; return undefined; }
      if (!st.many) st.cur = all[0];
      else if (!st.cur || !document.contains(st.cur) || !st.cur.matches(sel)) st.cur = all[0];
      st.el = st.cur;
      return boxOf(st.cur);
    };
    // A config provider's locale, given by code ("zh-cn"): the locale file
    // its R function loaded defines ElementPlusLocaleZhCn. English is
    // Element's own.
    app.config.globalProperties.$elLocale = localeOf;
    // A picker's default-value and default-time are Dates; R sends text --
    // "2010-10-01", "2010-10-01 12:00:00", "12:00:00" -- read in local time
    // so a day never shifts with the time zone. A pair maps item by item.
    app.config.globalProperties.$elDate = function (v) {
      if (v === null || v === undefined || v === '') return undefined;
      if (Array.isArray(v)) return v.map(app.config.globalProperties.$elDate);
      if (typeof v !== 'string') return v;
      var m = /^(?:(\d{4})-(\d{1,2})-(\d{1,2}))?[ T]?(?:(\d{1,2}):(\d{2})(?::(\d{2}))?)?$/.exec(v.trim());
      if (!m || (!m[1] && !m[4])) return new Date(v);
      return m[1]
        ? new Date(+m[1], +m[2] - 1, +m[3], +(m[4] || 0), +(m[5] || 0), +(m[6] || 0))
        : new Date(2000, 0, 1, +m[4], +m[5], +(m[6] || 0));
    };
    var icons = window.ElementPlusIconsVue || {};
    // Element UI names Element Plus spells differently. Element UI's "more"
    // and "warning" were the filled icons, so they win over Element Plus's
    // outlined More and Warning -- registered once, as Vue warns on a second.
    var legacy = { 'user-solid': 'UserFilled', 'star-on': 'StarFilled', 'star-off': 'Star',
                   's-tools': 'Tools', 'more': 'MoreFilled', 'error': 'CircleCloseFilled',
                   'success': 'CircleCheckFilled', 'warning': 'WarningFilled',
                   'info': 'InfoFilled', 'question': 'QuestionFilled' };
    Object.keys(icons).forEach(function (name) {
      if (name.charAt(0) !== name.charAt(0).toUpperCase()) return;
      app.component(name, icons[name]);
      // Element UI's class names, el-icon-arrow-right, reach the same icon
      // when given to an icon prop
      var kebab = name.replace(/([a-z0-9])([A-Z])/g, '$1-$2').toLowerCase();
      if (!legacy[kebab]) app.component('el-icon-' + kebab, icons[name]);
    });
    Object.keys(legacy).forEach(function (old) {
      if (icons[legacy[old]]) app.component('el-icon-' + old, icons[legacy[old]]);
    });
  } };

  // el_icon(): an <i class="el-icon" data-el-icon="Search">, drawn here with
  // the icon's SVG wherever it is on the page -- inside a component or not,
  // and in any UI the server renders later.
  se.fillIcons = function (scope) {
    var icons = window.ElementPlusIconsVue;
    if (!icons || !window.Vue || !Vue.render) return;
    (scope || document).querySelectorAll('i[data-el-icon]').forEach(function (el) {
      var name = el.getAttribute('data-el-icon');
      if (el._elIcon === name && el.querySelector('svg')) return;
      if (!icons[name]) return;
      Vue.render(Vue.h(icons[name]), el);
      el._elIcon = name;
    });
  };
  if (typeof document !== 'undefined') {
    var queued = false;
    var fill = function () {
      if (queued) return;
      queued = true;
      requestAnimationFrame(function () { queued = false; se.fillIcons(document); });
    };
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', fill);
    else fill();
    if (typeof MutationObserver !== 'undefined') {
      new MutationObserver(function (records) {
        for (var i = 0; i < records.length; i++) if (records[i].addedNodes.length) { fill(); return; }
      }).observe(document.documentElement, { childList: true, subtree: true });
    }
  }

  // Bootstrap's dark mode -- bslib's input_dark_mode(), a theme -- is
  // data-bs-theme on <html>; Element Plus's is the class `dark` there. While
  // the attribute is set, the class follows it, so one switch turns both.
  if (typeof document !== 'undefined') {
    var html = document.documentElement;
    var followTheme = function () {
      var theme = html.getAttribute('data-bs-theme');
      if (theme === 'dark' || theme === 'light') html.classList.toggle('dark', theme === 'dark');
    };
    followTheme();
    if (typeof MutationObserver !== 'undefined') {
      new MutationObserver(followTheme).observe(html, { attributes: true, attributeFilter: ['data-bs-theme'] });
    }
  }

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
    // Element Plus frames a failed control from within the item's content
    // (.el-form-item.is-error .el-form-item__content .el-input__wrapper); an
    // unlabelled component's root box stands in for it
    var root = host.querySelector(':scope > [data-shiny-vue-root]');
    if (item === host && root) root.classList.add('el-form-item__content');
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
    var root = host.querySelector(':scope > [data-shiny-vue-root]');
    if (item === host && root) root.classList.remove('el-form-item__content');
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

  // call_el() arguments that stand for an object: el_table_row(3) is the
  // third row the table holds (Element compares rows by identity, so a copy
  // from R would not do); el_upload_file("a.csv") is that file in the list.
  sv.refs.row = function(i, vm) {
    var rows = vm.tableData || [];
    return rows[i - 1];
  };
  // el_tree_node(key): a tree's node, the object its expandNode() and the
  // like take, found by its key
  sv.refs.node = function(key, vm, target) {
    return target && typeof target.getNode === 'function' ? target.getNode(key) : undefined;
  };
  sv.refs.file = function(name, vm, target) {
    var files = vm.fileList || (target && target.uploadFiles) || [];
    for (var i = 0; i < files.length; i++) if (files[i].name === name) return files[i];
    return undefined;
  };

  // Where a table row sits, 1-based, so R can index its own data with it.
  se.rowIndex = function (vm, row) {
    if (!row || !vm || !vm.tableData) return null;
    var i = vm.tableData.indexOf(row);
    // a row replaced by update_el_table() is a new object; Element keeps
    // the old one ticked by its row-key, and so is it found here
    var key = vm.rowKey;
    if (i < 0 && typeof key === 'string' && row[key] !== undefined) {
      for (var k = 0; k < vm.tableData.length; k++) {
        if (vm.tableData[k] && vm.tableData[k][key] === row[key]) { i = k; break; }
      }
    }
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
      if (!window.ElementPlus) {
        console.warn('[shiny.element] <' + tag.toLowerCase() + '> was not rendered: ' +
          'Element Plus is not loaded on this page.');
        continue;
      }
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

// A config provider's card and dialog settings, for what this package draws
// as markup inside it: Element's ConfigProvider reaches its own el-card and
// el-dialog components, but el_card() and el_dialog() are plain markup with
// a binding. The provider's scope carries the settings as attributes; each
// card or dialog that left them to Element takes them, as Element's would.
(function () {
  var se = window.shinyElement = window.shinyElement || {};
  function apply(scope) {
    // the components drawn inside it later, apps of their own
    (scope._seFollowers || []).forEach(function (f) { f(); });
    var shadow = scope.getAttribute('data-card-shadow') || 'always';
    scope.querySelectorAll('.el-card[data-el-shadow-default]').forEach(function (card) {
      card.classList.remove('is-always-shadow', 'is-hover-shadow', 'is-never-shadow');
      card.classList.add('is-' + shadow + '-shadow');
    });
    var dialog = {};
    try { dialog = JSON.parse(scope.getAttribute('data-dialog') || '{}') || {}; } catch (e) {}
    scope.querySelectorAll('[data-el-overlay=dialog][data-el-dialog-defaults]').forEach(function (el) {
      var flags = {};
      el.getAttribute('data-el-dialog-defaults').split(' ').forEach(function (k) {
        if (k) flags[k] = !!dialog[k];
      });
      if (se.applyOverlayFlags) se.applyOverlayFlags(el, flags);
    });
  }
  se.applyProvider = apply;
  if (typeof document === 'undefined' || typeof MutationObserver === 'undefined') return;
  var queued = false;
  function all() {
    queued = false;
    document.querySelectorAll('.el-provider-scope').forEach(apply);
  }
  new MutationObserver(function (records) {
    for (var i = 0; i < records.length; i++) {
      var r = records[i];
      if (r.type === 'attributes' || r.addedNodes.length) {
        if (!queued) { queued = true; requestAnimationFrame(all); }
        return;
      }
    }
  }).observe(document.documentElement, {
    childList: true, subtree: true, attributes: true,
    attributeFilter: ['data-card-shadow', 'data-dialog', 'data-config']
  });
})();

// Element gives the inputs inside its components ids of their own, for
// their labels -- `el-id-1024-7` -- and Shiny's text, number and password
// bindings bind every such input that has an id: each select, input and
// picker on a page reported a stray input$`el-id-...` besides its own, and
// a date panel's header inputs did, teleported out of their component.
// They are Element's, not the page's: Shiny's bindings pass them over.
(function () {
  if (!window.Shiny || !Shiny.inputBindings || !window.jQuery) return;
  // Element's own: an input or textarea carrying one of its classes --
  // el-input__inner, el-select__input, el-range-input -- not a page's
  // input that happens to sit in a popover
  function elements(el) {
    if (!el.classList || !/^(INPUT|TEXTAREA)$/.test(el.tagName)) return false;
    return Array.prototype.some.call(el.classList, function (c) { return c.indexOf('el-') === 0; });
  }
  Shiny.inputBindings.getBindings().forEach(function (entry) {
    var binding = entry.binding;
    if (!binding || binding._elSkipsElement || typeof binding.find !== 'function') return;
    var find = binding.find;
    binding.find = function (scope) {
      return jQuery(find.call(this, scope)).filter(function () { return !elements(this); });
    };
    binding._elSkipsElement = true;
  });
})();
