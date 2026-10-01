// Tabs as a Shiny input binding rather than a Vue instance.
//
// A Vue instance mounted over the tabs recompiles and rebuilds the DOM inside
// the panes, which detaches any nested htmlwidget from its registration: the
// pane still renders, but the component inside stops reporting and stops
// responding to update_el_*(). Element's tabs are CSS classes plus show/hide
// and one moving bar, so a binding does the job and leaves the panes alone.
//
// Events are reported under Element's names: input$<id>_tab_click,
// _tab_remove, _tab_add, and _edit for the last two together.
(function() {
  // Rendered outside Shiny the markup still shows; there is just nothing to
  // bind it to.
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

  var binding = (hasShiny ? new Shiny.InputBinding() : {});

  function items(el) {
    return Array.prototype.slice.call(el.querySelectorAll('.el-tabs__item'));
  }

  function panes(el) {
    return Array.prototype.slice.call(
      el.querySelectorAll(':scope > .el-tabs__content > .el-tab-pane'));
  }

  function pane(el, name) {
    return panes(el).filter(function(p) {
      return p.getAttribute('data-el-name') === name;
    })[0];
  }

  function selectedName(el) {
    var active = el.querySelector('.el-tabs__item.is-active');
    return active ? active.getAttribute('data-el-name') : null;
  }

  function report(el, what, value) {
    hasShiny && Shiny.setInputValue(el.id + what, value, { priority: 'event' });
  }

  // The active bar's size and offset are inline styles in Element too --
  // they depend on the rendered width of the active label, so there is no
  // CSS class that could express them.
  function moveBar(el) {
    var bar = el.querySelector('.el-tabs__active-bar');
    if (!bar) return;                       // card types have no bar
    var active = el.querySelector('.el-tabs__item.is-active');
    if (!active) return;

    var vertical = el.getAttribute('data-position') === 'left' ||
                   el.getAttribute('data-position') === 'right';
    if (vertical) {
      bar.style.height = active.offsetHeight + 'px';
      bar.style.transform = 'translateY(' + active.offsetTop + 'px)';
    } else {
      bar.style.width = active.offsetWidth + 'px';
      bar.style.transform = 'translateX(' + active.offsetLeft + 'px)';
    }
  }

  // A lazy tab keeps its content in an inert <template> until it is first
  // shown. Instantiating it means binding what it holds: Shiny's inputs and
  // outputs, and the htmlwidgets that carry this package's components.
  function instantiate(p) {
    if (!p) return;
    var tpl = p.querySelector(':scope > template[data-el-lazy]');
    if (!tpl) return;
    p.appendChild(document.importNode(tpl.content, true));
    tpl.parentNode.removeChild(tpl);
    if (window.HTMLWidgets) window.HTMLWidgets.staticRender();
    hasShiny && Shiny.bindAll(p);
  }

  function show(el, name) {
    items(el).forEach(function(it) {
      var on = it.getAttribute('data-el-name') === name;
      it.classList.toggle('is-active', on);
      it.setAttribute('tabindex', on ? '0' : '-1');
      if (on) { it.setAttribute('aria-selected', 'true'); }
      else    { it.removeAttribute('aria-selected'); }
    });
    panes(el).forEach(function(p) {
      // Hidden rather than removed, so a nested component stays mounted.
      var on = p.getAttribute('data-el-name') === name;
      if (on) instantiate(p);
      p.style.display = on ? '' : 'none';
    });
    moveBar(el);
  }

  // Element's before-leave: a function that may return false, or a promise,
  // to keep the current tab.
  function guard(el) {
    if (el._elBeforeLeave === undefined) {
      var src = el.getAttribute('data-before-leave');
      el._elBeforeLeave = src ? eval('(' + src + ')') : null;
    }
    return el._elBeforeLeave;
  }

  function select(el, name, done) {
    var old = selectedName(el);
    if (name === old) { show(el, name); if (done) done(); return; }
    var check = guard(el);
    var result = check ? check(name, old) : true;
    if (result === false) return;
    if (result && typeof result.then === 'function') {
      result.then(function(ok) {
        if (ok === false) return;
        show(el, name); if (done) done();
      }, function() {});
      return;
    }
    show(el, name);
    if (done) done();
  }

  function removeTab(el, name, callback) {
    var item = el.querySelector('.el-tabs__item[data-el-name="' + name + '"]');
    if (!item) return;
    var wasActive = item.classList.contains('is-active');
    var p = pane(el, name);
    item.parentNode.removeChild(item);
    if (p) { hasShiny && Shiny.unbindAll(p); p.parentNode.removeChild(p); }
    var remaining = items(el);
    if (wasActive && remaining.length) {
      show(el, remaining[0].getAttribute('data-el-name'));
    } else {
      moveBar(el);
    }
    if (callback) callback(false);
  }

  function addItem(el, tab) {
    var nav = el.querySelector('.el-tabs__nav');
    var pos = 'is-' + (el.getAttribute('data-position') || 'top');
    var closable = tab.closable === null || tab.closable === undefined
      ? el.getAttribute('data-closable') === 'true' : !!tab.closable;
    var item = document.createElement('div');
    item.id = el.id + '-tab-' + tab.name;
    item.setAttribute('role', 'tab');
    item.setAttribute('tabindex', '-1');
    item.setAttribute('data-el-name', tab.name);
    item.className = 'el-tabs__item ' + pos + (closable ? ' is-closable' : '');
    item.appendChild(document.createTextNode(tab.label));
    if (closable) {
      var x = document.createElement('span');
      x.className = 'el-icon-close';
      item.appendChild(x);
    }
    nav.appendChild(item);
    moveBar(el);
  }

  $.extend(binding, {
    find: function(scope) {
      return $(scope).find('.el-tabs[data-el-tabs]');
    },

    getValue: function(el) {
      return selectedName(el);
    },

    setValue: function(el, value) {
      select(el, value);
    },

    initialize: function(el) {
      // The bar cannot be positioned server-side: it depends on the label's
      // rendered width.
      moveBar(el);
    },

    subscribe: function(el, callback) {
      // receiveMessage has no callback of its own; it raises this instead.
      $(el).on('elTabsChange.elTabs', function() { callback(false); });

      $(el).on('click.elTabs', '.el-tabs__new-tab', function() {
        report(el, '_tab_add', true);
        report(el, '_edit', { target: null, action: 'add' });
      });

      $(el).on('click.elTabs', '.el-tabs__item', function(e) {
        var item = e.currentTarget;
        var name = item.getAttribute('data-el-name');

        // The close button sits inside the tab, so a click on it would
        // otherwise select the tab on its way out.
        if (e.target.classList.contains('el-icon-close')) {
          e.stopPropagation();
          removeTab(el, name, callback);
          report(el, '_tab_remove', name);
          report(el, '_edit', { target: name, action: 'remove' });
          return;
        }

        if (item.classList.contains('is-disabled')) return;
        report(el, '_tab_click', name);
        select(el, name, function() { callback(false); });
      });

      // The bar is positioned from a rendered width, so it has to be redone
      // when the layout changes.
      $(window).on('resize.elTabs' + el.id, function() { moveBar(el); });
    },

    unsubscribe: function(el) {
      $(el).off('.elTabs');
      $(window).off('resize.elTabs' + el.id);
    },

    receiveMessage: function(el, data) {
      if (data.add_tab) addItem(el, data.add_tab);
      if (data.remove_tab) removeTab(el, data.remove_tab);
      if (data.hasOwnProperty('selected') && data.selected !== null) {
        select(el, data.selected);
      }
      $(el).trigger('elTabsChange');
    }
  });

  if (hasShiny) Shiny.inputBindings.register(binding, 'shiny.element.tabs');
    else standalone(binding);
})();
