##' Search PEcAn PFTs from the database using search string based on
##' PFT name, type & model type. Hits the `/api/pfts/` API endpoint  
##' with relevant query parameters
##' @name search.pfts
##' @title Search for PEcAn PFTs from the database
##' @param server Server object obtained using the connect() function 
##' @param pft_name Search string for pft name. Default: "" (Returns all pfts)
##' @param pft_type PFT type to be filtered. Could be one out of "plant", "cultivar" or "". 
##' Default: "" (Returns PFTs of all types)
##' @param model_type Search string for model type associated with PFT. Default: "" (Returns PFTs with any model type)
##' @param ignore_case Indicator of case sensitive or case insensitive search
##' @return Response obtained from the `/api/pfts/` endpoint with relevant query parameters
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of all PFTs
##' res1 <- search.pfts(server)
##' 
##' # Get details of all PFTs containing 'temperate' in their name
##' res2 <- search.pfts(server, pft_name="temperate")
##' 
##' # Get details of all PFTs containing of 'cultivar' type
##' res3 <- search.pfts(server, pft_type="cultivar")
##' 
##' # Get details of PFTs with 'SIPNET' model type
##' res4 <- search.pfts(server, model_type='SIPNET')

search.pfts <- function(server, pft_name="", pft_type="", model_type="", ignore_case=TRUE){
  if(! is.element(pft_type, c("", "plant", "cultivar"))) {
    stop("pft_type can be only one of '', 'plant' or 'cultivar'")
  }
  
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/pfts/?pft_name=", pft_name, "&pft_type=", pft_type, "&model_type=", model_type, "&ignore_case=", ignore_case)
      
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
      stop("PFTs not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}