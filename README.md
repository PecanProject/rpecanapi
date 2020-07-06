# rpecanapi <a href='https://dplyr.tidyverse.org'><img src='man/figures/logo.png' align="right" height="139" /></a>

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

```R
library(rpecanapi)

server <- connect(url="http://localhost:8000", username="carya", password="illinois")

ping(server)
#> $request
#> [1] "ping"
#> $response
#> [1] "pong"

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

get.models(server, 'SIPNET', 'ssr')
#> $models
#>     model_id model_name revision modeltype_id model_type
#> 1 1000000022     SIPNET      ssr            3     SIPNET

```

***

_Please note that this package is under active development & some functionality may not be ready to use._
