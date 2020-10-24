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
##' @param ensemble_size Ensemble size for the workflow. Default: 1
##' @param sensitivity_variable Variable for performing sensitivity. Default: NPP
##' @param meta.analysis Meta-analysis settings object for the workflow. Default: NULL (uses default parameters)
##' @param sensitivity.analysis Whether or not to perform a sensitivity analysis. Can also take
##' a sensitivity setting object as input. Default: FALSE (logical or list)
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

submit.workflow <- function(server, model_id, site_id, pfts, start_date, end_date, inputs, meta.analysis=NULL, 
                            ensemble_size=1, sensitivity_variable = "NPP", sensitivity.analysis = FALSE, notes=NULL) {
  # Prepare the workflow based on the parameters set by user
  workflow <- list()
  for(i in 1:length(pfts)) {
    workflow$pfts <- c(workflow$pfts, pft=list())
    workflow$pfts$pft[i]$pft$name <- pfts[i]
  }
  
  workflow$model <- list(id = model_id)
  
  workflow$run <- list()
  workflow$run$site <- list(
    id = site_id,
    met.start = start_date,
    met.end = end_date
  )
  workflow$run$start.date <- start_date
  workflow$run$end.date <- end_date
  workflow$run$inputs <- inputs
  
  # Set the default ensemble settings
  workflow$ensemble <- list(
    size = ensemble_size,
    variable = sensitivity_variable,
    samplingspace = list(
      parameters = list(
        method = "uniform"
      ),
      met = list(
        method = "sampling"
      )
    )
  )
  
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
  
  # If sensitivity.analysis is set to TRUE, use the default settings to populate the workflow
  if(typeof(sensitivity.analysis) == "logical") {
    if(sensitivity.analysis) {
      workflow$sensitivity.analysis <- list(
        quantiles = list(sigma1 = -2, sigma2 = -1, sigma3 = 1, sigma4 = 2)
      )
    }
    # Else if FALSE, do nothing
  }
  # If a list containing configs (sigmas, etc.) is passed, use that to populate thw workflow
  else if (typeof(sensitivity.analysis) == "list") {
    workflow$sensitivity.analysis <- sensitivity.analysis
  }
  # Else, do not populate the sensitivity analysis settings
  
  
  if(! is.null(notes)) {
    workflow$info$notes <- notes
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
