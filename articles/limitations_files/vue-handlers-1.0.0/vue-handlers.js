// Page-wide checks for an Element page. update_vue_data() and
// update_vue_component() go through shiny-vue.js like every other update.

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
