// Field updates for el-popconfirm; the shared updater in el-update.js
// validates each key against the Vue data before assigning it.
// Registered at once when Shiny is already on the page. Waiting for
// shiny:connected missed every script that arrives later -- through
// renderUI() or insertUI() -- after that event has fired, so a component
// rendered there never heard its update_el_*().
(function(register) {
  if (window.Shiny && Shiny.addCustomMessageHandler) register();
  else if (window.jQuery) jQuery(document).one('shiny:connected', register);
})(function() {
  elRegisterUpdate('updateElPopconfirm');
});
