// Handler for updating el_steps component  
$(document).on('shiny:connected', function() {  
  Shiny.addCustomMessageHandler('updateElSteps', function(message) {  
    var widget = HTMLWidgets.find('#' + message.id);  
    if (widget && widget.instance) {  
      if (message.active !== undefined) widget.instance.active = message.active;  
      if (message.processStatus !== undefined) widget.instance.processStatus = message.processStatus;  
      if (message.finishStatus !== undefined) widget.instance.finishStatus = message.finishStatus;  
    }  
  });  
});