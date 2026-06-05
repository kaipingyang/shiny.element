// Handler for updating el_progress component
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElProgress', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.percentage  !== undefined) widget.instance.percentage  = message.percentage;
      if (message.type        !== undefined) widget.instance.type        = message.type;
      if (message.status      !== undefined) widget.instance.status      = message.status;
      if (message.color       !== undefined) widget.instance.color       = message.color;
      if (message.strokeWidth !== undefined) widget.instance.strokeWidth = message.strokeWidth;
      if (message.showText    !== undefined) widget.instance.showText    = message.showText;
      if (message.textInside  !== undefined) widget.instance.textInside  = message.textInside;
    }
  });
});
