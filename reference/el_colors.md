# Element's colours, recoloured

Element compiles its colours into its stylesheet: each of primary,
success, warning and danger as itself, nine tints towards white and one
shade towards black. Element's own site changes the theme colour by
replacing those eleven values in the stylesheet's text (its theme
picker); this does the same, once, in R, and serves the result in place
of Element's.

## Details

Only these four are recoloured. Element's `info` grey is the same value
as its secondary text colour, `#909399`, and the two cannot be told
apart once compiled – recolouring one would recolour every hint and
placeholder.
