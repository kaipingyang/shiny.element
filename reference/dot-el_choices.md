# The values Element accepts for its enumerated props

Read from Element 2.15.14's documentation ("Accepted Values") and
checked against its source and stylesheet, which the documentation does
not always match – `tools/el-choices.py` lists the candidates. Where
they differ the union is kept, so nothing Element renders is refused:

## Usage

``` r
.el_choices
```

## Details

- `el-button` and `el-link` default `type` to `"default"`, which the
  documentation omits.

- `el-select` and `el-date-picker` document `large | small | mini`, but
  hand `size` to `el-input`, whose stylesheet has
  `medium | small | mini`.

- `el-input-number` documents `large | small`; its stylesheet has all
  four.

- `el-avatar`'s `size` is also a number of pixels.

- `el-input`'s `autocomplete` is not checked: the documentation lists
  `on | off`, but HTML takes `email`, `new-password` and many more.
