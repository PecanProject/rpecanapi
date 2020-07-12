context("Search for appropriate PEcAn sites")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(search.sites(server_incorrect, sitename="haliburton"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(search.sites(server_invalid, sitename="haliburton"), "Invalid credentials")
})

test_that("Case insensitive search works", {
  res <- search.sites(server, sitename="haliburton")
  expect_false(is.null(res$sites))
})

test_that("Case sensitive search works", {
  res <- search.sites(server, sitename = "Haliburton", ignore_case = FALSE)
  expect_false(is.null(res$sites))

  expect_error(search.sites(server, sitename = "haliburton", ignore_case = FALSE), "Sites not found")
})

