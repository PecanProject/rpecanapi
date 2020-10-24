context("Get the details of desired PEcAn format")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(get.format(server_incorrect, format_id = 19), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(get.format(server_invalid, format_id = 19), "Invalid credentials")
})

test_that("Requesting details for valid Format ID is successful", {
  res <- get.format(server, format_id = 19)
  expect_equal(res$format_id, 19)
  expect_equal(res$name, "AmeriFlux.level4.h")
})

test_that("Requesting details for invalid Format ID fails", {
  expect_error(get.format(server, format_id = 0), "Format not found")
})