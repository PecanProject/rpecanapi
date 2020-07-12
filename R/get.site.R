##' Get details of PEcAn Site from the database using site id.
##' Hits the `/api/sites/{site_id}` API endpoint.
##' @name get.site
##' @title Get details of PEcAn Site from the database using site id
##' @param server Server object obtained using the connect() function 
##' @param site_id ID of the model to retrieve
##' @return Response obtained from the `/api/sites/{site_id}` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="https://pecan-tezan.ncsa.illinois.edu", username="carya", password="illinois")
##' 
##' # Get details of the WillowCreek(US-WCr) site (id = 676)
##' res <- get.site(server, site_id=676)

get.site <- function(server, site_id){
  url <- paste0(server$url, "/api/sites/", site_id)
  
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
    stop("Site not found")
  }
  else if(res$status_code == 500){
    stop("Internal server error")
  }
  else{
    stop("Unidentified error")
  }
}