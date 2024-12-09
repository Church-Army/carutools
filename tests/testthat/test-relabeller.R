# WARNING - Generated by {fusen} from dev/flat_helpers.qmd: do not edit by hand

test_that("relabeller works",
          {
            labs <- c("foo", "bar", "baz")
            relab <- relabeller("foo" ~ "baz")
            
            expect_equal(relab(labs), c("baz", "bar", "baz"))
          })

test_that("relabller works with no arguments",
          expect_no_condition(relabeller()))
