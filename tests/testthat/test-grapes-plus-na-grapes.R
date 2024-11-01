test_that("%+na% is working",
          {
            x <- c(1, NA, 3, NA)
            y <- c(1, 2, NA, NA)

            result <- x %+na% y

            expect_equal(result, c(2, 2, 3, NA))
          })
