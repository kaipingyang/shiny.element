if (typeof Shiny !== 'undefined' && Shiny.addCustomMessageHandler) {

// update_vue_component() and update_vue_data(). Nothing to do without Shiny.

Shiny.addCustomMessageHandler('update_vue_component', function(message) {
  var widget = HTMLWidgets.find('#' + message.id);
  if (widget && widget.instance) {
    Object.keys(message).forEach(function(key) {
      if (key !== 'id' && widget.instance.hasOwnProperty(key)) {
        widget.instance[key] = message[key];
      }
    });
    if (widget.instance._elReport) widget.instance._elReport();
  }
});

Shiny.addCustomMessageHandler('update_vue_data', function(message) {
  var widget = HTMLWidgets.find('#' + message.id);
  if (widget && widget.instance && message.data) {
    Object.assign(widget.instance.$data, message.data);
    if (widget.instance._elReport) widget.instance._elReport();
  }
});

}

// A raw Element tag -- el$button() -- is compiled only inside a Vue instance.
// Placed anywhere else it stays an unknown <el-button> element and shows its
// bare text, with nothing said. Say it, once per tag, after the page and
// after each piece of UI the server renders.
(function() {
  var warned = {};
  function check() {
    var all = document.getElementsByTagName('*');
    for (var i = 0; i < all.length; i++) {
      var tag = all[i].tagName;
      if (tag.indexOf('EL-') !== 0 || warned[tag]) continue;
      warned[tag] = true;
      console.warn('[shiny.element] <' + tag.toLowerCase() + '> is outside any ' +
        'component and was not rendered. Raw el$ tags work inside one -- ' +
        'el_widget(markup =), template(), a slot, a table cell, a wrapper\'s ' +
        'trigger; at the top level use the component function instead.');
    }
  }
  function later() { setTimeout(check, 500); }
  if (document.readyState === 'complete') later();
  else window.addEventListener('load', later);
  if (window.jQuery) jQuery(document).on('shiny:value', later);
})();
