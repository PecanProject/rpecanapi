context("Get the list of PEcAn workflows after filtering")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(get.workflows(server_incorrect, model_id = 1000000014, site_id = 676), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(get.workflows(server_invalid, model_id = 1000000014, site_id = 676), "Invalid credentials")
})

test_that("Requests with valid filters are successful", {
  res <- get.workflows(server, model_id = 1000000014)
  expect_equal(all(res$workflows$properties$modelid == 1000000014 || is.na(res$workflows$properties$modelid)), TRUE)
  
  res <- get.workflows(server, site_id = 676)
  expect_equal(all(res$workflows$properties$siteid == 676 || is.na(res$workflows$properties$siteid)), TRUE)
  
  res <- get.workflows(server, model_id = 1000000014, site_id = 676)
  expect_equal(
    all(res$workflows$properties$modelid == 1000000014 || is.na(res$workflows$properties$modelid)) &&
      all(res$workflows$properties$siteid == 676 || is.na(res$workflows$properties$siteid)), 
    TRUE
  )
})

test_that("Requests with invalid filters fail", {
  expect_error(get.workflows(server, model_id = 0), "No workflows found")
  expect_error(get.workflows(server, site_id = 0), "No workflows found")
  expect_error(get.workflows(server, model_id = 0, site_id = 0), "No workflows found")
})

test_that("Pagination works", {
  res <- get.workflows(server, model_id = 1000000014, limit = 50)
  expect_equal((res$count < 50 && is.null(res$next_page)) || (res$count == 50 && ! is.null(res$next_page)), TRUE)
  
  res <- get.workflows(server, model_id = 1000000014, limit = 20)
  expect_equal((res$count < 20 && is.null(res$next_page)) || (res$count == 20 && ! is.null(res$next_page)), TRUE)
  
  expect_error(get.workflows(server, model_id = 1000000014, limit = 45), "limit can be only one of 10, 20, 50, 100 or 500")
})
