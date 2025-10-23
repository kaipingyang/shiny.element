$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElTable', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.data !== undefined) widget.instance.tableData = message.data;
      if (message.columns !== undefined) widget.instance.columns = message.columns;
      if (message.border !== undefined) widget.instance.border = message.border;
      if (message.selection !== undefined) widget.instance.selection = message.selection;
    }
  });
});
