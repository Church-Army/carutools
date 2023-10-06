#' @export
theme_ca <- function(colour = "orange", ...){

  colour <- ca_col(colour)

  extrafont::loadfonts(device = "win")

  theme <-
      theme_minimal() +
      theme(
        text       = element_text(family = "Trebuchet MS"),
        plot.title = element_text(colour = colour),
        ...
        )

  return(theme)
}

