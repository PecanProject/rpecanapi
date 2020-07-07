##' Creates a server object containing the base URL of the PEcAn API server, 
##' the username & password, which can be simply passed into other functions 
##' to make requests to the PEcAn API.
##' Currently, there is no validation. In future, we may validate the username-password 
##' pair by hitting the appropriate API endpoint
##'
##' @name connect
##' @title Creates a server object that can be passed into other functions for making requests to the PEcAn API
##' @param url Base URL of the PEcAn API Server
##' @param username Username
##' @param password Password corresponding to the username
##' @return A server object that can be passed into other functions for making requests to the PEcAn API
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")

connect <- function(url, username=NULL, password=NULL){
  res <- list(url=url, username=username, password=password)
  return(res)
}