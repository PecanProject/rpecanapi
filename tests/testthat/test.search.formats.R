context("Search for appropriate PEcAn formats")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(search.formats(server_incorrect, format_name = "ameriflux", mimetype = "netcdf"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(search.formats(server_invalid, format_name = "ameriflux", mimetype = "netcdf"), "Invalid credentials")
})

test_that("Case insensitive search works", {
  res <- search.formats(server, format_name = "ameriflux")
  expect_false(is.null(res$formats))
  
  res <- search.formats(server, format_name = "ameriflux", mimetype = "netcdf")
  expect_false(is.null(res$formats))
})

test_that("Case sensitive search works", {
  res <- search.formats(server, format_name = "Ameriflux", ignore_case = FALSE)
  expect_false(is.null(res$formats))
  
  res <- search.formats(server, format_name = "Ameriflux", mimetype = "netcdf", ignore_case = FALSE)
  expect_false(is.null(res$formats))
  
  expect_error(search.formats(server, format_name = "ameriflux", mimetype = "netcdf", ignore_case = FALSE), "Formats not found")
})