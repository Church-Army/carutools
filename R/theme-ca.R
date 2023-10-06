#' Church Army theme for ggplot2 visualisations
#'
#' @param colour A string, one of `ca_pal()`
#'
#' @param ... Additional arguments passed on to [ggplot2::theme()]
#'
#' @returns A ggplot2 theme object
#'
#' @export
theme_ca <- function(colour = "orange", ...){

  colour <- ca_col(colour)

  extrafont::loadfonts(device = "win", quiet = TRUE)

  theme <-
      theme_minimal() +
      theme(
        text       = element_text(family = "Trebuchet MS"),
        plot.title = element_text(colour = colour),
        ...
        )

  return(theme)
}

