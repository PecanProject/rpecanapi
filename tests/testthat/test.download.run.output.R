context("Download & save an output file for a desired PEcAn run")

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(download.run.output(server_incorrect, run_id = 99000000282, filename="2002.nc", save_as = "temp.file"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_incorrect <- set.server(username=NULL, password=NULL)
  expect_error(download.run.output(server_incorrect, run_id = 99000000282, filename="2002.nc", save_as = "temp.file"), "Invalid credentials")
})

test_that("Desired input file is downloaded on passing correct input_id", {
  download.run.output(server, run_id = 99000000282, filename="2002.nc", save_as = "temp.file")
  expect_equal(file.exists("temp.file"), TRUE)
  file.remove("temp.file")
})

test_that("Invalid input_id results in 404 Error", {
  expect_error(download.run.output(server, run_id = 0, filename="2002.nc", save_as = "temp.file"), "Output file not found")
})