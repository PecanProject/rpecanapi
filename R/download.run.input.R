##' Downloads & saves the desired input file for a run.
##' Hits the `/api/run/{run_id}/input/{filename}` API endpoint
##' @name download.run.input
##' @title Download & save the desired input file for a run
##' @param server Server object obtained using the connect() function
##' @param run_id ID of the PEcAn run whose input is needed
##' @param filename Name of the input file to be downloaded
##' @param save_as File name to save the downloaded file as. Default: NULL (same
##' name as `filename` would be used)
##' @return Response obtained from the `/api/run/{run_id}/input/{filename}` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://pecan.localhost:80", username="carya", password="illinois")
##' 
##' # Download the 'sipnet.clim' input for the run with id = '99000000282'
##' download.run.input(server, run_id=99000000282, filename='sipnet.clim', save_as='test.sipnet.clim')

download.run.input <- function(server, run_id, filename, save_as=NULL){
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/runs/", run_id, "/input/", filename)
      
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
      stop("Input file not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}
