##' Obtain the details of a details of a specified PEcAn run.
##' Hits the `/api/run/{id}` API endpoint
##'
##' @name get.run
##' @title Get the details of a particular PEcAn run using the run ID
##' @param server Server object obtained using the connect() function
##' @param run_id ID of the PEcAn run whose details are needed
##' @return Response obtained from the `/api/run/{id}` endpoint
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of run with id = '1002042201'
##' res <- get.run(server, "1002042201")

get.run <- function(server, run_id){
  res <- httr::GET(
    paste0(server$url, "/api/runs/", run_id),
    httr::authenticate(server$username, server$password)
  )
  
  if(res$status_code == 200){
    return(jsonlite::fromJSON(rawToChar(res$content)))
  }
  else if(res$status_code == 401){
    stop("Invalid credentials")
  }
  else if(res$status_code == 404){
    stop("Run not found")
  }
  else if(res$status_code == 500){
    stop("Internal server error")
  }
  else{
    stop("Unidentified error")
  }
}