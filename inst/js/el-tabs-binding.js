// Tabs as a Shiny input binding rather than a Vue instance.
//
// A Vue instance mounted over the tabs recompiles and rebuilds the DOM inside
// the panes, which detaches any nested htmlwidget from its registration: the
// pane still renders, but the component inside stops reporting and stops
// responding to update_el_*(). Element's tabs are CSS classes plus show/hide
// and one moving bar, so a binding does the job and leaves the panes alone.
(function() {
  // Rendered outside Shiny the markup still shows; there is just nothing to
  // bind it to.
  if (typeof Shiny === 'undefined' || !Shiny.InputBinding) return;

  var binding = new Shiny.InputBinding();

  function items(el) {
    return Array.prototype.slice.call(el.querySelectorAll('.el-tabs__item'));
  }

  function panes(el) {
    return Array.prototype.slice.call(
      el.querySelectorAll(':scope > .el-tabs__content > .el-tab-pane'));
  }

  function selectedName(el) {
    var active = el.querySelector('.el-tabs__item.is-active');
    return active ? active.getAttribute('data-el-name') : null;
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

  function select(el, name) {
    items(el).forEach(function(it) {
      var on = it.getAttribute('data-el-name') === name;
      it.classList.toggle('is-active', on);
      it.setAttribute('tabindex', on ? '0' : '-1');
      if (on) { it.setAttribute('aria-selected', 'true'); }
      else    { it.removeAttribute('aria-selected'); }
    });
    panes(el).forEach(function(p) {
      // Hidden rather than removed, so a nested component stays mounted.
      p.style.display = (p.getAttribute('data-el-name') === name) ? '' : 'none';
    });
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

      $(el).on('click.elTabs', '.el-tabs__item', function(e) {
        var item = e.currentTarget;
        if (item.classList.contains('is-disabled')) return;

        var name = item.getAttribute('data-el-name');

        // The close button sits inside the tab, so a click on it would
        // otherwise select the tab on its way out.
        if (e.target.classList.contains('el-icon-close')) {
          e.stopPropagation();
          var wasActive = item.classList.contains('is-active');
          var remaining = items(el).filter(function(i) { return i !== item; });

          item.parentNode.removeChild(item);
          panes(el).forEach(function(p) {
            if (p.getAttribute('data-el-name') === name) p.parentNode.removeChild(p);
          });

          Shiny.setInputValue(el.id + '_closed', name, { priority: 'event' });
          if (wasActive && remaining.length) {
            select(el, remaining[0].getAttribute('data-el-name'));
          } else {
            moveBar(el);
          }
          callback(false);
          return;
        }

        select(el, name);
        callback(false);
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
      if (data.hasOwnProperty('selected')) {
        this.setValue(el, data.selected);
        $(el).trigger('elTabsChange');
      }
    }
  });

  Shiny.inputBindings.register(binding, 'shiny.element.tabs');
})();
