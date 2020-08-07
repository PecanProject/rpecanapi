##' Search PEcAn Input files from the database using search based on
##' model_id & site_id Hits the `/api/inputs/` API endpoint with 
##' relevant query parameters
##' @name search.inputs
##' @title Search for PEcAn Models from the database
##' @param server Server object obtained using the connect() function 
##' @param model_id ID of the model associated with the input, Default: NULL (Returns all models)
##' @param site_id ID of the model associated with the input, Default: NULL (Returns all sites)
##' @param format_id ID of the format associated with the input, Default: NULL (Returns all formats)
##' @param host_id ID of the host containing the input, Default: NULL (Returns all hosts)
##' @param offset The number of workflows to skip before starting to collect the result set.
##' @param limit The number of workflows to return (Available values : 10, 20, 50, 100, 500)
##' @return Response obtained from the `/api/inputs/` endpoint with relevant query parameters
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Get details of all inputs
##' res1 <- search.inputs(server)
##' 
##' # Get details of all inputs for the SIPNET ssr model (id = 1000000022)
##' res2 <- search.inputs(server, model_id="1000000022")
##' 
##' # Get details of all inputs for the SIPNET ssr model (id = 1000000022) & Niwor Ridge site (id = 772)
##' res3 <- search.inputs(server, model_id="1000000022", site_id="772")

search.inputs <- function(server, model_id=NULL, site_id=NULL, format_id=NULL, host_id=NULL, offset=0, limit=50){
  if(! is.element(limit, c(10, 20, 50, 100, 500))) {
    stop("limit can be only one of 10, 20, 50, 100 or 500")
  }
  
  url <- paste0(server$url, "/api/inputs/?")
  
  if(!is.null(model_id)) {
    url <- paste0(url, "&model_id=", model_id)
  }
  if(!is.null(site_id)) {
    url <- paste0(url, "&site_id=", site_id)
  }
  if(!is.null(format_id)) {
    url <- paste0(url, "&format_id=", format_id)
  }
  if(!is.null(host_id)) {
    url <- paste0(url, "&host_id=", host_id)
  }
  
  url <- paste0(url, "&offset=", offset, "&limit=", limit)
  url <- stringr::str_replace(url, "\\?&", "\\?")
  
  res <- NULL
  tryCatch(
    expr = {
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
      stop("Inputs not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}