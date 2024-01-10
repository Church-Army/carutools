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
