##' Retrive a list of PEcAn Workflows from the database. Filters 
##' can also be applied based on model_id & site_id to get details
##' about specific workflows. Hits the `/api/workflows/` API endpoint with 
##' relevant query parameters
##' @name get.workflows
##' @title Get list of PEcAn Workflows from the database
##' @param server Server object obtained using the connect() function 
##' @param model_id ID of the specific model being used in workflows to be retrieved. Default: NULL (Returns workflows using any model)
##' @param site_id ID of the specific site being used in workflows to be retrieved. Default: NULL (Returns workflows using any site)
##' @return Response obtained from the `/api/workflows/` endpoint with relevant query parameters
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get list of all workflows
##' res1 <- get.workflows(server)
##' 
##' # Get list of all workflows using 'SIPNET-ssr' model
##' res2 <- get.workflows(server, model_id="1000000022")
##' 
##' ##' # Get list of all workflows using 'Willow Creek (US-WCr)' as site
##' res3 <- get.workflows(server, site_id="676")
##' 
##' # Get list of workflow(s) that use 'SIPNET-ssr' model & 'Willow Creek (US-WCr)' as site
##' res4 <- get.workflows(server, "1000000022", "676")

get.workflows <- function(server, model_id=NULL, site_id=NULL){
  url <- paste0(server$url, "/api/workflows/")
  if(!is.null(model_id) && !is.null(site_id)){
    url <- paste0(url, "?model_id=", model_id, "&site_id=", site_id)
  }
  else if(!is.null(model_id) && is.null(site_id)){
    url <- paste0(url, "?model_id=", model_id)
  }
  else if(is.null(model_id) && !is.null(site_id)){
    url <- paste0(url, "?site_id=", site_id)
  }
  else{
    # Do nothing
  }
  
  res <- httr::GET(
    url,
    httr::authenticate(server$username, server$password)
  )
  
  return(res)
}