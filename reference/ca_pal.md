# Get a church army palette by name

This function returns a Church Army palette specified by the user

## Usage

``` r
ca_pal(which_pal = NULL)
```

## Arguments

- which_pal:

  A character, which must be one of
  [ca_sample_pals](https://church-army.github.io/carutools/reference/ca_sample_pals.md).

## Value

A character vector of length 5

## Details

Depending on which of the names in `get_pal()` is passed to `which_pal`,
the hexcodes of one of Church Army's colour palettes is returned

`which_pal` must exactly match one of
[`ca_sample_pals()`](https://church-army.github.io/carutools/reference/ca_sample_pals.md),
otherwise an error is thrown.
