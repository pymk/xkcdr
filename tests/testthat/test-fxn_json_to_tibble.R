resp <- httr::GET("https://xkcd.com/info.0.json")
resp_tibble <- fxn_json_to_tibble(resp)

testthat::test_that("Function returns the expected data type", {
  expected_list <- "list"
  testthat::expect_type(resp_tibble, expected_list)
})

testthat::test_that("Function returns the expected data class", {
  expected_class <- c("tbl_df", "tbl", "data.frame")
  testthat::expect_equal(class(resp_tibble), expected_class)
})
