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
// The overlay is Element Plus's markup: the wrapper is the .el-overlay (the
// mask), holding the panel. Its z-index comes from Element Plus's own
// counter (ElementPlus.useZIndex), the one every select, popover and message
// box on the page draws from: it starts where el_page(z_index =) says, and a
// dropdown opened inside a dialog lands above it. Escape closes the topmost
// open overlay; the page stops scrolling while one is open, with the class
// Element uses.
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

  // ── stacking, scroll lock, Escape ──────────────────────────────────────
  var zIndexer = null;
  function nextZIndex() {
    if (!zIndexer && window.ElementPlus && ElementPlus.useZIndex && window.Vue) {
      var cfg = window.shinyElementConfig || {};
      zIndexer = ElementPlus.useZIndex(cfg.zIndex ? Vue.ref(cfg.zIndex) : undefined);
    }
    return zIndexer ? zIndexer.nextZIndex() : 2000;
  }
  var stack = [];
  function lockScroll() {
    var open = stack.some(function(w) { return w.getAttribute('data-lock-scroll') !== 'false'; });
    document.body.classList.toggle('el-popup-parent--hidden', open);
  }
  document.addEventListener('keydown', function(e) {
    if (e.key !== 'Escape' && e.keyCode !== 27) return;
    var top = stack[stack.length - 1];
    if (top && top.getAttribute('data-esc-close') !== 'false') requestClose(top);
  });

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

  // Element's transitions, played as Vue's <transition> plays them:
  // dialog-fade for a dialog (animations), el-drawer-fade for a drawer (a
  // transition from -from to -to). opened and closed follow its end, as
  // Element's after-enter and after-leave do; a fallback timer covers a page
  // where nothing animates.
  function isDrawer(wrapper) { return wrapper.getAttribute('data-el-overlay') === 'drawer'; }
  function animate(wrapper, phase, done) {
    var name = isDrawer(wrapper) ? 'el-drawer-fade' : 'dialog-fade';
    var from = name + '-' + phase + '-from', active = name + '-' + phase + '-active',
        to = name + '-' + phase + '-to';
    var finished = false;
    function end(e) {
      if (finished || (e && e.target !== wrapper && !wrapper.contains(e.target))) return;
      finished = true;
      wrapper.removeEventListener('animationend', end);
      wrapper.removeEventListener('transitionend', end);
      wrapper.classList.remove(from, active, to);
      done();
    }
    wrapper.classList.add(from, active);
    requestAnimationFrame(function() { requestAnimationFrame(function() {
      wrapper.classList.remove(from);
      wrapper.classList.add(to);
    }); });
    wrapper.addEventListener('animationend', end);
    wrapper.addEventListener('transitionend', end);
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
    wrapper.style.zIndex = nextZIndex();
    stack.push(wrapper);
    lockScroll();
    // A drawer gives focus back to what had it, as Element's does
    wrapper._elPrevFocus = document.activeElement;
    wrapper.style.display = '';
    var panel = wrapper.querySelector('.el-drawer, .el-dialog');
    if (panel && isDrawer(wrapper)) panel.classList.add('open');
    animate(wrapper, 'enter', function() {
      if (panel) panel.focus();
      if (notify !== false) report(wrapper, '_opened');
    });
  }

  function hide(wrapper, notify) {
    if (!isOpen(wrapper)) return;
    wrapper._elOpen = false;
    report(wrapper, '_close');
    var i = stack.indexOf(wrapper);
    if (i !== -1) stack.splice(i, 1);
    lockScroll();
    if (notify) $(wrapper).trigger('elOverlayChange');
    animate(wrapper, 'leave', function() {
      if (wrapper._elOpen) return;            // opened again meanwhile
      wrapper.style.display = 'none';
      var panel = wrapper.querySelector('.el-drawer');
      if (panel) panel.classList.remove('open');
      if (wrapper.getAttribute('data-destroy-on-close') === 'true') destroy(wrapper);
      var prev = wrapper._elPrevFocus;
      wrapper._elPrevFocus = null;
      if (prev && prev.focus && document.body.contains(prev)) prev.focus();
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

        // A click on the mask, outside the panel, is Element's other way of
        // dismissing one: the dialog's full-screen box, or the drawer's mask
        $(el).on('mousedown.elOverlay', function(e) { el._elDownOnMask = isMask(el, e.target); });
        $(el).on('click.elOverlay', function(e) {
          var onMask = el._elDownOnMask && isMask(el, e.target);
          el._elDownOnMask = false;
          if (onMask && el.getAttribute('data-mask-close') === 'true') requestClose(el);
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
          var t = el.querySelector('.el-dialog__title, .el-drawer__title');
          if (t) t.textContent = data.title;
        }
        if (data.hasOwnProperty('width')) {
          var panel = el.querySelector('.el-dialog');
          if (panel) panel.style.setProperty('--el-dialog-width', data.width);
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

  function isMask(wrapper, target) {
    return target === wrapper || (target.classList && target.classList.contains('el-overlay-dialog') &&
                                  target.parentNode === wrapper);
  }

  makeBinding('[data-el-overlay=dialog]', 'shiny.element.dialog');
  makeBinding('[data-el-overlay=drawer]', 'shiny.element.drawer');
})();
