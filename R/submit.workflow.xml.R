##' Submit an XML file as a PEcAn workflow.
##' Hits the `POST /api/workflows/` API endpoint
##'
##' @name submit.workflow.xml
##' @title Submit an XML file as a PEcAn workflow & obtain the workflow_id
##' @param server Server object obtained using the connect() function
##' @param xmlFile XML file containing the workflow configurations
##' @return Response obtained from the `POST /api/workflow/` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' res <- submit.workflow.xml(server, "api.sipnet.xml")

submit.workflow.xml <- function(server, xmlFile){
  xml_string <- paste0(xml2::read_xml(xmlFile))
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/workflows/")
      
      if(! is.null(server$username) && ! is.null(server$password)){
        res <- httr::POST(
          url,
          httr::authenticate(server$username, server$password),
          httr::content_type("application/xml"),
          body = xml_string
        )
      }
      else{
        res <- httr::POST(
          url,
          httr::content_type("application/xml"),
          body = xml_string
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
