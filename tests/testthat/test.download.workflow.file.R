context("Download & save a file for a desired PEcAn workflow")

test_that("Invalid credentials results in 401 error", {
  server_incorrect <- set.server(username="random", password="random")
  expect_error(download.workflow.file(server_incorrect, workflow_id = 99000000031, filename="pecan.xml", save_as = "temp.file"), "Invalid credentials")
})

test_that("No credentials results in 401 error", {
  server_incorrect <- set.server(username=NULL, password=NULL)
  expect_error(download.workflow.file(server_incorrect, workflow_id = 99000000031, filename="pecan.xml", save_as = "temp.file"), "Invalid credentials")
})

test_that("Desired input file is downloaded on passing correct input_id", {
  download.workflow.file(server, workflow_id = 99000000031, filename="pecan.xml", save_as = "temp.file")
  expect_equal(file.exists("temp.file"), TRUE)
  file.remove("temp.file")
})

test_that("Invalid input_id results in 404 Error", {
  expect_error(download.workflow.file(server, workflow_id = 0, filename="pecan.xml", save_as = "temp.file"), "File not found")
})