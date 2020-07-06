##' Retrive a list of all PEcAn runs from the database that belong to a 
##' specific workflow
##' @name get.runs
##' @title Get list of PEcAn Runs that belong to a specific workflow
##' @param server Server object obtained using the connect() function 
##' @param workflow_id ID of the PEcAn workflow for which all runs are to be retrieved
##' @return Response obtained from the `/api/runs/` endpoint with relevant query parameters
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of all runs for the workflow with ID '1000009172'
##' res <- get.runs(server, "1000009172")

get.runs <- function(server, workflow_id){
  url <- paste0(server$url, "/api/runs/?workflow_id=", workflow_id)
  
  res <- httr::GET(
    url,
    httr::authenticate(server$username, server$password)
  )
  
  return(res)
}