// Handler for updating el_slider component
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElSlider', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.value    !== undefined) widget.instance.value    = message.value;
      if (message.min      !== undefined) widget.instance.min      = message.min;
      if (message.max      !== undefined) widget.instance.max      = message.max;
      if (message.step     !== undefined) widget.instance.step     = message.step;
      if (message.disabled !== undefined) widget.instance.disabled = message.disabled;
    }
  });
});
