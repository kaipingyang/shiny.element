$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElSwitch', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.value         !== undefined) widget.instance.value         = message.value;
      if (message.disabled      !== undefined) widget.instance.disabled      = message.disabled;
      if (message.activeText    !== undefined) widget.instance.activeText    = message.activeText;
      if (message.inactiveText  !== undefined) widget.instance.inactiveText  = message.inactiveText;
      if (message.activeColor   !== undefined) widget.instance.activeColor   = message.activeColor;
      if (message.inactiveColor !== undefined) widget.instance.inactiveColor = message.inactiveColor;
      if (message.width         !== undefined) widget.instance.width         = message.width;
    }
  });
});
