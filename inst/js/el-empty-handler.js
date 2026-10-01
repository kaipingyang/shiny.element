// Field updates for el-empty; the shared updater in el-update.js validates
// each key against the component's Vue data before assigning it.
if (window.jQuery) jQuery(document).on('shiny:connected', function() {
  elRegisterUpdate('updateElEmpty');
});
