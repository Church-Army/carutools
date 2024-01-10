test_that("tally-delimited-string works", {

  df <- data.frame(
    people = c("anna", "bob", "chloe", "dave"),
    fruit  = c("banana, apple, apple, pear",
               "banana, pear",
               "",
               "apple, peach")
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

  expect_length(result, 5)

  expect_error(
    tally_delimited_string(funny_names, fruit, names_repair = stringr::str_to_lower),
    class = "duplicate_names"
    )

})
