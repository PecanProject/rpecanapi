context("Get the details of desired PEcAn PFT")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(get.pft(server_incorrect, pft_id = 1000000082), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(get.pft(server_invalid, pft_id = 1000000082), "Invalid credentials")
})

test_that("Requesting details for valid PFT ID is successful", {
  res <- get.pft(server, pft_id = 1000000082)
  expect_equal(res$pft_id, 1000000082)
  expect_equal(res$pft_name, "everygreen.broadleaf")
})

test_that("Requesting details for invalid PFT ID fails", {
  expect_error(get.pft(server, pft_id = 0), "PFT not found")
})