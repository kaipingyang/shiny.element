// Handler for updating el_date_picker component
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElDatePicker', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.value            !== undefined) widget.instance.value            = message.value;
      if (message.disabled         !== undefined) widget.instance.disabled         = message.disabled;
      if (message.type             !== undefined) widget.instance.type             = message.type;
      if (message.clearable        !== undefined) widget.instance.clearable        = message.clearable;
      if (message.readonly         !== undefined) widget.instance.readonly         = message.readonly;
      if (message.placeholder      !== undefined) widget.instance.placeholder      = message.placeholder;
      if (message.startPlaceholder !== undefined) widget.instance.startPlaceholder = message.startPlaceholder;
      if (message.endPlaceholder   !== undefined) widget.instance.endPlaceholder   = message.endPlaceholder;
    }
  });
});
