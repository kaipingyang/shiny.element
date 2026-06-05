// Handler for updating el_tabs component
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElTabs', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.activeTab !== undefined) widget.instance.activeTab = message.activeTab;
    }
  });
});
