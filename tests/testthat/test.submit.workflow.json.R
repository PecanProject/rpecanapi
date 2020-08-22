
context("Submit a PEcAn wokflow in JSON format")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(submit.workflow.json(server_incorrect, jsonFile="test_workflows/api.sipnet.json"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(submit.workflow.json(server_invalid, jsonFile="test_workflows/api.sipnet.json"), "Invalid credentials")
})

test_that("Submitting a valid XML workflow is successful", {
  res <- submit.workflow.json(server, jsonFile="test_workflows/api.sipnet.json")
  expect_false(is.null(res$workflow_id))
  expect_equal(res$status, "Submitted successfully")
})
