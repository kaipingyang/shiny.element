# Check a server function was given a session

Every server function takes the session first, defaulting to the current
one, as Shiny's `update*Input()` do – so `update_el_input("name", ...)`
passes the id as the session. Shiny stops that with a message naming the
function; so does this, rather than failing on `$` inside.

## Usage

``` r
.el_check_session(session, fn = NULL)
```

## Arguments

- session:

  What was passed as `session`.

- fn:

  The calling function's name.

## Value

`session`, invisibly.
