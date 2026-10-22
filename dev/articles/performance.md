# Performance

A page of Element components takes longer to start than a page of
Shiny’s own inputs. This article says where the time goes, what the
package does about it, and the settings that make a page of many
components start faster. The numbers were measured on a shared server
(four CPUs, headless Chrome); a desktop is faster, but the proportions
hold.

## Where the time goes

Starting a page has three parts:

1.  **The server writes the page.** Each component is turned into its
    template and its options (JSON). The first page of a new R process
    also draws the page’s Bootstrap theme.
2.  **The browser loads the libraries**: Vue and Element Plus, about 620
    KB, where a plain Shiny page loads about 240 KB.
3.  **The browser draws each component.** Every component is a Vue
    application of its own: its template is compiled and Element renders
    it. This is the part that grows with the number of components.

| Page                   | All components drawn |
|------------------------|----------------------|
| 100 Shiny inputs       | 1.5 s                |
| 5 Element components   | 2.9 s                |
| 100 Element components | 3.9 s                |
| 300 Element components | 5.7 s                |

Most of the third part is Element rendering its own components, not Vue:
300 `el-select`s drawn by one Vue application take 3.2 s, by 300
applications 3.4 to 3.9 s. Some components cost far more than others
(per component, in the browser):

| Component | Time |
|----|----|
| [`el_input()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_input.md) | 0.5 ms |
| [`el_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select.md) | 11 ms |
| [`el_cascader()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_cascader.md) | 8 ms |
| [`el_tree_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tree_select.md) | 14 ms |
| [`el_date_picker()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_date_picker.md) | 14 ms |
| [`el_dropdown()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_dropdown.md) | 8 ms |
| [`el_popover()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_popover.md) | 4 ms |

## What the package does

- **The theme is drawn once per machine.** bslib compiles a page’s theme
  in every new R process;
  [`el_page()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_page.md)
  takes it from sass’s cache instead, and the default
  [`el_theme()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_theme.md)
  is shipped compiled, so even a machine that never drew it does not
  compile it. The first page of a new process takes about 0.3 s to
  write, as a plain Shiny page with a bslib theme does.
- **Each component is written in about 6 ms**: its dependencies are made
  once per session and its options written by a JSON writer in C.
- **[`el_page()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_page.md)
  shows Element’s loading mask** until every component is drawn and
  Shiny is connected, rather than a page that is not yet usable.
  `el_page(loading = FALSE)` leaves it out.

## Components drawn later, by `renderUI()`

The loading mask covers the page as it opens. A
[`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) whose
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) draws many
components later goes through the same two parts, on its own:

| [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) drawing | Server done | Components drawn |
|----|----|----|
| 20 [`el_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select.md)s | 1.0 s | 1.4 s |
| 100 [`el_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select.md)s | 2.1 s | 3.7 s |
| 300 [`el_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select.md)s | 4.5 s | 9.1 s |

While the server computes, Shiny marks the output as recalculating (it
fades). Shiny’s busy indicators show a spinner in the output instead –
in the output only, not over the page:

``` r

el_page(
  shiny::useBusyIndicators(),
  uiOutput("area")
)
```

While the browser then draws the components, it can draw nothing else: a
spinner stops turning until the last one is drawn. Draw fewer at once –
`persistent = FALSE` below, or a virtual list – rather than more.

## Drawing less at first

Element renders some parts of a component before they are needed, and
offers options to render them only when they are. The package keeps
Element’s defaults; set these where a page has many components.

### Dropdowns drawn when opened: `persistent = FALSE`

A component with a dropdown or a popup renders it when the page loads,
hidden, so that it opens at once (`persistent = TRUE`, Element’s
default). With `persistent = FALSE` it is rendered the first time it
opens – a few milliseconds then – and removed when it closes. For 100
components:

| Component | `persistent = TRUE` (default) | `persistent = FALSE` |
|----|----|----|
| [`el_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select.md) | 1.1 s | 0.18 s |
| [`el_tree_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tree_select.md) | 1.4 s | 0.25 s |
| [`el_cascader()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_cascader.md) | 0.8 s | 0.18 s |
| [`el_color_picker()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_color_picker.md) | 0.65 s | 0.15 s |
| [`el_dropdown()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_dropdown.md) | 0.8 s | 0.10 s |
| [`el_popover()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_popover.md) | 0.4 s | 0.06 s |
| [`el_tooltip()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tooltip.md) | 0.04 s | 0.04 s |

`persistent` is an argument of
[`el_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select.md),
[`el_select_v2()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select_v2.md),
[`el_tree_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tree_select.md),
[`el_cascader()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_cascader.md),
[`el_color_picker()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_color_picker.md),
[`el_dropdown()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_dropdown.md),
[`el_menu()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_menu.md),
[`el_popconfirm()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_popconfirm.md),
[`el_popover()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_popover.md),
[`el_slider()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_slider.md)
and
[`el_tooltip()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tooltip.md).
[`el_date_picker()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_date_picker.md)
has no such option.

``` r

el_select("city", choices = cities, persistent = FALSE)
```

### Content drawn when needed

| Option | Components | What it does |
|----|----|----|
| `render_after_expand` | [`el_tree()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tree.md), [`el_tree_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tree_select.md) | renders a node’s children when it is expanded (on by default) |
| `lazy` with the server loading | [`el_tree()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tree.md), [`el_cascader()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_cascader.md), [`el_table()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table.md) (tree rows) | asks the server for a level when it is opened: see [`el_load_children()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_load_children.md) |
| `lazy` | [`el_image()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_image.md) | loads the picture when it scrolls into view |
| `destroy_on_close` | [`el_dialog()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_dialog.md), [`el_drawer()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_drawer.md) | removes the content when closed |

### Long lists: virtual scrolling

These render only the rows in view, so ten thousand rows cost as little
as a screenful:

- [`el_select_v2()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select_v2.md)
  instead of
  [`el_select()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_select.md);
- [`el_table_v2()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table_v2.md)
  instead of
  [`el_table()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_table.md);
- [`el_tree_v2()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tree_v2.md)
  instead of
  [`el_tree()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tree.md);
- `el_cascader(virtual_scroll = TRUE)`,
  `el_transfer(virtual_scroll = TRUE)`.

## Deploying an app with its own theme

A theme of your own is compiled once on each machine, then taken from
sass’s cache. On a server – Posit Connect, shinyapps.io – sass keeps
that cache in the app’s directory, `app_cache/sass`, when it exists. Run
the app once locally with that directory created, and deploy it with the
app:

``` r

dir.create("app_cache/sass", recursive = TRUE)
shiny::runApp() # draws the theme once into app_cache/sass
# then deploy, app_cache/ included
```

The default
[`el_theme()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_theme.md)
needs none of this: the package ships it compiled.
