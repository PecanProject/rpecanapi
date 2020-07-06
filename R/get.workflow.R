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
##' res <- get.workflow(server, "1000009172")

get.workflow <- function(server, workflow_id){
  res <- httr::GET(
    paste0(server$url, "/api/workflows/", workflow_id),
    httr::authenticate(server$username, server$password)
  )
  return(res)
}