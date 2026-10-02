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
      // a dot inside a name arrives escaped, "a\\.b"
      var parts = path.split(/(?<!\\)\./).map(function(p) { return p.replace(/\\\./g, '.'); });
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

  // A host leaving the page takes its instance and its questions with it. A
  // bound host hears it from Shiny (unsubscribe); a host with no value of its
  // own -- a table, an alert -- is never bound, so removals are watched for.
  function release(host) {
    if (host._shinyVueObserver) host._shinyVueObserver.disconnect();
    dropQuestions(host);
    if (host._shinyVue) host._shinyVue.$destroy();
    host._shinyVue = null;
  }
  sv.release = release;
  if (typeof MutationObserver !== 'undefined' && typeof document !== 'undefined') {
    var gone = new MutationObserver(function(records) {
      records.forEach(function(r) {
        Array.prototype.forEach.call(r.removedNodes, function(n) {
          if (n.nodeType !== 1) return;
          var hosts = n.matches && n.matches('[data-shiny-vue]') ? [n] : [];
          hosts = hosts.concat(Array.prototype.slice.call(n.querySelectorAll('[data-shiny-vue]')));
          hosts.forEach(function(h) {
            // Moved rather than removed -- a dialog appended to <body> -- is
            // still on the page
            if (h._shinyVue && !document.documentElement.contains(h)) release(h);
          });
        });
      });
    });
    var startWatching = function() {
      gone.observe(document.documentElement, { childList: true, subtree: true });
    };
    if (document.documentElement) startWatching();
  }

  // ── updates and method calls from the server ────────────────────────────
  //
  // One message type each, whatever the component. Not the binding's
  // receiveMessage(): Shiny hands an input message only to a *bound* input,
  // and a component with no value of its own -- an avatar, a progress bar, a
  // table -- is mounted but not bound, so its updates would be dropped
  // without a word. These find the host by id, bound or not.

  function warn(text) { if (window.console) console.warn('[shiny-vue] ' + text); }

  // Assign the fields a component declares. A field it does not declare is
  // refused with a warning rather than assigned: Vue would not track it, so
  // the update could never take effect. A component with something to do
  // beyond assigning -- move a carousel, check tree nodes -- defines
  // shinyVueReceive(data), which handles what it can and returns the rest.
  // Keys starting with a dot are the bridge's, not fields. A layer above it
  // registers what it handles -- the Element layer draws a label and an
  // error message -- and `.resolve` answers a question a component asked.
  sv.hooks = sv.hooks || {};
  // How a component layer finds an object a method takes, by index or name
  sv.refs = sv.refs || {};

  sv.update = function(id, data) {
    var host = document.getElementById(id);
    var vm = host && host.hasAttribute('data-shiny-vue') ? mount(host) : null;
    if (!vm) { warn('update: no component with id "' + id + '"'); return; }
    // A function in an update -- a new formatter, a form rule's validator --
    // travels as source too
    if (data['.evals']) { revive(data, data['.evals']); delete data['.evals']; }
    var rest = {};
    Object.keys(data).forEach(function(k) {
      if (k === 'id') return;
      if (k.charAt(0) === '.' && typeof sv.hooks[k] === 'function') {
        sv.hooks[k](host, data[k], vm);
      } else {
        rest[k] = data[k];
      }
    });
    if (typeof vm.shinyVueReceive === 'function') rest = vm.shinyVueReceive(rest) || {};
    Object.keys(rest).forEach(function(k) {
      if (!(k in vm.$data)) {
        warn('update: "' + k + '" is not a field of "' + id + '"; the update was ignored');
        return;
      }
      vm[k] = rest[k];
    });
    // Report the new value, as Shiny's own update*Input() does
    if (vm._elReport) vm._elReport();
  };

  // ── asking the server ───────────────────────────────────────────────────
  //
  // A component that cannot go on without the server -- a tree node's
  // children, a cascader's next column, a select's matches -- asks: the
  // question goes to input$<input> with a request number, and the promise
  // settles when an update carries `.resolve: {request, value}` back. With
  // no server to ask, the answer is null at once.
  //
  // A question is not kept for ever: one the server never answers -- no
  // observer, an error, a lost connection -- settles as null after
  // sv.askTimeout (30 s), and the questions of a component that leaves the
  // page settle at once, so nothing waits on a spinner or stays in memory.
  var pending = {}, nextRequest = 0;
  sv.askTimeout = 30000;
  function settle(request, value) {
    var p = pending[request];
    if (!p) return false;
    delete pending[request];
    clearTimeout(p.timer);
    p.resolve(value);
    return true;
  }
  sv.ask = function(input, question, owner) {
    if (typeof Shiny === 'undefined' || !Shiny.setInputValue) return Promise.resolve(null);
    var request = ++nextRequest;
    var payload = plain(question) || {};
    payload.request = request;
    var host = owner && owner._shinyVueHost ? owner._shinyVueHost : null;
    return new Promise(function(resolve) {
      pending[request] = {
        resolve: resolve, host: host,
        timer: setTimeout(function() {
          if (settle(request, null)) warn('no answer to input$' + input + ' request ' + request +
                                          ' within ' + sv.askTimeout / 1000 + ' s');
        }, sv.askTimeout)
      };
      Shiny.setInputValue(input, payload, { priority: 'event' });
    });
  };
  sv.hooks['.resolve'] = function(host, answer) {
    if (!answer || !settle(answer.request, answer.value)) {
      warn('update: "' + host.id + '" answered request ' + (answer && answer.request) +
           ', which nothing is waiting for');
    }
  };
  function dropQuestions(host) {
    Object.keys(pending).forEach(function(r) {
      if (!host || pending[r].host === host) settle(r, null);
    });
  }
  if (typeof jQuery !== 'undefined') {
    jQuery(document).on('shiny:disconnected', function() { dropQuestions(null); });
  }

  // The component the instance renders, whose methods Element documents:
  // $refs.el if marked, else the first child of the given name, else the
  // first child at all.
  function componentOf(vm, name) {
    if (vm.$refs && vm.$refs.el) return vm.$refs.el;
    var found = null;
    (function walk(node, depth) {
      if (found || depth > 4 || !node.$children) return;
      for (var i = 0; i < node.$children.length; i++) {
        var child = node.$children[i];
        if (!name || (child.$options || {}).name === name) { found = child; return; }
      }
      for (var j = 0; j < node.$children.length && !found; j++) walk(node.$children[j], depth + 1);
    })(vm, 0);
    return found || (vm.$children || [])[0] || null;
  }

  var SAFE_NAME = /^[A-Za-z][A-Za-z0-9_]*$/;

  function reportResult(input, value) {
    if (!input || typeof Shiny === 'undefined' || !Shiny.setInputValue) return;
    Shiny.setInputValue(input, plain(value === undefined ? true : value), { priority: 'event' });
  }

  // Call a method of the component behind an id, and report what it returns
  // -- a promise's value once it settles -- as input$<input>.
  sv.call = function(msg) {
    if (!SAFE_NAME.test(msg.method)) { warn('call: refusing method name "' + msg.method + '"'); return; }
    var args = msg.args || [];
    if (!Array.isArray(args)) args = [args];
    var host = document.getElementById(msg.id);
    // A component drawn as markup with a binding of its own (a drawer)
    // lists its methods on the element
    if (host && !host.hasAttribute('data-shiny-vue') && host._elMethods &&
        Object.prototype.hasOwnProperty.call(host._elMethods, msg.method)) {
      reportResult(msg.input, host._elMethods[msg.method].apply(host, args));
      return;
    }
    var vm = host && host.hasAttribute('data-shiny-vue') ? mount(host) : null;
    if (!vm) { warn('call: no component with id "' + msg.id + '"'); return; }
    var target = componentOf(vm, msg.component);
    if (!target) { warn('call: no component under "' + msg.id + '"'); return; }
    // An argument that names an object the component holds -- a table's
    // row, an upload's file -- by an index or a name, since the object
    // itself cannot cross the wire: {".ref": kind, value: ...}
    args = args.map(function(a) {
      if (!a || typeof a !== 'object' || !a['.ref']) return a;
      var resolve = sv.refs[a['.ref']];
      if (!resolve) { warn('call: no way to find a "' + a['.ref'] + '"'); return a; }
      var found = resolve(a.value, vm, target);
      if (found === undefined) warn('call: no ' + a['.ref'] + ' ' + JSON.stringify(a.value) + ' in "' + msg.id + '"');
      return found;
    });
    if (typeof target[msg.method] !== 'function') {
      warn('call: "' + msg.method + '" is not a method of the component behind "' + msg.id + '"');
      return;
    }
    var result;
    try { result = target[msg.method].apply(target, args); }
    catch (e) { warn('call: ' + msg.method + '() raised: ' + e.message); return; }
    if (vm._elReport) vm._elReport();   // a method can change a reported value
    if (!msg.input) return;
    if (result && typeof result.then === 'function') {
      result.then(function(v) { reportResult(msg.input, v); },
                  function() { reportResult(msg.input, false); });
    } else {
      reportResult(msg.input, result);
    }
  };

  var hasShiny = typeof Shiny !== 'undefined' && !!Shiny.InputBinding && !!Shiny.inputBindings;
  if (hasShiny && Shiny.addCustomMessageHandler) {
    Shiny.addCustomMessageHandler('shinyVueUpdate', function(msg) { sv.update(msg.id, msg); });
    Shiny.addCustomMessageHandler('shinyVueCall', sv.call);
  }
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
      release(el);
    },
    getRatePolicy: function(el) {
      return (el._shinyVueSpec && el._shinyVueSpec.rate) || null;
    },
    // shinyvalidate asks the binding to show a rule's message before it looks
    // for a Bootstrap .form-group, so a component library can show it its
    // own way: shinyVue.setInvalid / clearInvalid, or a plain message below.
    setInvalid: function(el, data) {
      var msg = (data && data.message) || '';
      if (typeof sv.setInvalid === 'function') return sv.setInvalid(el, msg);
      var box = el.querySelector(':scope > .shiny-vue-invalid');
      if (!box) {
        box = document.createElement('div');
        box.className = 'shiny-vue-invalid';
        box.style.color = '#dc3545';
        box.style.fontSize = '0.875em';
        el.appendChild(box);
      }
      box.textContent = msg;
    },
    clearInvalid: function(el) {
      if (typeof sv.clearInvalid === 'function') return sv.clearInvalid(el);
      var box = el.querySelector(':scope > .shiny-vue-invalid');
      if (box) box.parentNode.removeChild(box);
    },
    // session$sendInputMessage(id, list(field = value)), for anyone who sends
    // one to a component with a value: the same as shinyVueUpdate.
    receiveMessage: function(el, data) {
      sv.update(el.id, data);
    }
  });
  Shiny.inputBindings.register(binding, 'shiny.vue');
})();
