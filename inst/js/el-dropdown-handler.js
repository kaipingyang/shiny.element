$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElDropdown', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.disabled !== undefined) widget.instance.disabled = message.disabled;
    }
  });
});
