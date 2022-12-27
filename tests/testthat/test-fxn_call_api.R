api_resp <- fxn_call_api(1)

testthat::test_that("Function returns the expected data type", {
  expected_list <- "list"
  testthat::expect_type(api_resp, expected_list)
})

testthat::test_that("Function returns the expected data class", {
  expected_class <- "response"
  testthat::expect_equal(class(api_resp), expected_class)
})

testthat::test_that("Error out if no parameter is passed", {
  testthat::expect_error(fxn_call_api())
})

testthat::test_that("Error out if wrong parameter type is passed", {
  testthat::expect_error(fxn_call_api("wrong"))
})

testthat::test_that("Show a mssage if incorrect comic number is passed", {
  testthat::expect_message(fxn_call_api(99999), "Incorrect Comic Number")
})

