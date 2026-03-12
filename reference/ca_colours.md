# Get church army colours by name

Get church army colours by name

## Usage

``` r
ca_colours(...)
```

## Arguments

- ...:

  Any number of characters vectors. All values must all be in
  [ca_sample_cols](https://church-army.github.io/carutools/reference/ca_sample_pals.md)

## Value

A character vector

## Examples

``` r
ca_colours("cyan", "green", "purple")
#>      cyan     green    purple 
#> "#0092BC" "#509E2F" "#523178" 
ca_colour("darkteal")
#>  darkteal 
#> "#006272" 
## colour names are forgiving:
ca_colour("dark-teal")
#> dark-teal 
#> "#006272" 
```
