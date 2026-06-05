$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElDrawer', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.visible !== undefined) widget.instance.visible = message.visible;
      if (message.title   !== undefined) widget.instance.title   = message.title;
      if (message.size    !== undefined) widget.instance.size    = message.size;
    }
  });
});
