context("Get the details of the PEcAn server")

server <- set.server()

test_that("Status of PEcAn server is obtained correctly", {
  res <- get.status(server)
  expect_false(is.null(res$host_details))
  expect_false(is.null(res$pecan_details))
})