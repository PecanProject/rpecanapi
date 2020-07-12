context("Search for appropriate PEcAn models")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(search.models(server_incorrect, model_name = "SIP", revision = "r136"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(search.models(server_invalid, model_name = "SIP", revision = "r136"), "Invalid credentials")
})

test_that("Case insensitive search works", {
  res <- search.models(server, model_name = "sipnet")
  expect_false(is.null(res$models))
  
  res <- search.models(server, model_name = "sipnet", revision = "r136")
  expect_false(is.null(res$models))
})

test_that("Case sensitive search works", {
  res <- search.models(server, model_name = "SIPNET", ignore_case = FALSE)
  expect_false(is.null(res$models))
  
  res <- search.models(server, model_name = "SIPNET", revision = "r136", ignore_case = FALSE)
  expect_false(is.null(res$models))
  
  expect_error(search.models(server, model_name = "sipnet", revision = "r136", ignore_case = FALSE), "Models not found")
})

