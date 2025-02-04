## Community reshuffling ##
## MS_3 Project MEIOSIS ##
# Summary of the Workflow
# 1️. Load data and clean missing values.
# 2️. Compute CWLI to quantify butterfly body size changes.
# 3️. Generate a null model by shuffling species data.
# 4️. Compare observed vs. null distributions to detect significant deviations.
# 5️. Visualize trends over time and identify significant shifts.
# 6️. Fit a mixed-effects model to analyze CWLI trends while accounting for site variability.
# 7️. Run a Generalized Linear Model (GLM) to test for environmental effects.
# 8️. Check and correct overdispersion using a Negative Binomial model.
# 9️. Save final results for documentation.


# Load required libraries ------------------------------------------------
library(dplyr)
library(ggplot2)
library(nlme)
library(tidyr)
library(MASS)  # For negative binomial models
library(car)   # For VIF analysis
library(broom) # For tidy model outputs
library(gridExtra)

# Set working directory and load data -------------------------------------
setwd("H:/My Drive/Greece/A_ELIDEK_mine/WP3_DATA ANALYSIS/Output2/FIN_dfs/")
butterfly_data <- read.csv("swissdata_all.csv")

# Data Preprocessing ------------------------------------------------------
# Convert necessary columns to appropriate data types
butterfly_data$GenusSpecies <- as.factor(butterfly_data$GenusSpecies)
butterfly_data$id_site <- as.factor(butterfly_data$id_site)

# Remove rows with missing length_synthesis values
filtered_data <- butterfly_data %>%
  filter(!is.na(length_synthesis))

# Step 1: Compute Observed Community Weighted Length Index (CWLI) ---------
obs_cwli <- filtered_data %>%
  group_by(id_site, year) %>%
  summarise(
    CWLI = weighted.mean(length_synthesis, w = individuals, na.rm = TRUE),
    total_count = sum(individuals, na.rm = TRUE),
    .groups = "drop"
  )

# Step 2: Generate Null Distributions --------------------------------------
generate_null_model <- function(data, n_iter = 1000) {
  null_results <- list()
  
  for (i in 1:n_iter) {
    null_data <- data %>%
      group_by(id_site, year) %>%
      mutate(Count = sample(individuals, replace = FALSE)) %>%
      ungroup()
    
    null_cli <- null_data %>%
      group_by(id_site, year) %>%
      summarise(
        CLI = sum(Count * length_synthesis) / sum(Count),
        .groups = "drop"
      )
    
    null_results[[i]] <- null_cli %>% mutate(Iteration = i)
  }
  
  bind_rows(null_results)
}

# Generate Null Models
set.seed(123)  # Ensure reproducibility
null_model_results <- generate_null_model(filtered_data, n_iter = 999)

# Step 3: Compare Observed vs. Null Distributions -------------------------
null_summary <- null_model_results %>%
  group_by(id_site, year) %>%
  summarise(
    null_mean = mean(CLI),
    null_sd = sd(CLI),
    .groups = "drop"
  )

# Merge Observed CWLI with Null Distributions
comparison_data <- obs_cwli %>%
  left_join(null_summary, by = c("id_site", "year")) %>%
  mutate(
    z_score = (CWLI - null_mean) / null_sd,
    p_value = 2 * pnorm(abs(z_score), lower.tail = FALSE),  # Two-tailed test
    Significant = ifelse(p_value < 0.05, "Significant", "Not Significant")
  )

# Step 4: Visualization ---------------------------------------------------
ggplot(comparison_data, aes(x = year, y = CWLI, group = id_site, color = Significant)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  scale_color_manual(values = c("Significant" = "black", "Not Significant" = "grey")) +
  theme_bw() +
  labs(
    title = "Community Length Index (CLI) over Time",
    x = "Year",
    y = "Community Weighted Length Index (CWLI)"
  )

# Step 5: Trend Analysis Over Time ----------------------------------------
analyze_changes <- function(cli_observed, null_models) {
  observed_trend <- cli_observed %>%
    group_by(year) %>%
    summarise(mean_cli = mean(CWLI), .groups = "drop")
  
  null_trend <- null_models %>%
    group_by(year, Iteration) %>%
    summarise(mean_cli = mean(CLI), .groups = "drop")
  
  observed_vs_null <- observed_trend %>%
    left_join(
      null_trend %>% group_by(year) %>% summarise(
        null_mean = mean(mean_cli),
        null_sd = sd(mean_cli),
        .groups = "drop"
      ),
      by = "year"
    ) %>%
    mutate(z_score = (mean_cli - null_mean) / null_sd)
  
  return(observed_vs_null)
}

cli_changes <- analyze_changes(obs_cwli, null_model_results)

# Visualization
ggplot(cli_changes, aes(x = year, y = mean_cli)) +
  geom_line(color = "black", size = 1) +
  geom_ribbon(aes(ymin = null_mean - 1 * null_sd, ymax = null_mean + 1 * null_sd),
              fill = "grey", alpha = 0.3) +
  theme_bw() +
  labs(
    title = "Community Length Index Over Time",
    x = "Year",
    y = "Community Length Index"
  )

# Step 6: Global Mixed Effects Model --------------------------------------
global_model <- lme(
  fixed = CWLI ~ year,
  random = ~ 1 | id_site,
  data = comparison_data,
  na.action = na.omit
)

summary(global_model)

# Step 7: Community Reshuffling GLM ---------------------------------------
glm_model <- glm(individuals ~ elevation * length_synthesis, data = butterfly_data, family = poisson())

# Check Overdispersion
dispersion_ratio <- sum(residuals(glm_model, type = "pearson")^2) / df.residual(glm_model)
if (dispersion_ratio > 1) print("Warning: Overdispersion detected!")

# Fit Negative Binomial GLM if Overdispersion is detected
if (dispersion_ratio > 1) {
  glm_model <- glm.nb(individuals ~ elevation * length_synthesis, data = butterfly_data)
}

summary(glm_model)

# Step 8: Visualization of Community Reshuffling Effects -----------------
ggplot(butterfly_data, aes(x = elevation, y = individuals)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue", size = 1) +
  theme_bw() +
  labs(
    title = "Relationship Between Elevation and Butterfly Abundance",
    x = "Elevation (m)",
    y = "Butterfly Abundance"
  )

# Save Results -----------------------------------------------------------
write.csv(comparison_data, "cli_comparison_results.csv", row.names = FALSE)
write.csv(cli_changes, "cli_trend_analysis.csv", row.names = FALSE)

