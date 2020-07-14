##' Get details of PEcAn Model from the database using model id.
##' Hits the `/api/models/{model_id}` API endpoint.
##' @name get.model
##' @title Get details of PEcAn Model from the database using model id
##' @param server Server object obtained using the connect() function 
##' @param model_id ID of the model to retrieve
##' @return Response obtained from the `/api/models/{model_id}` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of the SIPNET ssr model (id = 1000000022)
##' res <- get.model(server, model_id=1000000022)

get.model <- function(server, model_id){
  url <- paste0(server$url, "/api/models/", model_id)
  
  if(! is.null(server$username) && ! is.null(server$password)){
    res <- httr::GET(
      url,
      httr::authenticate(server$username, server$password)
    )
  }
  else{
    res <- httr::GET(url)
  }
  
  if(res$status_code == 200){
    return(jsonlite::fromJSON(rawToChar(res$content)))
  }
  else if(res$status_code == 401){
    stop("Invalid credentials")
  }
  else if(res$status_code == 404){
    stop("Model not found")
  }
  else if(res$status_code == 500){
    stop("Internal server error")
  }
  else{
    stop("Unidentified error")
  }
}