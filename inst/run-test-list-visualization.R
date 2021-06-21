source("run-test-list.R")
library(plotly)

view(stages)


stages$site_id <- as.factor(stages$site_id)
stages$workflow_id <- as.factor(stages$workflow_id)
stages$model_id <- as.factor(stages$model_id)

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

# Final Status Visualization Using Scatter Plot.

scatter_plot <-
  plot_ly(
    data = stages,
    y = ~ site_id,
    x = ~ workflow_id,
    text = ~ stage,
    color = ~ site_id,
    type = "scatter",
    size = 10,
    mode = "markers",
    marker = list(
      sizemode = "diameter",
      opacity = 0.4,
      colors = "Paired"
    )
  )
scatter_plot %>% layout(
  title = 'run-test-list.R Visualization',
  xaxis = list(showgrid = FALSE),
  yaxis = list(showgrid = FALSE)
)