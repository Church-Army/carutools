# Church Army Colours #

#' Church Army Colours
#'
#' These functions each return the hexadecimal code of a colour in Church Army's brand
#'
#' These functions are wrappers around character vectors of length one. They take no arguments and always return the same string.
#'
#' @returns
#' A single character vector of length one.
#' @export
#' @rdname ca_cols
ca_black <- function() "#000000"
#' @rdname ca_cols
#' @export
ca_white <- function() "#FFFFFF"
#' @rdname ca_cols
#' @export
ca_orange <- function() "#E84619"
#' @rdname ca_cols
#' @export
ca_gold   <- function() "#FBC900"
#' @rdname ca_cols
#' @export
ca_green  <- function() "#509E2F"
#' @rdname ca_cols
#' @export
ca_maroon <- function() "#910048"
#' @rdname ca_cols
#' @export
ca_cyan   <- function() "#0092BC"
#' @rdname ca_cols
#' @export
ca_purple <- function() "#523178"
#' @rdname ca_cols
#' @export
ca_light_teal <- function() "#6C8B93"
#' @rdname ca_cols
#' @export
ca_dark_teal  <- function() "#006272"
#' @rdname ca_cols
#' @export
ca_brown      <- function() "#6F2C3F"

colours <- c(
  black      = ca_black(),
  white      = ca_white(),
  orange     = ca_orange(),
  gold       = ca_gold(),
  green      = ca_green(),
  maroon     = ca_maroon(),
  cyan       = ca_cyan(),
  purple     = ca_purple(),
  light_teal = ca_light_teal(),
  dark_teal  = ca_dark_teal(),
  brown      = ca_brown()
)

get_cols <- function(x) colours[x]

fix_col_name <- function(x){
  stringr::str_replace(x, "_", "-") |>
    stringr::str_replace("[:space:]", "-")
}

#' Get church army colours by name
#'
#' @param x A character vector. Values must all be in \link[carutools]{ca_sample_cols}
#' @returns A character vector
#' @export
ca_cols <- function(x){
  x <- fix_col_name(x)
  stopifnot(all(x %in% names(colours)))

  out <- get_cols(x)

  return(out)
}

#' Get a single church army colour by name
#'
#' A wrapper around \link[carutools]{ca_cols} that accepts one name and returns one colour
#'
#' @param x A character. Value must be one of \link[carutools]{ca_sample_cols}
#' @export
ca_col <- function(x){
  stopifnot(length(x) == 1)
  ca_cols(x)
}

## PALETTES ####################################################################

# Pallettes proper -------------------------------------------------------------
oranges      <- c("#E84619", "#ED6B47", "#F19074", "#F6B6A4", "#FADAD1")
golds        <- c("#FBC900", "#FCD446", "#FCDF74", "#FDE9A1", "#FEF4D0")
light_teals  <- c("#6C8B93", "#8AA2A9", "#A6B9BF", "#C4D1D3", "#E2E9E9")
cyans        <- c("#0092BC", "#36AFDA", "#68C4E2", "#9AD6EB", "#CCE9F3")
dark_teals   <- c("#006272", "#35818D", "#67A1AB", "#9AC0C8", "#CCDFE3")
maroons      <- c("#9A054A", "#AE396F", "#C26A93", "#D89CBB", "#EBCED8")
purples      <- c("#523178", "#765B94", "#9784AE", "#BBAEC9", "#DCD6E4")
browns       <- c("#652430", "#85515A", "#A37C83", "#C1A7AD", "#E1D4D7")
greens       <- c("#2AB04A", "#5EB66D", "#84C491", "#ACD6B5", "#D5E9D9")

# Palet functions --------------------------------------------------------------

#' Church Army Colour Pallets
#'
#' These functions each return a colour pallet from Church Army's brand
#'
#' These functions are wrappers around character vectors of length five.
#' They take no arguments and always return the same character vector.
#'
#' @returns
#' A single character vector of length five.
#' @rdname ca_pals
#' @export
ca_pal_orange     <- function() return(oranges)

#' @rdname ca_pals
#' @export
ca_pal_gold       <- function() return(golds)

#' @rdname ca_pals
#' @export
ca_pal_light_teal <- function() return(light_teals)

#' @rdname ca_pals
#' @export
ca_pal_cyan       <- function() return(cyans)

#' @rdname ca_pals
#' @export
ca_pal_dark_teal  <- function() return(dark_teals)

#' @rdname ca_pals
#' @export
ca_pal_maroon     <- function() return(maroons)

#' @rdname ca_pals
#' @export
ca_pal_purple     <- function() return(purples)

#' @rdname ca_pals
#' @export
ca_pal_brown      <- function() return(browns)

#' @rdname ca_pals
#' @export
ca_pal_green      <- function() return(greens)

#' @rdname ca_pals
#' @export
ca_pal_mix <- function(){
  out <-
    c(ca_gold(), ca_cyan(), ca_green(), ca_purple(),
    ca_light_teal(), ca_orange(), ca_brown(),
    ca_dark_teal(), ca_maroon())
  return(out)
}

## Get ca_pal_* by name

#' See all Church Army palette and colour names
#'
#' A character vector of colour or pallette names accepted by `carutools` functions. For instance,
#' \link[carutools]{ca_pal} will only accept a name from `ca_sample_pals()`.
#'
#' @returns A character vector of Church Army palette or colour names
#' @export
ca_sample_pals    <- function(){
  c("mix", "orange", "gold", "light-teal", "cyan", "dark-teal", "purple", "brown", "green")
}

#'@export
#'@rdname ca_sample_pals
ca_sample_cols <- function() return(names(colours))

#' Get a church army palette by name
#'
#' This function returns a Church Army palette specified by the user
#'
#' Depending on which of the names in `get_pal()` is passed to `which_pal`,
#' the hexcodes of one of Church Army's colour palettes is returned
#'
#' `which_pal` must exactly match one of `get_pal()`, otherwise an error is thrown.
#'
#' @returns
#' A character vector of length 5
#'
#' @param which_pal A character, which must be one of \link[carutools]{ca_sample_pals}.
#' @export
ca_pal <- function(which_pal = NULL){

  stopifnot(length(which_pal) == 1)

  which_pal <- fix_col_name(which_pal)

  if(is.null(which_pal) | !which_pal %in% ca_sample_pals()){
    rlang::abort("You must specify a pallet name. See ca_sample_pals() for all valid paletts")
  }
  get_pal(as.character(which_pal))
}

get_pal <- function(which_pal){
  pals <- c(
    "mix"        = ca_pal_mix,
    "orange"     = ca_pal_orange,
    "gold"       = ca_pal_gold,
    "light-teal" = ca_pal_light_teal,
    "cyan"       = ca_pal_cyan,
    "dark-teal"  = ca_pal_dark_teal,
    "purple"     = ca_pal_purple,
    "brown"      = ca_pal_brown,
    "green"      = ca_pal_green
    )
  out_pal <- (pals[[which_pal]])()
  return(out_pal)
}


