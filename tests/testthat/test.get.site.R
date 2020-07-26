context("Get the details of desired PEcAn site")

server <- set.server()

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(get.site(server_incorrect, site_id = 676), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(get.site(server_invalid, site_id = 676), "Invalid credentials")
})

test_that("Requesting details for valid Site ID is successful", {
  res <- get.site(server, site_id = 676)
  expect_equal(res$id, 676)
  expect_equal(res$sitename, "Willow Creek (US-WCr)")
})

test_that("Requesting details for invalid Site ID fails", {
  expect_error(get.site(server, site_id = 0), "Site not found")
})