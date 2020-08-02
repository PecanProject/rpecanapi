##' Search PEcAn Models from the database using search string based on
##' model_name & revision. Hits the `/api/models/` API endpoint with 
##' relevant query parameters
##' @name search.models
##' @title Search for PEcAn Models from the database
##' @param server Server object obtained using the connect() function 
##' @param model_name Search string for model name Default: "" (Returns all models)
##' @param revision Search string for revision. Default: "" (Returns all revisions for a model)
##' @param ignore_case Indicator of case sensitive or case insensitive search
##' @return Response obtained from the `/api/models/` endpoint with relevant query parameters
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of all models
##' res1 <- search.models(server)
##' 
##' # Get details of all models containing 'sip' in their name
##' res2 <- search.models(server, model_name="sip")
##' 
##' # Get details of the 'ssr' revision of the 'SIPNET' model
##' res3 <- search.models(server, model_name="SIPNET", revision="ssr")
##' 
##' # Get details of models where name contains "SIP" (case sensitive)
##' res4 <- search.models(server, model_name="SIPNET", ignore_case=FALSE)

search.models <- function(server, model_name="", revision="", ignore_case=TRUE){
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/models/?model_name=", model_name, "&revision=", revision, "&ignore_case=", ignore_case)
      
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
      stop("Models not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}