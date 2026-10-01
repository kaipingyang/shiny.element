// Field updates for el-input-number; the shared updater in el-update.js validates
// each key against the component's Vue data before assigning it.
if (window.jQuery) jQuery(document).on('shiny:connected', function() {
  elRegisterUpdate('updateElInputNumber');
});
