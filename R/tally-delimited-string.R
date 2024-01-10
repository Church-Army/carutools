#' Tally delimited string
#'
#' Expand a delimited string column into columns that tally each instance of every observed delimited value.
#'
#' @param x A data-frame, tibble or similar
#' @param delim The delimiter that separates elements of the string column, passed to \link[tidyr]{separate_longer_delim}. A fixed string by default, use \link[stringr]{regex} to split in other ways.
#' @param col <dynamic> The character column to tally
#' @param count TRUE/FALSE. Should items in strings be counted or just marked as present/missing? These options respectively result in new columns being integer or logical type.
#' @param names_repair Function to repair names of new columns, prior to the appending of prefix
#' @param squish Should delimited elements be 'squished' with \link[stringr]{str_squish}?
#' @param names_prefix Prefix for names of new columns. If NULL (the default), the name of `col` is used.
#' @param ignore Values within string column to ignore. The defaults result in expected behaviour.
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

  function(x, col, delim = ",",
           count = FALSE,
           names_repair = janitor::make_clean_names,
           squish = TRUE,
           names_prefix = NULL,
           ignore = c(NA, "")){

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
      tidyr::separate_longer_delim(!!col, delim = delim) |>
      dplyr::group_by(id, !!col) |>
      dplyr::count()

    completed <-
      dplyr::ungroup(separated_answers) |>
      tidyr::complete(id, !!col, fill = list(n = 0))

    if(squish) completed <- dplyr::mutate(completed, !!col := stringr::str_squish(!!col))

    completed <-
      dplyr::filter(completed, !(!!col %in% ignore)) |>
      dplyr::summarise(.by = c(id, !!col), n = sum(n))

    if(!count) completed <- dplyr::mutate(completed, n = as.logical(n))

    pivot_ready <-
      completed |>
      dplyr::mutate(!!col := names_repair(!!col), .by = id)

    names_test <-
      pivot_ready |>
      dplyr::group_by(id, !!col) |>
      dplyr::count()

    names_counts <- dplyr::pull(names_test, n)

    if(any(names_counts > 1)){
      dodgy_names <-
        names_test |>
        dplyr::filter(n > 1) |>
        dplyr::distinct() |>
        dplyr::pull(!!col)

      rlang::abort(c(
        "'names_repair' must result in a unique name for each delimited item.",
        `*` = "Problem with these names:",
        `*` = stringr::str_c(unique(dodgy_names), collapse = ", ")
        ),
        class = "duplicate_names")
      }

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
