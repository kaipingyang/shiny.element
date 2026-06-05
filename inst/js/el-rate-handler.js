$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElRate', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.value    !== undefined) widget.instance.value    = message.value;
      if (message.disabled !== undefined) widget.instance.disabled = message.disabled;
    }
  });
});
