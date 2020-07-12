context("Get the details of requested PEcAn run")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(get.run(server_incorrect, run_id = 1002042202), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(get.run(server_invalid, run_id = 1002042202), "Invalid credentials")
})

test_that("Requesting details for valid Run ID is successful", {
  res <- get.run(server, run_id = 1002042202)
  expect_equal(res$id, 1002042202)
})

test_that("Requesting details for invalid Run ID fails", {
  expect_error(get.run(server, run_id = 0), "Run not found")
})