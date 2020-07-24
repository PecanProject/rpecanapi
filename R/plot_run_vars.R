##' Plot the desired variables from the results of a PEcAn run.
##' Hits the `/api/run/{run_id}/graph/{year}/{y_var}` API endpoint
##' @name plot_run_vars
##' @title Plot the desired variables from the results of a PEcAn run
##' @param server Server object obtained using the connect() function
##' @param run_id ID of the PEcAn run whose details are needed
##' @param year the year this data is for
##' @param yvar the variable to plot along the y-axis.
##' @param xvar the variable to plot along the x-axis, by default time is used.
##' @param width the width of the image generated, default is 800 pixels.
##' @param height the height of the image generated, default is 600 pixels.
##' @param filename File name to save the generated plot, default is 'plot.png'.
##' @param display Boolean to indicate if the generated pot should be displayed
##' @return Response obtained from the `/api/run/{run_id}/graph/{year}/{y_var}` endpoint
##' @author Tezan Sahu
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Plot the Gross Primary Productivity vs Time for the run with ID '99000000282' for the year 2002
##' plot_run_vars(server, run_id=99000000282, year=2002, y_var="GPP")
##' 
##' # Plot the Total Respiration vs Soil Respiration for the run with ID '99000000283' for the year 2002 of custom size
##' plot_run_vars(server, run_id=99000000283, year=2002, y_var="TotalResp", x_var="SoilResp", width=500, height=400)

plot_run_vars <- function(server, run_id, year, y_var, x_var="time", width=800, height=600, filename="plot.png", display=TRUE){
  url <- paste0(server$url, "/api/runs/", run_id, "/graph/", year, "/", y_var, "?x_var=", x_var, "&width=", width, "&height=", height)
  
  if(! is.null(server$username) && ! is.null(server$password)){
    res <- httr::GET(
      url,
      httr::authenticate(server$username, server$password)
    )
  }
  else{
    res <- httr::GET(url)
  }
  
  if(res$status_code == 200){
    writeBin(res$content, filename)
    print(paste0("Successfully saved image to ", filename))
    if(display){
      img <- png::readPNG(filename)
      grid::grid.raster(img)
    }
  }
  else if(res$status_code == 401){
    stop("Invalid credentials")
  }
  else if(res$status_code == 404){
    stop("Run details not found")
  }
  else if(res$status_code == 500){
    stop("Internal server error")
  }
  else{
    stop("Unidentified error")
  }
}