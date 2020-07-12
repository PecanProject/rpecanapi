context("Get the list of PEcAn runs for a workflow")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(get.runs(server_incorrect, workflow_id = 1000009172), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(get.runs(server_invalid, workflow_id = 1000009172), "Invalid credentials")
})

test_that("Requests for valid workflow id are successful", {
  res <- get.runs(server, workflow_id = 1000009172)
  expect_equal(all(res$runs$workflow_id == 1000009172), TRUE)
})

test_that("Requests with invalid workflow id fail", {
  expect_error(get.runs(server, workflow_id = 0), "No runs found")
})

test_that("Pagination works", {
  res <- get.runs(server, workflow_id = 1000009172, limit = 50)
  expect_equal((res$count < 50 && is.null(res$next_page)) || (res$count == 50 && ! is.null(res$next_page)), TRUE)
  
  res <- get.runs(server, workflow_id = 1000009172, limit = 20)
  expect_equal((res$count < 20 && is.null(res$next_page)) || (res$count == 20 && ! is.null(res$next_page)), TRUE)
  
  expect_error(get.runs(server, workflow_id = 1000009172, limit = 45), "limit can be only one of 10, 20, 50, 100 or 500")
})
