context("Get the status of requested PEcAn workflow")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(get.workflow.status(server_incorrect, workflow_id = 99000000031), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(get.workflow.status(server_invalid, workflow_id = 99000000031), "Invalid credentials")
})

test_that("Requesting status for valid Workflow ID is successful", {
  res <- get.workflow.status(server, workflow_id = 99000000031)
  expect_equal(res$workflow_id, "99000000031")
})

test_that("Requesting status for invalid Workflow ID fails", {
  expect_error(get.workflow.status(server, workflow_id = 0), "Workflow not found")
})