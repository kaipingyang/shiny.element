// Handlers for el_form(). The form owns its model, so these reach into the
// single Vue instance rather than touching individual controls.
// Registered at once when Shiny is already on the page. Waiting for
// shiny:connected missed every script that arrives later -- through
// renderUI() or insertUI() -- after that event has fired, so a component
// rendered there never heard its update_el_*().
(function(register) {
  if (window.Shiny && Shiny.addCustomMessageHandler) register();
  else if (window.jQuery) jQuery(document).one('shiny:connected', register);
})(function() {

  function formInstance(id) {
    var widget = (window.shinyElement && shinyElement.find(id));
    return widget && widget.instance ? widget.instance : null;
  }

  Shiny.addCustomMessageHandler('updateElForm', function(message) {
    var vm = formInstance(message.id);
    if (!vm) return;
    if (message.model !== undefined) {
      // Merged rather than replaced, so a partial model only touches the
      // fields it names. $set keeps new keys reactive.
      Object.keys(message.model).forEach(function(key) {
        vm.$set(vm.model, key, message.model[key]);
      });
    }
    if (message.rules !== undefined) vm.rules = message.rules;
    if (message.labelWidth !== undefined) vm.labelWidth = message.labelWidth;
    if (vm._elReport) vm._elReport();
  });

  Shiny.addCustomMessageHandler('elFormValidate', function(message) {
    var vm = formInstance(message.id);
    if (!vm || !vm.$refs.form) return;
    vm.$refs.form.validate(function(ok) {
      vm.submitCount++;
      vm.valid = ok;
      // Reported exactly as the submit button does, so one observeEvent
      // handles both paths.
      Shiny.setInputValue(message.id, vm.model);
      Shiny.setInputValue(message.id + '_valid', ok);
      Shiny.setInputValue(message.id + '_submit', vm.submitCount);
    });
  });

  Shiny.addCustomMessageHandler('elFormReset', function(message) {
    var vm = formInstance(message.id);
    if (!vm || !vm.$refs.form) return;
    vm.$refs.form.resetFields();
    Shiny.setInputValue(message.id, vm.model);
  });

  Shiny.addCustomMessageHandler('elFormClearValidate', function(message) {
    var vm = formInstance(message.id);
    if (!vm || !vm.$refs.form) return;
    vm.$refs.form.clearValidate(message.props || undefined);
  });
});
