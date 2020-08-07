##' Downloads & saves the desired input file.
##' Hits the `/api/inputs/{input_id}` API endpoint
##' @name download.input
##' @title Download & save the desired input file
##' @param server Server object obtained using the connect() function
##' @param input_id ID of the PEcAn input to be downloaded
##' @param save_as File name to save the downloaded file as. Default: "pecan_input_file"
##' @return Response obtained from the `/api/inputs/{input_id}` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Download the 'niwot.clim' file (id = 99000000003)
##' download.input(server, input_id='99000000003', save_as='local.niwot.clim')

download.input <- function(server, input_id, save_as="pecan_input_file"){
  res <- NULL
  tryCatch(
    expr = {
      url <- paste0(server$url, "/api/inputs/", input_id)
      
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