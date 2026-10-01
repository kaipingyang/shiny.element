if (typeof Shiny !== 'undefined' && Shiny.addCustomMessageHandler) {

// update_vue_component() and update_vue_data(). Nothing to do without Shiny.

Shiny.addCustomMessageHandler('update_vue_component', function(message) {
  var widget = HTMLWidgets.find('#' + message.id);
  if (widget && widget.instance) {
    Object.keys(message).forEach(function(key) {
      if (key !== 'id' && widget.instance.hasOwnProperty(key)) {
        widget.instance[key] = message[key];
      }
    });
    if (widget.instance._elReport) widget.instance._elReport();
  }
});

Shiny.addCustomMessageHandler('update_vue_data', function(message) {
  var widget = HTMLWidgets.find('#' + message.id);
  if (widget && widget.instance && message.data) {
    Object.assign(widget.instance.$data, message.data);
    if (widget.instance._elReport) widget.instance._elReport();
  }
});

}
