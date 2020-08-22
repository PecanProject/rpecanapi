##' Downloads & saves the desired file for a workflow.
##' Hits the `/api/workflows/{id}/file/{filename}` API endpoint
##' @name download.workflow.file
##' @title Download & save the desired file for a workflow
##' @param server Server object obtained using the connect() function
##' @param workflow_id ID of the PEcAn workflow whose file is needed
##' @param filename Name of the file to be downloaded
##' @param save_as File name to save the downloaded file as. Default: NULL (same
##' name as `filename` would be used)
##' @return Response obtained from the `/api/workflows/{id}/file/{filename}` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' \dontrun{
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Download the 'ensemble.ts.99000000017.NPP.2002.2002.Rdata' output file for the workflow with id = 99000000031
##' download.workflow.file(server, workflow_id=99000000031, filename='ensemble.ts.99000000017.NPP.2002.2002.Rdata')
##' }

download.workflow.file <- function(server, workflow_id, filename, save_as=NULL){
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/workflows/", workflow_id, "/file/", filename)
      
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
      if(is.null(save_as)){
        save_as = filename
      }
      writeBin(res$content, save_as)
    }
    else if(res$status_code == 401){
      stop("Invalid credentials")
    }
    else if(res$status_code == 403){
      stop("Access forbidden")
    }
    else if(res$status_code == 404){
      stop("File not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}