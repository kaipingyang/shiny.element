// Handler for updating el_pagination component
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElPagination', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.total       !== undefined) widget.instance.total       = message.total;
      if (message.currentPage !== undefined) widget.instance.currentPage = message.currentPage;
      if (message.pageSize    !== undefined) widget.instance.pageSize    = message.pageSize;
      if (message.disabled    !== undefined) widget.instance.disabled    = message.disabled;
    }
  });
});
