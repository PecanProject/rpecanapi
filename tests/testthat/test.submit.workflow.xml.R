context("Submit a PEcAn wokflow in XML format")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(submit.workflow.xml(server_incorrect, xmlFile="test_workflows/api.sipnet.xml"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(submit.workflow.xml(server_invalid, xmlFile="test_workflows/api.sipnet.xml"), "Invalid credentials")
})

test_that("Submitting a valid XML workflow is successful", {
  res <- submit.workflow.xml(server, xmlFile="test_workflows/api.sipnet.xml")
  expect_false(is.null(res$workflow_id))
  expect_equal(res$status, "Submitted successfully")
})
