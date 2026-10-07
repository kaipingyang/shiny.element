// Tabs as a Shiny input binding rather than a Vue instance.
//
// A Vue instance mounted over the tabs recompiles and rebuilds the DOM inside
// the panes, which detaches the components placed there: the
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
    hasShiny && Shiny.setInputValue && Shiny.setInputValue(el.id + what, value, { priority: 'event' });
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
    // as Element's tab-bar.vue: a horizontal bar spans the label alone,
    // the item's padding left out
    if (vertical) {
      bar.style.height = active.clientHeight + 'px';
      bar.style.transform = 'translateY(' + active.offsetTop + 'px)';
    } else {
      var cs = window.getComputedStyle(active);
      var padL = parseFloat(cs.paddingLeft) || 0, padR = parseFloat(cs.paddingRight) || 0;
      bar.style.width = (active.clientWidth - padL - padR) + 'px';
      bar.style.transform = 'translateX(' + (active.offsetLeft + padL) + 'px)';
    }
  }

  // A lazy tab keeps its content in an inert <template> until it is first
  // shown. Instantiating it means binding what it holds: Shiny's inputs and
  // outputs, and this package's components, each an input binding.
  function instantiate(p) {
    if (!p) return;
    var tpl = p.querySelector(':scope > template[data-el-lazy]');
    if (!tpl) return;
    p.appendChild(document.importNode(tpl.content, true));
    tpl.parentNode.removeChild(tpl);
    // Shiny's bindAll() mounts the components inside; without Shiny, mount them here
    if (!hasShiny && window.shinyVue) window.shinyVue.mount(p);
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
      if (on) p.removeAttribute('aria-hidden'); else p.setAttribute('aria-hidden', 'true');
    });
    moveBar(el);
    scrollToActive(el);
  }

  // ── scrolling, as Element's TabNav does when the tabs outgrow the bar ──
  //
  // The nav moves inside its scroll box by a transform; prev and next
  // buttons appear on the wrap, which takes is-scrollable.
  function vertical(el) {
    var pos = el.getAttribute('data-position');
    return pos === 'left' || pos === 'right';
  }
  function navParts(el) {
    var wrap = el.querySelector('.el-tabs__nav-wrap');
    return { wrap: wrap, scroll: wrap && wrap.querySelector('.el-tabs__nav-scroll'),
             nav: wrap && wrap.querySelector('.el-tabs__nav') };
  }
  function sizeOf(node, el) { return vertical(el) ? node.offsetHeight : node.offsetWidth; }
  function offsetOf(el) { return el._elNavOffset || 0; }
  function setOffset(el, value) {
    var n = navParts(el);
    if (!n.nav) return;
    el._elNavOffset = value;
    n.nav.style.transform = 'translate' + (vertical(el) ? 'Y' : 'X') + '(-' + value + 'px)';
  }
  function ensureButtons(el) {
    var n = navParts(el);
    if (!n.wrap || n.wrap.querySelector(':scope > .el-tabs__nav-prev')) return;
    var v = vertical(el);
    var prev = document.createElement('span');
    prev.className = 'el-tabs__nav-prev';
    prev.innerHTML = '<i class="el-icon" data-el-icon="' + (v ? 'ArrowUp' : 'ArrowLeft') + '"></i>';
    var next = document.createElement('span');
    next.className = 'el-tabs__nav-next';
    next.innerHTML = '<i class="el-icon" data-el-icon="' + (v ? 'ArrowDown' : 'ArrowRight') + '"></i>';
    n.wrap.insertBefore(next, n.wrap.firstChild);
    n.wrap.insertBefore(prev, n.wrap.firstChild);
    prev.addEventListener('click', function() {
      var box = sizeOf(navParts(el).scroll, el);
      setOffset(el, Math.max(0, offsetOf(el) - box));
      update(el);
    });
    next.addEventListener('click', function() {
      var p = navParts(el), navSize = sizeOf(p.nav, el), box = sizeOf(p.scroll, el);
      var cur = offsetOf(el);
      if (navSize - cur <= box) return;
      setOffset(el, navSize - cur > box * 2 ? cur + box : navSize - box);
      update(el);
    });
  }
  function update(el) {
    var n = navParts(el);
    if (!n.nav || !n.scroll) return;
    var navSize = sizeOf(n.nav, el), box = sizeOf(n.scroll, el), cur = offsetOf(el);
    if (!navSize || !box) return;              // not laid out yet: hidden
    var scrollable = box < navSize;
    n.wrap.classList.toggle('is-scrollable', scrollable);
    if (scrollable) {
      ensureButtons(el);
      if (navSize - cur < box) { cur = navSize - box; setOffset(el, cur); }
      n.wrap.querySelector('.el-tabs__nav-prev').classList.toggle('is-disabled', !cur);
      n.wrap.querySelector('.el-tabs__nav-next').classList.toggle('is-disabled', cur + box >= navSize);
    } else if (cur > 0) {
      setOffset(el, 0);
    }
  }
  function scrollToActive(el) {
    update(el);
    var n = navParts(el);
    if (!n.wrap || !n.wrap.classList.contains('is-scrollable')) return;
    var active = el.querySelector('.el-tabs__item.is-active');
    if (!active) return;
    var v = vertical(el), a = active.getBoundingClientRect(), b = n.scroll.getBoundingClientRect();
    var navSize = sizeOf(n.nav, el), box = sizeOf(n.scroll, el), cur = offsetOf(el), next = cur;
    if (v) {
      if (a.top < b.top) next = cur - (b.top - a.top);
      if (a.bottom > b.bottom) next = cur + a.bottom - b.bottom;
    } else {
      if (a.left < b.left) next = cur - (b.left - a.left);
      if (a.right > b.right) next = cur + a.right - b.right;
    }
    setOffset(el, Math.max(0, Math.min(next, navSize - box)));
    update(el);
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
        show(el, name); report(el, '_tab_change', name); if (done) done();
      }, function() {});
      return;
    }
    show(el, name);
    report(el, '_tab_change', name);
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
      update(el);
    }
    if (callback) callback(false);
  }

  function addItem(el, tab) {
    var nav = el.querySelector('.el-tabs__nav');
    var pos = 'is-' + (el.getAttribute('data-position') || 'top');
    var closable = tab.closable === null || tab.closable === undefined
      ? el.getAttribute('data-closable') === 'true' : !!tab.closable;
    // a disabled tab cannot be closed, as in Element Plus's TabNav
    if (tab.disabled) closable = false;
    var item = document.createElement('div');
    item.id = el.id + '-tab-' + tab.name;
    item.setAttribute('role', 'tab');
    item.setAttribute('aria-controls', el.id + '-pane-' + tab.name);
    item.setAttribute('tabindex', '-1');
    item.setAttribute('data-el-name', tab.name);
    item.className = 'el-tabs__item ' + pos + (closable ? ' is-closable' : '') +
      (tab.disabled ? ' is-disabled' : '');
    item.appendChild(document.createTextNode(tab.label));
    if (closable) {
      var x = document.createElement('i');
      x.className = 'el-icon is-icon-close';
      x.setAttribute('data-el-icon', 'Close');
      item.appendChild(x);
    }
    nav.appendChild(item);
    moveBar(el);
    update(el);
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
      scrollToActive(el);
    },

    subscribe: function(el, callback) {
      // receiveMessage has no callback of its own; it raises this instead.
      $(el).on('elTabsChange.elTabs', function() { callback(false); });

      function add() {
        report(el, '_tab_add', true);
        report(el, '_edit', { target: null, action: 'add' });
      }
      $(el).on('click.elTabs', '.el-tabs__new-tab', add);
      // focusable, so Enter adds a tab as a click does (Element's handleKeydown)
      $(el).on('keydown.elTabs', '.el-tabs__new-tab', function(e) {
        if (e.key === 'Enter' || e.keyCode === 13) { e.preventDefault(); add(); }
      });

      $(el).on('click.elTabs', '.el-tabs__item', function(e) {
        var item = e.currentTarget;
        var name = item.getAttribute('data-el-name');

        // The close button sits inside the tab, so a click on it would
        // otherwise select the tab on its way out.
        if (e.target.closest && e.target.closest('.is-icon-close')) {
          e.stopPropagation();
          if (item.classList.contains('is-disabled')) return;
          removeTab(el, name, callback);
          report(el, '_tab_remove', name);
          report(el, '_edit', { target: name, action: 'remove' });
          return;
        }

        if (item.classList.contains('is-disabled')) return;
        report(el, '_tab_click', name);
        select(el, name, function() { callback(false); });
      });

      // Keyboard, as Element's TabNav: arrows move to the next tab and select
      // it, wrapping round; Delete or Backspace closes a closable one.
      $(el).on('keydown.elTabs', '.el-tabs__item', function(e) {
        var k = e.keyCode, item = e.currentTarget;
        if (k === 46 || k === 8) {
          if (item.classList.contains('is-closable')) {
            var x = item.querySelector('.is-icon-close');
            if (x) { e.preventDefault(); x.click(); }
          }
          return;
        }
        if ([37, 38, 39, 40].indexOf(k) === -1) return;
        e.preventDefault();
        // disabled tabs are passed over, as Element's changeTab does
        var list = items(el).filter(function(t) { return !t.classList.contains('is-disabled'); });
        var i = list.indexOf(item);
        if (!list.length) return;
        var to = i + ((k === 37 || k === 38) ? -1 : 1);
        if (to < 0) to = list.length - 1; else if (to >= list.length) to = 0;
        el._elKeyboard = true;
        list[to].focus();
        list[to].click();
      });
      // is-focus marks a tab focused from the keyboard, not by a click
      $(el).on('mousedown.elTabs', '.el-tabs__item', function() { el._elKeyboard = false; });
      $(el).on('keydown.elTabs', function(e) { if (e.keyCode === 9) el._elKeyboard = true; });
      $(el).on('focusin.elTabs', '.el-tabs__item', function(e) {
        if (el._elKeyboard) e.currentTarget.classList.add('is-focus');
      });
      $(el).on('focusout.elTabs', '.el-tabs__item', function(e) {
        e.currentTarget.classList.remove('is-focus');
      });

      // The bar and the scrolling are worked out from rendered sizes, so
      // they have to be redone when the layout changes.
      $(window).on('resize.elTabs' + el.id, function() { moveBar(el); scrollToActive(el); });
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
