context("Ping the server")

server <- set.server()

test_that("Server is live", {
  res <- ping(server)
  expect_equal(res$request, "ping")
  expect_equal(res$response, "pong")
})