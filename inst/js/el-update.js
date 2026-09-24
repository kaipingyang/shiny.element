// Shared updater for the components whose server-side update is nothing but
// field assignment.
//
// Hand-writing one `if (message.x !== undefined) instance.x = message.x` per
// field let two classes of bug through without a sound:
//
//   * assigning a field the component never declared. el-table's handler set
//     instance.columns, .border and .selection, none of which were in its Vue
//     data -- Vue 2 does not track undeclared fields, so those writes could
//     never have taken effect.
//   * a handler file that was never loaded at all. el_cascader attached the
//     button's dependency, so every updateElCascader message went unheard.
//
// Checking each key against $data turns the first into a console warning
// instead of a silent no-op, and a missing widget into a warning rather than
// nothing happening.
(function() {
  'use strict';

  window.elRegisterUpdate = function(messageType) {
    Shiny.addCustomMessageHandler(messageType, function(message) {
      var widget = HTMLWidgets.find('#' + message.id);
      if (!widget || !widget.instance) {
        console.warn('[shiny.element] ' + messageType +
                     ': no mounted widget with id "' + message.id + '"');
        return;
      }

      var vm = widget.instance;
      Object.keys(message).forEach(function(key) {
        if (key === 'id') return;
        if (!(key in vm.$data)) {
          console.warn('[shiny.element] ' + messageType + ': "' + key +
                       '" is not a field of widget "' + message.id +
                       '"; the update was ignored');
          return;
        }
        vm[key] = message[key];
      });
    });
  };
})();
