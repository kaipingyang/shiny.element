$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElAlert', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.title       !== undefined) widget.instance.title       = message.title;
      if (message.type        !== undefined) widget.instance.type        = message.type;
      if (message.description !== undefined) widget.instance.description = message.description;
    }
  });
});
