##' Submit a PEcAn workflow using various user-defined parameters
##' Hits the `POST /api/workflows/` API endpoint.
##' @name submit.workflow
##' @param server Server object obtained using the connect() function
##' @param model_id ID of the model to be used (character)
##' @param site_id ID of the site to be used (character)
##' @param pfts List of PFTs to be used (list)
##' @param start_date Starting date of the analysis (character)
##' @param end_date Ending date of the analysis (character)
##' @param inputs Inputs to the workflow (including meteorological data, etc.) (object)
##' @param ensemble_size Ensemble size for the workflow. Default: 1
##' @param sensitivity_variable Variable for performing sensitivity. Default: NPP
##' @param meta.analysis Meta-analysis settings object for the workflow. Default: NULL (uses default parameters)
##' @param sensitivity.analysis Whether or not to perform a sensitivity analysis. Can also take
##' a sensitivity setting object as input. Default: FALSE (logical or list)
##' @param notes Additional notes that the user need to specify for the submitted workflow. Default: NULL
##' @param workflow_list_mods List of additional changes to be applied to the
##'   workflow list. Passed to [utils::modifyList()]. Default = `list() (no changes)`.
##' @return Response obtained from the `POST /api/workflows/` endpoint
##' @author Tezan Sahu, Alexey Shiklomanov
##' @export
##' @examples
##' server <- connect(url="http://localhost:8000", username="carya", password="illinois")
##' 
##' # Submit a workflow with the SIPNET r136 model (id = 1000000014) for Niwot Ridge site (id = 772) with 
##' # PFT as 'temperate.coniferous' starting from 01-01-2002 to 31-12-2003 using the input met data with
##' # id = 99000000003
##' res <- submit.workflow(server, model_id=1000000014, site_id=772, pfts=c("temperate.coniferous"), start_date="2002-01-01", 
##'   end_date="2003-12-31", inputs=list(met=list(id=99000000003)))

submit.workflow <- function(server, model_id, site_id, pfts, start_date, end_date, inputs, meta.analysis = list(),
                            ensemble_size=1, sensitivity_variable = "NPP", sensitivity.analysis = FALSE, notes = NULL,
                            workflow_list_mods = list()) {
  # Prepare the workflow based on the parameters set by user
  workflow <- list()
  workflow$pfts <- lapply(pfts, function(x) list(name = x))
  names(workflow$pfts) <- rep("pft", length(pfts))

  workflow$model <- list(id = model_id)
  
  workflow$run <- list(
    start.date = start_date,
    end.date = end_date,
    inputs = inputs,
    site = list(
      id = site_id,
      met.start = start_date,
      met.end = end_date
    )
  )

  # Set the default ensemble settings
  workflow$ensemble <- list(
    size = ensemble_size,
    variable = sensitivity_variable,
    samplingspace = list(
      parameters = list(method = "uniform"),
      met = list(method = "sampling")
    )
  )

  workflow$meta.analysis <- modifyList(
    list(iter = 3000, random.effects = FALSE),
    meta.analysis
  )

  # If sensitivity.analysis is set to TRUE, use the default settings to populate the workflow
  if (is.logical(sensitivity.analysis)) {
    if (sensitivity.analysis) {
      workflow$sensitivity.analysis <- list(
        quantiles = list(sigma1 = -2, sigma2 = -1, sigma3 = 1, sigma4 = 2)
      )
    }
    # Else if FALSE, do nothing
  }
  # If a list containing configs (sigmas, etc.) is passed, use that to populate thw workflow
  else if (is.list(sensitivity.analysis)) {
    workflow$sensitivity.analysis <- sensitivity.analysis
  }
  # Else, do not populate the sensitivity analysis settings

  if (!is.null(notes)) {
    workflow$info$notes <- notes
  }

  # Apply any additional user changes (if any)
  workflow <- modifyList(workflow, workflow_list_mods)

  # Submit the prepared workflow to the PEcAn API in XML format
  # NOTE: Use XML here because JSON doesn't like duplicate tags (which we use
  # for PFTs, among other things).
  pecanxml <- listToXML(workflow, "pecan")
  tf <- tempfile(fileext = ".xml")
  on.exit(file.remove(tf), add = TRUE)
  invisible(XML::saveXML(pecanxml, tf))
  xml_string <- paste0(xml2::read_xml(tf))

  res <- NULL
  tryCatch({
    url <- paste0(server$url, "/api/workflows/")
    if (!is.null(server$username) && !is.null(server$password)) {
      res <- httr::POST(
        url,
        httr::authenticate(server$username, server$password),
        httr::content_type("application/xml"),
        body = xml_string
      )
    } else {
      res <- httr::POST(
        url,
        httr::content_type("application/xml"),
        body = xml_string
      )
    }
  }, error = function(e) {
    message("Server request failed with the following error:\n",
            conditionMessage(e))
  })
  
  if (!is.null(res)) {
    if (res$status_code == 201) {
      return(httr::content(res))
    }
    else if (res$status_code == 401){
      stop("Invalid credentials")
    }
    else if(res$status_code == 500){
      output <- httr::content(res)
      stop("Internal server error:\n",
           output[[1]], "\n",
           output[[2]])
    }
    else{
      stop("Encountered other error.\n",
           "Code: ", res$status_code, "\n",
           "Message: ", httr::content(res)$error)
    }
  }
}

listToXML <- function(item, tag) {
  if (typeof(item) != "list") {
    if (length(item) > 1) {
      xml <- XML::xmlNode(tag)
      for (name in names(item)) {
        XML::xmlAttrs(xml)[[name]] <- item[[name]]
      }
      return(xml)
    } else {
      return(XML::xmlNode(tag, item))
    }
  }
  if (identical(names(item), c("text", ".attrs"))) {
    xml <- XML::xmlNode(tag, item[["text"]])
  } else {
    xml <- XML::xmlNode(tag)
    for (i in seq_along(item)) {
      if (is.null(names(item)) || names(item)[i] != ".attrs") {
        xml <- XML::append.xmlNode(xml, listToXML(item[[i]], names(item)[i]))
      }
    }
  }
  attrs <- item[[".attrs"]]
  for (name in names(attrs)) {
    XML::xmlAttrs(xml)[[name]] <- attrs[[name]]
  }
  return(xml)
}
