context("testing s2 authors")

test_that("s2_authors returns", {
  skip_on_cran()
  a <- s2_authors("2204561")
  b <- s2_authors(c("2204561", "144128278", "49930593"))

  # correct classes
  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")

  expect_warning(s2_authors(c("2204561", NA, "dkdk")))
})
