source("run-test-list.R")
library(plotly)
library(ggplot2)
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

## Bar Chart Visualization

# function to calculate percentage
cal_percentage <- function(stages) {
  as.data.frame.matrix(prop.table(table(stages)) * 100)
}

# model percentage

model_perc <-
  data.frame(model = stages$model_id,
             success = stages$success_status)
m_per <- cal_percentage(model_perc)

rmodel <- rownames_to_column(m_per, var = "model_id")
colnames(rmodel) <- c("model_id", "fail_percent", "succ_percent")

# site percentage

site_perc <-
  data.frame(model = stages$site_id, success = stages$success_status)
s_per <- cal_percentage(site_perc)

rsite <- rownames_to_column(s_per, var = "site_id")
colnames(rsite) <- c("site_id", "fail_percent", "succ_percent")

# site_id as Y axis and success percentage as X axis

rsite$succ_percent <- as.character(rsite$succ_percent)
rsite$site_id <- as.character(rsite$site_id)

ggplot(data = rsite,
       aes(x = succ_percent,
           y = site_id,
           fill = succ_percent)) +
  geom_bar(stat = "identity",
           color = "black",
           position = position_dodge()) +
  theme_bw() +
  labs(title = "success percentage of site_id",
       x = "percentage",
       y = "site_id",
       fill = " success percentage")

# model_id as Y axis and success percentage as X axis

rmodel$succ_percent <- as.character(rmodel$succ_percent)
rmodel$model_id <- as.character(rmodel$model_id)

ggplot(data = rmodel,
       aes(x = succ_percent,
           y = model_id,
           fill = succ_percent)) +
  geom_bar(stat = "identity",
           color = "black",
           position = position_dodge()) +
  theme_bw() +
  labs(title = "success percentage of model_id",
       x = "percentage",
       y = "model_id",
       fill = " success percentage")
