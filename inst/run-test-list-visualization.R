source("run-test-list.R")
library(plotly)
library(ggplot2)
library(rpecanapi)

stages$site_id <- as.character(stages$site_id)
stages$workflow_id <- as.character(stages$workflow_id)
stages$model_id <- as.character(stages$model_id)
stages$stage <- as.character(stages$stage)

test_list <- read.csv("inst/integration-test-list.csv", comment.char = "#",
                      na.strings = "")

stages$success_status <-
  ifelse(grepl("DONE", stages$stage), TRUE, FALSE)

color_var <-
  ifelse(grepl("TRUE", stages$success_status), "red", "green")



# Get models & sites Name

models_name <- search.models(server)
sites_name <- search.sites(server)
stages$model_name <- models_name$models$model_name[match(stages$model_id, models_name$models$model_id)]
stages$site_name <- sites_name$sites$sitename[match(stages$site_id, sites_name$sites$id)]

# Final Status Visualization Using Scatter Plot.

scatter_plot <-
  plot_ly(
    data = stages,
    x = ~ site_name,
    y = ~ model_name,
    text = ~ stage,
    color = ~ success_status,
    type = "scatter",
    size = 10,
    mode = "markers",
    marker = list(
      sizemode = "diameter",
      opacity = 0.4,
      color = color_var
    )
  )
scatter_plot %>% layout(
  title = 'run-test-list.R Visualization',
  xaxis = list(showgrid = TRUE),
  yaxis = list(showgrid = TRUE)
)

## Final Status Visualization Using Bar Chart

# function to calculate percentage
cal_percentage <- function(stages) {
  as.data.frame.matrix(prop.table(table(stages)) * 100)
}

# model percentage

model_perc <-
  data.frame(model = stages$model_name,
             success = stages$success_status)
m_per <- cal_percentage(model_perc)

rmodel <- rownames_to_column(m_per, var = "model_name")
colnames(rmodel) <- c("model_name", "fail_percent", "succ_percent")

# site percentage

site_perc <-
  data.frame(model = stages$site_name, success = stages$success_status)
s_per <- cal_percentage(site_perc)

rsite <- rownames_to_column(s_per, var = "site_name")
colnames(rsite) <- c("site_name", "fail_percent", "succ_percent")

# met percentage

met_perc <-
  data.frame(model = stages$met, success = stages$success_status)
m_per <- cal_percentage(met_perc)

rmet <- rownames_to_column(m_per, var = "r_met")
colnames(rmet) <- c("r_met", "fail_percent", "succ_percent")

# site_id as Y axis and success percentage as X axis

rsite$succ_percent <- as.character(rsite$succ_percent)

ggplot(data = rsite,
       aes(x = succ_percent,
           y = site_name,
           fill = succ_percent)) +
  geom_bar(stat = "identity",
           color = "black",
           position = position_dodge()) +
  theme_bw() +
  labs(title = "success percentage of site_name",
       x = "percentage",
       y = "site_name",
       fill = " success percentage")

# model_id as Y axis and success percentage as X axis

rmodel$succ_percent <- as.character(rmodel$succ_percent)

ggplot(data = rmodel,
       aes(x = succ_percent,
           y = model_name,
           fill = succ_percent)) +
  geom_bar(stat = "identity",
           color = "black",
           position = position_dodge()) +
  theme_bw() +
  labs(title = "success percentage of model_name",
       x = "percentage",
       y = "model_name",
       fill = " success percentage")

# met as Y axis and success percentage as X axis

stages$met <- test_list$met[match(stages$notes, test_list$notes)]
test_list$met <- as.character(test_list$met)

rmet$succ_percent <- as.character(rmet$succ_percent)

ggplot(data = rmet,
       aes(x = succ_percent,
           y = r_met,
           fill = succ_percent)) +
  geom_bar(stat = "identity",
           color = "black",
           position = position_dodge()) +
  theme_bw() +
  labs(title = "success percentage of met",
       x = "percentage",
       y = "met",
       fill = " success percentage")


