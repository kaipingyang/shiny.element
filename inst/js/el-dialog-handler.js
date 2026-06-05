// Handler for updating el_dialog component
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElDialog', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.visible !== undefined) widget.instance.visible = message.visible;
      if (message.title   !== undefined) widget.instance.title   = message.title;
      if (message.width   !== undefined) widget.instance.width   = message.width;
    }
  });
});
