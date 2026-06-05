$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElInputNumber', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.value    !== undefined) widget.instance.value    = message.value;
      if (message.min      !== undefined) widget.instance.min      = message.min;
      if (message.max      !== undefined) widget.instance.max      = message.max;
      if (message.disabled !== undefined) widget.instance.disabled = message.disabled;
    }
  });
});
