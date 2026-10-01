// el-tree needs more than field assignment.
//
// Assigning default-checked-keys goes through Element's
// _initDefaultCheckedNodes(), which checks the keys it is given but never
// unchecks anything: sending a new selection left the previous one checked
// as well. Replacing it means calling the component's own setCheckedKeys().
// That method fires no check event, so the input is updated here to keep the
// server's view in step.
if (window.jQuery) jQuery(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElTree', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
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
