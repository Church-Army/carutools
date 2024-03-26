test_that("tally_delimited_string works", {

  df <- data.frame(
    people = c("anna", "bob", "chloe", "dave", "ernest"),
    fruit  = c("banana, apple, apple, pear",
               "banana, pear",
               NA,
               "",
               "apple, , peach")
  )


  expect_no_error(tally_delimited_string(df, fruit))

  result <- tally_delimited_string(df, fruit)

  expect_length(result, 5)

  })

test_that("Duplicate names are handled properly", {

  funny_names <- data.frame(
    people = c("anna", "bob", "chloe", "dave"),
    fruit  = c("banana, apple, apple, pear, BANANA",
               "BANANA, pear",
               "",
               "apple, peach")
  )

  result <- tally_delimited_string(funny_names, fruit)

  expect_length(result, 6)

  expect_error(
    tally_delimited_string(funny_names, fruit, names_repair = stringr::str_to_lower),
    class = "duplicate_names"
    )

})

test_that("Keep argument functions as expected",{

  df <- data.frame(
    people = c("anna", "bob", "chloe", "dave", "ernest"),
    fruit  = c("banana, apple, apple, pear",
               "banana, pear",
               NA,
               "",
               "apple, , peach")
  )

  expect_length(
    tally_delimited_string(df, fruit, keep = c("apple", "pear")),
    5
  )

  expect_length(
    tally_delimited_string(df, fruit, keep = c("apple", "pear"),
                           other_suffix = NA),
    4
    )

  expect_length(
    tally_delimited_string(df, fruit, keep = c("apple", "pear"),
                           other_suffix = NA, other_tally_suffix = NA),
    3
  )

  expect_named(
    tally_delimited_string(df, fruit, keep = c("apple", "pear"),
                           other_suffix = "foo", other_tally_suffix = "bar"),
    c("people", "fruit_apple", "fruit_pear", "fruit_foo", "fruit_bar")
  )

})
