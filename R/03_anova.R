# ============================================================
# 03_anova.R
# Purpose : Test whether summer mean LST differs significantly
#           between high-income and low-income census tracts
#           (answers SQ1)
# Method  : Median split on EP_POV150 + Welch two-sample t-test
# Input   : 3.DataProcessed/tracts_for_R.csv
# Output  : output_figures/fig02_boxplot_LST_by_income.png
#           3.DataProcessed/tracts_with_groups.csv
# ============================================================

library(tidyverse)

# ---- 1. Load data ----
data <- read_csv("3.DataProcessed/tracts_for_R.csv")

# ---- 2. Create income group (median split on EP_POV150) ----
# EP_POV150 = % of population below 150% of the poverty line
# Higher EP_POV150 = more poverty = lower socioeconomic status
median_pov <- median(data$EP_POV150, na.rm = TRUE)

data <- data %>%
  mutate(
    income_group = if_else(EP_POV150 >= median_pov, "Low-Income", "High-Income"),
    income_group = factor(income_group, levels = c("Low-Income", "High-Income"))
  )

# Check group sizes (should be close to 348/349)
table(data$income_group)

# ---- 3. Descriptive stats per group ----
group_stats <- data %>%
  group_by(income_group) %>%
  summarise(
    n = n(),
    mean_LST = mean(LST_mean, na.rm = TRUE),
    sd_LST = sd(LST_mean, na.rm = TRUE),
    median_LST = median(LST_mean, na.rm = TRUE),
    .groups = "drop"
  )
print(group_stats)

# ---- 4. Welch two-sample t-test ----
# (var.equal = FALSE is the default -> this IS the Welch test)
t_result <- t.test(LST_mean ~ income_group, data = data)
print(t_result)

# Gap in degrees Celsius (Low-Income minus High-Income)
lst_gap <- group_stats$mean_LST[group_stats$income_group == "Low-Income"] -
  group_stats$mean_LST[group_stats$income_group == "High-Income"]
cat("LST gap (Low-Income minus High-Income):", round(lst_gap, 2), "degrees C\n")

# ---- 5. Boxplot (Figure 2) ----
fig2 <- ggplot(data, aes(x = income_group, y = LST_mean, fill = income_group)) +
  geom_boxplot(alpha = 0.7, outlier.color = "black") +
  scale_fill_manual(values = c("Low-Income" = "#d73027", "High-Income" = "#4575b4")) +
  labs(
    title = "Summer Mean LST by Income Group",
    subtitle = "Miami-Dade County census tracts, 2022",
    x = NULL,
    y = "Mean LST (°C)"
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none")

print(fig2)

ggsave(
  "4.Analysis/output_figures/fig02_boxplot_LST_by_income.png",
  fig2, width = 6, height = 5, dpi = 300
)

# ---- 6. Save group assignment for later stages (Stage C & D) ----
write_csv(data, "3.DataProcessed/tracts_with_groups.csv")
