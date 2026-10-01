// Handlers for el_notification and el_message server-side functions
if (window.jQuery) jQuery(document).on('shiny:connected', function() {

  // Instances opened under an id, so el_*_close() can close one of them
  var notifications = {}, messages = {};

  function clean(opts) {
    Object.keys(opts).forEach(function(k) {
      if (opts[k] === undefined || opts[k] === null) delete opts[k];
    });
    return opts;
  }

  // A function sent from R arrives as its source text
  function fn(src) {
    return typeof src === 'string' ? eval('(' + src + ')') : undefined;
  }

  function report(id, what) {
    if (id) Shiny.setInputValue(id + what, true, { priority: 'event' });
  }

  Shiny.addCustomMessageHandler('elNotification', function(message) {
    if (!window.ELEMENT || !window.ELEMENT.Notification) return;
    var id = message.id;
    var n = window.ELEMENT.Notification(clean({
      title:     message.title    || '',
      message:   message.message,
      type:      message.type     || 'info',
      duration:  message.duration !== undefined ? message.duration : 4500,
      position:  message.position || 'top-right',
      showClose: message.showClose !== undefined ? message.showClose : true,
      offset:    message.offset   || 0,
      iconClass: message.iconClass,
      customClass: message.customClass,
      dangerouslyUseHTMLString: message.dangerouslyUseHTMLString,
      onClose:   function() { if (id) delete notifications[id]; report(id, '_close'); },
      onClick:   function() { report(id, '_click'); }
    }));
    if (id) notifications[id] = n;
  });

  Shiny.addCustomMessageHandler('elNotificationClose', function(message) {
    if (!window.ELEMENT) return;
    if (message.id) {
      if (notifications[message.id]) notifications[message.id].close();
    } else {
      window.ELEMENT.Notification.closeAll();
    }
  });

  Shiny.addCustomMessageHandler('elMessageClose', function(message) {
    if (!window.ELEMENT) return;
    if (message.id) {
      if (messages[message.id]) messages[message.id].close();
    } else {
      window.ELEMENT.Message.closeAll();
    }
  });

  // MessageBox answers asynchronously: the promise resolves on confirm and
  // rejects on cancel or close. Both arrive as input$<id>, so an observeEvent
  // sees "confirm", "cancel" or "close" rather than nothing at all.
  Shiny.addCustomMessageHandler('elMessageBox', function(message) {
    if (!window.ELEMENT || !window.ELEMENT.MessageBox) return;

    var opts = {
      title:                    message.title || '',
      type:                     message.type || '',
      confirmButtonText:        message.confirmButtonText,
      cancelButtonText:         message.cancelButtonText,
      showCancelButton:         message.showCancelButton,
      showClose:                message.showClose,
      dangerouslyUseHTMLString: message.dangerouslyUseHTMLString || false,
      center:                   message.center || false,
      roundButton:              message.roundButton || false,
      customClass:              message.customClass,
      iconClass:                message.iconClass,
      closeOnClickModal:        message.closeOnClickModal,
      closeOnPressEscape:       message.closeOnPressEscape,
      inputPlaceholder:         message.inputPlaceholder,
      inputValue:               message.inputValue,
      inputPattern:             message.inputPattern ? new RegExp(message.inputPattern) : undefined,
      inputErrorMessage:        message.inputErrorMessage,
      inputType:                message.inputType,
      inputValidator:           fn(message.inputValidator),
      showInput:                message.showInput,
      showConfirmButton:        message.showConfirmButton,
      confirmButtonClass:       message.confirmButtonClass,
      cancelButtonClass:        message.cancelButtonClass,
      distinguishCancelAndClose: message.distinguishCancelAndClose,
      lockScroll:               message.lockScroll,
      closeOnHashChange:        message.closeOnHashChange,
      beforeClose:              fn(message.beforeClose)
    };
    Object.keys(opts).forEach(function(k) {
      if (opts[k] === undefined || opts[k] === null) delete opts[k];
    });

    var box = message.boxType === 'prompt'
      ? window.ELEMENT.MessageBox.prompt(message.message, message.title, opts)
      : message.boxType === 'alert'
        ? window.ELEMENT.MessageBox.alert(message.message, message.title, opts)
        : window.ELEMENT.MessageBox.confirm(message.message, message.title, opts);

    function report(action, value) {
      Shiny.setInputValue(message.id,
        value === undefined ? action : { action: action, value: value },
        { priority: 'event' });
    }
    box.then(function(res) {
      report('confirm', res && res.value !== undefined ? res.value : undefined);
    }).catch(function(reason) {
      report(reason === 'cancel' ? 'cancel' : 'close');
    });
  });

  // v-loading as an imperative service: one mask per id, closed by name.
  var loadings = {};
  Shiny.addCustomMessageHandler('elLoading', function(message) {
    if (!window.ELEMENT || !window.ELEMENT.Loading) return;

    if (message.close) {
      if (loadings[message.id]) {
        loadings[message.id].close();
        delete loadings[message.id];
      }
      return;
    }

    if (loadings[message.id]) loadings[message.id].close();
    var opts = {
      target:      message.target || document.body,
      body:        message.body,
      fullscreen:  message.fullscreen,
      lock:        message.lock,
      text:        message.text,
      spinner:     message.spinner,
      background:  message.background,
      customClass: message.customClass
    };
    Object.keys(opts).forEach(function(k) {
      if (opts[k] === undefined || opts[k] === null) delete opts[k];
    });
    loadings[message.id] = window.ELEMENT.Loading.service(opts);
  });

  Shiny.addCustomMessageHandler('elMessage', function(message) {
    if (!window.ELEMENT || !window.ELEMENT.Message) return;
    var id = message.id;
    var m = window.ELEMENT.Message(clean({
      message:   message.message,
      type:      message.type      || 'info',
      duration:  message.duration  !== undefined ? message.duration : 3000,
      showClose: message.showClose || false,
      center:    message.center    || false,
      offset:    message.offset,
      iconClass: message.iconClass,
      customClass: message.customClass,
      dangerouslyUseHTMLString: message.dangerouslyUseHTMLString,
      onClose:   function() { if (id) delete messages[id]; report(id, '_close'); }
    }));
    if (id) messages[id] = m;
  });

});
