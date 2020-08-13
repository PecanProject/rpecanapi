##' Submits a bunch of PEcAn workflows, the details of which are mentioned in CSV format
##' CSV Template:
##'   Columns: model  revision  met  site_id  pft  start_date  end_date  sensitivity  ensemble  comment
##' Each row corresponds to one workflow to be submitted
##' @name submit.workflows.csv
##' @title Submit a bunch of PEcAn workflows, the details of which are mentioned in CSV file
##' @param server Server object obtained using the connect() function
##' @param csvFile CSV file containing the list of all workflow configurations to be submitted
##' @return Response obtained from the `POST /api/workflow/` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' res <- submit.workflows.csv(server, "default_tests.csv")

submit.workflows.csv <- function(server, csvFile) {
  workflows_configs <- read.csv(csvFile, stringsAsFactors = FALSE)
  
  # The following is a very primitive & sequential implementation.
  # We plan to submit these workflows & track their progress asynchronously 
  # in a multithreaded way
  for(i in 1:nrow(data)) {
    # Get the model id using the helper function
    model_id <- get.model.id(server, data[i, ]["model"], data[i, ]["revision"])
    
    # Submit the workflow using the configs mentioned in the row
    workflow_details <- submit.workflow(
      server, 
      model_id = model_id,
      site_id = data[i, ]["site_id"],
      pfts = c(data[i, ]["pft"]),
      start_date = data[i, ]["start_date"],
      end_date = data[i, ]["end_date"],
      inputs = list(
        met = list(source = data[i, ]["met"])
      ),
      ensemble_size = data[i, ]["ensemble_size"],
      sensitivity.analysis = data[i, ]["sensitivity"],
      notes = data[i, ]["comment"]
    )
    
    print(workflow_details)
  }
}

##' Get the time taken for a workflow to reach its current state from the time it started execution
##' @name get.workflow.time.elapsed
##' @title Get the time taken for a workflow to reach its current state from the time it started execution
##' @param server Server object obtained using the connect() function
##' @param workflow_id ID of the PEcAn workflow whose details are needed
##' @return An object containing the most recent step of the workflow, its status along with the total 
##' time taken for execution till the step (in seconds)
##' @author Tezan Sahu

get.workflow.time.elapsed <- function(server, workflow_id) {
  status <- get.workflow.status(server, workflow_id)$status
  first_step <- strsplit(status[1], "  ")
  last_step <- strsplit(tail(status, n=1), "  ")
  
  elapsed_time <- (lubridate::as_datetime(last_step[3]) - lubridate::as_datetime(first_step[2]))/lubridate::dseconds()
  return(
    list(
      recent_step = last_step[1],
      status = last_step[4],
      tot_time_elapsed = elapsed_time
    )
  )
}

##' Get the model ID from the exact name & revision
##' @name get.model.id
##' @title Get the model ID from the exact name & revision
##' @param server Server object obtained using the connect() function
##' @param model_name Name of the Model
##' @param revision Revision of the Model
##' @return ID of the model with exact name & revision passed as parameters 
##' @author Tezan Sahu
get.model.id <- function(server, model_name, revision) {
  models <- search.models(server, model_name = model_name, revision = revision)
  model_id <- as.character(
    models$models %>% 
    filter(model_name == "SIPNET") %>% 
    filter(revision == "r136") %>% 
    pull(model_id)
  )
  
  # If there is no such model, return NULL
  if(identical(model_id, character(0))){
    return(NULL)
  }
  
  return(model_id)
}