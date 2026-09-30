// Call a method on the Element component a widget wraps.
//
// update_el_*() assigns into the Vue instance's `data`, which covers props but
// not methods: clearSelection(), setCheckedKeys() and validate() live on the
// Element component itself. That component is a child of the instance
// htmlwidgets hands back, not the instance itself.
//
// A method with a return value sends it to input$<id>_<method>, with the name
// in snake_case to match how events are reported. Promises are awaited, so
// el-form's validate() -- which returns one when called without a callback --
// arrives the same way.
(function () {
  'use strict';

  // Reject anything that could reach beyond the component's own methods.
  var SAFE_NAME = /^[A-Za-z][A-Za-z0-9_]*$/;

  function componentOf(vm, name) {
    if (vm.$refs && vm.$refs.el) return vm.$refs.el;

    var found = null;
    (function walk(node, depth) {
      if (found || depth > 4 || !node.$children) return;
      for (var i = 0; i < node.$children.length; i++) {
        var child = node.$children[i];
        var childName = (child.$options || {}).name;
        if (!name || childName === name) { found = child; return; }
        walk(child, depth + 1);
      }
      // No match at this level -- go deeper before giving up
      for (var j = 0; j < node.$children.length && !found; j++) {
        walk(node.$children[j], depth + 1);
      }
    })(vm, 0);

    return found || (vm.$children || [])[0] || null;
  }

  function report(id, input, value) {
    if (!input || typeof Shiny === 'undefined' || !Shiny.setInputValue) return;
    var plain = (window.shinyElement && window.shinyElement.plain) ||
                function (x) { return x; };
    Shiny.setInputValue(input, plain(value), { priority: 'event' });
  }

  // One handler serves every component, so it registers itself rather than
  // being called from each component's handler file the way elRegisterUpdate
  // is -- that one needs a call per component because the message type
  // differs.
  var registered = false;

  function register() {
    if (registered || typeof Shiny === 'undefined') return;
    registered = true;

    Shiny.addCustomMessageHandler('elInvoke', function (message) {
      var widget = HTMLWidgets.find('#' + message.id);
      if (!widget || !widget.instance) {
        console.warn('[shiny.element] elInvoke: no mounted widget with id "' +
                     message.id + '"');
        return;
      }

      if (!SAFE_NAME.test(message.method)) {
        console.warn('[shiny.element] elInvoke: refusing method name "' +
                     message.method + '"');
        return;
      }

      var target = componentOf(widget.instance, message.component);
      if (!target) {
        console.warn('[shiny.element] elInvoke: no Element component under "' +
                     message.id + '"');
        return;
      }

      var fn = target[message.method];
      if (typeof fn !== 'function') {
        console.warn('[shiny.element] elInvoke: "' + message.method +
                     '" is not a method of the component behind "' +
                     message.id + '"');
        return;
      }

      var args = message.args || [];
      if (!Array.isArray(args)) args = [args];

      var result;
      try {
        result = fn.apply(target, args);
      } catch (e) {
        console.warn('[shiny.element] elInvoke: ' + message.method +
                     '() raised: ' + e.message);
        return;
      }

      if (!message.input) return;
      if (result && typeof result.then === 'function') {
        result.then(
          function (v) { report(message.id, message.input, v === undefined ? true : v); },
          // el-form's validate() rejects when the form is invalid
          function () { report(message.id, message.input, false); }
        );
      } else {
        report(message.id, message.input, result === undefined ? true : result);
      }
    });
  }

  if (typeof $ !== 'undefined') {
    $(document).on('shiny:connected', register);
  }
})();
