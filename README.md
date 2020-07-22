# rpecanapi <a href='https://dplyr.tidyverse.org'><img src='man/figures/logo.png' align="right" height="139" /></a>

[![Build Status](https://travis-ci.org/PecanProject/rpecanapi.svg?branch=master)](https://travis-ci.org/PecanProject/rpecanapi)
![GitHub](https://img.shields.io/github/license/PecanProject/rpecanapi?color=blue)

## Overview

`rpecanapi` is an open source R package to interact with the PEcAn Project Server(s) & leverage the functionality of the PEcAn bioinformatics toolbox. The Predictive Ecosystem Analyser (PEcAn) Project is an open source framework initiated to meet the demands for more accessible, transparent & repeatable modeling of ecosystems. To know more about the PEcAn Project, check out the [PEcAn Github Repository](https://github.com/PecanProject/pecan)

This package allows users to get relevant information from the PEcAn database as well as submit PEcAn workflows.

## Installation

You can install the development version of `rpecanapi` from GitHub as follows:
```R
# install.packages("devtools")
devtools::install_github("PecanProject/rpecanapi")
```

## Usage

_The following snippets assume that the PEcAn RESTful API Server is running on `http://localhost:8000`. This can be replaced with any
other appropriate PEcAn Server URL._

### Load `rpecanapi` & Create the Server Object
```R
library(rpecanapi)

server <- connect(url="http://localhost:8000", username="carya", password="illinois")
```

### Ping the PEcAn API Server
```R
ping(server)

#> $request
#> [1] "ping"

#> $response
#> [1] "pong"
```
### Get Genaral Information about the Server & PEcAn Version
```R
get.status(server)

#> $pecan_details$version
#> [1] "1.7.0"

#> $pecan_details$branch
#> [1] "develop"

#> $pecan_details$gitsha1
#> [1] "unknown"

#> $host_details$hostid
#> [1] 99

#> $host_details$hostname
#> [1] ""

#> $host_details$start
#> [1] 99000000000

#> $host_details$end
#> [1] 99999999999

#> $host_details$sync_url
#> [1] ""

#> $host_details$sync_contact
#> [1] ""
```

### Search for PEcAn Model(s):
```R
search.models(server, model_name='sip', revision='r')

#> $models
#>     model_id model_name revision
#> 1 1000000014     SIPNET     r136
#> 2 1000000022     SIPNET      ssr

#> $count
#> [1] 2
```

### Get the details of a PEcAn Model:
```R
get.model(server, model_id='1000000014')

#>     model_id model_name revision modeltype_id modeltype
#> 1 1000000014     SIPNET     r136           3     SIPNET
```

### Search for PEcAn Site(s):
```R
search.sites(server, sitename='willow')

#> $sites
#>           id                                      sitename
#> 1        676                         Willow Creek (US-WCr)
#> 2       1108 Willow Creek (WC)-Chequamegon National Forest
#> 3       1202                                  Tully_willow
#> 4       1223                   Saare SRF willow plantation
#> 5 1000005151                         Willow Creek (US-WCr)

#> $count
#> [1] 5
```

### Get the details of a PEcAn Site:
```R
get.site(server, site_id='676')

#>    id                       city     state country mat map soil notes soilnotes              sitename
#> 1 676 Park Falls Ranger District Wisconsin      US   4 815         MF           Willow Creek (US-WCr)
#>   greenhouse sand_pct clay_pct       time_zone
#> 1      FALSE    42.52    20.17 America/Chicago
```

### Get list of PEcAn Workflows:
```R
get.workflows(server, model_id='1000000022', site_id='676')

#> $workflows
#>           id properties.end                    properties.pft properties.email properties.notes properties.start
#> 1 1000009172     2004/12/31   soil.IF, temperate.deciduous.IF                                         2004/01/01
#> 2 1000009900     2004/12/31 soil.ALL, temperate.deciduous.ALL                                         2004/01/01
#> 3 1000010079     2004/12/31 soil.ALL, temperate.deciduous.ALL                                         2004/01/01
#> 4 1000010172     2004/12/31 soil.ALL, temperate.deciduous.ALL                                         2004/01/01
#> 5 1000010213     2004/12/31                 boreal.coniferous                                         2004/01/01
#>   properties.siteid properties.modelid properties.hostname properties.sitename properties.input_met properties.pecan_edit
#> 1               676         1000000022   test-pecan.bu.edu WillowCreek(US-WCr)  AmerifluxLBL.SIPNET                    on
#> 2               676         1000000022          geo.bu.edu WillowCreek(US-WCr)  AmerifluxLBL.SIPNET                    on
#> 3               676         1000000022          geo.bu.edu WillowCreek(US-WCr)  AmerifluxLBL.SIPNET                    on
#> 4               676         1000000022          geo.bu.edu WillowCreek(US-WCr)  AmerifluxLBL.SIPNET                    on
#> 5               676         1000000022          geo.bu.edu WillowCreek(US-WCr)       CRUNCEP.SIPNET                  <NA>
#>   properties.sitegroupid properties.fluxusername properties.input_poolinitcond properties.lat properties.lon
#> 1             1000000022                   pecan                            -1           <NA>           <NA>
#> 2                      1                   pecan                            -1           <NA>           <NA>
#> 3                      1                   pecan                            -1           <NA>           <NA>
#> 4                      1                   pecan                            -1                              
#> 5                      1                    <NA>                            -1                              

#> $count
#> [1] 5
```

### Get details about a PEcAn Workflow:
```R
get.workflow(server, workflow_id='1000010213')

#> $id
#> [1] "1000010213"

#> $properties
#> $properties$end
#> [1] "2004/12/31"

#> $properties$lat
#> [1] ""

#> $properties$lon
#> [1] ""

#> $properties$pft
#> [1] "boreal.coniferous"

#> $properties$email
#> [1] ""

#> $properties$notes
#> [1] ""

#> $properties$start
#> [1] "2004/01/01"

#> $properties$siteid
#> [1] "676"

#> $properties$modelid
#> [1] "1000000022"

#> $properties$hostname
#> [1] "geo.bu.edu"

#> $properties$sitename
#> [1] "WillowCreek(US-WCr)"

#> $properties$input_met
#> [1] "CRUNCEP.SIPNET"

#> $properties$sitegroupid
#> [1] "1"

#> $properties$input_poolinitcond
#> [1] "-1"
```

### Get list of Runs belonging to a PEcAn Workflow
```R
get.runs(server, workflow_id='1000009172')

#> $runs
#>     runtype ensemble_id workflow_id         id   model_id site_id parameter_list start_time finish_time
#> 1  ensemble  1000017624  1000009172 1002042201 1000000022     796     ensemble=1 2005-01-01  2011-12-31
#> 2  ensemble  1000017624  1000009172 1002042202 1000000022     796     ensemble=2 2005-01-01  2011-12-31
#> 3  ensemble  1000017624  1000009172 1002042203 1000000022     796     ensemble=3 2005-01-01  2011-12-31
#> 4  ensemble  1000017624  1000009172 1002042204 1000000022     796     ensemble=4 2005-01-01  2011-12-31
#> 5  ensemble  1000017624  1000009172 1002042205 1000000022     796     ensemble=5 2005-01-01  2011-12-31
#> ...

#> $count
#> [1] 50

#> $next_page
#> [1] "http://localhost:8000/api/runs/?workflow_id=1000009172&offset=50&limit=50"
```

### Get details about a PEcAn Run

```R
get.run(server, run_id='1002042202')
#>     runtype ensemble_id workflow_id         id   model_id site_id start_time finish_time parameter_list
#>  1 ensemble  1000017624  1000009172 1002042202 1000000022     796 2005-01-01  2011-12-31     ensemble=2
#>             created_at          updated_at          started_at         finished_at
#>  1 2018-04-11 22:20:31 2018-04-11 22:22:20 2018-04-11 18:22:08 2018-04-11 18:22:20
```

### Submit a PEcAn Workflow in XML format
_This assumes the presence of an XML file `test.xml` containing the specifications of the workflow._

```R
submit.workflow.xml(server, xmlFile='test.xml')
#> $workflow_id
#> [1] 99000000001

#> $status
#> [1] "Submitted successfully"
```
***

_Please note that this package is under active development & some functionality may not be ready to use._
