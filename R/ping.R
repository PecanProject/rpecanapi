##' Pings the PEcAn API server (using the URL passed in the server object)
##' to see if it is live or not. Hits the `/api/ping` API endpoint
##'
##' @name ping
##' @title Pings the PEcAn API server to see if it is live
##' @param server Server object obtained using the connect() function 
##' @return Response obtained from the `/api/ping` endpoint
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' res <- ping(server)

ping <- function(server){
  return(httr::GET(paste0(server$url, "/api/ping")))
}