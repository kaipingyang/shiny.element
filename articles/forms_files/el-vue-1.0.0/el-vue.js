// Mounting every Vue component of this package, and binding it to Shiny.
//
// A component is rendered as
//
//   <div id="<id>" data-el-vue-host style="display: contents">
//     <div id="<id>_container" style="display: contents"> Element markup </div>
//     <script type="application/json" data-el-vue> Vue options </script>
//   </div>
//
// The host carries the input id, so it *is* the component as far as the rest
// of Shiny is concerned: shinyjs::hide("id") hides it, removeUI("#id") removes
// it, a test driver finds it. Vue compiles the inner container in place.
//
// The host is a Shiny input binding, the way reactR binds React components:
// Shiny asks it for its value, subscribes to its changes, and unbinds it when
// it leaves the page. vueR, which this package used to mount on, renders Vue
// as an htmlwidget *output* -- the input id then sat on a hidden 0x0 element
// beside the component, out of reach of everything above.
(function() {
  'use strict';
  if (typeof Vue === 'undefined') return;

  var se = window.shinyElement = window.shinyElement || {};
  var HOST = '[data-el-vue-host]';

  // Functions travel as source, listed by path in `evals`, as htmlwidgets
  // sends them: "methods.handleChange", "data.columns.0.formatter".
  function revive(obj, paths) {
    (paths || []).forEach(function(path) {
      var parts = path.split('.');
      var o = obj;
      for (var i = 0; i < parts.length - 1; i++) {
        if (o == null) return;
        o = o[parts[i]];
      }
      var key = parts[parts.length - 1];
      if (o && typeof o[key] === 'string') o[key] = eval('(' + o[key] + ')');
    });
  }

  function mount(host) {
    if (host._elVue) return host._elVue;
    var script = host.querySelector(':scope > script[data-el-vue]');
    var target = host.querySelector(':scope > [data-el-mount]');
    if (!script || !target) return null;
    var spec = JSON.parse(script.textContent);
    revive(spec, spec.evals);
    spec.options.el = target;
    var vm = new Vue(spec.options);
    vm._elHost = host;
    host._elVue = vm;
    host._elSpec = { input: spec.input || null, type: spec.type || null,
                     rate: spec.rate || null };
    watchDisabled(host, vm);
    return vm;
  }

  // shinyjs::disable() sets `disabled` on the element it is given, which is
  // the host. The component's own `disabled` field is what Element draws, so
  // carry the attribute over.
  function watchDisabled(host, vm) {
    if (typeof MutationObserver === 'undefined' || !('disabled' in vm.$data)) return;
    var obs = new MutationObserver(function() {
      vm.disabled = host.hasAttribute('disabled');
    });
    obs.observe(host, { attributes: true, attributeFilter: ['disabled'] });
    host._elObserver = obs;
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

  // The component behind an id, mounting it first if need be. Shaped like
  // HTMLWidgets.find() -- {instance: vm} -- which this replaces.
  se.find = function(id) {
    var host = document.getElementById(String(id).replace(/^#/, ''));
    if (!host || !host.hasAttribute('data-el-vue-host')) return null;
    var vm = mount(host);
    return vm ? { instance: vm } : null;
  };
  se.mount = mountAll;

  // The reported value: a field -- "value", "range" -- or an expression over
  // the instance's fields, as a menu reports "active || null" so that nothing
  // selected arrives as NULL rather than "".
  function getter(expr) {
    if (/^[A-Za-z_$][\w$]*$/.test(expr)) return function(vm) { return vm[expr]; };
    var f = new Function('with (this) { return (' + expr + '); }');
    return function(vm) { return f.call(vm); };
  }

  function hasShiny() {
    return typeof Shiny !== 'undefined' && !!Shiny.InputBinding && !!Shiny.inputBindings;
  }

  if (!hasShiny()) {
    // A page with no Shiny: mount once the document is there
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', function() { mountAll(document); });
    } else {
      mountAll(document);
    }
    return;
  }

  var binding = new Shiny.InputBinding();
  jQuery.extend(binding, {
    // Shiny calls find() whenever it binds a piece of the page -- at start-up,
    // and for every renderUI() and insertUI() -- so mounting here covers
    // them all, before Shiny asks for a value.
    find: function(scope) {
      return jQuery(mountAll(scope && scope.nodeType ? scope : jQuery(scope)[0] || document));
    },
    // Only a component with a value of its own is an input. The others --
    // an avatar, a progress bar -- are mounted all the same, but binding them
    // would set an input$<id> of NULL for each.
    getId: function(el) {
      return (el._elSpec && el._elSpec.input) ? el.id : null;
    },
    getType: function(el) {
      return (el._elSpec && el._elSpec.type) || false;
    },
    getValue: function(el) {
      var vm = el._elVue, field = el._elSpec && el._elSpec.input;
      if (!vm || !field) return null;
      var v = getter(field)(vm);
      return se.plain ? se.plain(v) : v;
    },
    setValue: function(el, value) {
      var vm = el._elVue, field = el._elSpec && el._elSpec.input;
      // An expression cannot be assigned to; its first field can
      var target = field && field.match(/^[A-Za-z_$][\w$]*/);
      if (vm && target && target[0] in vm.$data) vm[target[0]] = value;
    },
    subscribe: function(el, callback) {
      var vm = el._elVue, field = el._elSpec && el._elSpec.input;
      if (!vm || !field) return;
      var get = getter(field);
      el._elUnwatch = vm.$watch(function() { return get(this); },
                                function() { callback(true); }, { deep: true });
    },
    unsubscribe: function(el) {
      // Leaving the page -- removeUI(), a renderUI() redrawn -- so the
      // instance goes too, rather than living on over detached DOM.
      if (el._elUnwatch) el._elUnwatch();
      if (el._elObserver) el._elObserver.disconnect();
      if (el._elVue) el._elVue.$destroy();
      el._elVue = null;
    },
    getRatePolicy: function(el) {
      return (el._elSpec && el._elSpec.rate) || null;
    },
    receiveMessage: function(el, data) {
      // update_el_*() still arrives as a custom message; this serves
      // session$sendInputMessage() for anyone who sends one.
      var vm = el._elVue;
      if (!vm) return;
      Object.keys(data).forEach(function(k) { if (k in vm.$data) vm[k] = data[k]; });
    }
  });
  Shiny.inputBindings.register(binding, 'shiny.element.vue');
})();
