##' Search PEcAn Sites from the database using search string based on
##' sitename. Hits the `/api/sites/` API endpoint with 
##' relevant query parameters
##' @name search.sites
##' @title Search for PEcAn Sites from the database
##' @param server Server object obtained using the connect() function 
##' @param sitename Search string for site name Default: "" (Returns all sites)
##' @param ignore_case Indicator of case sensitive or case insensitive search
##' @return Response obtained from the `/api/sites/` endpoint with relevant query parameters
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://pecan.localhost:80", username="carya", password="illinois")
##' 
##' # Get details of all sites
##' res1 <- search.sites(server)
##' 
##' # Get details of all sites containing 'willow' in their name
##' res2 <- search.sites(server, sitename="willow")
##' 
##' # Get details of sites where name contains "Willow" (case sensitive)
##' res3 <- search.sites(server, sitename="Willow", ignore_case=FALSE)

search.sites <- function(server, sitename="", ignore_case=TRUE){
  res <- NULL
  tryCatch(
    expr = {
      url <- URLencode(paste0(server$url, "/api/sites/?sitename=", sitename, "&ignore_case=", ignore_case))
      
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
      stop("Sites not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}
