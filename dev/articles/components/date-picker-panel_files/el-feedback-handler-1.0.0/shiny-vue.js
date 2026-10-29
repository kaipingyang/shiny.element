// Vue components as Shiny inputs. Nothing here knows any component library:
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
    if (x === undefined) return false;
    if (x === null) return true;
    if (typeof Node !== 'undefined' && x instanceof Node) return false;
    if (typeof Event !== 'undefined' && x instanceof Event) return false;
    if (typeof x === 'function') return false;
    if (x._isVue || x.$options || x.$ || x.__v_skip) return false;
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
    if (x._isVue || x.$el || x.$options || x.$ || x.__v_skip) return undefined;
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
  // A component's value as an input reports it. JSON has no undefined --
  // JSON.stringify leaves nothing for it -- so an input set to undefined
  // was never sent and kept its old value on the server -- a select that
  // the component library clears to undefined. It goes as null, NULL in R,
  // as an empty selection does.
  function reported(x) {
    var p = plain(x);
    return p === undefined ? null : p;
  }
  sv.plain = plain;
  sv.serialisable = serialisable;

  // A component event as input$<id>_<event>. Several arguments go as an
  // object, never an array: Shiny unlists an unnamed list into one flat
  // vector, types and all. What cannot travel -- undefined, an element, an
  // event, a function, a component -- is left out; null is a value and keeps
  // its place, but nulls at the end are dropped ($emit('pick', row, null) is
  // the row), unless null is all there is.
  //
  // `wait` (ms) is for an event that fires on every frame -- a scroll, a
  // drag: it goes at once, then at most once per `wait`, and the last one
  // always goes, so the server hears where the scroll or the drag ended.
  var throttled = {};
  // A key pressed is worth sending: which one, and the modifiers held. Other
  // DOM events carry nothing a server can use, and are dropped.
  function keyOf(x) {
    if (typeof KeyboardEvent === 'undefined' || !(x instanceof KeyboardEvent)) return x;
    return { key: x.key, code: x.code, ctrl: x.ctrlKey, shift: x.shiftKey, alt: x.altKey, meta: x.metaKey };
  }

  sv.emit = function(id, event, args, wait) {
    if (typeof Shiny === 'undefined' || !Shiny.setInputValue) return;
    var usable = Array.prototype.slice.call(args || []).map(keyOf).filter(serialisable)
      .map(function(a) { return a === null ? null : plain(a); })
      .filter(function(a) { return a !== undefined; });
    while (usable.length > 1 && usable[usable.length - 1] === null) usable.pop();
    var value;
    if (usable.length === 0) value = true;
    else if (usable.length === 1) value = usable[0];
    else {
      value = {};
      usable.forEach(function(u, i) { value['arg' + (i + 1)] = u; });
    }
    var input = event ? id + '_' + event : id;
    var send = function(v) { Shiny.setInputValue(input, v, { priority: 'event' }); };
    if (!wait) return send(value);
    var t = throttled[input] || (throttled[input] = { last: 0, timer: null, value: null });
    var now = Date.now();
    t.value = value;
    if (t.timer) return;
    if (now - t.last >= wait) { t.last = now; send(value); return; }
    t.timer = setTimeout(function() {
      t.timer = null;
      t.last = Date.now();
      send(t.value);
    }, wait - (now - t.last));
  };

  // ── mounting ────────────────────────────────────────────────────────────

  // A child registered as todo_item -- R's way of writing a name -- is
  // <todo_item> in a template as written, and <todo-item>, Vue's way, too.
  function aliasComponents(opts) {
    var comps = opts && opts.components;
    if (!comps || typeof comps !== 'object') return;
    Object.keys(comps).forEach(function(k) {
      aliasComponents(comps[k]);
      var kebab = k.replace(/_/g, '-');
      if (kebab !== k && !(kebab in comps)) comps[kebab] = comps[k];
    });
  }

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
  // ── the page's router (vue_router()) ────────────────────────────────────
  //
  // One vue-router for the page, in every app (mount() installs it). Any
  // path is a route -- one catch-all record that renders nothing -- for
  // what the page shows is the server's, from input$<id>: the route's full
  // path, reported on load and after every navigation that succeeds. It is
  // started in an app of its own, so it runs with no component on the page.
  sv.router = null;
  sv.routerId = null;
  sv.createRouter = function(config) {
    if (sv.router) {
      warn('vue_router("' + config.id + '"): the page has a router already, "' + sv.routerId + '"');
      return sv.router;
    }
    if (!window.VueRouter) { warn('vue_router(): VueRouter is not on the page'); return null; }
    revive(config, config.evals);
    var history = config.history === 'memory' ?
      VueRouter.createMemoryHistory() : VueRouter.createWebHashHistory();
    // the routes given, each a component a <router-view> renders; then any
    // other path, rendering nothing
    var nothing = { render: function() { return null; } };
    var routes = (config.routes || []).map(function(r) {
      aliasComponents(r.component);
      return { path: r.path, component: r.component };
    });
    routes.push({ path: '/:pathMatch(.*)*', component: nothing });
    var router = VueRouter.createRouter({ history: history, routes: routes });
    // before Shiny is connected -- the first navigation, as the page loads
    // -- the latest route waits for it
    var latest = null, waiting = false;
    var connected = function() {
      return window.Shiny && Shiny.setInputValue && Shiny.shinyapp &&
        Shiny.shinyapp.isConnected && Shiny.shinyapp.isConnected();
    };
    var params = function(route) {
      return Object.keys(route.params).length && !route.params.pathMatch ? plain(route.params) : null;
    };
    var send = function(route) {
      Shiny.setInputValue(config.id + '_params', params(route));
      Shiny.setInputValue(config.id, route.fullPath);
    };
    var report = function(route) {
      latest = route;
      if (connected()) { send(route); return; }
      if (waiting || !window.jQuery) return;
      waiting = true;
      jQuery(document).one('shiny:connected', function() {
        waiting = false;
        if (latest !== null) send(latest);
      });
    };
    // A guard: the browser's own (as vue-router's beforeEach), or the
    // server's -- each navigation asks input$<id>_guard and waits for
    // vue_answer(): true goes, false stays, a path goes there; no answer
    // in time goes
    if (typeof config.guard === 'function') {
      router.beforeEach(config.guard);
    } else if (config.guard === 'server') {
      router.beforeEach(function(to, from) {
        return sv.ask(config.id + '_guard', {
          to: to.fullPath,
          from: from.fullPath,
          params: params(to)
        }).then(function(answer) {
          if (answer === false) return false;
          if (typeof answer === 'string') return answer;
          return true;
        }, function() { return false; });
      });
    }
    // a refused navigation runs afterEach too, with its failure
    router.afterEach(function(to, from, failure) { if (!failure) report(to); });
    sv.router = router;
    sv.routerId = config.id;
    var start = function() {
      Vue.createApp({ render: function() { return null; } }).use(router)
        .mount(document.createElement('div'));
      // a bookmark's route, when the URL brings none of its own
      var hash = window.location.hash;
      if (config.initial && (config.history === 'memory' || !hash || hash === '#' || hash === '#/')) {
        router.replace(config.initial);
      }
    };
    if (!window.Vue) return router;
    // asking the server needs it: the first navigation waits for Shiny
    if (config.guard === 'server' && window.Shiny && Shiny.shinyapp && !connected() && window.jQuery) {
      jQuery(document).one('shiny:connected', start);
    } else {
      start();
    }
    return router;
  };


  // ── optional props ──────────────────────────────────────────────────────
  //
  // A prop the component library defaults when it is not given. Vue applies
  // a prop's default for undefined only, and JSON has no undefined: unset in
  // R (NULL, or NA in an update) arrives as null, and for the fields a
  // component lists as optional (spec.optional, {group: {prop: field}}) it
  // is made undefined here -- before revive(), so that JS("null"), revived
  // after, stays a deliberate null. A template binds a group with
  // v-bind="$optional('group')", which gives the props whose field is not
  // undefined. An entry may be {field, wrap}: the value goes through
  // sv.optionalWraps[wrap], which a component library registers, called
  // on the component (`this`).
  sv.optionalWraps = sv.optionalWraps || {};
  function optionalEntry(e) { return typeof e === 'string' ? { field: e } : e; }
  function optionalFields(optional) {
    var out = {};
    Object.keys(optional || {}).forEach(function(g) {
      Object.keys(optional[g]).forEach(function(p) { out[optionalEntry(optional[g][p]).field] = true; });
    });
    return out;
  }
  // null -> undefined for the optional ones among `data`'s keys; `nameOf`
  // maps a key to the field it sets, where the two differ (a folded component)
  function unsetOptional(fields, data, nameOf) {
    if (!data) return;
    Object.keys(data).forEach(function(k) {
      var f = nameOf ? nameOf(k) : k;
      if (f && fields[f] && data[k] === null) data[k] = undefined;
    });
  }
  function optionalOf(vm) { return optionalFields(vm && vm.$options && vm.$options.shinyVueOptional); }
  function optionalProps(group) {
    var map = (this.$options.shinyVueOptional || {})[group], out = {};
    if (!map) { warn('$optional: no group "' + group + '"'); return out; }
    for (var prop in map) {
      var e = optionalEntry(map[prop]), v = this[e.field];
      if (v === undefined) continue;
      if (e.wrap) {
        var wrap = sv.optionalWraps[e.wrap];
        if (typeof wrap !== 'function') { warn('$optional: no wrap "' + e.wrap + '"'); continue; }
        v = wrap.call(this, v);
      }
      out[prop] = v;
    }
    return out;
  }


  // Stores: state shared by components. Each component is an app of its
  // own, so Vue's provide/inject cannot reach across them; a store is what
  // Vue recommends instead, Pinia's -- reached in any template as
  // $store.<id>, its getters and actions with it. A store is itself a host
  // (vue_store()) exposing the store, so the bridge treats it as any
  // component: its model is input$<id>, update_vue() sets its state,
  // call_vue() runs its actions, a bookmark restores it.
  var storeRegistry = null;
  sv.stores = function() {
    if (!storeRegistry) storeRegistry = Vue.reactive({});
    return storeRegistry;
  };
  // One Pinia for the page; a store defined from a vue_store()'s spec
  var pinia = null;
  function piniaOf() {
    if (!pinia && window.Pinia) pinia = Pinia.createPinia();
    return pinia;
  }
  function defineStore(id, state, def) {
    if (!window.Pinia) { warn('vue_store("' + id + '"): Pinia is not on the page'); return null; }
    var p = piniaOf();
    // a store drawn again starts from its new state, not the old one's
    if (p.state.value[id]) delete p.state.value[id];
    var useStore = Pinia.defineStore(id, typeof def.setup === 'function' ? def.setup : {
      state: function() { return state; },
      getters: def.getters || {},
      actions: def.actions || {}
    });
    var store = useStore(p);
    sv.stores()[id] = store;
    return store;
  }
  // What a store's host exposes: its state and getters as refs, its actions
  function storeFields(store) {
    var out = {}, refs = Pinia.storeToRefs(store);
    Object.keys(refs).forEach(function(k) { out[k] = refs[k]; });
    Object.keys(store).forEach(function(k) {
      if (typeof store[k] === 'function' && k.charAt(0) !== '$' && k.charAt(0) !== '_') out[k] = store[k];
    });
    return out;
  }
  // A store in a component's setup(): the Pinia store vue_store() made
  sv.useStore = function(id) {
    var st = sv.stores()[id];
    if (!st) warn('useStore(): no store "' + id + '" on the page');
    return st || null;
  };
  // ── state followed in the browser: vue_bind() ──────────────────────────
  //
  // A field given vue_bind("<path>") in R follows page state with no round
  // trip: a store's field ($store.<id>.<field>, both ways), another
  // component's value ($inputs.<id>) or the route ($route.<...>), one way.
  // The field stays in the component's data -- its template, $optional,
  // updates and its input are as they were -- and is kept in step with
  // the path by two watchers (bindFields()). Containers, which are not Vue
  // apps, follow a path with sv.bindElement().
  var PATH_SEGMENT = /\.([A-Za-z_$][\w$]*)|\['((?:[^'\\]|\\.)*)'\]|\["((?:[^"\\]|\\.)*)"\]|\[(\d+)\]/g;
  function pathOf(path) {
    var root = String(path).match(/^\$(store|inputs|route)/);
    if (!root) return null;
    var keys = [], rest = path.slice(root[0].length), m, at = 0;
    PATH_SEGMENT.lastIndex = 0;
    while ((m = PATH_SEGMENT.exec(rest)) && m.index === at) {
      keys.push(m[1] !== undefined ? m[1] :
                m[2] !== undefined ? m[2].replace(/\\(.)/g, '$1') :
                m[3] !== undefined ? m[3].replace(/\\(.)/g, '$1') : Number(m[4]));
      at = PATH_SEGMENT.lastIndex;
    }
    if (at !== rest.length || !keys.length) return null;
    return { root: root[1], keys: keys, text: path };
  }
  function rootOf(name) {
    if (name === 'store') return sv.stores();
    if (name === 'inputs') return sv.inputs();
    return sv.router ? sv.router.currentRoute.value : undefined;
  }
  function readPath(p) {
    var o = rootOf(p.root);
    for (var i = 0; i < p.keys.length; i++) {
      if (o === null || o === undefined) return undefined;
      o = o[p.keys[i]];
    }
    return o;
  }
  function writePath(p, value) {
    if (p.root !== 'store') { warn(p.text + ' is read-only'); return; }
    var o = rootOf(p.root);
    for (var i = 0; i < p.keys.length - 1; i++) {
      o = o === null || o === undefined ? undefined : o[p.keys[i]];
    }
    if (o === null || typeof o !== 'object') {
      warn(p.text + ': no such store or field on the page; the change stays with the component');
      return;
    }
    o[p.keys[p.keys.length - 1]] = value;
  }
  // a copy, so a field and the state it follows never share an array
  function copied(v) { return v !== null && typeof v === 'object' ? plain(v) : v; }
  function same(a, b) {
    return a === b || JSON.stringify(plain(a)) === JSON.stringify(plain(b));
  }
  // An element of a binding of its own -- a component drawn as markup --
  // following the paths in its `data-shiny-vue-bind`, {"<field>": "<path>"}:
  // `apply({field: value})` takes each path's value as an update of that
  // field would, the first at once (none while the path is not on the page
  // yet). `state` is {field, get} for the element's value: `changed()`,
  // called when its user has changed it, writes get() back to a store.
  // Returns null when nothing is bound.
  sv.bindElement = function(el, apply, state) {
    var spec = el.getAttribute('data-shiny-vue-bind');
    if (!spec) return null;
    var map;
    try { map = JSON.parse(spec); } catch (e) { warn('vue_bind: "' + spec + '" is not a map of paths'); return null; }
    var stops = [], statePath = null;
    Object.keys(map).forEach(function(field) {
      var p = pathOf(map[field]);
      if (!p) { warn('vue_bind: "' + map[field] + '" is not a path'); return; }
      var isState = state && field === state.field;
      if (isState) statePath = p;
      stops.push(Vue.watch(function() { return readPath(p); }, function(v) {
        if (v === undefined || (isState && same(v, state.get()))) return;
        var d = {};
        d[field] = copied(v);
        apply(d);
      }, { immediate: true, deep: true }));
    });
    return {
      changed: function() {
        if (!statePath || statePath.root !== 'store') return;
        var v = state.get();
        if (!same(v, readPath(statePath))) writePath(statePath, copied(v));
      },
      stop: function() { stops.forEach(function(s) { s(); }); }
    };
  };

  // Run when an instance is created, before its first render: each bound
  // field takes the path's value, follows it, and -- for a store -- sets it
  // when the field changes (the component's user, an update)
  var bindFields = {
    created: function() {
      var bound = this.$options.shinyVueBound, vm = this;
      if (!bound) return;
      Object.keys(bound).forEach(function(field) {
        var p = pathOf(bound[field]);
        if (!p) { warn('vue_bind: "' + bound[field] + '" is not a path'); return; }
        vm.$watch(function() { return readPath(p); }, function(v) {
          if (!same(v, vm[field])) vm[field] = copied(v);
        }, { immediate: true, deep: true });
        if (p.root === 'store') {
          vm.$watch(field, function(v) {
            if (!same(v, readPath(p))) writePath(p, copied(v));
          }, { deep: true });
        }
      });
    }
  };

  // Which data outputs Shiny is recalculating, by output id --
  // $recalculating.<id> in templates
  var recalculating = null;
  sv.recalculating = function() {
    if (!recalculating) recalculating = Vue.reactive({});
    return recalculating;
  };
  // A data output's error, by output id -- $errors.<id>: {message, type},
  // gone once it renders again -- as Shiny draws an output's error
  var errors = null;
  sv.errors = function() {
    if (!errors) errors = Vue.reactive({});
    return errors;
  };
  // The page's input values, by id without a :type -- $inputs.<id>: what a
  // template can read of the page's other inputs. Each component puts its
  // value here as it changes (feedInputs()), with or without Shiny on the
  // page; Shiny's own inputs come from shiny:inputchanged. Read-only: an
  // input is set through its own component, or $setInput.
  var inputs = null;
  sv.inputs = function() {
    if (!inputs) {
      inputs = Vue.reactive({});
      var put = function(name, value) { inputs[String(name).replace(/:.*$/, '')] = value; };
      if (window.Shiny && Shiny.shinyapp && Shiny.shinyapp.$inputValues) {
        Object.keys(Shiny.shinyapp.$inputValues).forEach(function(k) {
          if (k.charAt(0) !== '.') put(k, Shiny.shinyapp.$inputValues[k]);
        });
      }
      if (window.jQuery) {
        jQuery(document).on('shiny:inputchanged', function(e) {
          if (e.name && String(e.name).charAt(0) !== '.') put(e.name, plain(e.value));
        });
      }
    }
    return inputs;
  };
  // The values data outputs rendered, by output id: what useOutput() reads
  var outputValues = null;
  sv.outputValues = function() {
    if (!outputValues) outputValues = Vue.reactive({});
    return outputValues;
  };

  // Composables, for setup(): what templates read as $inputs, $busy,
  // $recalculating and $errors, and an input of one's own -- shinyreact's
  // hooks, the Vue way. Ids are the page's, a module's namespace included.
  //
  //   setup() {
  //     const pick = shinyVue.useInput('pick', 'a');   // a ref, input$pick
  //     const n = shinyVue.useInputValue('counter');    // another input
  //     const stats = shinyVue.useOutput('stats');      // {value, recalculating, error}
  //     const busy = shinyVue.useBusy();
  //     return { pick, n, stats, busy };
  //   }
  sv.useInput = function(name, initial, opts) {
    var inputs = sv.inputs();
    var value = Vue.ref(name in inputs ? inputs[name] : initial);
    var send = function(v) {
      if (window.Shiny && Shiny.setInputValue) Shiny.setInputValue(name, reported(v), opts || {});
    };
    // sent on load, as an input is, and on every change
    if (window.Shiny && Shiny.shinyapp && Shiny.shinyapp.isConnected && Shiny.shinyapp.isConnected()) send(value.value);
    else if (window.jQuery) jQuery(document).one('shiny:connected', function() { send(value.value); });
    Vue.watch(value, send, { deep: true });
    // and follows the input when something else sets it
    Vue.watch(function() { return inputs[name]; }, function(v) {
      if (JSON.stringify(v) !== JSON.stringify(plain(value.value))) value.value = v;
    });
    return value;
  };
  sv.useInputValue = function(name) {
    var inputs = sv.inputs();
    return Vue.computed(function() { return inputs[name]; });
  };
  sv.useOutput = function(id) {
    var values = sv.outputValues(), recalc = sv.recalculating(), errs = sv.errors();
    // an output of render_vue_data(): placed in the component, as `outputs`
    // places it, so Shiny holds it back while the component is hidden
    if (sv.mountingHost && !document.getElementById(id)) placeOutputs(sv.mountingHost, null, [id]);
    return Vue.reactive({
      value: Vue.computed(function() { return values[id]; }),
      recalculating: Vue.computed(function() { return !!recalc[id]; }),
      error: Vue.computed(function() { return errs[id] || null; })
    });
  };
  sv.useBusy = function() {
    var state = sv.state();
    return Vue.computed(function() { return state.busy; });
  };

  // Whether the server is working -- $busy, as Shiny's shiny:busy and
  // shiny:idle tell it
  var shinyState = null;
  sv.state = function() {
    if (!shinyState) {
      shinyState = Vue.reactive({ busy: false });
      if (window.jQuery) {
        jQuery(document).on('shiny:busy', function() { shinyState.busy = true; });
        jQuery(document).on('shiny:idle', function() { shinyState.busy = false; });
      }
      if (document.documentElement.classList.contains('shiny-busy')) shinyState.busy = true;
    }
    return shinyState;
  };

  function islandHolder(host) {
    return host.querySelector(':scope > [data-shiny-vue-islands]');
  }
  function islandComponent(host) {
    return {
      props: ['name'],
      render: function() {
        return Vue.h('div', { class: 'shiny-island', style: 'display: contents' });
      },
      mounted: function() {
        var holder = islandHolder(host);
        var node = holder && holder.querySelector(':scope > [data-shiny-island-of="' + this.name + '"]');
        if (!node) {
          warn('"' + host.id + '": Shiny UI number ' + this.name + ' is shown once only -- it is elsewhere already');
          return;
        }
        this.$el.appendChild(node);
        // Shiny looks again at what is visible: an output held back while
        // hidden is drawn now
        if (window.jQuery) jQuery(node).trigger('shown');
      },
      beforeUnmount: function() {
        var holder = islandHolder(host), node = this.$el.firstElementChild;
        if (!holder || !node) return;
        holder.appendChild(node);
        if (window.jQuery) jQuery(node).trigger('hidden');
      }
    };
  }

  function mount(host) {
    if (host._shinyVue) return host._shinyVue;
    var tpl = host.querySelector(':scope > script[data-shiny-vue-template]');
    var opt = host.querySelector(':scope > script[data-shiny-vue-options]');
    if (!tpl || !opt) return null;
    var spec = JSON.parse(opt.textContent);
    if (spec.optional) unsetOptional(optionalFields(spec.optional), spec.options.data);
    revive(spec, spec.evals);
    var options = spec.options;
    if (spec.optional) options.shinyVueOptional = spec.optional;
    if (spec.bound) options.shinyVueBound = spec.bound;
    aliasComponents(options);
    options.template = tpl.textContent;
    // Vue 3: data is a function, and the lifecycle hooks have new names
    var data = options.data || {};
    // A store (vue_store()) is a Pinia store, defined here from its spec:
    // state, getters and actions, or a setup function. Its host's own
    // instance exposes the store's state and getters (refs) and actions, so
    // the bridge reaches it as any component -- the binding's value,
    // update_vue(), call_vue(), outputs.
    if (spec.store) {
      var store = defineStore(host.id, data, spec.storeDef || {});
      if (store) {
        host._shinyVueStore = store;
        data = {};
        options.setup = function() { return storeFields(store); };
      }
    }
    options.data = function() { return data; };
    if (options.beforeDestroy) { options.beforeUnmount = options.beforeDestroy; delete options.beforeDestroy; }
    if (options.destroyed) { options.unmounted = options.destroyed; delete options.destroyed; }
    // emits: Vue's own way for a component to send something out. The root
    // component's listeners are props of createApp(); each declared event
    // becomes input$<id>_<event>.
    // Its arguments arrive as sv.emit() sends any event's: none is TRUE, one is
    // itself, several an object of arg1, arg2, ...
    var rootProps = {};
    (Array.isArray(options.emits) ? options.emits : []).forEach(function(ev) {
      var name = 'on' + ev.charAt(0).toUpperCase() + ev.slice(1).replace(/-(\w)/g, function(m, c) { return c.toUpperCase(); });
      var event = ev.replace(/-/g, '_');
      rootProps[name] = function() { sv.emit(host.getAttribute('data-shiny-vue-id') || host.id, event, arguments); };
    });
    var app = Vue.createApp(options, rootProps);
    // A template cannot reach window.Shiny: Vue allows only a few globals in
    // its expressions. $setInput(name, value) is Shiny.setInputValue for
    // templates -- a checkbox in a table cell reporting the rows ticked.
    // An event's value by default, so the same value twice still counts.
    app.config.globalProperties.$setInput = function(name, value, opts) {
      if (window.Shiny && Shiny.setInputValue) {
        Shiny.setInputValue(name, plain(value), opts || { priority: 'event' });
      }
    };
    // Shiny UI taken out of the template (.vue_islands() in R): kept in the
    // host's hidden holder, moved in while Vue shows its place and back out
    // -- its bindings and state kept, its outputs suspended -- when Vue
    // removes it
    app.component('shiny-island', islandComponent(host));
    app.config.globalProperties.$store = sv.stores();
    app.config.globalProperties.$recalculating = sv.recalculating();
    app.config.globalProperties.$errors = sv.errors();
    app.config.globalProperties.$inputs = Vue.readonly(sv.inputs());
    // a getter, so a template reading $busy follows it
    Object.defineProperty(app.config.globalProperties, '$busy', {
      get: function() { return sv.state().busy; }, enumerable: true, configurable: true
    });
    app.config.globalProperties.$optional = optionalProps;
    // fields given vue_bind(), kept in step with what they follow
    if (spec.bound) app.mixin(bindFields);
    // The page's router (vue_router()), in every app: vue-router keeps the
    // apps it is installed in, each with $router, $route, <router-link>
    if (sv.router) app.use(sv.router);
    // The page's Pinia, which vue_store()'s stores are made with, in every
    // app, so a component's setup() can reach them (shinyVue.useStore())
    if (window.Pinia) app.use(piniaOf());
    // Vue plugins the component asks for (`use`), by their global names --
    // a component library, an i18n plugin: app.use() on each
    // -- a name, or {name, options} for a plugin that takes them
    // the host being mounted, for a plugin to read what is around it
    sv.mountingHost = host;
    // -- or a plugin written in R, revived here: {plugin}
    (spec.use || []).forEach(function(p) {
      if (p && typeof p === 'object' && p.plugin) { app.use(p.plugin); return; }
      var name = typeof p === 'string' ? p : p.name;
      var plugin = name.split('.').reduce(function(o, k) { return o && o[k]; }, window);
      if (plugin) app.use(plugin, typeof p === 'string' ? undefined : p.options);
      else if (window.console) console.warn('[shiny-vue] "' + host.id + '" asks for plugin ' + name + ', which is not on the page');
    });
    sv.mountingHost = null;
    // the user's plugin wins, as the user's code does; said, since the
    // component's own optional props then bind through it
    if (app.config.globalProperties.$optional !== optionalProps && spec.optional) {
      warn('"' + host.id + '": a plugin replaced $optional; its optional props bind through that one');
    }
    // The app's root goes into a box of its own: Vue 3 owns its container
    var box = document.createElement('div');
    box.setAttribute('data-shiny-vue-root', '');
    box.style.display = 'contents';
    host.appendChild(box);
    // One component that fails to compile or mount is reported, and the
    // rest of the page carries on
    var vm;
    try {
      // the host being mounted, for setup()'s composables (useOutput())
      sv.mountingHost = host;
      vm = app.mount(box);
      sv.mountingHost = null;
    } catch (e) {
      sv.mountingHost = null;
      if (window.console) console.error('[shiny-vue] "' + host.id + '" could not be mounted: ' + e.message);
      try { app.unmount(); } catch (e2) {}
      if (box.parentNode) box.parentNode.removeChild(box);
      return null;
    }
    host._shinyVueApp = app;
    vm._shinyVueHost = host;
    // a bookmarked value for an input field that setup() defines -- one in
    // data was restored on the server, into the data itself
    if (spec.restored !== undefined && spec.input && /^[A-Za-z_$][\w$]*$/.test(spec.input)) {
      vm[spec.input] = spec.restored;
    }
    host._shinyVue = vm;
    host._shinyVueSpec = { input: spec.input || null, type: spec.type || null,
                           rate: spec.rate || null };
    watchDisabled(host, vm);
    forwardClick(host, box);
    reportFromOutput(host, vm);
    applyPending(host);
    placeOutputs(host, vm, spec.outputs);
    boxTrigger(host);
    host._svInitial = initialValues(host, vm);
    feedInputs(host, vm, spec);
    return vm;
  }

  // The component's value, and those of the components folded into it, in
  // $inputs as they change -- before any debounce, and with no Shiny on the
  // page, so another component's vue_bind("$inputs.<id>") follows at once
  function feedInputs(host, vm, spec) {
    var inputs = sv.inputs();
    var follow = function(name, expr) {
      var get = getter(expr);
      vm.$watch(function() { return get(this); }, function(v) {
        inputs[name] = copied(v);
      }, { immediate: true, deep: true });
    };
    if (spec.input) follow(host.getAttribute('data-shiny-vue-id') || host.id, spec.input);
    Object.keys(spec.absorbed || {}).forEach(function(id) {
      var e = spec.absorbed[id];
      if (e && e.input) follow(id, e.input);
    });
  }

  // A component an output renders (render_el_table()) shares the output's
  // id, and Shiny warns of an input and an output bound to one id. Its value
  // is sent as rhandsontable sends its own, with setInputValue() and no
  // binding: on load, and on every change.
  function reportFromOutput(host, vm) {
    var id = host.getAttribute('data-shiny-vue-id');
    var spec = host._shinyVueSpec;
    if (!id || !spec.input || !window.Shiny) return;
    var get = getter(spec.input);
    var name = id + (spec.type ? ':' + spec.type : '');
    var send = function() { Shiny.setInputValue(name, reported(get(vm))); };
    // stopped with the instance when Vue unmounts it
    vm.$watch(function() { return get(this); }, send, { deep: true });
    if (Shiny.shinyapp && Shiny.shinyapp.isConnected && Shiny.shinyapp.isConnected()) send();
    else if (window.jQuery) jQuery(document).one('shiny:connected', send);
  }

  // A click on the host itself -- shinyjs::click(id), el.click() -- is the
  // component's: the host has no box to be clicked, so it goes to the first
  // thing in the component that takes a click. A user's click lands inside
  // and bubbles up with another target, and is left alone.
  function forwardClick(host, box) {
    host.addEventListener('click', function(e) {
      if (e.target !== host) return;
      var target = box.querySelector(
        'button, a[href], input, select, textarea, [role="button"], [tabindex]:not([tabindex="-1"])'
      ) || box.firstElementChild;
      if (target && typeof target.click === 'function') target.click();
    });
  }

  // Data outputs a component's data follows (vue_app(outputs =)): an
  // element for each, which Shiny binds as an output -- visible while the
  // component is, so held back with it when it is hidden
  function placeOutputs(host, vm, outputs) {
    var ids = Array.isArray(outputs) ? outputs : (outputs ? [outputs] : []);
    if (!ids.length) return;
    var holder = document.createElement('span');
    holder.setAttribute('data-shiny-vue-outputs', '');
    ids.forEach(function(id) {
      var out = document.getElementById(id);
      if (!out) {
        out = document.createElement('span');
        out.id = id;
        out.className = 'shiny-vue-data-output';
        holder.appendChild(out);
      }
      // a component's fields follow it; useOutput() only reads it
      if (vm) {
        (out._svTargets = out._svTargets || []).push({ vm: vm, host: host });
        if (out._svFields !== undefined) assignFields(vm, host, id, out._svFields);
      }
    });
    host.appendChild(holder);
    // bound with the page if Shiny has not started yet, here if it has
    if (window.Shiny && Shiny.initializedPromise && Shiny.bindAll) {
      Promise.resolve(Shiny.initializedPromise).then(function() { Shiny.bindAll(holder); });
    } else if (window.Shiny && Shiny.shinyapp && Shiny.bindAll) {
      Shiny.bindAll(holder);
    }
  }
  // A data output's fields, set on a component as update_vue() sets them:
  // only fields it declares, as Vue tracks no others
  function assignFields(vm, host, output, fields) {
    var setupState = vm.$ && vm.$.setupState;
    Object.keys(fields).forEach(function(k) {
      if (!(k in vm.$data) && !(setupState && k in setupState)) {
        warn('output "' + output + '" sets "' + k + '", which is not a field of "' + host.id + '"; declare it in data');
        return;
      }
      vm[k] = fields[k];
    });
  }

  // Updates sent to an output before it drew its component, applied now
  function applyPending(host) {
    var id = host.getAttribute('data-shiny-vue-id');
    var output = id && document.getElementById(id);
    if (!output || !output._svPending) return;
    var pending = output._svPending;
    output._svPending = null;
    Promise.resolve().then(function() {
      pending.forEach(function(data) { sv.update(id, data); });
    });
  }

  // Bootstrap's tooltip and popover -- bslib's tooltip() and popover() --
  // take the element they wrap as their trigger: here the host, which has
  // no box (display: contents), so they could neither place the tip nor see
  // the trigger on screen, and hid it again at once. A host that is a
  // trigger gets a box the size of the component: a block around one that
  // fills its line (an input), inline-block around one narrower (a button).
  // Measured again as the tip opens, for a component hidden when mounted.
  function boxTrigger(host) {
    if (!/^(tooltip|popover)$/.test(host.getAttribute('data-bs-toggle') || '')) return;
    var fit = function() {
      host.style.display = 'block';
      host.style.width = '';
      var el = host.querySelector(':scope > [data-shiny-vue-root]');
      while (el && getComputedStyle(el).display === 'contents') el = el.firstElementChild;
      if (el && el.getBoundingClientRect().width < host.getBoundingClientRect().width - 1) {
        // fit-content, or a flex container (bslib's main) stretches it
        host.style.display = 'inline-block';
        host.style.width = 'fit-content';
      }
    };
    fit();
    if (!host._svTriggerFit) {
      host._svTriggerFit = true;
      host.addEventListener('show.bs.tooltip', fit);
      host.addEventListener('show.bs.popover', fit);
    }
  }

  // The data fields an input reads: "value", "active || null" (active),
  // "({from: from, to: to})" (from, to).
  function inputFields(expr) {
    if (!expr) return [];
    var several = expr.match(/^\(\{(.*)\}\)$/);
    if (several) return several[1].split(',').map(function(p) { return p.split(':')[0].trim(); });
    var head = expr.match(/^[A-Za-z_$][\w$]*/);
    return head ? [head[0]] : [];
  }
  // What they held when the component was put on the page, for
  // shinyjs::reset()
  function initialValues(host, vm) {
    var out = {};
    inputFields(host._shinyVueSpec.input).forEach(function(f) {
      if (f in vm) out[f] = JSON.stringify(plain(vm[f]) === undefined ? null : plain(vm[f]));
    });
    return out;
  }

  // shinyjs::reset() puts Shiny's own inputs back as the page first had
  // them -- it knows them by their markup and calls update*Input(). The
  // components under the element reset go back the same way, here.
  function resetHosts(id) {
    var el = id ? document.getElementById(id) : document.body;
    if (!el) return;
    var hosts = el.matches && el.matches(HOST) ? [el] : [];
    hosts = hosts.concat(Array.prototype.slice.call(el.querySelectorAll(HOST)));
    hosts.forEach(function(host) {
      var vm = host._shinyVue, initial = host._svInitial;
      if (!vm || !initial) return;
      Object.keys(initial).forEach(function(f) { vm[f] = JSON.parse(initial[f]); });
    });
  }
  function wrapShinyjsReset() {
    var js = window.shinyjs;
    if (!js || typeof js.reset !== 'function' || js.reset._shinyVue) return;
    var original = js.reset;
    js.reset = function(params) {
      var out = original.apply(this, arguments);
      try { resetHosts(params && params.id); } catch (e) {
        if (window.console) console.error('[shiny-vue] shinyjs::reset(): ' + e.message);
      }
      return out;
    };
    js.reset._shinyVue = true;
  }
  if (window.jQuery) {
    jQuery(document).on('shiny:connected shiny:value', wrapShinyjsReset);
  }

  // shinyjs::disable() sets `disabled` on the element it is given, which is
  // the host. A component's own `disabled` field is what it draws from, so
  // carry the attribute over.
  function watchDisabled(host, vm) {
    if (typeof MutationObserver === 'undefined' || !('disabled' in vm.$data)) return;
    // disabled before it mounted -- shinyjs::disabled() in the UI
    if (host.hasAttribute('disabled')) vm.disabled = true;
    var obs = new MutationObserver(function() { vm.disabled = host.hasAttribute('disabled'); });
    obs.observe(host, { attributes: true, attributeFilter: ['disabled'] });
    host._shinyVueObserver = obs;
  }

  function isStore(host) {
    var opt = host.querySelector(':scope > script[data-shiny-vue-options]');
    return !!opt && /"store":\s*true/.test(opt.textContent);
  }
  function mountAll(scope) {
    scope = scope || document;
    var hosts = [];
    if (scope.matches && scope.matches(HOST)) hosts.push(scope);
    if (scope.querySelectorAll) {
      hosts = hosts.concat(Array.prototype.slice.call(scope.querySelectorAll(HOST)));
    }
    // stores first: the components that read them may come earlier
    hosts.filter(isStore).forEach(mount);
    hosts.forEach(mount);
    return hosts;
  }

  // The component behind an id, mounted first if need be, as {instance: vm}.
  sv.find = function(id) {
    var host = byId(String(id).replace(/^#/, ''));
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
    if (host._shinyVueApp) host._shinyVueApp.unmount();
    // a store goes with its host; drawn again, it starts from its state
    if (host._shinyVueStore) {
      if (storeRegistry) delete storeRegistry[host.id];
      if (host._shinyVueStore.$dispose) host._shinyVueStore.$dispose();
      if (pinia) delete pinia.state.value[host.id];
      host._shinyVueStore = null;
    }
    host._shinyVueApp = null;
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
  // registers what it handles -- a label, an error message, say -- and
  // `.resolve` answers a question a component asked.
  sv.hooks = sv.hooks || {};
  // How a component layer finds an object a method takes, by index or name
  sv.refs = sv.refs || {};

  // The element a component's id names: its host, or -- a component an
  // output renders, the output holding that id -- the host whose inputs are
  // named after it (data-shiny-vue-id)
  function byId(id) {
    var el = document.getElementById(id);
    if (el && el.hasAttribute('data-shiny-vue')) return el;
    var named = document.querySelectorAll('[data-shiny-vue-id]');
    for (var i = 0; i < named.length; i++) {
      if (named[i].getAttribute('data-shiny-vue-id') === id) return named[i];
    }
    return el;
  }
  sv.byId = byId;
  // the component instance under a host's: a table's el-table
  sv.componentOf = componentOf;

  // A component folded into another -- a button in a group, a select in an
  // input's slot -- has no host of its own: the one that took it in lists it
  // in its spec's `absorbed`, {id: {fields: {name: name as renamed}, ref}},
  // and its updates and method calls go to that host's instance, under its
  // fields' names there.
  function absorbedBy(id) {
    var hosts = document.querySelectorAll(HOST);
    for (var i = 0; i < hosts.length; i++) {
      var h = hosts[i];
      if (h._svAbsorbed === undefined) {
        var opt = h.querySelector(':scope > script[data-shiny-vue-options]');
        var spec = null;
        try { spec = opt && /"absorbed"/.test(opt.textContent) ? JSON.parse(opt.textContent) : null; }
        catch (e) { spec = null; }
        h._svAbsorbed = (spec && spec.absorbed) || null;
      }
      if (h._svAbsorbed && Object.prototype.hasOwnProperty.call(h._svAbsorbed, id)) {
        return { host: h, entry: h._svAbsorbed[id] };
      }
    }
    return null;
  }

  // Changes made in place (update_vue(insert =, replace =, delete =, set =)):
  // `.edit` splices a list field -- rows inserted at a position, replaced or
  // deleted by position, or by a key field's value -- and `.set` assigns
  // by path ("items", 2, "done"), so a long list or a deep object is not
  // sent whole. `nameOf` gives the field's name in the instance (a folded
  // component's are renamed), or null. A component that has to know --
  // a table renumbering its selection -- gets shinyVueEdited(edit).
  function applyEdits(vm, data, nameOf, id) {
    var e = data['.edit'];
    if (e) {
      delete data['.edit'];
      var name = nameOf(e.field), list = name ? vm[name] : null;
      if (!Array.isArray(list)) {
        warn('update: "' + e.field + '" is not a list of "' + id + '"; the edit was ignored');
      } else {
        var rows = e.rows || [], at = e.at === null || e.at === undefined ? [] : [].concat(e.at);
        var find = function(v) {
          for (var i = 0; i < list.length; i++) {
            if (list[i] && String(list[i][e.key]) === String(v)) return i;
          }
          return -1;
        };
        if (e.op === 'insert') {
          var i0 = at.length ? at[0] - 1 : list.length;
          list.splice.apply(list, [i0, 0].concat(rows));
        } else if (e.op === 'replace') {
          rows.forEach(function(r, k) {
            if (e.key) {
              // by key: the row with that key, or a new one at the end
              var i = find(r[e.key]);
              if (i >= 0) list.splice(i, 1, r); else list.push(r);
            } else if (at[k] !== undefined) {
              list.splice(at[k] - 1, 1, r);
            }
          });
        } else if (e.op === 'delete') {
          var idx = e.key ? at.map(find).filter(function(i) { return i >= 0; })
                          : at.map(function(i) { return i - 1; });
          idx.sort(function(a, b) { return b - a; }).forEach(function(i) { list.splice(i, 1); });
        }
        if (typeof vm.shinyVueEdited === 'function') vm.shinyVueEdited(e);
      }
    }
    var sets = data['.set'];
    if (sets) {
      delete data['.set'];
      sets.forEach(function(st) {
        var parts = [].concat(st.path), first = nameOf(parts[0]);
        if (!first) { warn('update: "' + parts[0] + '" is not a field of "' + id + '"; the update was ignored'); return; }
        parts[0] = first;
        var o = vm;
        for (var i = 0; i < parts.length - 1; i++) {
          o = o[parts[i]];
          if (o === null || typeof o !== 'object') {
            warn('update: "' + st.path.join('.') + '" of "' + id + '" does not exist; the update was ignored');
            return;
          }
        }
        o[parts[parts.length - 1]] = st.value;
      });
    }
  }

  function updateAbsorbed(id, data) {
    var found = absorbedBy(id);
    if (!found) return false;
    var vm = mount(found.host);
    if (!vm) return false;
    var fields = found.entry.fields || {};
    unsetOptional(optionalOf(vm), data, function(k) { return fields[k]; });
    if (data['.evals']) { revive(data, data['.evals']); delete data['.evals']; }
    applyEdits(vm, data, function(f) {
      var n = fields[f];
      return n && n in vm.$data ? n : null;
    }, id);
    var rest = {};
    Object.keys(data).forEach(function(k) {
      if (k === 'id') return;
      if (k === '.value') {
        // the component's value, whichever field that is
        if (found.entry.input) rest[found.entry.input] = data[k];
        else warn('update: "' + id + '" has no value to set');
      } else if (k === '.resolve' && typeof sv.hooks[k] === 'function') {
        // an answer to a question it asked: not tied to its host
        sv.hooks[k](found.host, data[k], vm);
      } else if (k.charAt(0) === '.') {
        warn('update: "' + id + '" is folded into "' + found.host.id + '"; its ' + k + ' was ignored');
      } else {
        rest[k] = data[k];
      }
    });
    var receive = fields.shinyVueReceive;
    if (receive && typeof vm[receive] === 'function') rest = vm[receive](rest) || {};
    Object.keys(rest).forEach(function(k) {
      var name = fields[k];
      if (!name || !(name in vm.$data)) {
        warn('update: "' + k + '" is not a field of "' + id + '"; the update was ignored');
        return;
      }
      var v = rest[k];
      if (Array.isArray(vm[name]) && v !== null && v !== undefined && !Array.isArray(v) &&
          typeof v !== 'object') {
        v = [v];
      }
      vm[name] = v;
    });
    if (vm._svReport) vm._svReport();
    return true;
  }

  sv.update = function(id, data) {
    var host = byId(id);
    if ((!host || !host.hasAttribute('data-shiny-vue')) && updateAbsorbed(id, data)) return;
    var vm = host && host.hasAttribute('data-shiny-vue') ? mount(host) : null;
    // An output not drawn yet -- an update sent while the server renders it,
    // from an observer of an input that reports on load -- gets it once drawn
    if (!vm && host && host.classList.contains('shiny-vue-output')) {
      (host._svPending = host._svPending || []).push(data);
      return;
    }
    // an answer to a question asked under an id with no component -- the
    // router's guard -- settles it all the same
    if (!vm && data['.resolve'] && typeof sv.hooks['.resolve'] === 'function') {
      sv.hooks['.resolve'](host || null, data['.resolve'], null);
      return;
    }
    if (!vm) { warn('update: no component with id "' + id + '"'); return; }
    // announced to screen readers, as Shiny's update*Input() does
    if (!host.hasAttribute('aria-live')) host.setAttribute('aria-live', 'polite');
    // NA in R: back to the component library's default
    unsetOptional(optionalOf(vm), data);
    // A function in an update -- a new formatter, a form rule's validator --
    // travels as source too
    if (data['.evals']) { revive(data, data['.evals']); delete data['.evals']; }
    var setupFields = vm.$ && vm.$.setupState;
    applyEdits(vm, data, function(f) {
      return f in vm.$data || (setupFields && f in setupFields) ? f : null;
    }, id);
    var rest = {};
    Object.keys(data).forEach(function(k) {
      if (k === 'id' || k === '.value') return;
      if (k.charAt(0) === '.' && typeof sv.hooks[k] === 'function') {
        sv.hooks[k](host, data[k], vm);
      } else {
        rest[k] = data[k];
      }
    });
    if (typeof vm.shinyVueReceive === 'function') rest = vm.shinyVueReceive(rest) || {};
    // `.value` is the component's value, whichever field that is
    if ('.value' in data && host._shinyVueSpec && host._shinyVueSpec.input) {
      var field = host._shinyVueSpec.input.match(/^[A-Za-z_$][\w$]*$/);
      if (field) rest[field[0]] = data['.value'];
      else warn('update: "' + id + '" reports an expression, so `value` cannot be set');
    }
    // fields of the instance: data, or state returned by setup()
    var setupState = vm.$ && vm.$.setupState;
    Object.keys(rest).forEach(function(k) {
      if (!(k in vm.$data) && !(setupState && k in setupState)) {
        warn('update: "' + k + '" is not a field of "' + id + '"; the update was ignored');
        return;
      }
      // R sends a vector of one as a bare value; a field that holds a list
      // -- a multiple select's selection, a tree's expanded keys -- keeps
      // holding one
      var v = rest[k];
      if (Array.isArray(vm[k]) && v !== null && v !== undefined && !Array.isArray(v) &&
          typeof v !== 'object') {
        v = [v];
      }
      vm[k] = v;
    });
    // Report the new value, as Shiny's own update*Input() does
    if (vm._svReport) vm._svReport();
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
  // An answer can also be a refusal (`failed`): the promise rejects, and a
  // lazy loader can tell its library the load failed, so it can be tried
  // again.
  function settle(request, value, failed) {
    var p = pending[request];
    if (!p) return false;
    delete pending[request];
    clearTimeout(p.timer);
    if (failed) p.reject(new Error('the server refused request ' + request));
    else p.resolve(value);
    return true;
  }
  sv.ask = function(input, question, owner) {
    if (typeof Shiny === 'undefined' || !Shiny.setInputValue) return Promise.resolve(null);
    var request = ++nextRequest;
    var payload = plain(question) || {};
    payload.request = request;
    var host = owner && owner._shinyVueHost ? owner._shinyVueHost : null;
    return new Promise(function(resolve, reject) {
      pending[request] = {
        resolve: resolve, reject: reject, host: host,
        timer: setTimeout(function() {
          if (settle(request, null)) warn('no answer to input$' + input + ' request ' + request +
                                          ' within ' + sv.askTimeout / 1000 + ' s');
        }, sv.askTimeout)
      };
      Shiny.setInputValue(input, payload, { priority: 'event' });
    });
  };
  sv.hooks['.resolve'] = function(host, answer) {
    if (!answer || !settle(answer.request, answer.value, answer.failed)) {
      warn('update: "' + (host ? host.id : 'the router') + '" answered request ' + (answer && answer.request) +
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

  // The component the instance renders, whose methods its library documents:
  // $refs.el if marked, else the first child of the given name, else the
  // first child at all.
  function componentOf(vm, name) {
    // A component named outright is looked for; otherwise the one the
    // template marks ref="el", or the first
    if (!name && vm.$refs && vm.$refs.el) return vm.$refs.el;
    var found = null;
    (function walk(node, depth) {
      if (found || depth > 4) return;
      var kids = children(node);
      for (var i = 0; i < kids.length; i++) {
        if (!name || kids[i].name === name) { found = kids[i]; return; }
      }
      for (var j = 0; j < kids.length && !found; j++) walk(kids[j].instance, depth + 1);
    })(vm.$, 0);
    if (found) return publicOf(found.instance);
    var first = children(vm.$)[0];
    return first ? publicOf(first.instance) : null;
  }
  // Vue 3 has no $children: the component instances are found in the
  // rendered tree, each with its component's name
  function children(inst) {
    var out = [];
    (function walk(vnode) {
      if (!vnode) return;
      if (vnode.component) {
        out.push({ instance: vnode.component,
                   name: (vnode.type && (vnode.type.name || vnode.type.__name)) || '' });
        return;
      }
      if (Array.isArray(vnode.children)) vnode.children.forEach(walk);
    })(inst && inst.subTree);
    return out;
  }
  // What a template ref would give: the exposed methods of a <script setup>
  // component, the instance otherwise
  function publicOf(inst) {
    if (inst.exposed) {
      if (!inst.exposeProxy) inst.exposeProxy = new Proxy(inst.exposed, {
        get: function(t, k) { return k in t ? Vue.unref(t[k]) : inst.proxy[k]; }
      });
      return inst.exposeProxy;
    }
    return inst.proxy;
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
    var host = byId(msg.id);
    // A component drawn as markup with a binding of its own (a drawer)
    // lists its methods on the element
    if (host && !host.hasAttribute('data-shiny-vue') && host._svMethods &&
        Object.prototype.hasOwnProperty.call(host._svMethods, msg.method)) {
      reportResult(msg.input, host._svMethods[msg.method].apply(host, args));
      return;
    }
    var vm = host && host.hasAttribute('data-shiny-vue') ? mount(host) : null;
    var target = null, owner = vm;
    if (!vm) {
      // folded into another: its component is the ref it was marked with,
      // and its fields are found under the names they were given there
      var found = absorbedBy(msg.id);
      vm = found ? mount(found.host) : null;
      if (vm && found.entry.ref) {
        target = vm.$refs[found.entry.ref];
        if (Array.isArray(target)) target = target[0];
      }
      if (vm) {
        var fields = found.entry.fields || {};
        owner = typeof Proxy === 'function' ? new Proxy(vm, {
          get: function(t, k) { return t[typeof k === 'string' && fields[k] ? fields[k] : k]; }
        }) : vm;
      }
    }
    if (!vm) { warn('call: no component with id "' + msg.id + '"'); return; }
    target = target || componentOf(vm, msg.component);
    // a host with no component under it -- a store -- runs its own: a
    // store's actions are its host's methods
    if (!target && !msg.component && typeof vm[msg.method] === 'function') target = vm;
    if (!target) { warn('call: no component under "' + msg.id + '"'); return; }
    // An argument that names an object the component holds -- a table's
    // row, an upload's file -- by an index or a name, since the object
    // itself cannot cross the wire: {".ref": kind, value: ...}
    args = args.map(function(a) {
      if (!a || typeof a !== 'object' || !a['.ref']) return a;
      var resolve = sv.refs[a['.ref']];
      if (!resolve) { warn('call: no way to find a "' + a['.ref'] + '"'); return a; }
      var found = resolve(a.value, owner, target);
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
    if (vm._svReport) vm._svReport();   // a method can change a reported value
    // A promise that rejects -- a form's validate() on invalid fields -- is
    // an answer, not an error: with no input to report it to, it is dropped
    // rather than left unhandled
    if (!msg.input) {
      if (result && typeof result.then === 'function') result.then(null, function() {});
      return;
    }
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
    Shiny.addCustomMessageHandler('shinyVueRouter', function(msg) {
      if (!sv.router) { warn('update_vue_router(): no vue_router() on the page'); return; }
      if (msg.id !== sv.routerId) { warn('update_vue_router(): no router "' + msg.id + '"'); return; }
      sv.router[msg.replace ? 'replace' : 'push'](msg.path);
    });
  }
  // session$sendInputMessage() reaches only a bound input; a component
  // folded into another has no binding of its own, so its messages -- bslib's
  // update_task_button() to a task button in a tooltip -- are taken here
  if (hasShiny && window.jQuery) {
    jQuery(document).on('shiny:message', function(e) {
      var msgs = e.message && e.message.inputMessages;
      if (!msgs || !msgs.length) return;
      msgs.forEach(function(m) {
        if (!m || !m.id) return;
        // a bound input gets it from Shiny; a folded component keeps only
        // its id on its markup, unbound
        var el = document.getElementById(m.id);
        if (el && el.classList.contains('shiny-bound-input')) return;
        if (absorbedBy(m.id)) sv.update(m.id, jQuery.extend({}, m.message));
      });
    });
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
      // one an output holds reports through reportFromOutput(), unbound
      if (!(el._shinyVueSpec && el._shinyVueSpec.input)) return null;
      if (el.hasAttribute('data-shiny-vue-id')) return null;
      return el.id;
    },
    getType: function(el) {
      return (el._shinyVueSpec && el._shinyVueSpec.type) || false;
    },
    getValue: function(el) {
      var vm = el._shinyVue, field = el._shinyVueSpec && el._shinyVueSpec.input;
      if (!vm || !field) return null;
      return reported(getter(field)(vm));
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

  // ── render_vue(): an output that keeps what the user did ────────────
  //
  // renderUI() replaces everything on every render, and with it what the
  // user had done: a table's sort, a tree's open nodes, the tab they were
  // on. render_vue() applies a render as a change instead -- a three-way
  // comparison of the server's last render, its new one and the page:
  //
  // * markup the server did not change is left as the page has it, so
  //   bindings that changed it (an open tab, a moved dialog) keep that;
  // * text and attributes the server did change are set on the page;
  // * each component (a host) whose template and options are unchanged
  //   gets only the data fields the server changed since its last render,
  //   so a field the user changed and the server did not stays the user's.
  //
  // Anything else -- an element added or removed, a component's template
  // or options changed, a host where there was none -- and the output is
  // rendered afresh, as renderUI() would.
  function topHosts(root) {
    return Array.prototype.filter.call(root.querySelectorAll(HOST), function(h) {
      return !h.parentElement.closest(HOST) || !root.contains(h.parentElement.closest(HOST));
    });
  }
  function hostSpec(host) {
    var tpl = host.querySelector(':scope > script[data-shiny-vue-template]');
    var opt = host.querySelector(':scope > script[data-shiny-vue-options]');
    if (!tpl || !opt) return null;
    var spec = JSON.parse(opt.textContent);
    var data = (spec.options && spec.options.data) || {};
    var rest = JSON.parse(opt.textContent);
    if (rest.options) delete rest.options.data;
    // functions in the data (a column's formatter) may change from render
    // to render; they are revived when sent, so they are data like any other
    rest.evals = (rest.evals || []).filter(function(p) { return !/^options\.data\./.test(p); });
    // An id drawn at random each render -- the R side marks one it drew for
    // a component given none -- is not a difference; an id the author gave
    // is the component's identity, and another one is another component.
    var generated = spec.generated === true;
    var norm = function(x) { return generated ? x.split(host.id).join('\u0000') : x; };
    return { id: generated ? null : host.id,
             data: data, evals: (spec.evals || []).filter(function(p) { return /^options\.data\./.test(p); }),
             keys: Object.keys(data).sort().join(','),
             shape: norm(tpl.textContent) + '\u0001' + norm(JSON.stringify(rest)) };
  }
  // Text and attributes the server changed between its last render and this
  // one, set on the page. False when the structure differs: then nothing is
  // touched and the caller renders afresh.
  function changes(last, next, live, out) {
    if (last.isEqualNode(next)) return true;          // nothing the server changed here
    if (!live || last.nodeType !== next.nodeType || last.nodeName !== next.nodeName) return false;
    if (last.nodeType === 3) { out.push(function() { live.data = next.data; }); return true; }
    if (last.nodeType !== 1) return true;
    if (last.matches(HOST)) return true;              // a component: compared by its spec
    if (last.nodeName === 'SCRIPT' || last.nodeName === 'STYLE') return false;
    var names = {};
    Array.prototype.forEach.call(last.attributes, function(a) { names[a.name] = 1; });
    Array.prototype.forEach.call(next.attributes, function(a) { names[a.name] = 1; });
    Object.keys(names).forEach(function(n) {
      var v = next.getAttribute(n);
      if (last.getAttribute(n) === v) return;
      out.push(function() { if (v === null) live.removeAttribute(n); else live.setAttribute(n, v); });
    });
    var lk = last.childNodes, nk = next.childNodes, vk = live.childNodes;
    if (lk.length !== nk.length || lk.length !== vk.length) return false;
    for (var i = 0; i < lk.length; i++) if (!changes(lk[i], nk[i], vk[i], out)) return false;
    return true;
  }
  function parse(html) {
    var holder = document.createElement('div');
    holder.innerHTML = html || '';
    return holder;
  }
  function remember(el, html) {
    el._svLast = parse(html);
    var live = topHosts(el), last = topHosts(el._svLast);
    last.forEach(function(h, i) {
      var spec = hostSpec(h);
      if (live[i] && spec) live[i]._svSent = JSON.parse(JSON.stringify(spec.data));
    });
  }
  function applyRender(el, content) {
    var last = el._svLast;
    if (!last || !content) return false;
    var next = parse(content.html);
    var lastHosts = topHosts(last), nextHosts = topHosts(next), liveHosts = topHosts(el);
    if (lastHosts.length !== nextHosts.length || liveHosts.length !== lastHosts.length) return false;
    var updates = [];
    for (var i = 0; i < nextHosts.length; i++) {
      var a = hostSpec(lastHosts[i]), b = hostSpec(nextHosts[i]), host = liveHosts[i];
      if (!a || !b || a.id !== b.id || a.shape !== b.shape || a.keys !== b.keys || !host._shinyVue) return false;
      updates.push({ host: host, spec: b });
    }
    // the page's elements: a moved node (a dialog appended to <body>) has
    // left the output, so the walk below finds fewer children and gives up
    var edits = [];
    if (!changes(last, next, el, edits)) return false;
    edits.forEach(function(f) { f(); });
    updates.forEach(function(u) {
      var vm = u.host._shinyVue, sentBefore = u.host._svSent || {};
      // compared as sent -- functions still their source text -- then revived
      var asSent = JSON.parse(JSON.stringify(u.spec.data));
      unsetOptional(optionalOf(vm), u.spec.data);
      revive({ options: { data: u.spec.data } }, u.spec.evals);
      Object.keys(asSent).forEach(function(k) {
        if (JSON.stringify(asSent[k]) === JSON.stringify(sentBefore[k])) return;
        if (k in vm.$data) vm[k] = u.spec.data[k];
      });
      u.host._svSent = asSent;
      if (vm._svReport) vm._svReport();
    });
    el._svLast = next;
    return true;
  }
  // A render that changed only data comes as data: each changed field, JSON
  // as the page reads it ({value, evals}), assigned as applyRender() would.
  // A page that cannot apply it -- its component gone -- asks for the
  // markup: input$<output>__vue_redraw renders the output again, whole.
  function applyPatch(el, patch) {
    var host = document.getElementById(patch.host);
    var vm = host && el.contains(host) && host._shinyVue;
    if (!vm) {
      if (window.Shiny && Shiny.setInputValue) {
        Shiny.setInputValue(el.id + '__vue_redraw', Date.now(), { priority: 'event' });
      }
      return;
    }
    var sent = host._svSent || (host._svSent = {});
    Object.keys(patch.fields || {}).forEach(function(k) {
      var asSent = JSON.parse(patch.fields[k]);
      var field = JSON.parse(patch.fields[k]);
      if (field.value === null && optionalOf(vm)[k]) field.value = undefined;
      revive(field, field.evals);
      sent[k] = asSent.value;
      if (k in vm.$data) vm[k] = field.value;
      // the server's own loading, kept when the recalculation's mask ends
      if (k === 'loading' && el._svLoading !== undefined) el._svLoading = field.value;
    });
    if (vm._svReport) vm._svReport();
  }
  // An output drawing a component with a `loading` field (a table) shows
  // that field's mask while Shiny recalculates it, in place of fading it
  function showLoading(el, show) {
    if (!el.hasAttribute('data-shiny-vue-loading')) return;
    var hosts = topHosts(el);
    var vm = hosts.length && hosts[0]._shinyVue;
    if (!vm || !('loading' in vm.$data)) return;
    if (show) {
      if (el._svLoading === undefined) el._svLoading = vm.loading;
      vm.loading = true;
    } else if (el._svLoading !== undefined) {
      vm.loading = el._svLoading;
      el._svLoading = undefined;
    }
  }
  var outputBinding = new Shiny.OutputBinding();
  jQuery.extend(outputBinding, {
    find: function(scope) { return jQuery(scope).find('.shiny-vue-output'); },
    showProgress: function(el, show) {
      Shiny.OutputBinding.prototype.showProgress.call(this, el, show);
      showLoading(el, show);
    },
    renderValue: function(el, content) {
      if (content && content.patch) {
        applyPatch(el, content.patch);
        jQuery(el).trigger('shiny-vue:patched');
        return;
      }
      var deps = (content && content.deps) || [];
      return Promise.resolve(deps.length ? Shiny.renderDependenciesAsync(deps) : null).then(function() {
        if (applyRender(el, content)) { jQuery(el).trigger('shiny-vue:patched'); return; }
        return Promise.resolve(Shiny.renderContentAsync(el, content)).then(function() {
          remember(el, content && content.html);
          jQuery(el).trigger('shiny-vue:rendered');
        });
      });
    }
  });
  Shiny.outputBindings.register(outputBinding, 'shiny.vue.output');

  // render_vue_data(): fields of a component's data, JSON as the page reads
  // it ({fields, evals}), set on every component following the output
  var dataBinding = new Shiny.OutputBinding();
  jQuery.extend(dataBinding, {
    find: function(scope) { return jQuery(scope).find('.shiny-vue-data-output'); },
    renderValue: function(el, json) {
      delete sv.errors()[el.id];
      var data = typeof json === 'string' ? JSON.parse(json) : { fields: json };
      revive(data, data.evals);
      el._svFields = data.fields || {};
      sv.outputValues()[el.id] = el._svFields;
      (el._svTargets || []).forEach(function(t) {
        assignFields(t.vm, t.host, el.id, el._svFields);
      });
    },
    showProgress: function(el, show) {
      Shiny.OutputBinding.prototype.showProgress.call(this, el, show);
      sv.recalculating()[el.id] = !!show;
    },
    // the error reaches the components, $errors.<id>; the element itself,
    // hidden in them, shows nothing. A silent req() is not an error.
    renderError: function(el, err) {
      if (!err || !err.message) { delete sv.errors()[el.id]; return; }
      sv.errors()[el.id] = { message: err.message, type: err.type || null };
    },
    clearError: function(el) {
      delete sv.errors()[el.id];
    }
  });
  Shiny.outputBindings.register(dataBinding, 'shiny.vue.data');
})();
