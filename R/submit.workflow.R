##' Submit a PEcAn workflow using various user-defined parameters
##' Hits the `POST /api/workflows/` API endpoint.
##' @name submit.workflow
##' @title Submit a PEcAn workflow using various user-defined parameters
##' @param server Server object obtained using the connect() function 
##' @param model_id ID of the model to be used (character)
##' @param site_id ID of the site to be used (character)
##' @param pfts List of PFTs to be used (list)
##' @param start_date Starting date of the analysis (character)
##' @param end_date Ending date of the analysis (character)
##' @param inputs Inputs to the workflow (including meteorological data, etc.) (object)
##' @param ensemble Ensemble settings object for the workflow. Default: NULL (uses NPP & runs for 1 iteration)
##' @param meta.analysis Meta-analysis settings object for the workflow. Default: NULL (uses default parameters)
##' @param sensitivity.analysis Sensitivity Analysis settings object. Default: NULL (No sensitivity analysis)
##' @param notes Additional notes that the user need to specify for the submitted workflow. Default: NULL
##' @return Response obtained from the `POST /api/workflows/` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Submit a workflow with the SIPNET r136 model (id = 1000000014) for Niwot Ridge site (id = 772) with 
##' # PFT as 'temperate.coniferous' starting from 01-01-2002 to 31-12-2003 using the input met data with
##' # id = 99000000003
##' res <- submit.workflow(server, model_id=1000000014, site_id=772, pfts=c("temperate.coniferous"), start_date="2002-01-01", 
##'   end_date="2003-12-31", inputs=list(met=list(id=99000000003)))

submit.workflow <- function(server, model_id, site_id, pfts, start_date, end_date, inputs, ensemble=NULL, meta.analysis=NULL, sensitivity.analysis = NULL, notes=NULL) {
  # Prepare the workflow based on the parameters set by user
  workflow <- list()
  for(i in 1:length(pfts)) {
    workflow$pfts <- c(workflow$pfts, pft=list())
    workflow$pfts$pft[i]$pft$name <- pfts[i]
  }
  
  workflow$model <- list(id = model_id)
  
  workflow$run <- list()
  workflow$run$site <- list(id = site_id)
  workflow$run$start.date <- start_date
  workflow$run$end.date <- end_date
  workflow$run$inputs <- inputs
  
  if(is.null(ensemble)) {
    # Set the default ensemble settings
    workflow$ensemble <- list(
      size = 1,
      variable = "NPP",
      samplingspace = list(
        parameters = list(
          method = "uniform"
        ),
        met = list(
          method = "sampling"
        )
      )
    )
  }
  else {
    workflows$ensemble <- ensemble
  }
  
  if(is.null(meta.analysis)) {
    # Set the default meta.analysis settings
    workflow$meta.analysis <- list(
      iter = 3000,
      random.effects = FALSE
    )
  }
  else {
    workflow$meta.analysis <- meta.analysis
  }
  
  if(! is.null(sensitivity.analysis) && sensitivity.analysis != FALSE) {
    workflow$sensitivity.analysis <- sensitivity.analysis
  }
  
  if(! is.null(notes)) {
    workflowList$info$notes <- notes
  }
  
  # Submit the prepared workflow to the PEcAn API in JSON format
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/workflows/")
      
      if(! is.null(server$username) && ! is.null(server$password)){
        res <- httr::POST(
          url,
          httr::authenticate(server$username, server$password),
          body = workflow,
          encode='json'
        )
      }
      else{
        res <- httr::POST(
          url,
          body = workflow,
          encode='json'
        )
      }
    },
    error = function(e) {
      message("Sorry! Server not responding.")
    }
  )
  
  if(! is.null(res)) {
    if(res$status_code == 201){
      return(jsonlite::fromJSON(rawToChar(res$content)))
    }
    else if(res$status_code == 401){
      stop("Invalid credentials")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}