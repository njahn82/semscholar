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

  d <- s2_papers(c("10.1001/amajethics.2018.699",
                              "10.1001/jama.2013.279671",
                              "10.1001/jama.2013.285157",
                              "10.1001/jama.2014.11888",
                              "10.1001/jama.2014.14604",
                              "10.1001/jama.2014.2104",
                              "10.1001/jama.2014.306",
                              "10.1001/jama.2014.6421",
                              "10.1001/jama.2014.7667",
                              "10.1001/jama.2014.9007",
                              "10.1001/jama.2015.17103")
  )

  # correct classes
  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")
  expect_is(c, "tbl_df")
  expect_is(d, "tbl_df")
  expect_is(d$authors, "list")

  expect_warning(s2_papers("/ng.3260"))
})
