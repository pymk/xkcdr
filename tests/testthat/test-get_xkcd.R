xkcd_936 <- get_xkcd(936)
xkcd_latest <- get_xkcd()

testthat::test_that("Function returns a {gt} table", {
  expected_class <- c("gt_tbl", "list")
  testthat::expect_equal(class(xkcd_936), expected_class)
})

testthat::test_that("The correct comic is returned", {
  expected_url <- "https://imgs.xkcd.com/comics/password_strength.png"
  testthat::expect_equal(xkcd_936$`_data`$`xkcd #936`, expected_url)
})

testthat::test_that("No errors when no parameter is passed", {
  testthat::expect_type(xkcd_latest, "list")
})
