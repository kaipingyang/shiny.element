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
  if (typeof Shiny === 'undefined' || !Shiny.InputBinding) return;

  var BASE_Z = 2000;
  var open = [];            // wrappers currently shown, oldest first

  function nextZ() {
    // Odd numbers above the backdrop, matching Element: 2001, 2003, ...
    return BASE_Z + open.length * 2 - 1;
  }

  function backdrop() {
    return document.querySelector('.v-modal');
  }

  function syncBody() {
    // Element's own class; it sets overflow:hidden on <body>.
    document.body.classList.toggle('el-popup-parent--hidden', open.length > 0);

    var mask = backdrop();
    var wantsMask = open.some(function(w) {
      return w.getAttribute('data-modal') !== 'false';
    });

    if (wantsMask && !mask) {
      mask = document.createElement('div');
      mask.className = 'v-modal';
      document.body.appendChild(mask);
      mask.addEventListener('click', function() {
        // Only the topmost overlay closes, and only if it allows it.
        for (var i = open.length - 1; i >= 0; i--) {
          if (open[i].getAttribute('data-mask-close') === 'true') {
            hide(open[i], true);
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

  function show(wrapper) {
    if (open.indexOf(wrapper) === -1) open.push(wrapper);
    wrapper.style.zIndex = nextZ();
    wrapper.style.display = '';
    // The drawer slides in from a class on its container.
    var container = wrapper.querySelector('.el-drawer__container');
    if (container) container.classList.add('el-drawer__open');
    syncBody();
  }

  function hide(wrapper, notify) {
    var i = open.indexOf(wrapper);
    if (i > -1) open.splice(i, 1);
    wrapper.style.display = 'none';
    var container = wrapper.querySelector('.el-drawer__container');
    if (container) container.classList.remove('el-drawer__open');
    syncBody();
    if (notify) $(wrapper).trigger('elOverlayChange');
  }

  document.addEventListener('keydown', function(e) {
    if (e.key !== 'Escape' && e.keyCode !== 27) return;
    for (var i = open.length - 1; i >= 0; i--) {
      if (open[i].getAttribute('data-esc-close') === 'true') {
        hide(open[i], true);
        return;
      }
    }
  });

  function makeBinding(selector, name) {
    var binding = new Shiny.InputBinding();

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
        if (el.getAttribute('data-visible') === 'true') show(el);
      },

      subscribe: function(el, callback) {
        $(el).on('elOverlayChange.elOverlay', function() { callback(false); });

        $(el).on('click.elOverlay', '.el-dialog__headerbtn, .el-drawer__close-btn',
          function() { hide(el, true); });

        // Clicking the wrapper itself, outside the panel, is Element's other
        // way of dismissing a dialog.
        $(el).on('click.elOverlay', function(e) {
          if (e.target !== el) return;
          if (el.getAttribute('data-mask-close') === 'true') hide(el, true);
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

    Shiny.inputBindings.register(binding, name);
  }

  makeBinding('.el-dialog__wrapper[data-el-overlay]', 'shiny.element.dialog');
  makeBinding('.el-drawer__wrapper[data-el-overlay]', 'shiny.element.drawer');
})();
