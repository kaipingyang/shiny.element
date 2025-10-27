// inst/assets/vue_handlers.js

Shiny.addCustomMessageHandler('update_vue_component', function(message) {
  var widget = HTMLWidgets.find('#' + message.id);
  if (widget && widget.instance) {
    Object.keys(message).forEach(function(key) {
      if (key !== 'id' && widget.instance.hasOwnProperty(key)) {
        widget.instance[key] = message[key];
      }
    });
  }
});

Shiny.addCustomMessageHandler('update_vue_data', function(message) {
  var widget = HTMLWidgets.find('#' + message.id);
  if (widget && widget.instance && message.data) {
    Object.assign(widget.instance.$data, message.data);
  }
});