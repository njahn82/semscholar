context("testing s2 papers")

test_that("s2_papers returns", {
  skip_on_cran()
  a <- s2_papers("14a22b032524573d15593abed170f9f76359e581")
  b <- s2_papers(
    c("10.1093/nar/gkr1047",
      "14a22b032524573d15593abed170f9f76359e581",
      "10.7717/peerj.2323",
      "arXiv:0711.0914")
  )
  c <- s2_papers(
    c("10.1093/nar/gkr1047",
      "14a22b032524573d15593abed170f9f76359e581",
      "10.7717/peerj.2323",
      "arXiv:0711.0914",
      "skksks")
  )

  # correct classes
  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")
  expect_is(c, "tbl_df")

  expect_warning(s2_papers("/ng.3260"))
})
