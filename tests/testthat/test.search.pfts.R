context("Search for appropriate PEcAn PFTs")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(search.pfts(server_incorrect, pft_name="temperate"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(search.pfts(server_invalid, pft_name="temperate"), "Invalid credentials")
})

test_that("Case insensitive search works", {
  res <- search.pfts(server, pft_name="temperate")
  expect_false(is.null(res$pfts))
  
  res <- search.pfts(server, pft_type="cultivar")
  expect_false(is.null(res$pfts))
  
  res <- search.pfts(server, model_type="sipnet")
  expect_false(is.null(res$pfts))
})

test_that("Case sensitive search works", {
  res <- search.pfts(server, model_type="SIPNET", ignore_case = FALSE)
  expect_false(is.null(res$pfts))
  
  expect_error(search.pfts(server, model_type="sipnet", ignore_case = FALSE), "PFTs not found")
})

test_that("Valid PFT types are only allowed", {
  res <- search.pfts(server, pft_type="plant")
  expect_false(is.null(res$pfts))
  
  expect_error(search.pfts(server, pft_type="random"), "pft_type can be only one of '', 'plant' or 'cultivar'")
})
