$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElCollapse', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.activeNames !== undefined) widget.instance.activeNames = message.activeNames;
    }
  });
});
