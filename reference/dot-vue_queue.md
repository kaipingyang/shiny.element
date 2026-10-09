# A session's queue of messages for the components

One per session, in its `userData`, which a module's session shares with
the session it belongs to – so messages from both keep their order.

## Usage

``` r
.vue_queue(session)
```

## Arguments

- session:

  A Shiny session.

## Value

An environment, or `NULL` for a session that cannot hold one until the
flush.
