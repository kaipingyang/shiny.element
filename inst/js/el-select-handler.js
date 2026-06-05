// Handler for updating el_select component
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElSelect', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.value       !== undefined) widget.instance.value       = message.value;
      if (message.options     !== undefined) widget.instance.options     = message.options;
      if (message.disabled    !== undefined) widget.instance.disabled    = message.disabled;
      if (message.placeholder !== undefined) widget.instance.placeholder = message.placeholder;
      if (message.clearable   !== undefined) widget.instance.clearable   = message.clearable;
      if (message.filterable  !== undefined) widget.instance.filterable  = message.filterable;
    }
  });
});
