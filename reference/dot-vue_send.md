# Send a message to the components, with the flush

Shiny's own `update*Input()` queue their messages and send them with the
flush, after the outputs it recalculated (`sendInputMessage()`), as DT's
and leaflet's proxies do (`deferUntilFlush`). Updates and method calls
do the same: queued per session and sent once the flush is done, so a
component re-rendered and updated in one observer is updated after it is
drawn. A flush is requested, for a call from outside one – a `later()`
callback.
[`flush_vue()`](https://kaipingyang.github.io/shiny.element/reference/flush_vue.md)
sends what is queued at once; a session without
[`onFlushed()`](https://rdrr.io/pkg/shiny/man/onFlush.html) (a test's
mock) is sent to at once.

## Usage

``` r
.vue_send(session, type, msg, immediate = FALSE)
```

## Arguments

- session:

  A Shiny session.

- type:

  The custom message's type.

- msg:

  The message.

- immediate:

  Send now: a progress, a feedback service.

## Value

`NULL`, invisibly.
