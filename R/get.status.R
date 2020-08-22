##' Obtain general information about PEcAn & the details of the database host
##' Hits the `/api/status` API endpoint
##'
##' @name get.status
##' @title Gets general information about PEcAn & the details of the database host
##' @param server Server object obtained using the connect() function 
##' @return Response obtained from the `/api/status` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' \dontrun{
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' res <- get.status(server)
##' }

get.status <- function(server){
  res <- NULL
  tryCatch(
    expr = {
      res <- httr::GET(paste0(server$url, "/api/status"))
    },
    error = function(e) {
      message("Sorry! Server not responding.")
    }
  )
  
  if(! is.null(res)) {
    if(res$status_code == 200){
      return(jsonlite::fromJSON(rawToChar(res$content)))
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}
