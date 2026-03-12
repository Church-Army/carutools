# Range labels

Create 'range labels' for grouping and tabulating a continuous variable

## Usage

``` r
range_labels(
  x,
  width,
  start = NA,
  sep = " - ",
  explicit_zero = TRUE,
  suffix = "",
  include = c("upper", "lower", "integer"),
  ordered = TRUE
)
```

## Arguments

- x:

  a numeric vector

- width:

  Desidered label width - numeric

- start:

  The number from which to start the lowest range label

- sep:

  The character used to separate values within each label

- explicit_zero:

  Logical; should zeroes have a label all to themselves? They do by
  default.

- suffix:

  Optional suffix to append to each label (e.g. "%")

- include:

  Which side of each range should be included. One of 'upper', 'lower'
  or 'integer' - the latter is a special case that deals exclusively
  with integer ranges and otherwise crashes.

- ordered:

  Logical; should output be an ordered factor?

## Value

A character vector of labels

## Examples

``` r
range_labels(c(1,3,4,1), width = 2)
#> [1] 1 - <3 3 - <5 3 - <5 1 - <3
#> Levels: 1 - <3 < 3 - <5
range_labels(1:7, width = 3, include = "lower", start = 0, explicit_zero = TRUE)
#> [1] >0 - 3 >0 - 3 >0 - 3 >3 - 6 >3 - 6 >3 - 6 >6 - 9
#> Levels: >-3 - 0 < >0 - 3 < >3 - 6 < >6 - 9
```
