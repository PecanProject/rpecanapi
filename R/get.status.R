##' Obtain general information about PEcAn & the details of the database host
##' Hits the `/api/status` API endpoint
##'
##' @name get.status
##' @title Gets general information about PEcAn & the details of the database host
##' @param server Server object obtained using the connect() function 
##' @return Response obtained from the `/api/status` endpoint
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' res <- get.status(server)

get.status <- function(server){
  return(httr::GET(paste0(server$url, "/api/status")))
}