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

  // Focus stays inside the topmost open overlay, as Element Plus's
  // ElFocusTrap keeps it: Tab from the last control comes round to the
  // first, Shift+Tab from the first to the last, and focus that lands
  // outside -- a click on the page under the mask -- is brought back.
  // Element's own popups (a select's dropdown, a date picker's panel, a
  // message box) are appended to <body> outside the overlay and are left
  // alone.
  var TABBABLE = 'a[href], area[href], button:not([disabled]), ' +
    'input:not([disabled]):not([type="hidden"]), select:not([disabled]), ' +
    'textarea:not([disabled]), [tabindex]:not([tabindex="-1"]), [contenteditable="true"]';
  function panelOf(wrapper) { return wrapper.querySelector('.el-dialog, .el-drawer'); }
  function tabbables(panel) {
    return Array.prototype.filter.call(panel.querySelectorAll(TABBABLE), function(el) {
      return el.tabIndex >= 0 && el.getClientRects().length > 0 &&
        getComputedStyle(el).visibility !== 'hidden';
    });
  }
  // Element Plus's own overlays (a message box's mask, an image viewer) are
  // popups above the dialog; this package's dialogs and drawers are .el-overlay
  // too, and one lower in the stack is not -- the topmost keeps the focus.
  function popupOutside(el) {
    if (!el || !el.closest) return false;
    if (el.closest('.el-popper, .el-message-box, .el-message, .el-notification, .el-image-viewer__wrapper')) {
      return true;
    }
    var ov = el.closest('.el-overlay');
    return !!ov && !ov.hasAttribute('data-el-overlay');
  }
  document.addEventListener('keydown', function(e) {
    if (e.key !== 'Tab') return;
    var top = stack[stack.length - 1];
    var panel = top && panelOf(top);
    if (!panel) return;
    var active = document.activeElement;
    if (active !== panel && !panel.contains(active) && popupOutside(active)) return;
    var items = tabbables(panel);
    if (!items.length) { e.preventDefault(); panel.focus(); return; }
    var first = items[0], last = items[items.length - 1];
    var inside = panel.contains(active) && active !== panel;
    if (e.shiftKey && (!inside || active === first)) { e.preventDefault(); last.focus(); }
    else if (!e.shiftKey && (!inside || active === last)) { e.preventDefault(); first.focus(); }
  });
  document.addEventListener('focusin', function(e) {
    var top = stack[stack.length - 1];
    var panel = top && panelOf(top);
    if (!panel || panel.contains(e.target) || popupOutside(e.target)) return;
    // only while it is fully open; the enter animation focuses the panel
    if (top._elEntering) return;
    var items = tabbables(panel);
    (items[0] || panel).focus();
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
    // A dialog drawn by a Vue wrapper (a config provider) has its <template>
    // rendered by Vue, which puts the children on the element, not in
    // .content: they are the wrapper's live nodes, moved in and back out,
    // where a copy would have none of Vue's listeners
    if (tpl.content.childNodes.length) {
      live.appendChild(document.importNode(tpl.content, true));
    } else {
      while (tpl.firstChild) live.appendChild(tpl.firstChild);
      live._elFrom = tpl;
    }
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
    if (live._elFrom) {
      while (live.firstChild) live._elFrom.appendChild(live.firstChild);
    }
    live.parentNode.removeChild(live);
  }

  // Element's transitions, played as Vue's <transition> plays them:
  // dialog-fade for a dialog (animations), el-drawer-fade for a drawer (a
  // transition from -from to -to). opened and closed follow its end, as
  // Element's after-enter and after-leave do; a fallback timer covers a page
  // where nothing animates.
  function isDrawer(wrapper) { return wrapper.getAttribute('data-el-overlay') === 'drawer'; }
  // A new phase cancels the one still playing, as Vue's <transition> does:
  // closed straight after opening, the dialog never reports opened, and its
  // enter step does not take focus after the leave began.
  function animate(wrapper, phase, done) {
    if (wrapper._elCancelAnim) wrapper._elCancelAnim();
    var name = wrapper.getAttribute('data-transition') ||
               (isDrawer(wrapper) ? 'el-drawer-fade' : 'dialog-fade');
    var from = name + '-' + phase + '-from', active = name + '-' + phase + '-active',
        to = name + '-' + phase + '-to';
    var finished = false, timer;
    function stop() {
      finished = true;
      clearTimeout(timer);
      wrapper.removeEventListener('animationend', end);
      wrapper.removeEventListener('transitionend', end);
      wrapper.classList.remove(from, active, to);
      if (wrapper._elCancelAnim === stop) wrapper._elCancelAnim = null;
    }
    function end(e) {
      if (finished || (e && e.target !== wrapper && !wrapper.contains(e.target))) return;
      stop();
      done();
    }
    wrapper._elCancelAnim = stop;
    wrapper.classList.add(from, active);
    requestAnimationFrame(function() { requestAnimationFrame(function() {
      if (finished) return;
      wrapper.classList.remove(from);
      wrapper.classList.add(to);
    }); });
    wrapper.addEventListener('animationend', end);
    wrapper.addEventListener('transitionend', end);
    timer = setTimeout(end, 450);
  }

  function isOpen(wrapper) { return !!wrapper._elOpen; }

  // open-delay and close-delay: the change waits, and a later one cancels it
  function later(wrapper, attr, fn) {
    clearTimeout(wrapper._elDelay);
    var ms = parseInt(wrapper.getAttribute(attr) || '0', 10);
    if (ms > 0) wrapper._elDelay = setTimeout(fn, ms); else fn();
  }

  function show(wrapper, notify) {
    if (isOpen(wrapper)) return;
    // append-to: out of any container that could clip it. Moving a node
    // keeps every binding and Vue instance inside it.
    var target = wrapper.getAttribute('data-append-to');
    var into = target && document.querySelector(target);
    if (into && wrapper.parentNode !== into) into.appendChild(wrapper);
    if (wrapper.getAttribute('data-destroy-on-close') === 'true') create(wrapper);
    wrapper._elOpen = true;
    if (notify !== false) report(wrapper, '_open');
    wrapper.style.zIndex = wrapper.getAttribute('data-z-index') || nextZIndex();
    stack.push(wrapper);
    lockScroll();
    // A drawer gives focus back to what had it, as Element's does
    // (reopened while closing, focus is still inside: keep the first one)
    if (!wrapper.contains(document.activeElement)) wrapper._elPrevFocus = document.activeElement;
    wrapper.style.display = '';
    var panel = wrapper.querySelector('.el-drawer, .el-dialog');
    if (panel && isDrawer(wrapper)) panel.classList.add('open');
    wrapper._elEntering = true;
    animate(wrapper, 'enter', function() {
      wrapper._elEntering = false;
      if (panel) { panel.focus(); report(wrapper, '_open_auto_focus'); }
      if (notify !== false) report(wrapper, '_opened');
    });
  }

  function hide(wrapper, notify) {
    if (!isOpen(wrapper)) return;
    wrapper._elOpen = false;
    wrapper._elEntering = false;
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
      if (prev && prev.focus && document.body.contains(prev)) {
        prev.focus();
        report(wrapper, '_close_auto_focus');
      }
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
    var close = function() { later(wrapper, 'data-close-delay', function() { hide(wrapper, true); }); };
    if (fn) fn(close); else close();
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
        later(el, value ? 'data-open-delay' : 'data-close-delay', function() {
          if (value) show(el); else hide(el, false);
          $(el).trigger('elOverlayChange');
        });
      },

      initialize: function(el) {
        // Rendered visible from R: register it so the backdrop and the body
        // class match what is on screen.
        if (el.getAttribute('data-visible') === 'true') show(el, false);
        // Reached by call_el(): Element's drawer has closeDrawer(), which
        // closes it the way the user would, through before-close.
        el._svMethods = {
          closeDrawer: function() { requestClose(el); },
          handleClose: function() { requestClose(el); },
          resetPosition: function() { resetPosition(el); }
        };
        draggable(el);
        if (el.getAttribute('data-resizable') === 'true') resizable(el);
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
        applyFlags(el, data);
        if (data.hasOwnProperty('visible')) this.setValue(el, data.visible);
        if (data.hasOwnProperty('title')) {
          var t = el.querySelector('.el-dialog__title, .el-drawer__title');
          if (t) t.textContent = data.title;
        }
        if (data.hasOwnProperty('width')) {
          var panel = el.querySelector('.el-dialog');
          // a fullscreen dialog's size is is-fullscreen's, as in Element
          if (panel && !panel.classList.contains('is-fullscreen')) panel.style.setProperty('--el-dialog-width', data.width);
        }
        if (data.hasOwnProperty('direction')) {
          var d = el.querySelector('.el-drawer');
          if (d) {
            var was = (d.className.match(/\b(rtl|ltr|ttb|btt)\b/) || [])[1] || 'rtl';
            var wasV = was === 'ttb' || was === 'btt', isV = data.direction === 'ttb' || data.direction === 'btt';
            d.classList.remove(was);
            d.classList.add(data.direction);
            // the size moves to the other dimension with the edge
            if (wasV !== isV) {
              var sz = d.style[wasV ? 'height' : 'width'];
              d.style[wasV ? 'height' : 'width'] = '';
              if (sz) d.style[isV ? 'height' : 'width'] = sz;
            }
          }
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

  // An overlay's behaviour changed from the server -- update_el_dialog(),
  // update_el_drawer(), a config provider -- as Element's props change it:
  // the attributes the binding reads as the user acts, and the classes
  // Element's stylesheet reads
  // reached by a config provider's dialog settings (el-events.js)
  (window.shinyElement = window.shinyElement || {}).applyOverlayFlags = function(el, d) {
    applyFlags(el, d);
  };
  function applyFlags(el, d) {
    var panel = el.querySelector('.el-dialog') || el.querySelector('.el-drawer');
    var attr = function(name, v) { el.setAttribute(name, v ? 'true' : 'false'); };
    // close-on-click-modal is kept as asked, so a backdrop brought back
    // closes the dialog again; asked for nothing, Element's default is true
    if (d.hasOwnProperty('closeOnClickModal')) el._elMaskWanted = !!d.closeOnClickModal;
    if (el._elMaskWanted === undefined) {
      // what the markup was drawn with: without a backdrop it says false
      // whatever was asked, so Element's default stands
      el._elMaskWanted = el.getAttribute('data-modal') === 'false' ||
        el.getAttribute('data-mask-close') !== 'false';
    }
    if (d.hasOwnProperty('modal')) {
      attr('data-modal', d.modal);
      el.style.backgroundColor = d.modal ? '' : 'transparent';
    }
    if (d.hasOwnProperty('modal') || d.hasOwnProperty('closeOnClickModal')) {
      attr('data-mask-close', el._elMaskWanted && el.getAttribute('data-modal') !== 'false');
    }
    if (d.hasOwnProperty('closeOnPressEscape')) attr('data-esc-close', d.closeOnPressEscape);
    if (d.hasOwnProperty('lockScroll')) attr('data-lock-scroll', d.lockScroll);
    if (d.hasOwnProperty('overflow')) attr('data-overflow', d.overflow);
    if (d.hasOwnProperty('draggable')) {
      attr('data-draggable', d.draggable);
      if (panel) panel.classList.toggle('is-draggable', !!d.draggable);
    }
    if (!panel) return;
    if (d.hasOwnProperty('center')) panel.classList.toggle('el-dialog--center', !!d.center);
    if (d.hasOwnProperty('alignCenter')) {
      panel.classList.toggle('is-align-center', !!d.alignCenter);
      var box = el.querySelector('.el-overlay-dialog');
      if (box) box.style.display = d.alignCenter ? 'flex' : '';
    }
    if (d.hasOwnProperty('top')) panel.style.setProperty('--el-dialog-margin-top', d.top);
    if (d.hasOwnProperty('fullscreen')) {
      panel.classList.toggle('is-fullscreen', !!d.fullscreen);
      // as Element: a fullscreen dialog has no width or top of its own,
      // which would outrank is-fullscreen's; they come back after
      ['--el-dialog-width', '--el-dialog-margin-top'].forEach(function(v) {
        var key = '_el' + v;
        if (d.fullscreen) {
          var had = panel.style.getPropertyValue(v);
          if (had) { panel[key] = had; panel.style.removeProperty(v); }
        } else if (panel[key]) {
          panel.style.setProperty(v, panel[key]);
        }
      });
    }
    if (d.hasOwnProperty('showClose')) {
      var btn = panel.querySelector('.el-dialog__headerbtn, .el-drawer__close-btn');
      if (btn) btn.style.display = d.showClose ? '' : 'none';
      var head = panel.querySelector('.el-dialog__header');
      if (head) head.classList.toggle('show-close', !!d.showClose);
    }
    if (d.hasOwnProperty('withHeader')) {
      var dh = panel.querySelector('.el-drawer__header');
      if (dh) dh.style.display = d.withHeader ? '' : 'none';
    }
  }

  // draggable: the dialog moves with its header, kept inside the viewport
  // unless `overflow` lets it out; resetPosition() puts it back. Whether it
  // drags is read as the header is pressed, so an update can turn it on.
  function draggable(wrapper) {
    var panel = wrapper.querySelector('.el-dialog');
    var header = panel && panel.querySelector('.el-dialog__header');
    if (!header || header._elDrag) return;
    header._elDrag = true;
    header.addEventListener('mousedown', function(e) {
      if (wrapper.getAttribute('data-draggable') !== 'true') return;
      if (e.target.closest('.el-dialog__headerbtn')) return;
      var x0 = e.clientX, y0 = e.clientY;
      var dx0 = panel._elDx || 0, dy0 = panel._elDy || 0;
      var rect = panel.getBoundingClientRect();
      var free = wrapper.getAttribute('data-overflow') === 'true';
      function move(ev) {
        var dx = dx0 + ev.clientX - x0, dy = dy0 + ev.clientY - y0;
        if (!free) {
          dx = Math.min(Math.max(dx, dx0 - rect.left), dx0 + window.innerWidth - rect.right);
          dy = Math.min(Math.max(dy, dy0 - rect.top), dy0 + window.innerHeight - rect.bottom);
        }
        panel._elDx = dx; panel._elDy = dy;
        panel.style.transform = 'translate(' + dx + 'px, ' + dy + 'px)';
      }
      function up() {
        document.removeEventListener('mousemove', move);
        document.removeEventListener('mouseup', up);
      }
      document.addEventListener('mousemove', move);
      document.addEventListener('mouseup', up);
    });
  }
  function resetPosition(wrapper) {
    var panel = wrapper.querySelector('.el-dialog');
    if (!panel) return;
    panel._elDx = panel._elDy = 0;
    panel.style.transform = '';
  }

  // resizable: the drawer's inner edge drags its size, reported as it goes
  function resizable(wrapper) {
    var panel = wrapper.querySelector('.el-drawer');
    var dragger = panel && panel.querySelector('.el-drawer__dragger');
    if (!dragger) return;
    // the edge it slides from, read as a drag starts: update_el_drawer()
    // can change it
    var dir, vertical;
    function sizeNow() { var r = panel.getBoundingClientRect(); return vertical ? r.height : r.width; }
    function send(what, v) {
      hasShiny && Shiny.setInputValue && Shiny.setInputValue(wrapper.id + what, v, { priority: 'event' });
    }
    dragger.addEventListener('mousedown', function(e) {
      e.preventDefault();
      dir = (panel.className.match(/\b(rtl|ltr|ttb|btt)\b/) || [])[1] || 'rtl';
      vertical = dir === 'ttb' || dir === 'btt';
      var start = vertical ? e.clientY : e.clientX, size0 = sizeNow();
      var sign = (dir === 'rtl' || dir === 'btt') ? -1 : 1;
      send('_resize_start', Math.round(size0));
      var last = 0;
      function move(ev) {
        var now = vertical ? ev.clientY : ev.clientX;
        var size = Math.max(0, size0 + sign * (now - start));
        panel.style[vertical ? 'height' : 'width'] = size + 'px';
        if (Date.now() - last > 100) { last = Date.now(); send('_resize', Math.round(size)); }
      }
      function up() {
        document.removeEventListener('mousemove', move);
        document.removeEventListener('mouseup', up);
        send('_resize_end', Math.round(sizeNow()));
      }
      document.addEventListener('mousemove', move);
      document.addEventListener('mouseup', up);
    });
  }

  function isMask(wrapper, target) {
    return target === wrapper || (target.classList && target.classList.contains('el-overlay-dialog') &&
                                  target.parentNode === wrapper);
  }

  makeBinding('[data-el-overlay=dialog]', 'shiny.element.dialog');
  makeBinding('[data-el-overlay=drawer]', 'shiny.element.drawer');
})();
