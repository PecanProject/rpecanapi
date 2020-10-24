##' Obtain the status of a particular PEcAn workflow by supplying 
##' its ID. Hits the `/api/workflows/{id}/status` API endpoint
##'
##' @name get.workflow.status
##' @title Get the status of a particular PEcAn workflow using the workflow ID
##' @param server Server object obtained using the connect() function
##' @param workflow_id ID of the PEcAn workflow whose status are needed
##' @return Response obtained from the `/api/workflow/{id}/status` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of workflow with id = '1000009172'
##' res <- get.workflow.status(server, workflow_id=1000009172)

get.workflow.status <- function(server, workflow_id){
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/workflows/", workflow_id, "/status")
      
      
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
      stop("Workflow not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}