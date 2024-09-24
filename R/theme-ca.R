#' Church Army theme for ggplot2 visualisations
#'
#' @param colour A string, one of [carutools::ca_pal()]
#'
#' @param ... Additional arguments passed on to [ggplot2::theme()]
#'
#' @returns A ggplot2 theme object
#'
#' @export
theme_ca <- function(colour = "cyan", ...){

  colour <- ca_col(colour)

  extrafont::loadfonts(device = "win", quiet = TRUE)

  theme <-
      ggplot2::theme_minimal() +
      theme(
        text       = ggplot2::element_text(family = "Trebuchet MS"),
        plot.title = ggplot2::element_text(colour = colour),
        axis.line = element_line(colour = "black"),
        axis.ticks = element_line()
        )

  return(theme)
}

