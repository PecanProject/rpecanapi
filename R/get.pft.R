##' Get details of PEcAn PFT from the database using PFT id.
##' Hits the `/api/pfts/{pft_id}` API endpoint.
##' @name get.pft
##' @title Get details of PEcAn PFT from the database using PFT id
##' @param server Server object obtained using the connect() function 
##' @param pft_id ID of the model to retrieve
##' @return Response obtained from the `/api/pfts/{pft_id}` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://pecan.localhost:80", username="carya", password="illinois")
##' 
##' # Get details of the temperate.deciduous PFT (id = 41)
##' res <- get.pft(server, pft_id=41)

get.pft <- function(server, pft_id){
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/pfts/", pft_id)
      
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
      stop("PFT not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}
