#' Tally delimited string
#'
#' Expand a delimited string column into columns that tally each instance of every observed delimited value.
#'
#' @param x A data-frame, tibble or similar
#' @param delim The delimiter that separates elements of the string column, passed to \link[tidyr]{separate_longer_delim}. A fixed string by default, use \link[stringr]{regex} to split in other ways.
#' @param col <dynamic> The character column to tally
#' @param count TRUE/FALSE. Should items in strings be counted or just marked as present/missing? These options respectively result in new columns being integer or logical type.
#' @param names_repair A logical indicating whether or not to repair new column names with \link[janitor]{make_clean_names}, or an alternative function for name repair. Names are repaired prior to prefixing.
#' @param squish Should delimited elements be 'squished' with \link[stringr]{str_squish}?
#' @param names_prefix Prefix for names of new columns. If NULL (the default), the name of `col` is used.
#' @param ignore Values within string column to ignore. The defaults result in expected behaviour.
#' @param keep A character vector of delineated items to tally. Ignored if `NULL` (the default).  Values outside of these are concatenated into a single string and reported in a separate column.
#' @param other_suffix The prefix with which to name the column containing concatenated strings of all values not in `keep` when `keep` is not `NULL`. If this argument is set to `NA`, the column is dropped.
#' @param other_tally_suffix The prefix with which to name the column containing the count of all the values not in `keep` when `keep` is not `NULL`. If this argument is set to `NA`, the column is dropped
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
#' tally_delimited_string(df, fruits, keep = c("apple", "banana"))
#'
#' @export
tally_delimited_string <-

  function(x, col, delim = ",",
           count = FALSE,
           names_repair = TRUE,
           squish = TRUE,
           names_prefix = NULL,
           ignore = c(NA, ""),
           keep = NULL,
           other_suffix = "other",
           other_tally_suffix = "n_other"){

    stopifnot(length(names_repair) == 1)

    if(is.logical(names_repair)){
      if(names_repair) names_repair <- janitor::make_clean_names
      else names_repair <- identity
    }

    stopifnot(is.function(names_repair))

    col <- rlang::enexpr(col)
    col_name <- rlang::as_string(col)

    other_col <- paste(col_name, other_suffix, sep = "_")
    tally_col <- paste(col_name, other_tally_suffix, sep = "_")

    ided <- dplyr::mutate(x, id = dplyr::row_number())

    separated_answers <-
      ided |>
      dplyr::select(id, !!col) |>
      tidyr::separate_longer_delim(!!col, delim = delim) |>
      dplyr::group_by(id, !!col) |>
      dplyr::count()

    if(squish) separated_answers <- dplyr::mutate(separated_answers, !!col := stringr::str_squish(!!col))

    if(!is.null(keep)){
      separated_answers <-
        dplyr::group_by(separated_answers, id) |>
        dplyr::mutate(!!other_col := stringr::str_c((!!col)[!((!!col) %in% keep)], collapse = delim),
                      !!tally_col := sum(!(!!col %in% keep)))


      replace_with_na <- \(x) replace(x, x == "", NA)

      other_data <-
        dplyr::select(separated_answers, id, !!other_col, !!tally_col) |>
        dplyr::distinct() |>
        dplyr::mutate(dplyr::across(!!other_col, replace_with_na))

      if(is.na(other_tally_suffix)) other_data <- dplyr::select(other_data, -dplyr::any_of(tally_col))
      if(is.na(other_suffix))       other_data <- dplyr::select(other_data, -dplyr::any_of(other_col))


      separated_answers <-
        dplyr::select(separated_answers, id, !!col, n) |>
        dplyr::filter(!!col %in% keep) |>
        rbind(other_data)
    }

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
        by = "id")

    if(!is.null(keep)){
      out <-
        dplyr::left_join(out, other_data, by = "id")
    }

    out <- dplyr::select(out, -id)

    out
  }
