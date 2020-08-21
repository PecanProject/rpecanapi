context("Download & save the desired PEcAn input file")

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(download.input(server_incorrect, input_id = 99000000003, save_as = "temp.file"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_incorrect <- set.server(username=NULL, password=NULL)
  expect_error(download.input(server_incorrect, input_id = 99000000003, save_as = "temp.file"), "Invalid credentials")
})

test_that("Desired input file is downloaded on passing correct input_id", {
  download.input(server, input_id = 99000000003, save_as = "temp.file")
  expect_equal(file.exists("temp.file"), TRUE)
  file.remove("temp.file")
})

test_that("Invalid input_id results in 404 Error", {
  expect_error(download.input(server, input_id = 0, save_as = "temp.file"), "Input file not found")
})

test_that("Desired input file is downloaded on passing input_id pointing to a folder along with correct filename", {
  download.input(server, input_id = 295, filename = "fraction.plantation", save_as = "temp.file")
  expect_equal(file.exists("temp.file"), TRUE)
  file.remove("temp.file")
})

test_that("input_id pointing to folder & no filename results in 400 Error", {
  expect_error(
    download.input(server, input_id = 295, save_as = "temp.file"), 
    "Bad request. Input ID points to directory & filename is not specified"
  )
})