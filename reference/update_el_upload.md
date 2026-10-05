# Update an Element Plus Upload

Update an Element Plus Upload

## Usage

``` r
update_el_upload(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL,
  limit = NULL,
  label = NULL,
  error = NULL,
  button_label = NULL,
  drag = NULL,
  multiple = NULL,
  accept = NULL,
  show_file_list = NULL,
  list_type = NULL,
  auto_upload = NULL,
  headers = NULL,
  extra_data = NULL,
  file_list = NULL,
  with_credentials = NULL,
  before_upload = NULL,
  before_remove = NULL,
  on_change = NULL,
  on_progress = NULL,
  on_preview = NULL,
  on_remove = NULL,
  on_exceed = NULL,
  crossorigin = NULL,
  directory = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Upload ID (un-namespaced).

- disabled:

  New disabled state.

- limit:

  New maximum number of files.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

- button_label:

  Text for the trigger, as `buttonLabel` is for
  [`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html):
  on the button when `drag = FALSE`, inside the drop zone otherwise.

- drag:

  Render a drop zone rather than a button.

- multiple:

  Allow selecting several files at once.

- accept:

  File types to accept, as an `accept` attribute would have them, e.g.
  `".csv,.tsv"` or `"image/*"`.

- show_file_list:

  Show the list of chosen files.

- list_type:

  `"text"` (default), `"picture"` or `"picture-card"`.

- auto_upload:

  Start uploading as soon as files are chosen.

- headers:

  Request headers, as a named list.

- extra_data:

  Extra fields sent alongside the file, as a named list.

- file_list:

  Files shown initially, each `list(name=, url=)`.

- with_credentials:

  Whether to send cookies with the request.

- before_upload:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function called before a file is sent; returning `false` cancels it.

- before_remove:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function called before a file is removed; returning `false` cancels
  it.

- on_change:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function called when a file is added, or finishes.

- on_progress:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function called as a file uploads.

- on_preview:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function called when an uploaded file is clicked.

- on_remove:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function called after a file is removed.

- on_exceed:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function called when more files are picked than `limit`.

- crossorigin:

  Native attribute crossorigin. Element Plus's `crossorigin` (” \|
  'anonymous' \| 'use-credentials').

- directory:

  Whether to support uploading directory. After enabling it, only
  folders can be selected, and after selecting a folder, the files
  within the folder will be flattened. Element Plus's `directory`
  (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_upload()`](https://kaipingyang.github.io/shiny.element/reference/el_upload.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_upload(session, "files", disabled = TRUE)
  })
}
```
