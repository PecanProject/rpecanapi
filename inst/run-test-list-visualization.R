source("run-test-list.R")
library(plotly)
library(ggplot2)
library(rpecanapi)

stages$site_id <- as.character(stages$site_id)
stages$workflow_id <- as.character(stages$workflow_id)
stages$model_id <- as.character(stages$model_id)
stages$stage <- as.character(stages$stage)

test_list <-
  read.csv("inst/integration-test-list.csv",
           comment.char = "#",
           na.strings = "")

stages$success_status <-
  ifelse(grepl("DONE", stages$stage), TRUE, FALSE)

# Add Met Column

stages$met <- test_list$met[match(stages$notes, test_list$notes)]

# Success Percentages of Models, Sites and Met

site_succ_percent <-
  tapply(stages$success_status, stages$site_name, mean) * 100
model_succ_percent <-
  tapply(stages$success_status, stages$model_name, mean) * 100
met_succ_percent <-
  tapply(stages$success_status, stages$met, mean) * 100

# Get models & sites Name

models_name <- search.models(server)
sites_name <- search.sites(server)
stages$model_name <-
  models_name$models$model_name[match(stages$model_id, models_name$models$model_id)]
stages$site_name <-
  sites_name$sites$sitename[match(stages$site_id, sites_name$sites$id)]

# Final Status Visualization Using Scatter Plot.


color_var <-
  ifelse(grepl("TRUE", stages$success_status), "red", "green")

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

# site_id as Y axis and success percentage as X axis

s_df <- data.frame(site_succ_percent)
all_sites <- rownames_to_column(s_df, var = "site_name")

ggplot(data = all_sites,
       aes(x = site_name,
           y = site_succ_percent,
           fill = site_succ_percent)) +
  geom_bar(stat = "identity",
           color = "black",
           position = position_dodge()) +
  scale_x_discrete(guide = guide_axis(n.dodge = 4)) +
  theme_bw() +
  labs(title = "Success Percentage of Sites",
       x = "Sites Name",
       y = "Percentage(%)",
       fill = " Success Percentage")

# model_id as Y axis and success percentage as X axis

m_df <- data.frame(model_succ_percent)
all_models <- rownames_to_column(m_df, var = "model_name")

ggplot(data = all_models,
       aes(x = model_name,
           y = model_succ_percent,
           fill = model_succ_percent)) +
  geom_bar(stat = "identity",
           color = "black",
           position = position_dodge()) +
  theme_bw() +
  labs(title = "Success Percentage of Models",
       x = "Models Name",
       y = "Percentage(%)",
       fill = " Success Percentage")

# met as Y axis and success percentage as X axis
met_df <- data.frame(met_succ_percent) %>%
  na.omit(met_df)
all_met <- rownames_to_column(met_df, var = "met_val")

ggplot(data = all_met,
       aes(x = met_val,
           y = met_succ_percent,
           fill = met_succ_percent)) +
  geom_bar(stat = "identity",
           color = "black",
           position = position_dodge()) +
  theme_bw() +
  labs(title = "Success Percentage of Met",
       x = "Met",
       y = "Percentage(%)",
       fill = " Success Percentage")
