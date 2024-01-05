#' Tally delimited string
#'
#' Expand a delimited string column into columns that tally each instance of every observed delimited value.
#'
#' @param x A data-frame, tibble or similar
#' @param col <dynamic> The character column to tally
#'
#' @returns A data-frame-like object of the same type as `x`
#' @examples
#' df <- data.frame(name = c("anna", "betty"),
#'               fruits = c("apple, banana", "pear, banana"))
#'
#' tally_delimited_string(tib, fruits)
#'
#' @export
tally_delimited_string <-

  function(x, col){

    col <- rlang::enexpr(col)

    ided <- dplyr::mutate(x, id = dplyr::row_number())

    separated_answers <-
      ided |>
      dplyr::select(id, !!col) |>
      tidyr::separate_longer_delim(!!col, delim = ", ") |>
      dplyr::mutate(selected = TRUE)

    completed <-
      tidyr::complete(separated_answers, id, !!col,
                      fill = list(selected = FALSE))

    pivot_ready <-
      completed |>
      dplyr::mutate(!!col :=
                      stringr::str_to_lower(!!col) |>
                      stringr::str_squish() |>
                      stringr::str_replace_all("\\W", "_")
      )

    prefix <- stringr::str_c(toString(col), "_")

    pivoted <-
      tidyr::pivot_wider(
        pivot_ready,
        names_from = !!col, values_from = selected,
        names_prefix = prefix) |>
      dplyr::select(!ends_with("_NA"))

    out <-

      dplyr::left_join(
        dplyr::select(ided, -!!col),
        pivoted,
        by = "id") |>

      dplyr::select(-id)

    out
  }
