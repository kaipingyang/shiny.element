# Element's own stylesheet, themed

Element compiles its look from Sass variables (`theme-chalk`'s
`common/var.scss`): `$--color-primary`, `$--border-radius-base`,
`$--font-size-base` and some five hundred more. A page whose theme
changes any of them gets Element's stylesheet built for it, served under
Element's own name at a later version, so it replaces – rather than
joins – the copy every component brings.

## Details

Two ways to build it, as upstream has two:

- Only the brand colours changed – primary, success, warning, danger –
  the shipped stylesheet is recoloured in place, as Element's own theme
  picker does: each colour's eleven values (itself, nine tints, one
  shade) replaced. Instant, and byte for byte what Element's build would
  give.

- Anything else – `info`, radii, sizes, fonts – the bundled Sass sources
  are compiled with the variables set, as Element's theme tool does, by
  the sass package bslib already uses. About a second, once per theme
  and R session.
