$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElButton', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.label !== undefined) widget.instance.label = message.label;
      if (message.type !== undefined) widget.instance.type = message.type;
      if (message.disabled !== undefined) widget.instance.disabled = message.disabled;
    }
  });
});