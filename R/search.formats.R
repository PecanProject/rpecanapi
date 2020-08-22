##' Search PEcAn Formats from the database using search string based on
##' format_name & mimetype Hits the `/api/formats/` API endpoint with 
##' relevant query parameters
##' @name search.formats
##' @title Search for PEcAn Models from the database
##' @param server Server object obtained using the connect() function 
##' @param format_name Search string for format name. Default: "" (Returns all models)
##' @param revision Search string for revision. Default: "" (Returns all revisions for a model)
##' @param ignore_case Indicator of case sensitive or case insensitive search
##' @return Response obtained from the `/api/formats/` endpoint with relevant query parameters
##' @author Tezan Sahu
##' @export
##' @examples
##' \dontrun{
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of all formats
##' res1 <- search.formats(server)
##' 
##' # Get details of all formats containing 'ameriflux' in their name
##' res2 <- search.formats(server, format_name="ameriflux")
##' 
##' # Get details of the 'ameriflux' formats of 'csv' mimetype
##' res3 <- search.formats(server, format_name="ameriflux", mimetype="csv")
##' }

search.formats <- function(server, format_name="", mimetype="", ignore_case=TRUE){
  res <- NULL
  tryCatch(
    expr = {
      url <- URLencode(paste0(server$url, "/api/formats/?format_name=", format_name, "&mimetype=", mimetype, "&ignore_case=", ignore_case))
      
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
      stop("Formats not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}
