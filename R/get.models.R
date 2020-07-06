##' Retrive information about PEcAn Models from the database. Filters 
##' can also be applied based on model_name & revision to get details
##' about specific models. Hits the `/api/models/` API endpoint with 
##' relevant query parameters
##' @name get.models
##' @title Get information about PEcAn Models from the database
##' @param server Server object obtained using the connect() function 
##' @param model_name Name of the specific model being searched for. Default: NULL (Returns all models)
##' @param revision Revision corresponding to the model being searched for. Default: NULL (Returns all revisions for a model)
##' @return Response obtained from the `/api/models/` endpoint with relevant query parameters
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of all models
##' res1 <- get.models(server)
##' 
##' # Get details of all 'SIPNET' models
##' res2 <- get.models(server, "SIPNET")
##' 
##' # Get details of the 'ssr' revision of the 'SIPNET' model
##' res3 <- get.models(server, "SIPNET", "ssr")

get.models <- function(server, model_name=NULL, revision=NULL){
  url <- paste0(server$url, "/api/models/")
  if(!is.null(model_name) && !is.null(revision)){
    url <- paste0(url, "?model_name=", model_name, "&revision=", revision)
  }
  else if(!is.null(model_name) && is.null(revision)){
    url <- paste0(url, "?model_name=", model_name)
  }
  else if(is.null(model_name) && !is.null(revision)){
    url <- paste0(url, "?revision=", revision)
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