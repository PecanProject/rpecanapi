library(rpecanapi)
library(dplyr)
library(tidyr)
library(tibble)
library(purrr)
library(httr)
library(glue)

# Modify for your target machine and authentication
server <- connect("http://localhost:8000", "ashiklom", "admin")

# List all available models
models <- GET(
  file.path(server$url, "api", "availableModels/"),
  authenticate(server$user, server$password)
) %>%
  content() %>%
  bind_rows()

default_start_date <- "2004-01-01"
default_end_date <- "2004-12-31"

test_list <- read.csv("inst/integration-test-list.csv", comment.char = "#") %>%
  as_tibble() %>%
  # Only test models that are available on the target machine
  inner_join(models, c("model_name", "revision")) %>%
  mutate(start_date = if_else(is.na(start_date), default_start_date, as.character(start_date)),
         end_date = if_else(is.na(end_date), default_end_date, as.character(end_date)),
         inputs = map(met, ~list(met = list(source = .x))),
         pfts = strsplit(pfts, "|", fixed = TRUE))

test_runs <- test_list %>%
  select_if(colnames(.) %in% names(formals(submit.workflow))) %>%
  mutate(submit = pmap(., submit.workflow, server = server))

# Interactively check the status of runs
finished <- FALSE
while (!finished) {
  # Print a summary table
  Sys.sleep(10)
  message(Sys.time())
  run_status <- test_runs %>%
    mutate(workflow_id = map_chr(submit, "workflow_id"),
           status = map(workflow_id, possibly(get.workflow.status,
                                              list(NA, "Not started")),
                        server = server))
  stages <- run_status %>%
    mutate(stage = map(status, 2) %>% map_chr(tail, 1))
  finished <- !any(stages$stage == "Not started")
  stages %>%
    select(workflow_id, stage) %>%
    print(n = Inf)
}
