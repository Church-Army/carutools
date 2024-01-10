## DISCRETE SCALES #################################################################

#' Discrete colour/fill scales for ggplot2
#'
#' Add Church Army colour/fill scales to ggplot objects
#'
#' These functions are wrappers around \link[ggplot2]{scale_colour_discrete} that add Church Army colours to the aesthetics of ggplot objects.
#' Note that, since CA is a UK/ROI based charity, there are no americanised aliases for 'colour'.
#'
#' These functions take a single argument `ca_palette`. If its length is one, it is passed to \link[carutools]{ca_pal} to specify a palette.
#' Otherwise, it is passed to \link[carutools]{ca_cols} to specify individual colours.`

#' @param ca_palette The CA palette to use for the scale. A character vector. If length one, it must be one of \link[carutools]{ca_sample_pals}.
#' Otherwise, every value must be one of \link[carutools]{ca_cols}
#'
#' @param ... Other arguments passed to \link[ggplot2]{scale_colour_discrete}/\link[ggplot2]{scale_fill_discrete}
#'
#' @export
#' @rdname ca_scale_colour_discrete
ca_scale_colour_discrete <- function(ca_palette = "mix", ...){
  if(length(ca_palette) == 1) ggplot2::scale_colour_discrete(type = ca_pal(ca_palette), ...)
  else                        ggplot2::scale_colour_discrete(values = ca_cols(ca_palette))
}

#'@export
#'@rdname ca_scale_colour_discrete
ca_scale_fill_discrete <- function(ca_palette = "mix", ...){
  if(length(ca_palette) == 1) ggplot2::scale_fill_discrete(type = ca_pal(ca_palette), ...)
  else                        ggplot2::scale_fill_discrete(values = ca_cols(ca_palette))
}


## Discrete, diverging scales

make_likert_scale <- function(low, high, mid = NULL, n){

  colours <- vector("character", n)

  even_n <- n %% 2 == 0
  mid_n  <- median(1:n)

  lower_n <- 1:floor(mid_n)
  upper_n <- ceiling(mid_n):n

  colours[lower_n] <- low[lower_n]
  colours[rev(upper_n)] <- high[lower_n]


  if(!even_n){
    if(is.null(mid)){
      getter <- grDevices::colorRampPalette(
        c(
          colours[max(lower_n)],
          colours[min(upper_n)]
          ))
      colours[mid_n] <- (getter(3))[2] #mix those colours
    } else colours[mid_n] <- mid
  }

  return(colours)

}

#' Church Army Discrete colour/fill Scales, brewed from palettes
#'
#' Discrete, diverging scales with a white midpoint, useful for plotting likert responses
#'
#' These are wrappers around \link[ggplot2]{scale_colour_discrete}/\link[ggplot2]{scale_fill_discrete}.
#' 'Low' and 'High' arguments are passed to \link[carutools]{ca_pal} to get official Church Army
#' palettes, from which values are extracted to be used in the discrete scale.
#'
#' By default, odd scales have a `ca_white()` mid-point, which is convenient for plotting likert responses.
#' Specifying `mid = NULL` replaces this with an automatically mixed colour, which often produces
#' an attractive diverging scale. With the exception of this mixed colour, all colours in the scale
#' will be official CA brand colours
#'
#' @param low The CA palette to be used for the lower half of the scale. Must be one of `ca_show_pal()`.
#' @param high The CA palette to be used for the upper half of the scale. Must be one of `ca_show_pal()`.
#' @param mid The colour to use for the mid-point of the scale. Must be a colour that ggplot can understand.
#' If this is null, a new colour is calculated by blending the mid-points of low and high scales.
#' @param ... Additional arguments passed to \link[ggplot2]{scale_fill_discrete}
#' @rdname ca_scale_fill_brew
#' @export
ca_scale_fill_brew <- function(low = "cyan", high = "green", mid = ca_white(), ...){

  stopifnot(is.null(mid)|length(mid) == 1)

  low <- ca_pal(low)
  high <- ca_pal(high)

  list_out <- lapply(as.list(1:11), make_likert_scale, low = low, high = high, mid = mid)

  ggplot2::scale_fill_discrete(type = list_out, ...)
}

#' @rdname ca_scale_fill_brew
#' @export
ca_scale_colour_brew <- function(low = "cyan", high = "green", mid = ca_white(), ...){

  low <- ca_pal(low)
  high <- ca_pal(high)

  list_out <- lapply(as.list(1:11), make_likert_scale, low = low, high = high, mid = mid)

  ggplot2::scale_colour_discrete(type = list_out, ...)
}
## CONTINUOUS SCALES ##############################################################

#' Continuous colour/fill scales for ggplot2
#'
#' Add Church Army colour/fill scales to ggplot objects
#'
#' These functions are wrappers around \link[ggplot2]{scale_colour_gradientn}/\link[ggplot2]{scale_fill_gradientn} that add Church Army colours to the aesthetics of ggplot objects.
#' Note that, since CA is a UK/ROI based charity, there are no americanised aliases for 'colour'.
#'
#' These functions take a single argument `ca_palette`, which is passed to \link[carutools]{ca_pal} to specify a palette.
#' The values of the palette are used to generate a continuous scale.

#' @param ca_palette The CA palette to use for the scale. Must be one of \link[carutools]{ca_sample_pals}
#'
#' @param ... Other arguments passed to \link[ggplot2]{scale_colour_gradientn}/\link[ggplot2]{scale_fill_discrete}
#'
#' @export
#' @rdname ca_scale_colour_continuous
ca_scale_colour_continuous <- function(ca_palette = "orange", ...){
  if(ca_palette == "mix") rlang::warn("This plot probably looks ugly.", "Consider not using 'mix' lol.")
  pal <- ca_pal(ca_palette)
  ggplot2::scale_colour_gradientn(colours = pal, ...)
}

#' @export
#' @rdname ca_scale_colour_continuous
ca_scale_fill_continuous <- function(ca_palette, ...){
  if(ca_palette == "mix") rlang::warn("This plot probably looks ugly.", "Consider not using 'mix' lol.")
  pal <- ca_pal(ca_palette)
  ggplot2::scale_fill_gradientn(colours = pal, ...)
}


#' Continuous colour/fill scales for ggplot2
#'
#' Create continuous colour gradients from Church Army colours, and use these as scales for ggplot objects
#'
#' These functions are wrappers around \link[ggplot2]{scale_colour_gradient}/\link[ggplot2]{scale_fill_gradient} and \link[ggplot2]{scale_colour_gradient2}/\link[ggplot2]{scale_fill_gradient2} that add Church Army colours to the aesthetics of ggplot objects.
#' Note that, since CA is a UK/ROI based charity, there are no americanised aliases for 'colour'.
#'
#' Arguments for `low`, `high` and `mid` are passed to  \link[carutools]{ca_col} to specify a Church Army colour that is forwarded to the gradient-making function.
#' The values of the palette are used to generate a continuous scale.
#'
#' @param low The CA colour to be used for the lower half of the scale. Must be one of `ca_sample_cols()`.
#' @param high The CA palette to be used for the upper half of the scale. Must be one of `ca_sample_cols()`.
#' @param mid The colour to use for the mid-point of the scale. Must be one of `ca_sample_cols()`.
#' @param ... Other arguments passed to \link[ggplot2]{scale_colour_gradient} or \link[ggplot2]{scale_fill_gradient}
#'
#' @export
#' @rdname ca_scale_colour_gradient
ca_scale_colour_gradient <- function(low = "cyan", high = "green", ...){
  low  <- ca_col(low)
  high <- ca_col(high)
  ggplot2::scale_colour_gradient(low, high, ...)
}

#' @export
#' @rdname ca_scale_colour_gradient
ca_scale_fill_gradient <- function(low = "cyan", high = "green", ...){
  low  <- ca_col(low)
  high <- ca_col(high)
  ggplot2::scale_fill_gradient(low, high, ...)
}

#' @export
#' @rdname ca_scale_colour_gradient
ca_scale_colour_gradient2 <- function(low = "cyan", high = "green", mid = "white", ...){
  low <- ca_col(low)
  high <- ca_col(high)
  mid  <- ca_col(mid)

  ggplot2::scale_colour_gradient2(low = low, mid = mid, high = high, ...)
}

#' @export
#' @rdname ca_scale_colour_gradient
ca_scale_fill_gradient2 <- function(low = "cyan", high = "green", mid = "white", ...){
  low <- ca_col(low)
  high <- ca_col(high)
  mid  <- ca_col(mid)

  ggplot2::scale_fill_gradient2(low = low, mid = mid, high = high, ...)
}


