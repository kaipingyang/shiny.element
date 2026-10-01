// el-tree needs more than field assignment.
//
// Assigning default-checked-keys goes through Element's
// _initDefaultCheckedNodes(), which checks the keys it is given but never
// unchecks anything: sending a new selection left the previous one checked
// as well. Replacing it means calling the component's own setCheckedKeys().
// That method fires no check event, so the input is updated here to keep the
// server's view in step.
// Registered at once when Shiny is already on the page. Waiting for
// shiny:connected missed every script that arrives later -- through
// renderUI() or insertUI() -- after that event has fired, so a component
// rendered there never heard its update_el_*().
(function(register) {
  if (window.Shiny && Shiny.addCustomMessageHandler) register();
  else if (window.jQuery) jQuery(document).one('shiny:connected', register);
})(function() {
  Shiny.addCustomMessageHandler('updateElTree', function(message) {
    var widget = (window.shinyElement && shinyElement.find(message.id));
    if (!widget || !widget.instance) {
      console.warn('[shiny.element] updateElTree: no mounted widget with id "' +
                   message.id + '"');
      return;
    }
    var vm = widget.instance;

    // Watched props: assigning them is enough.
    if (message.treeData !== undefined)     vm.treeData     = message.treeData;
    if (message.expandedKeys !== undefined) vm.expandedKeys = message.expandedKeys;

    if (message.checkedKeys !== undefined) {
      var keys = message.checkedKeys || [];
      if (vm.$refs.tree) {
        vm.$refs.tree.setCheckedKeys(keys);
      }
      vm.checked = keys;
      Shiny.setInputValue(message.id + '_checked', keys);
    }
  });
});
