source("run-test-list.R")
library(plotly)
library(tidyverse)

view(stages)

stages$site_id <- as.character(stages$site_id)
stages$workflow_id <- as.character(stages$workflow_id)
stages$model_id <- as.character(stages$model_id)
stages$stage <- as.character(stages$stage)

stages$success_status <-
  ifelse(grepl("DONE", stages$stage), TRUE, FALSE)

color_fun <-
  ifelse(grepl("TRUE", stages$success_status), "red", "green")

# Final Status Visualization Using Scatter Plot.

scatter_plot <-
  plot_ly(
    data = stages,
    y = ~ model_id,
    x = ~ site_id,
    text = ~ stage,
    color = ~ success_status,
    type = "scatter",
    size = 10,
    mode = "markers",
    marker = list(
      sizemode = "diameter",
      opacity = 0.4,
      color = color_fun
    )
  )
scatter_plot %>% layout(
  title = 'run-test-list.R Visualization',
  xaxis = list(showgrid = FALSE),
  yaxis = list(showgrid = FALSE)
)

# Final Status Visualization Using Bar Chart.

bar_plot <- stages %>%
  plot_ly(
    type = "bar",
    y = ~ site_id,
    x = ~ workflow_id,
    text = ~ stage,
    color = ~ model_id,
    marker = list(colors = "Paired",
                  opacity = 1.0),
    hovertemplate = paste("<b>%{text}</b>")
  )
bar_plot %>% layout(
  title = "run-test-list.R Visualization",
  xaxis = list(showgrid = FALSE),
  yaxis = list(showgrid = FALSE)
)
