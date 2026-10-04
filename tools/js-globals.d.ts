// The browser globals inst/js/*.js runs among, for editors and the
// TypeScript language server: Shiny and jQuery from the page, Vue and
// Element Plus from the bundled scripts, and the bridge's own objects.
// Not shipped (tools/ is in .Rbuildignore).

declare const Shiny: any;
declare const jQuery: any;
declare const $: any;
declare const Vue: any;
declare const ElementPlus: any;

interface Window {
  Shiny: any;
  jQuery: any;
  Vue: any;
  ElementPlus: any;
  ElementPlusIconsVue: Record<string, any>;
  ELEMENT: any;
  shinyVue: any;
  shinyElement: any;
  shinyElementConfig: { locale?: any; size?: string; zIndex?: number };
}

// The bindings keep their state on the elements they drive, under _el*
interface Element {
  [key: `_el${string}`]: any;
}
