##' Obtain the details of a particular PEcAn workflow by supplying 
##' its ID. Hits the `/api/workflows/{id}` API endpoint
##'
##' @name get.workflow
##' @title Get the details of a particular PEcAn workflow using the workflow ID
##' @param server Server object obtained using the connect() function
##' @param workflow_id ID of the PEcAn workflow whose details are needed
##' @return Response obtained from the `/api/workflow/{id}` endpoint
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of workflow with id = '1000009172'
##' res <- get.workflow(server, workflow_id=1000009172)

get.workflow <- function(server, workflow_id){
  url <- paste0(server$url, "/api/workflows/", workflow_id)
    
  
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
    stop("Workflow not found")
  }
  else if(res$status_code == 500){
    stop("Internal server error")
  }
  else{
    stop("Unidentified error")
  }
}