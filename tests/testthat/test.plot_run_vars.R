context("Plot the desired variables from the results of a PEcAn run")

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(
    plot_run_vars(
      server_incorrect, 
      run_id=99000000283, 
      year=2002, 
      y_var="TotalResp", 
      x_var="SoilResp"
    ), 
    "Invalid credentials"
  )
})

test_that("No credentials results in 401 error", {
  server_invalid <- set.server(username=NULL, password=NULL)
  expect_error(
    plot_run_vars(
      server_invalid, 
      run_id=99000000283, 
      year=2002, 
      y_var="TotalResp", 
      x_var="SoilResp"
    ), 
    "Invalid credentials"
  )
})

test_that("Plot is generated when valid parameters are provided", {
  plot_run_vars(
    server, 
    run_id=99000000283, 
    year=2002, 
    y_var="TotalResp", 
    x_var="SoilResp"
  )
  expect_equal(file.exists("plot.png"), TRUE)
  file.remove("plot.png")
})

test_that("Invalid run id results in 404 error", {
  expect_error(
    plot_run_vars(
      server, 
      run_id=0, 
      year=2002, 
      y_var="TotalResp", 
      x_var="SoilResp"
    ), 
    "Run details not found"
  )
})