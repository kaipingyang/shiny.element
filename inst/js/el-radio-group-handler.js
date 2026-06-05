// Handler for updating el_radio_group component
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElRadioGroup', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.value    !== undefined) widget.instance.value    = message.value;
      if (message.options  !== undefined) widget.instance.options  = message.options;
      if (message.disabled !== undefined) widget.instance.disabled = message.disabled;
    }
  });
});
