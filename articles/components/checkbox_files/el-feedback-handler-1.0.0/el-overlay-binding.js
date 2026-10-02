// Dialog and drawer as Shiny input bindings rather than Vue instances.
//
// A Vue instance mounted over either one rebuilds the DOM inside it, leaving
// any nested component rendered but disconnected from the server. Both are
// really just a panel, a backdrop and a few classes, so a binding does the job
// and leaves the contents alone.
//
// One thing to know before changing the input name: Shiny routes
// sendInputMessage() by looking up the DOM element whose id matches, not by
// asking bindings for their getId(). The input is the element's own id, as
// it is for the collapse and the tabs.
//
// The overlay itself -- stacking, backdrop, scroll lock, Escape, a click on
// the backdrop -- is Element's own: each wrapper gets a headless instance of
// Element's Popup mixin (the one el-dialog and el-drawer are built on),
// registered with Element's popup manager. So a dialog's z-index comes from
// the same counter as every select, popover and message box on the page,
// starts where el_page(z_index =) says, and a dropdown opened inside a dialog
// lands above it.
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

  function report(wrapper, what) {
    hasShiny && Shiny.setInputValue && Shiny.setInputValue(wrapper.id + what, true, { priority: 'event' });
  }

  function attr(wrapper, name, dflt) {
    var v = wrapper.getAttribute(name);
    return v === null ? dflt : v !== 'false';
  }

  // ── Element's popup manager ────────────────────────────────────────────
  //
  // The proxy's methods are what the manager calls: close() for a click on
  // the backdrop, handleClose() for Escape. Both go through before-close.
  function popupFor(wrapper) {
    if (wrapper._elPopup) return wrapper._elPopup;
    var Popup = window.ELEMENT && ELEMENT.Dialog && ELEMENT.Dialog.mixins &&
                ELEMENT.Dialog.mixins[0];
    if (!Popup || !window.Vue) return null;
    var Proxy = Vue.extend({
      mixins: [Popup],
      render: function(h) { return h('div', { style: { display: 'none' } }); },
      methods: {
        close: function() { requestClose(wrapper); },
        handleClose: function() { requestClose(wrapper); }
      }
    });
    var vm = new Proxy({ propsData: {
      modal: attr(wrapper, 'data-modal', true),
      modalAppendToBody: attr(wrapper, 'data-modal-append-to-body', true),
      lockScroll: attr(wrapper, 'data-lock-scroll', true),
      closeOnPressEscape: attr(wrapper, 'data-esc-close', true),
      closeOnClickModal: attr(wrapper, 'data-mask-close', true)
    } }).$mount();
    wrapper._elPopup = vm;
    return vm;
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

  // Element's transitions: dialog-fade for a dialog, el-drawer-fade (and the
  // panel's slide) for a drawer. opened and closed follow the animation's
  // end, as Element's after-enter and after-leave do; a fallback timer
  // covers a page where the animation never runs.
  function transitionName(wrapper) {
    return wrapper.classList.contains('el-drawer__wrapper') ? 'el-drawer-fade' : 'dialog-fade';
  }

  function animate(wrapper, phase, done) {
    var cls = transitionName(wrapper) + '-' + phase + '-active';
    var finished = false;
    function end(e) {
      if (finished || (e && e.target !== wrapper && !wrapper.contains(e.target))) return;
      finished = true;
      wrapper.removeEventListener('animationend', end);
      wrapper.classList.remove(cls);
      done();
    }
    wrapper.classList.add(cls);
    wrapper.addEventListener('animationend', end);
    setTimeout(end, 450);
  }

  function isOpen(wrapper) { return !!wrapper._elOpen; }

  function show(wrapper, notify) {
    if (isOpen(wrapper)) return;
    // append-to-body: out of any container that could clip it. Moving a node
    // keeps every binding and Vue instance inside it.
    if (wrapper.getAttribute('data-append-to-body') === 'true' &&
        wrapper.parentNode !== document.body) {
      document.body.appendChild(wrapper);
    }
    if (wrapper.getAttribute('data-destroy-on-close') === 'true') create(wrapper);
    wrapper._elOpen = true;
    if (notify !== false) report(wrapper, '_open');

    var popup = popupFor(wrapper);
    if (popup) {
      // modal-append-to-body = FALSE puts the backdrop beside the overlay:
      // Element puts it in the parent of the popup's element
      wrapper.parentNode.insertBefore(popup.$el, wrapper);
      popup.doOpen(popup.$props);
      wrapper.style.zIndex = popup.$el.style.zIndex;
    }
    // A drawer gives focus back to what had it, as Element's does
    wrapper._elPrevFocus = document.activeElement;
    wrapper.style.display = '';
    var container = wrapper.querySelector('.el-drawer__container');
    if (container) container.classList.add('el-drawer__open');
    var panel = wrapper.querySelector('.el-drawer, .el-dialog');
    animate(wrapper, 'enter', function() {
      if (panel && wrapper.classList.contains('el-drawer__wrapper')) panel.focus();
      if (notify !== false) report(wrapper, '_opened');
    });
  }

  function hide(wrapper, notify) {
    if (!isOpen(wrapper)) return;
    wrapper._elOpen = false;
    report(wrapper, '_close');
    var popup = popupFor(wrapper);
    if (popup && popup.opened) popup.doClose();
    if (notify) $(wrapper).trigger('elOverlayChange');
    animate(wrapper, 'leave', function() {
      if (wrapper._elOpen) return;            // opened again meanwhile
      wrapper.style.display = 'none';
      var container = wrapper.querySelector('.el-drawer__container');
      if (container) container.classList.remove('el-drawer__open');
      if (wrapper.getAttribute('data-destroy-on-close') === 'true') destroy(wrapper);
      var prev = wrapper._elPrevFocus;
      wrapper._elPrevFocus = null;
      if (wrapper.classList.contains('el-drawer__wrapper') && prev && prev.focus &&
          document.body.contains(prev)) prev.focus();
      report(wrapper, '_closed');
    });
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

  // Escape on a non-modal overlay: Element's popup manager only looks at
  // modal ones, but a drawer listens on itself
  document.addEventListener('keydown', function(e) {
    if (e.key !== 'Escape' && e.keyCode !== 27) return;
    var t = e.target && e.target.closest && e.target.closest('.el-drawer__wrapper[data-el-overlay]');
    if (t && isOpen(t) && t.getAttribute('data-modal') === 'false' &&
        t.getAttribute('data-esc-close') !== 'false') requestClose(t);
  });

  function makeBinding(selector, name) {
    var binding = (hasShiny ? new Shiny.InputBinding() : {});

    $.extend(binding, {
      find: function(scope) {
        return $(scope).find(selector);
      },

      getValue: function(el) {
        return isOpen(el);
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
        if (el._elPopup) { el._elPopup.$destroy(); el._elPopup = null; }
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
