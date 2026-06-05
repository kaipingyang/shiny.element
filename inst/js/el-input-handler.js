$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElInput', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.value !== undefined)        widget.instance.value        = message.value;
      if (message.placeholder !== undefined)  widget.instance.placeholder  = message.placeholder;
      if (message.disabled !== undefined)     widget.instance.disabled     = message.disabled;
      if (message.readonly !== undefined)     widget.instance.readonly     = message.readonly;
      if (message.type !== undefined)         widget.instance.type         = message.type;
      if (message.size !== undefined)         widget.instance.size         = message.size;
      if (message.clearable !== undefined)    widget.instance.clearable    = message.clearable;
      if (message.showPassword !== undefined) widget.instance.showPassword = message.showPassword;
    }
  });
});
