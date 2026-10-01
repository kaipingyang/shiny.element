// el-carousel needs more than field assignment for the active slide.
//
// `initial-index` is read once when the carousel mounts and has no watcher,
// so assigning it moves nothing. setActiveItem() is the component's own way
// to change slides, and it fires @change, which reports the new index back.
// Registered at once when Shiny is already on the page. Waiting for
// shiny:connected missed every script that arrives later -- through
// renderUI() or insertUI() -- after that event has fired, so a component
// rendered there never heard its update_el_*().
(function(register) {
  if (window.Shiny && Shiny.addCustomMessageHandler) register();
  else if (window.jQuery) jQuery(document).one('shiny:connected', register);
})(function() {
  Shiny.addCustomMessageHandler('updateElCarousel', function(message) {
    var widget = (window.shinyElement && shinyElement.find(message.id));
    if (!widget || !widget.instance) {
      console.warn('[shiny.element] updateElCarousel: no mounted widget with id "' +
                   message.id + '"');
      return;
    }
    var vm = widget.instance;

    if (message.autoplay !== undefined) vm.autoplay = message.autoplay;
    if (message.interval !== undefined) vm.interval = message.interval;

    if (message.active !== undefined && vm.$refs.carousel) {
      vm.$refs.carousel.setActiveItem(message.active);
    }
  });
});
