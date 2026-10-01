// Collapse as a Shiny input binding rather than a Vue instance.
//
// A Vue instance mounted over these panels would recompile and rebuild the
// DOM inside them, which detaches any nested htmlwidget from its registration
// -- the panel still renders, but the component inside stops reporting and
// stops responding to update_el_*(). Element's collapse is only CSS classes
// plus show/hide, so a binding does the job and leaves the children alone.
//
// Being a binding also means Shiny re-binds automatically after renderUI,
// which is what htmlwidgets was giving us for free.
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

  function setOpen(panel, open) {
    var header = panel.querySelector(':scope > .el-collapse-item__header');
    var arrow  = panel.querySelector('.el-collapse-item__arrow');
    var wrap   = panel.querySelector(':scope > .el-collapse-item__wrap');

    panel.classList.toggle('is-active', open);
    if (header) header.classList.toggle('is-active', open);
    if (arrow)  arrow.classList.toggle('is-active', open);
    // Hidden rather than removed, so a nested component stays mounted.
    if (wrap)   wrap.style.display = open ? '' : 'none';
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
        setOpen(p, wanted.indexOf(p.getAttribute('data-el-name')) > -1);
      });
    },

    subscribe: function(el, callback) {
      // receiveMessage changes the DOM but has no callback of its own, so it
      // raises this event for the subscription to pick up. Without it the
      // panels move and input$<id> keeps its old value.
      $(el).on('elCollapseChange.elCollapse', function() { callback(false); });

      $(el).on('click.elCollapse', '.el-collapse-item__header', function(e) {
        var panel = e.currentTarget.parentElement;
        if (panel.classList.contains('is-disabled')) return;

        var opening = !panel.classList.contains('is-active');
        if (el.getAttribute('data-accordion') === 'true') {
          panels(el).forEach(function(p) { setOpen(p, false); });
          setOpen(panel, opening);
        } else {
          setOpen(panel, opening);
        }
        callback(false);
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
