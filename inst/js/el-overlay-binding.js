// Dialog and drawer as Shiny input bindings rather than Vue instances.
//
// A Vue instance mounted over either one rebuilds the DOM inside it, leaving
// any nested component rendered but disconnected from the server. Both are
// really just a panel, a backdrop and a few classes, so a binding does the job
// and leaves the contents alone.
//
// One thing to know before changing the input name: Shiny routes
// sendInputMessage() by looking up the DOM element whose id matches, not by
// asking bindings for their getId(). Reporting as <id>_visible therefore made
// the value arrive while every update message went nowhere. The input is the
// element's own id, as it is for the collapse and the tabs.
//
// The shared part is the overlay itself: the backdrop is a direct child of
// <body>, the body gets a class that locks scrolling, and stacked overlays
// need increasing z-indexes. Element does the same through its popup manager.
(function() {
  if (typeof jQuery === 'undefined') return;
  var hasShiny = typeof Shiny !== 'undefined' && !!Shiny.InputBinding;

  // Without Shiny -- a static R Markdown page, the package's own website --
  // the component still works on the page; there is just no server to tell.
  function standalone(binding) {
    jQuery(function() {
      binding.find(document).each(function() {
        if (binding.initialize) binding.initialize(this);
        binding.subscribe(this, function() {});
      });
    });
  }

  var BASE_Z = 2000;
  var open = [];            // wrappers currently shown, oldest first

  function nextZ() {
    // Odd numbers above the backdrop, matching Element: 2001, 2003, ...
    return BASE_Z + open.length * 2 - 1;
  }

  function backdrop() {
    return document.querySelector('.v-modal');
  }

  function report(wrapper, what) {
    hasShiny && Shiny.setInputValue && Shiny.setInputValue(wrapper.id + what, true, { priority: 'event' });
  }

  function syncBody() {
    // Element's own class; it sets overflow:hidden on <body>. An overlay
    // with lock-scroll off leaves the page scrollable.
    document.body.classList.toggle('el-popup-parent--hidden', open.some(function(w) {
      return w.getAttribute('data-lock-scroll') !== 'false';
    }));

    var mask = backdrop();
    var wantsMask = open.some(function(w) {
      return w.getAttribute('data-modal') !== 'false';
    });

    if (wantsMask && !mask) {
      mask = document.createElement('div');
      mask.className = 'v-modal';
      // modal-append-to-body: the backdrop goes on <body> unless the topmost
      // overlay asks for it beside itself.
      var top = open[open.length - 1];
      if (top && top.getAttribute('data-modal-append-to-body') === 'false' && top.parentNode) {
        top.parentNode.insertBefore(mask, top);
      } else {
        document.body.appendChild(mask);
      }
      mask.addEventListener('click', function() {
        // Only the topmost overlay closes, and only if it allows it.
        for (var i = open.length - 1; i >= 0; i--) {
          if (open[i].getAttribute('data-mask-close') === 'true') {
            requestClose(open[i]);
            return;
          }
        }
      });
    } else if (!wantsMask && mask) {
      mask.parentNode.removeChild(mask);
      mask = null;
    }

    if (mask) {
      // Just under the lowest open overlay.
      mask.style.zIndex = BASE_Z;
    }
  }

  // destroy-on-close: the content is re-created from an inert <template> each
  // time the overlay opens, and unbound and removed when it closes.
  function bodyOf(wrapper) {
    return wrapper.querySelector('.el-dialog__body, .el-drawer__body');
  }

  function create(wrapper) {
    var body = bodyOf(wrapper);
    if (!body || body.querySelector(':scope > [data-el-live]')) return;
    var tpl = body.querySelector(':scope > template[data-el-pristine]');
    if (!tpl) return;
    var live = document.createElement('div');
    live.setAttribute('data-el-live', 'true');
    live.appendChild(document.importNode(tpl.content, true));
    body.appendChild(live);
    // Shiny's bindAll() mounts the components inside; without Shiny, mount them here
    if (!hasShiny && window.shinyVue) window.shinyVue.mount(live);
    hasShiny && Shiny.bindAll(live);
  }

  function destroy(wrapper) {
    var body = bodyOf(wrapper);
    var live = body && body.querySelector(':scope > [data-el-live]');
    if (!live) return;
    hasShiny && Shiny.unbindAll(live);
    live.parentNode.removeChild(live);
  }

  function show(wrapper, notify) {
    if (open.indexOf(wrapper) !== -1) return;
    // append-to-body: out of any container that could clip it. Moving a node
    // keeps every binding and Vue instance inside it.
    if (wrapper.getAttribute('data-append-to-body') === 'true' &&
        wrapper.parentNode !== document.body) {
      document.body.appendChild(wrapper);
    }
    if (wrapper.getAttribute('data-destroy-on-close') === 'true') create(wrapper);
    if (notify !== false) report(wrapper, '_open');
    open.push(wrapper);
    wrapper.style.zIndex = nextZ();
    wrapper.style.display = '';
    // The drawer slides in from a class on its container.
    var container = wrapper.querySelector('.el-drawer__container');
    if (container) container.classList.add('el-drawer__open');
    syncBody();
    if (notify !== false) setTimeout(function() { report(wrapper, '_opened'); }, 300);
  }

  function hide(wrapper, notify) {
    var i = open.indexOf(wrapper);
    if (i === -1) return;
    open.splice(i, 1);
    report(wrapper, '_close');
    wrapper.style.display = 'none';
    var container = wrapper.querySelector('.el-drawer__container');
    if (container) container.classList.remove('el-drawer__open');
    syncBody();
    if (wrapper.getAttribute('data-destroy-on-close') === 'true') destroy(wrapper);
    setTimeout(function() { report(wrapper, '_closed'); }, 300);
    if (notify) $(wrapper).trigger('elOverlayChange');
  }

  // A close the user asked for -- the cross, the backdrop, Escape -- goes
  // through before-close, which may hold it or let it happen.
  function requestClose(wrapper) {
    if (wrapper._elBeforeClose === undefined) {
      var src = wrapper.getAttribute('data-before-close');
      wrapper._elBeforeClose = src ? eval('(' + src + ')') : null;
    }
    var fn = wrapper._elBeforeClose;
    if (fn) fn(function() { hide(wrapper, true); });
    else hide(wrapper, true);
  }

  document.addEventListener('keydown', function(e) {
    if (e.key !== 'Escape' && e.keyCode !== 27) return;
    for (var i = open.length - 1; i >= 0; i--) {
      if (open[i].getAttribute('data-esc-close') === 'true') {
        requestClose(open[i]);
        return;
      }
    }
  });

  function makeBinding(selector, name) {
    var binding = (hasShiny ? new Shiny.InputBinding() : {});

    $.extend(binding, {
      find: function(scope) {
        return $(scope).find(selector);
      },

      getValue: function(el) {
        return el.style.display !== 'none';
      },

      setValue: function(el, value) {
        if (value) show(el); else hide(el, false);
      },

      initialize: function(el) {
        // Rendered visible from R: register it so the backdrop and the body
        // class match what is on screen.
        if (el.getAttribute('data-visible') === 'true') show(el, false);
        // Reached by el_call(): Element's drawer has closeDrawer(), which
        // closes it the way the user would, through before-close.
        el._elMethods = { closeDrawer: function() { requestClose(el); } };
      },

      subscribe: function(el, callback) {
        $(el).on('elOverlayChange.elOverlay', function() { callback(false); });

        $(el).on('click.elOverlay', '.el-dialog__headerbtn, .el-drawer__close-btn',
          function() { requestClose(el); });

        // Clicking the wrapper itself, outside the panel, is Element's other
        // way of dismissing a dialog.
        $(el).on('click.elOverlay', function(e) {
          if (e.target !== el) return;
          if (el.getAttribute('data-mask-close') === 'true') requestClose(el);
        });
      },

      unsubscribe: function(el) {
        $(el).off('.elOverlay');
        hide(el, false);
      },

      receiveMessage: function(el, data) {
        if (data.hasOwnProperty('visible')) {
          this.setValue(el, data.visible);
          $(el).trigger('elOverlayChange');
        }
        if (data.hasOwnProperty('title')) {
          var t = el.querySelector('.el-dialog__title, .el-drawer__header > span');
          if (t) t.textContent = data.title;
        }
        if (data.hasOwnProperty('width')) {
          var panel = el.querySelector('.el-dialog');
          if (panel) panel.style.width = data.width;
        }
        if (data.hasOwnProperty('size')) {
          var drawer = el.querySelector('.el-drawer');
          if (drawer) {
            var vertical = /ttb|btt/.test(drawer.className);
            drawer.style[vertical ? 'height' : 'width'] = data.size;
          }
        }
      }
    });

    if (hasShiny) Shiny.inputBindings.register(binding, name);
    else standalone(binding);
  }

  makeBinding('.el-dialog__wrapper[data-el-overlay]', 'shiny.element.dialog');
  makeBinding('.el-drawer__wrapper[data-el-overlay]', 'shiny.element.drawer');
})();
