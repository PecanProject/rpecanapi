##' Submit a JSON file as a PEcAn workflow.
##' Hits the `POST /api/workflows/` API endpoint
##'
##' @name submit.workflow.json
##' @title Submit a JSON file as a PEcAn workflow & obtain the workflow_id
##' @param server Server object obtained using the connect() function
##' @param jsonFile JSON file containing the workflow configurations
##' @return Response obtained from the `POST /api/workflow/` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://pecan.localhost:80", username="carya", password="illinois")
##' res <- submit.workflow.json(server, "api.sipnet.json")

submit.workflow.json <- function(server, jsonFile){
  json_content <- jsonlite::read_json(jsonFile)
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/workflows/")
      
      if(! is.null(server$username) && ! is.null(server$password)){
        res <- httr::POST(
          url,
          httr::authenticate(server$username, server$password),
          body = json_content,
          encode='json'
        )
      }
      else{
        res <- httr::POST(
          url,
          body = json_content,
          encode='json'
        )
      }
    },
    error = function(e) {
      message("Sorry! Server not responding.")
    }
  )
  
  if(! is.null(res)) {
    if(res$status_code == 201){
      return(jsonlite::fromJSON(rawToChar(res$content)))
    }
    else if(res$status_code == 401){
      stop("Invalid credentials")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}
