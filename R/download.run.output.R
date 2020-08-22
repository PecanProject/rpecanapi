##' Downloads & saves the desired output file for a run.
##' Hits the `/api/run/{run_id}/output/{filename}` API endpoint
##' @name download.run.output
##' @title Download & save the desired output file for a run
##' @param server Server object obtained using the connect() function
##' @param run_id ID of the PEcAn run whose output is needed
##' @param filename Name of the output file to be downloaded
##' @param save_as File name to save the downloaded file as. Default: NULL (same
##' name as `filename` would be used)
##' @return Response obtained from the `/api/run/{run_id}/output/{filename}` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Download the 'README.txt' output for the run with id = '99000000282'
##' download.run.output(server, run_id=99000000282, filename='README.txt', save_as='test.README.txt')

download.run.output <- function(server, run_id, filename, save_as=NULL){
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/runs/", run_id, "/output/", filename)
      
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
      stop("Output file not found")
    }
    else if(res$status_code == 500){
      stop("Internal server error")
    }
    else{
      stop("Unidentified error")
    }
  }
}
