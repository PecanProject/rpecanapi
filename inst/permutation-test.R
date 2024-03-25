library(rpecanapi)
library(dplyr)
library(tidyr)
library(tibble)
library(purrr)
library(httr)
library(glue)

argv <- commandArgs(trailingOnly = TRUE)

# Modify for your target machine and authentication
server <- connect("http://pecan.localhost:80", "ashiklom", "admin")

met_source <- c("CRUNCEP", "AmerifluxLBL")
startdate <- "2004-01-01"
enddate <- "2004-12-31"

# List all available models
models <- GET(
  file.path(server$url, "api", "availableModels/"),
  authenticate(server$user, server$password)
) %>%
  content() %>%
  bind_rows()

# List of sites to test
test_sites <- read.csv("inst/test-sites.csv")

# Model-PFT mappings. Not every PFT works with every model.
models_pfts <- read.csv("inst/test-models-pfts.csv") %>%
  inner_join(models, ., "model_name")

inputs <- map(met_source, ~list(met = list(source = .x)))

# Create permutations of all arguments
run_table <- tidyr::crossing(
  tidyr::nesting(models_pfts %>% select(model_id, model_name, revision,
                                        pfts = pft)),
  tidyr::nesting(test_sites),
  inputs = inputs
) %>%
  # These are constants, or metadata
  mutate(
    start_date = startdate,
    end_date = enddate,
    sensitivity.analysis = FALSE,
    ensemble_size = 1,
    met = map_chr(inputs, ~.x$met$source),
    notes = glue("Model: {model_name}--{revision}, ",
                 "Site: [{site_id}] {site_name}, ",
                 "Met: {met}")
  )

run_table_submit <- run_table %>%
  select_if(colnames(.) %in% names(formals(submit.workflow))) %>%
  tail(-5) %>%
  mutate(submit = pmap(., submit.workflow, server = server))

# Interactively check the status of runs
run_status <- run_table_submit %>%
  mutate(workflow_id = map_chr(submit, "workflow_id"),
         status = map(workflow_id, possibly(get.workflow.status,
                                            list(NA, "Not finished")),
                      server = server))

# Print a summary table
run_status %>%
  mutate(stage = map(status, 2) %>% map_chr(tail, 1)) %>%
  select(workflow_id, stage) %>%
  print(n = Inf)
