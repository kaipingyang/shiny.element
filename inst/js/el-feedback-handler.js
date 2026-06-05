// Handlers for el_notification and el_message server-side functions
$(document).on('shiny:connected', function() {

  Shiny.addCustomMessageHandler('elNotification', function(message) {
    if (window.ELEMENT && window.ELEMENT.Notification) {
      window.ELEMENT.Notification({
        title:     message.title    || '',
        message:   message.message,
        type:      message.type     || 'info',
        duration:  message.duration !== undefined ? message.duration : 4500,
        position:  message.position || 'top-right',
        showClose: message.showClose !== undefined ? message.showClose : true,
        offset:    message.offset   || 0
      });
    }
  });

  Shiny.addCustomMessageHandler('elMessage', function(message) {
    if (window.ELEMENT && window.ELEMENT.Message) {
      window.ELEMENT.Message({
        message:   message.message,
        type:      message.type      || 'info',
        duration:  message.duration  !== undefined ? message.duration : 3000,
        showClose: message.showClose || false,
        center:    message.center    || false
      });
    }
  });

});
