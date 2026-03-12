# colours and themes

``` r
library(carutools)
```

## Individual Church army colours

All the Church Army colours, wrapped in prefixed functions.

``` r
ca_black()
#> [1] "#000000"
```

## Church Army colours by name

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

## Palettes

Simple palettes based on Church Army colours that ‘fade to white’.

## Themes

Church Army default themes for:

- ggplot2
- flextable
