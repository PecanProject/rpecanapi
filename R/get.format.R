##' Get details of PEcAn Format from the database using format id.
##' Hits the `/api/formats/{format_id}` API endpoint.
##' @name get.format
##' @title Get details of PEcAn Model from the database using model id
##' @param server Server object obtained using the connect() function 
##' @param format_id ID of the model to retrieve
##' @return Response obtained from the `/api/formats/{format_id}` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://pecan.localhost:80", username="carya", password="illinois")
##' 
##' # Get details of the Ameriflux.level4.h format (id = 19)
##' res <- get.format(server, format_id=19)

get.format <- function(server, format_id){
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/formats/", format_id)
      
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
      stop("Format not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}
