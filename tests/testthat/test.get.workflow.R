context("Get the details of requested PEcAn workflow")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(get.workflow(server_incorrect, workflow_id = 1000010213), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(get.workflow(server_invalid, workflow_id = 1000010213), "Invalid credentials")
})

test_that("Requesting details for valid Workflow ID is successful", {
  res <- get.workflow(server, workflow_id = 1000010213)
  expect_equal(res$id, "1000010213")
  expect_false(is.null(res$properties))
})

test_that("Requesting details for invalid Workflow ID fails", {
  expect_error(get.workflow(server, workflow_id = 0), "Workflow not found")
})