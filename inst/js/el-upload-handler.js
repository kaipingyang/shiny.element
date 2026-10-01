// el-upload needs one handler beyond field assignment: emptying the file list
// is a method on the component, not a prop.
// Registered at once when Shiny is already on the page. Waiting for
// shiny:connected missed every script that arrives later -- through
// renderUI() or insertUI() -- after that event has fired, so a component
// rendered there never heard its update_el_*().
(function(register) {
  if (window.Shiny && Shiny.addCustomMessageHandler) register();
  else if (window.jQuery) jQuery(document).one('shiny:connected', register);
})(function() {
  elRegisterUpdate('updateElUpload');

  Shiny.addCustomMessageHandler('clearElUpload', function(message) {
    var widget = (window.shinyElement && shinyElement.find(message.id));
    if (!widget || !widget.instance) {
      console.warn('[shiny.element] clearElUpload: no mounted widget with id "' +
                   message.id + '"');
      return;
    }
    var vm = widget.instance;
    if (vm.$refs.upload) vm.$refs.upload.clearFiles();
    vm.succeeded = [];
    Shiny.setInputValue(message.id + '_success', []);
  });
});
