// Vue components as Shiny inputs. Nothing here is specific to Element UI:
// this is the layer a component library builds on.
//
// A component is rendered as
//
//   <div id="<id>" data-shiny-vue style="display: contents">
//     <script type="text/x-template" data-shiny-vue-template> markup </script>
//     <script type="application/json" data-shiny-vue-options> options </script>
//   </div>
//
// The host carries the input id, so it *is* the component as far as the rest
// of Shiny is concerned: shinyjs::hide("id") hides it, removeUI("#id")
// removes it, a test driver finds it.
//
// The template is a script, so the browser never parses it as HTML: nothing
// shows before Vue compiles it, and camelCase attribute names
// (:pickerOptions) reach Vue as written -- an HTML parser lowercases them.
// Vue compiles it off the page and the result goes into the host, which is
// never itself replaced.
//
// The host is a Shiny input binding, as reactR binds React components: Shiny
// asks it for its value, subscribes to its changes, and unbinds it when it
// leaves the page.
(function() {
  'use strict';
  if (typeof Vue === 'undefined') return;

  var sv = window.shinyVue = window.shinyVue || {};
  var HOST = '[data-shiny-vue]';

  // ── values that can cross the wire ──────────────────────────────────────

  function serialisable(x) {
    if (x === null || x === undefined) return false;
    if (typeof Node !== 'undefined' && x instanceof Node) return false;
    if (typeof Event !== 'undefined' && x instanceof Event) return false;
    if (typeof x === 'function') return false;
    if (x._isVue || x.$options) return false;
    return true;
  }

  // Component libraries hand whole instances and tree nodes to their events;
  // a tree node points at its parent and children, so the walk is bounded.
  var MAX_DEPTH = 6;
  function plain(x, depth, seen) {
    depth = depth || 0;
    seen = seen || [];
    if (x === null || typeof x !== 'object') return x;
    if (depth >= MAX_DEPTH || seen.indexOf(x) !== -1) return undefined;
    if (x._isVue || x.$el || x.$options) return undefined;
    seen = seen.concat([x]);
    if (Array.isArray(x)) return x.map(function(v) { return plain(v, depth + 1, seen); });
    var out = {};
    Object.keys(x).forEach(function(k) {
      if (k.charAt(0) === '$' || k.charAt(0) === '_') return;
      var v = x[k];
      if (typeof v === 'function') return;
      if (typeof Node !== 'undefined' && v instanceof Node) return;
      var p = (v !== null && typeof v === 'object') ? plain(v, depth + 1, seen) : v;
      if (p !== undefined) out[k] = p;
    });
    return out;
  }
  sv.plain = plain;
  sv.serialisable = serialisable;

  // A component event as input$<id>_<event>. Several arguments go as an
  // object, never an array: Shiny unlists an unnamed list into one flat
  // vector, types and all.
  sv.emit = function(id, event, args) {
    if (typeof Shiny === 'undefined' || !Shiny.setInputValue) return;
    var usable = Array.prototype.slice.call(args).filter(serialisable)
      .map(function(a) { return plain(a); })
      .filter(function(a) { return a !== undefined; });
    var value;
    if (usable.length === 0) value = true;
    else if (usable.length === 1) value = usable[0];
    else {
      value = {};
      usable.forEach(function(u, i) { value['arg' + (i + 1)] = u; });
    }
    Shiny.setInputValue(id + '_' + event, value, { priority: 'event' });
  };

  // ── mounting ────────────────────────────────────────────────────────────

  // Functions travel as source, listed by path in `evals`, as htmlwidgets
  // sends them: "options.methods.handleChange".
  function revive(obj, paths) {
    (paths || []).forEach(function(path) {
      var parts = path.split('.'), o = obj;
      for (var i = 0; i < parts.length - 1; i++) {
        if (o == null) return;
        o = o[parts[i]];
      }
      var key = parts[parts.length - 1];
      if (o && typeof o[key] === 'string') o[key] = eval('(' + o[key] + ')');
    });
  }

  function mount(host) {
    if (host._shinyVue) return host._shinyVue;
    var tpl = host.querySelector(':scope > script[data-shiny-vue-template]');
    var opt = host.querySelector(':scope > script[data-shiny-vue-options]');
    if (!tpl || !opt) return null;
    var spec = JSON.parse(opt.textContent);
    revive(spec, spec.evals);
    spec.options.template = tpl.textContent;
    var vm = new Vue(spec.options);
    vm.$mount();
    host.appendChild(vm.$el);
    vm._shinyVueHost = host;
    host._shinyVue = vm;
    host._shinyVueSpec = { input: spec.input || null, type: spec.type || null,
                           rate: spec.rate || null };
    watchDisabled(host, vm);
    return vm;
  }

  // shinyjs::disable() sets `disabled` on the element it is given, which is
  // the host. A component's own `disabled` field is what it draws from, so
  // carry the attribute over.
  function watchDisabled(host, vm) {
    if (typeof MutationObserver === 'undefined' || !('disabled' in vm.$data)) return;
    var obs = new MutationObserver(function() { vm.disabled = host.hasAttribute('disabled'); });
    obs.observe(host, { attributes: true, attributeFilter: ['disabled'] });
    host._shinyVueObserver = obs;
  }

  function mountAll(scope) {
    scope = scope || document;
    var hosts = [];
    if (scope.matches && scope.matches(HOST)) hosts.push(scope);
    if (scope.querySelectorAll) {
      hosts = hosts.concat(Array.prototype.slice.call(scope.querySelectorAll(HOST)));
    }
    hosts.forEach(mount);
    return hosts;
  }

  // The component behind an id, mounted first if need be, as {instance: vm}.
  sv.find = function(id) {
    var host = document.getElementById(String(id).replace(/^#/, ''));
    if (!host || !host.hasAttribute('data-shiny-vue')) return null;
    var vm = mount(host);
    return vm ? { instance: vm } : null;
  };
  sv.mount = mountAll;

  // The reported value: a field, or an expression over the fields ("active
  // || null" reports nothing selected as NULL rather than "").
  function getter(expr) {
    if (/^[A-Za-z_$][\w$]*$/.test(expr)) return function(vm) { return vm[expr]; };
    var f = new Function('with (this) { return (' + expr + '); }');
    return function(vm) { return f.call(vm); };
  }

  var hasShiny = typeof Shiny !== 'undefined' && !!Shiny.InputBinding && !!Shiny.inputBindings;
  if (!hasShiny) {
    // A page with no Shiny -- R Markdown, a static site: mount once it is there
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', function() { mountAll(document); });
    } else {
      mountAll(document);
    }
    return;
  }

  // ── the Shiny binding ───────────────────────────────────────────────────

  var binding = new Shiny.InputBinding();
  jQuery.extend(binding, {
    // Shiny calls find() whenever it binds a piece of the page -- start-up,
    // renderUI(), insertUI() -- so mounting here covers all three, before
    // Shiny asks for a value.
    find: function(scope) {
      var node = scope && scope.nodeType ? scope : (jQuery(scope)[0] || document);
      return jQuery(mountAll(node));
    },
    // Only a component with a value is an input; the others are mounted all
    // the same, but binding them would add an input$<id> of NULL for each.
    getId: function(el) {
      return (el._shinyVueSpec && el._shinyVueSpec.input) ? el.id : null;
    },
    getType: function(el) {
      return (el._shinyVueSpec && el._shinyVueSpec.type) || false;
    },
    getValue: function(el) {
      var vm = el._shinyVue, field = el._shinyVueSpec && el._shinyVueSpec.input;
      if (!vm || !field) return null;
      return plain(getter(field)(vm));
    },
    setValue: function(el, value) {
      var vm = el._shinyVue, field = el._shinyVueSpec && el._shinyVueSpec.input;
      var target = field && field.match(/^[A-Za-z_$][\w$]*/);
      if (vm && target && target[0] in vm.$data) vm[target[0]] = value;
    },
    subscribe: function(el, callback) {
      var vm = el._shinyVue, field = el._shinyVueSpec && el._shinyVueSpec.input;
      if (!vm || !field) return;
      var get = getter(field);
      el._shinyVueUnwatch = vm.$watch(function() { return get(this); },
                                      function() { callback(true); }, { deep: true });
    },
    // Leaving the page -- removeUI(), a renderUI() redrawn: the instance goes
    // too, rather than living on over detached DOM.
    unsubscribe: function(el) {
      if (el._shinyVueUnwatch) el._shinyVueUnwatch();
      if (el._shinyVueObserver) el._shinyVueObserver.disconnect();
      if (el._shinyVue) el._shinyVue.$destroy();
      el._shinyVue = null;
    },
    getRatePolicy: function(el) {
      return (el._shinyVueSpec && el._shinyVueSpec.rate) || null;
    },
    // session$sendInputMessage(id, list(field = value)) assigns fields the
    // component declares.
    receiveMessage: function(el, data) {
      var vm = el._shinyVue;
      if (!vm) return;
      Object.keys(data).forEach(function(k) { if (k in vm.$data) vm[k] = data[k]; });
    }
  });
  Shiny.inputBindings.register(binding, 'shiny.vue');
})();
