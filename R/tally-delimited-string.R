#' Tally delimited string
#'
#' Expand a delimited string column into columns that tally each instance of every observed delimited value.
#'
#' @param x A data-frame, tibble or similar
#' @param col <dynamic> The character column to tally
#' @param count TRUE/FALSE. Should items in strings be counted or just marked as present/missing? These options respectively result in new columns being integer or logical type.
#' @param names_repair Function to repair names of new columns, prior to the appending of prefix
#' @param names_prefix Prefix for names of new columns. If NULL (the default), the name of `col` is used.
#'
#' @returns A data-frame-like object of the same type as `x`
#' @examples
#' df <- data.frame(name = c("anna", "betty"),
#'               fruits = c("apple, banana", "pear, banana, banana"))
#'
#' tally_delimited_string(df, fruits)
#'
#' tally_delimited_string(df, fruits, count = TRUE)
#'
#' tally_delimited_string(df, fruits, count = TRUE, names_repair = toupper)
#'
#' @export
tally_delimited_string <-

  function(x, col,
           count = FALSE,
           names_repair = carutools:::repair_names,
           names_prefix = NULL){

    stopifnot(length(names_repair) == 1)

    if(is.logical(names_repair)){
      if(names_repair) names_repair <- repair_names
      else names_repair <- identity
    }

    col <- rlang::enexpr(col)

    ided <- dplyr::mutate(x, id = dplyr::row_number())

    separated_answers <-
      ided |>
      dplyr::select(id, !!col) |>
      tidyr::separate_longer_delim(!!col, delim = ", ") |>
      dplyr::group_by(id, !!col) |>
      dplyr::count()

    completed <-
      dplyr::ungroup(separated_answers) |>
      tidyr::complete(id, !!col, fill = list(n = 0))

    if(!count) completed <- dplyr::mutate(completed, n = as.logical(n))

    pivot_ready <-
      completed |>
      dplyr::mutate(!!col := names_repair(!!col))

    if(is.null(names_prefix)){
      prefix <- stringr::str_c(toString(col), "_")
    } else {
      stopifnot(is.character(names_prefix), length(names_prefix) == 1)
      prefix <- names_prefix
    }

    pivoted <-
      tidyr::pivot_wider(
        pivot_ready,
        names_from = !!col, values_from = n,
        names_prefix = prefix) |>
      dplyr::select(!dplyr::ends_with("_NA") & !dplyr::any_of(prefix))

    out <-

      dplyr::left_join(
        dplyr::select(ided, -!!col),
        pivoted,
        by = "id") |>

      dplyr::select(-id)

    out
  }

repair_names <- function(x){
  stringr::str_to_lower(x) |>
  stringr::str_replace_all("\\W", " ") |>
  stringr::str_squish() |>
  stringr::str_replace_all(" ", "_")
}
