# Tally delimited string

Expand a delimited string column into columns that tally each instance
of every observed delimited value.

## Usage

``` r
tally_delimited_string(
  x,
  col,
  delim = ",",
  count = FALSE,
  names_repair = TRUE,
  squish = TRUE,
  names_prefix = NULL,
  ignore = c(NA, ""),
  keep = NULL,
  other_suffix = "other",
  other_tally_suffix = "n_other"
)
```

## Arguments

- x:

  A data-frame, tibble or similar

- col:

  The character column to tally

- delim:

  The delimiter that separates elements of the string column, passed to
  [separate_longer_delim](https://tidyr.tidyverse.org/reference/separate_longer_delim.html).
  A fixed string by default, use
  [regex](https://stringr.tidyverse.org/reference/modifiers.html) to
  split in other ways.

- count:

  TRUE/FALSE. Should items in strings be counted or just marked as
  present/missing? These options respectively result in new columns
  being integer or logical type.

- names_repair:

  A logical indicating whether or not to repair new column names with
  [make_clean_names](https://sfirke.github.io/janitor/reference/make_clean_names.html),
  or an alternative function for name repair. Names are repaired prior
  to prefixing.

- squish:

  Should delimited elements be 'squished' with
  [str_squish](https://stringr.tidyverse.org/reference/str_trim.html)?

- names_prefix:

  Prefix for names of new columns. If NULL (the default), the name of
  `col` is used.

- ignore:

  Values within string column to ignore. The defaults result in expected
  behaviour.

- keep:

  A character vector of delineated items to tally. Ignored if `NULL`
  (the default). Values outside of these are concatenated into a single
  string and reported in a separate column.

- other_suffix:

  The prefix with which to name the column containing concatenated
  strings of all values not in `keep` when `keep` is not `NULL`. If this
  argument is set to `NA`, the column is dropped.

- other_tally_suffix:

  The prefix with which to name the column containing the count of all
  the values not in `keep` when `keep` is not `NULL`. If this argument
  is set to `NA`, the column is dropped

## Value

A data-frame-like object of the same type as `x`

## Examples

``` r
df <- data.frame(name = c("anna", "betty"),
              fruits = c("apple, banana", "pear, banana, banana"))

tally_delimited_string(df, fruits)
#>    name fruits_apple fruits_banana fruits_pear
#> 1  anna         TRUE          TRUE       FALSE
#> 2 betty        FALSE          TRUE        TRUE

tally_delimited_string(df, fruits, count = TRUE)
#>    name fruits_apple fruits_banana fruits_pear
#> 1  anna            1             1           0
#> 2 betty            0             2           1

tally_delimited_string(df, fruits, count = TRUE, names_repair = toupper)
#>    name fruits_APPLE fruits_BANANA fruits_PEAR
#> 1  anna            1             1           0
#> 2 betty            0             2           1

tally_delimited_string(df, fruits, keep = c("apple", "banana"))
#>    name fruits_apple fruits_banana fruits_other fruits_n_other
#> 1  anna         TRUE          TRUE         <NA>              0
#> 2 betty        FALSE          TRUE         pear              1
```
