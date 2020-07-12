context("Get the details of desired PEcAn model")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(get.model(server_incorrect, model_id = 1000000014), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(get.model(server_invalid, model_id = 1000000014), "Invalid credentials")
})

test_that("Requesting details for valid Model ID is successful", {
  res <- get.model(server, model_id = 1000000014)
  expect_equal(res$model_id, 1000000014)
  expect_equal(res$model_name, "SIPNET")
  expect_equal(res$revision, "r136")
})

test_that("Requesting details for invalid Model ID fails", {
  expect_error(get.model(server, model_id = 0), "Model not found")
})