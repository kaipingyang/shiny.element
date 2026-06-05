$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElTag', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.label    !== undefined) widget.instance.label    = message.label;
      if (message.type     !== undefined) widget.instance.type     = message.type;
      if (message.closable !== undefined) widget.instance.closable = message.closable;
    }
  });
});
