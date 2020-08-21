context("Submit a PEcAn wokflows in CSV format")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(submit.workflows.csv(server_incorrect, csvFile="test_workflows/test.workflows.csv"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(submit.workflows.csv(server_invalid, csvFile="test_workflows/test.workflows.csv"), "Invalid credentials")
})

test_that("Submitting a valid XML workflow is successful", {
  res <- submit.workflows.csv(server, csvFile="test_workflows/test.workflows.csv")
  expect_false(is.null(res))
  for(i in 1:length(res)){
    expect_equal(res[[i]]$status, "Submitted successfully")
  }
})
