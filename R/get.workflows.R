##' Retrive a list of PEcAn Workflows from the database. Filters 
##' can also be applied based on model_id & site_id to get details
##' about specific workflows. Hits the `/api/workflows/` API endpoint with 
##' relevant query parameters
##' @name get.workflows
##' @title Get list of PEcAn Workflows from the database
##' @param server Server object obtained using the connect() function 
##' @param model_id ID of the specific model being used in workflows to be retrieved. Default: NULL (Returns workflows using any model)
##' @param site_id ID of the specific site being used in workflows to be retrieved. Default: NULL (Returns workflows using any site)
##' @param offset The number of workflows to skip before starting to collect the result set.
##' @param limit The number of workflows to return (Available values : 10, 20, 50, 100, 500)
##' @return Response obtained from the `/api/workflows/` endpoint with relevant query parameters
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://pecan.localhost:80", username="carya", password="illinois")
##' 
##' # Get list of all workflows
##' res1 <- get.workflows(server)
##' 
##' # Get list of all workflows using 'SIPNET-ssr' model
##' res2 <- get.workflows(server, model_id=1000000022)
##' 
##' ##' # Get list of all workflows using 'Willow Creek (US-WCr)' as site
##' res3 <- get.workflows(server, site_id=676)
##' 
##' # Get list of workflow(s) that use 'SIPNET-ssr' model & 'Willow Creek (US-WCr)' as site
##' res4 <- get.workflows(server, 1000000022, 676)

get.workflows <- function(server, model_id=NULL, site_id=NULL, offset=0, limit=50){
  if(! is.element(limit, c(10, 20, 50, 100, 500))) {
    stop("limit can be only one of 10, 20, 50, 100 or 500")
  }
  
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/workflows/")
      if(!is.null(model_id) && !is.null(site_id)){
        url <- paste0(url, "?model_id=", model_id, "&site_id=", site_id, "&offset=", offset, "&limit=", limit)
      }
      else if(!is.null(model_id) && is.null(site_id)){
        url <- paste0(url, "?model_id=", model_id, "&offset=", offset, "&limit=", limit)
      }
      else if(is.null(model_id) && !is.null(site_id)){
        url <- paste0(url, "?site_id=", site_id, "&offset=", offset, "&limit=", limit)
      }
      else{
        url <- paste0(url, "?offset=", offset, "&limit=", limit)
      }
      
      if(! is.null(server$username) && ! is.null(server$password)){
        res <- httr::GET(
          url,
          httr::authenticate(server$username, server$password)
        )
      }
      else{
        res <- httr::GET(url)
      }
    },
    error = function(e) {
      message("Sorry! Server not responding.")
    }
  )
  
  if(! is.null(res)) {
    if(res$status_code == 200){
      return(jsonlite::fromJSON(rawToChar(res$content)))
    }
    else if(res$status_code == 401){
      stop("Invalid credentials")
    }
    else if(res$status_code == 404){
      stop("No workflows found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}