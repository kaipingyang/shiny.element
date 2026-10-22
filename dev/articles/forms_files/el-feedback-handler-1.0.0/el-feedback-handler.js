// Handlers for el_notification and el_message server-side functions
// Registered at once when Shiny is already on the page. Waiting for
// shiny:connected missed every script that arrives later -- through
// renderUI() or insertUI() -- after that event has fired, so a component
// rendered there never heard its update_el_*().
(function(register) {
  if (window.Shiny && Shiny.addCustomMessageHandler) register();
  else if (window.jQuery) jQuery(document).one('shiny:connected', register);
})(function() {

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

  // The options Element Plus takes, as R sent them: everything but the
  // bridge's own keys, with functions turned back from source
  function options(message, skip) {
    var o = {};
    Object.keys(message).forEach(function(k) {
      if (k.charAt(0) === '.' || skip.indexOf(k) !== -1) return;
      if (message[k] !== null && message[k] !== undefined) o[k] = message[k];
    });
    (message['.functions'] || []).forEach(function(k) { if (o[k]) o[k] = fn(o[k]); });
    return o;
  }

  Shiny.addCustomMessageHandler('elNotification', function(message) {
    if (!window.ELEMENT || !window.ELEMENT.Notification) return;
    var id = message.id;
    var o = options(message, ['id']);
    o.onClose = function() { if (id) delete notifications[id]; report(id, '_close'); };
    o.onClick = function() { report(id, '_click'); };
    var n = window.ELEMENT.Notification(o);
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

    var opts = options(message, ['id', 'boxType', 'message', 'title']);
    if (opts.inputPattern) opts.inputPattern = new RegExp(opts.inputPattern);
    var text = (message['.functions'] || []).indexOf('message') !== -1
      ? fn(message.message) : message.message;

    var box = message.boxType === 'prompt'
      ? window.ELEMENT.MessageBox.prompt(text, message.title, opts)
      : message.boxType === 'alert'
        ? window.ELEMENT.MessageBox.alert(text, message.title, opts)
        : window.ELEMENT.MessageBox.confirm(text, message.title, opts);

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
    var id = message.id;
    var opts = options(message, ['id', 'close']);
    if (!opts.target) opts.target = document.body;
    opts.closed = function() { report(id, '_closed'); };
    loadings[message.id] = window.ELEMENT.Loading.service(opts);
  });

  Shiny.addCustomMessageHandler('elMessage', function(message) {
    if (!window.ELEMENT || !window.ELEMENT.Message) return;
    var id = message.id;
    var o = options(message, ['id']);
    o.onClose = function() { if (id) delete messages[id]; report(id, '_close'); };
    var m = window.ELEMENT.Message(o);
    if (id) messages[id] = m;
  });

});
