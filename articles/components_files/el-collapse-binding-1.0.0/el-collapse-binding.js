// Collapse as a Shiny input binding rather than a Vue instance.
//
// A Vue instance mounted over these panels would recompile and rebuild the
// DOM inside them, which detaches the components placed there -- the panel
// still renders, but the component inside stops reporting and stops
// responding to update_el_*(). Element's collapse is only CSS classes plus
// show/hide, so a binding does the job and leaves the children alone, and
// Shiny binds it again after renderUI like any other input.
(function() {
  // Rendered outside Shiny (a vignette, say) the markup still shows; there is
  // just nothing to bind it to.
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

  function panels(el) {
    return Array.prototype.slice.call(
      el.querySelectorAll(':scope > .el-collapse-item'));
  }

  function openNames(el) {
    return panels(el)
      .filter(function(p) { return p.classList.contains('is-active'); })
      .map(function(p) { return p.getAttribute('data-el-name'); });
  }

  function headerOf(panel) {
    return panel.querySelector(':scope > [role=tab] > .el-collapse-item__header');
  }

  // Element's el-collapse-transition: the height runs from 0 to the
  // content's and back. Only for a change the user or the server makes;
  // a page drawn open or closed starts that way.
  function animateWrap(wrap, open) {
    var token = (wrap._elToken || 0) + 1;
    wrap._elToken = token;
    wrap.classList.add('collapse-transition');
    wrap.style.overflow = 'hidden';
    if (open) {
      wrap.style.display = '';
      var h = wrap.scrollHeight;
      wrap.style.height = '0';
      void wrap.offsetHeight;
      wrap.style.height = h + 'px';
    } else {
      wrap.style.height = wrap.scrollHeight + 'px';
      void wrap.offsetHeight;
      wrap.style.height = '0';
    }
    var done = function() {
      if (wrap._elToken !== token) return;
      wrap.classList.remove('collapse-transition');
      wrap.style.height = '';
      wrap.style.overflow = '';
      if (!open) wrap.style.display = 'none';
    };
    wrap.addEventListener('transitionend', function te(e) {
      if (e.target !== wrap) return;
      wrap.removeEventListener('transitionend', te);
      done();
    });
    setTimeout(done, 400);
  }

  function setOpen(panel, open, animate) {
    var tab    = panel.querySelector(':scope > [role=tab]');
    var header = headerOf(panel);
    var arrow  = panel.querySelector('.el-collapse-item__arrow');
    var wrap   = panel.querySelector(':scope > .el-collapse-item__wrap');
    var was = panel.classList.contains('is-active');

    panel.classList.toggle('is-active', open);
    if (tab)    tab.setAttribute('aria-expanded', open ? 'true' : 'false');
    if (header) header.classList.toggle('is-active', open);
    if (arrow)  arrow.classList.toggle('is-active', open);
    if (!wrap) return;
    wrap.setAttribute('aria-hidden', open ? 'false' : 'true');
    // Hidden rather than removed, so a nested component stays mounted.
    if (animate && was !== open) animateWrap(wrap, open);
    else wrap.style.display = open ? '' : 'none';
  }

  $.extend(binding, {
    find: function(scope) {
      return $(scope).find('.el-collapse[data-el-collapse]');
    },

    getValue: function(el) {
      return openNames(el);
    },

    setValue: function(el, value) {
      var wanted = value || [];
      if (el.getAttribute('data-accordion') === 'true' && wanted.length > 1) {
        wanted = [wanted[0]];
      }
      panels(el).forEach(function(p) {
        setOpen(p, wanted.indexOf(p.getAttribute('data-el-name')) > -1, true);
      });
    },

    subscribe: function(el, callback) {
      // receiveMessage changes the DOM but has no callback of its own, so it
      // raises this event for the subscription to pick up. Without it the
      // panels move and input$<id> keeps its old value.
      $(el).on('elCollapseChange.elCollapse', function() { callback(false); });

      function toggle(panel) {
        if (panel.classList.contains('is-disabled')) return;
        var opening = !panel.classList.contains('is-active');
        if (el.getAttribute('data-accordion') === 'true') {
          panels(el).forEach(function(p) { if (p !== panel) setOpen(p, false, true); });
        }
        setOpen(panel, opening, true);
        callback(false);
      }
      function panelOf(header) { return header.parentElement.parentElement; }
      function own(header) { return panelOf(header).parentElement === el; }

      $(el).on('click.elCollapse', '.el-collapse-item__header', function(e) {
        if (!own(e.currentTarget)) return;
        el._elClicked = true;
        toggle(panelOf(e.currentTarget));
      });
      // Enter or Space on a focused header, as Element's keyup handler
      $(el).on('keyup.elCollapse', '.el-collapse-item__header', function(e) {
        if (!own(e.currentTarget) || (e.keyCode !== 13 && e.keyCode !== 32)) return;
        e.stopPropagation();
        toggle(panelOf(e.currentTarget));
      });
      // focusing marks a header reached from the keyboard, not by a click
      $(el).on('focusin.elCollapse', '.el-collapse-item__header', function(e) {
        var h = e.currentTarget;
        setTimeout(function() {
          if (!el._elClicked) h.classList.add('focusing');
          el._elClicked = false;
        }, 50);
      });
      $(el).on('focusout.elCollapse', '.el-collapse-item__header', function(e) {
        e.currentTarget.classList.remove('focusing');
      });
    },

    unsubscribe: function(el) {
      $(el).off('.elCollapse');
    },

    receiveMessage: function(el, data) {
      if (data.hasOwnProperty('value')) {
        this.setValue(el, data.value);
        $(el).trigger('elCollapseChange');
      }
    }
  });

  if (hasShiny) Shiny.inputBindings.register(binding, 'shiny.element.collapse');
    else standalone(binding);
})();
