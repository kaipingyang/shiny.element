// Field updates for el-cascader; the shared updater in el-update.js validates
// each key against the component's Vue data before assigning it.
$(document).on('shiny:connected', function() {
  elRegisterUpdate('updateElCascader');
});
