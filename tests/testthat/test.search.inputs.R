context("Search for appropriate PEcAn inputs")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(search.inputs(server_incorrect, model_id=1000000014, site_id=676, format_id=24, host_id=2), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(search.inputs(server_invalid, model_id=1000000014, site_id=676, format_id=24, host_id=2), "Invalid credentials")
})

test_that("Case insensitive search works", {
  res <- search.inputs(server, model_id=1000000014, format_id=24, host_id=2)
  expect_false(is.null(res$inputs))
  
  res <- search.inputs(server, model_id=1000000014, site_id=676, format_id=24, host_id=2)
  expect_false(is.null(res$inputs))
})