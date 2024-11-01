## Helpers

#' Add vectors, ignoring NAs
#'
#' Vectorised addition with built-in missingness handling. If both elements are missing, `NA` is returned. Otherwise missing values are treated as zero. A `+` (i.e vectorised) equivalent to `sum(..., na.rm = TRUE)`. Vectors are recycled when lengths do not match.
#'
#' @returns A numeric vector
#' @examples c(1, 2, NA, 4, NA) %+na% c(1, 2, 3, NA, NA)
#' @export

`%+na%` <- function(x, y){
  out <- numeric(length(x + y))

  x <- rep_len(x, length(y))
  y <- rep_len(y, length(x))

  nax <- is.na(x)
  nay <- is.na(y)

  and_na  <- nay & nax
  nand_na <- !(nay | nax)
  xor_na <- !(and_na | nand_na)

  out[and_na] <- NA
  out[nand_na] <- x[nand_na] + y[nand_na]

  coalesced <- x[xor_na]
  coalesced[is.na(coalesced)] <- y[xor_na][is.na(coalesced)]
  out[xor_na]  <- coalesced

  out
}
