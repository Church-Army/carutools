# carutools

<!-- badges: start -->
[![R-CMD-check](https://github.com/church-army/carutools/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/church-army/carutools/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

carutools is an R package that provides helpful tools for use by Church Army's Research Unit.

## Colours and scales

Carutools makes Church Army brand colours available via simple functions (e.g. `ca_cyan()`). It also includes a number of (not fantastic) `ggplot()` scale functions, which are wrappers around default scales that use Church Army colours (and pallettes) by default).

## Miscellaneous

Carutools also contains simple, miscellaneous functions that have proved useful to CARU researchers at one time or another. These are:

### `tally_delimited_string` 

Expands data-frame columns comprised of delimited strings into multiple columns, with the option of couting instances of each unique item.