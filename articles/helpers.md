# helpers

``` r
library(carutools)
```

## Helper functions

The functions help with routine data processing tasks.

``` r
library(testthat)
```

### range_labels()

[`range_labels()`](https://church-army.github.io/carutools/reference/range_labels.md)
bins the elements of a numeric vector into bins of a specified width,
and returns an ordered factor whose labels describe the corresponding
bin. It’s useful for making bar plots of binned values. In short, it
turns `1, 2, 3,` into `"1 - 2", "1 - 2", "3 - 4"`.

``` r
range_labels(c(1,3,4,1), width = 2)
#> [1] 1 - <3 3 - <5 3 - <5 1 - <3
#> Levels: 1 - <3 < 3 - <5
range_labels(1:7, width = 3, include = "lower", start = 0, explicit_zero = TRUE)
#> [1] >0 - 3 >0 - 3 >0 - 3 >3 - 6 >3 - 6 >3 - 6 >6 - 9
#> Levels: >-3 - 0 < >0 - 3 < >3 - 6 < >6 - 9
```

### relabeller()

Creates a function that wraps around `dplry::case_match()` in order to
swap specified elements of a character vector. Designed to be passed to
the `labels` argument of `ggplot`s `scale_*_discrete()`.

``` r
fruits <- c("apple", "pear", "pear", "banana")

fruit_relabel <- relabeller("pear" ~ "orange", "banana" ~ "plum")
fruit_relabel(fruits)
#> [1] "apple"  "orange" "orange" "plum"

## Normal use case
#' \dontrun{
#' ggplot(palmerpenguins::penguins, aes(x = sex, y = flipper_length_mm)) +
#'   geom_point(alpha = 0.5) +
#'   scale_x_discrete(labels = relabeller("male" ~ "BOY\nPENGUIN", "female" ~ "GIRL\nPENGUIN"))
#' }
```

### tally_delimited_string()

[`tally_delimited_string()`](https://church-army.github.io/carutools/reference/tally_delimited_string.md)
‘widens’ a data.frame column containing a string of delimited values
(e.g. `"banana, pear, plum"`), replacing the original column with one
column per unique value detected. By default, these columns are logical
and indicate the presence of the respective value at each row, but
tallying multiple instances is also possible.

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
