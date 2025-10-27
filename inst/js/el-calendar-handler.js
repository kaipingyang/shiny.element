$(document).on('shiny:connected', function() {
  // 更新属性
  Shiny.addCustomMessageHandler('updateElCalendar', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.value !== undefined) widget.instance.value = message.value;
      if (message.range !== undefined) widget.instance.range = message.range;
      if (message.firstDayOfWeek !== undefined) widget.instance.firstDayOfWeek = message.firstDayOfWeek;
    }
  });
}); 
