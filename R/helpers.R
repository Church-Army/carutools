#' Relabeller
#'
#' A function factory that constructs a \link[dplyr]{case_match} function. Useful for the `labels` argument of ggplot's `scale_*_*` functions.
#'
#' @returns
#' A relabelling function
#' @export
#' @examples
#' fruits <- c("apple", "pear", "pear", "banana")
#'
#' fruit_relabel <- relabeller("pear" ~ "orange", "banana" ~ "plum")
#' fruit_relabel(fruits)
#'
#' ## Normal use case
#' \dontrun{
#' ggplot(palmerpenguins::penguins, aes(x = sex, y = flipper_length_mm)) +
#'   geom_point(alpha = 0.5) +
#'   scale_x_discrete(labels = relabeller("male" ~ "BOY\nPENGUIN", "female" ~ "GIRL\nPENGUIN"))
#' }

relabeller <- function(...){

  dots <- rlang::enexprs(...)

  rlang::new_function(
    args = rlang::pairlist2(x =),
    body = rlang::expr({
      dplyr::case_match(
        x,
        !!!dots,
        .default = x
      )}
    ))}


#' Range labels
#'
#' Create 'range labels' for grouping and tabulating a continuous variable
#'
#' @returns
#' A character vector of labels
#' @param x a numeric vector
#' @param width Desidered label width - numeric
#' @param sep The character used to separate values within each label
#' @param explicit_zero Logical; should zeroes have a label all to themselves? They do by default.
#' @param suffix Optional suffix to append to each label (e.g. "%")
#' @param continuous If NULL, labels assume integer values. Supply a value here to determine the precision with which a continuous range is separated.
#' @param ordered Logical; should output be an ordered factor?
#' @export
#' @examples
#' range_labels(1:10, width = 3)
#' range_labels(1:10/2, width = 1, continuous = 0.1)
range_labels <- function(x, width,
                         sep = " - ", explicit_zero = TRUE, suffix = "",
                         continuous = NULL,
                         ordered = TRUE){

  make_labels <- \(y){

    if(!is.null(continuous)) modify = 1 - continuous
    else modify = 0

    out <- stringr::str_c(((y - 1) * width + 1) - modify, y * width, sep = sep)
    if(explicit_zero) out[y == 0] <- "0"

    stringr::str_c(out, suffix)
  }

  make_levels <- \(y) ceiling(y / width)

  levels <- make_levels(x)
  labels <- make_labels(levels)

  if(ordered){
    complete_levels <- make_levels(min(x):max(x))
    complete_labels <- make_labels(complete_levels)

    labels <- ordered(labels, levels = unique(complete_labels))
  }

  labels

}
