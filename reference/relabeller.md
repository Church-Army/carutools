# Relabeller

A function factory that constructs a
[case_match](https://dplyr.tidyverse.org/reference/case_match.html)
function. Useful for the `labels` argument of ggplot's `scale_*_*`
functions.

## Usage

``` r
relabeller(...)
```

## Arguments

- ...:

  Any number of formulae in the format `'old_label' ~ 'new_label'`.

## Value

A relabelling function

## Examples

``` r
fruits <- c("apple", "pear", "pear", "banana")

fruit_relabel <- relabeller("pear" ~ "orange", "banana" ~ "plum")
fruit_relabel(fruits)
#> [1] "apple"  "orange" "orange" "plum"  

## Normal use case
if (FALSE) { # \dontrun{
ggplot(palmerpenguins::penguins, aes(x = sex, y = flipper_length_mm)) +
  geom_point(alpha = 0.5) +
  scale_x_discrete(labels = relabeller("male" ~ "BOY\nPENGUIN", "female" ~ "GIRL\nPENGUIN"))
} # }
```
