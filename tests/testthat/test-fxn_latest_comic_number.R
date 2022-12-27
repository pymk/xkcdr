xkcd_latest <- fxn_latest_comic_number()

testthat::test_that("Function returns a number", {
  testthat::expect_type(xkcd_latest, "integer")
})
