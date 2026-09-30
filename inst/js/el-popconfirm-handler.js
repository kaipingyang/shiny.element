// Field updates for el-popconfirm; the shared updater in el-update.js
// validates each key against the Vue data before assigning it.
$(document).on('shiny:connected', function() {
  elRegisterUpdate('updateElPopconfirm');
});
