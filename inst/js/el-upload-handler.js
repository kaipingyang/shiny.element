// el-upload needs one handler beyond field assignment: emptying the file list
// is a method on the component, not a prop.
$(document).on('shiny:connected', function() {
  elRegisterUpdate('updateElUpload');

  Shiny.addCustomMessageHandler('clearElUpload', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
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
