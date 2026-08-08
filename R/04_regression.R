# ============================================================
# 04_regression.R
# Purpose: Fit separate LST regressions for Low-Income and
#          High-Income groups (answers SQ2)
# Input  : 3.DataProcessed/tracts_with_groups.csv
# ============================================================

library(tidyverse)
library(car)
library(broom)

data <- read_csv("3.DataProcessed/tracts_with_groups.csv")
# split into two data subsets
data_low <- data %>% filter(income_group == "Low-Income")
data_high <- data %>% filter(income_group == "High-Income")

nrow(data_low)
nrow(data_high)
# run two regression models
model_low <- lm(LST_mean ~ NDVI_mean + IMP_mean + BLD_Density + GRN_pct, data = data_low)
model_high <- lm(LST_mean ~ NDVI_mean + IMP_mean + BLD_Density + GRN_pct, data = data_high)

summary(model_low)
summary(model_high)
summary(model_low)

# Check VIF
vif(model_low)
vif(model_high)

# Check residuals
par(mfrow = c(2, 2))
plot(model_low)

par(mfrow = c(2, 2))
plot(model_high)

# tidy up both models:
tidy_low <- tidy(model_low, conf.int = TRUE) %>% mutate(income_group = "Low-Income")
tidy_high <- tidy(model_high, conf.int = TRUE) %>% mutate(income_group = "High-Income")

coef_compare <- bind_rows(tidy_low, tidy_high)
print(coef_compare)

# coefficient plot
coef_plot_data <- coef_compare %>% filter(term != "(Intercept)")

fig3 <- ggplot(coef_plot_data, aes(x = term, y = estimate, color = income_group)) +
  geom_point(position = position_dodge(width = 0.5), size = 3) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high),
                position = position_dodge(width = 0.5), width = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  scale_color_manual(values = c("Low-Income" = "#d73027", "High-Income" = "#4575b4")) +
  labs(
    title = "Regression Coefficients by Income Group",
    subtitle = "LST_mean ~ NDVI_mean + IMP_mean + BLD_Density + GRN_pct",
    x = NULL, y = "Coefficient Estimate (95% CI)", color = "Income Group"
  ) +
  coord_flip() +
  theme_minimal(base_size = 13)

print(fig3)

ggsave("4.Analysis/output_figures/fig03_coefficient_plot.png", fig3, width = 8, height = 5, dpi = 300)

# refined version
coef_plot_data <- coef_compare %>% filter(term != "(Intercept)")

fig3 <- ggplot(coef_plot_data, aes(x = income_group, y = estimate, color = income_group)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  facet_wrap(~ term, scales = "free_y", nrow = 1) +
  scale_color_manual(values = c("Low-Income" = "#d73027", "High-Income" = "#4575b4")) +
  labs(
    title = "Regression Coefficients by Income Group",
    subtitle = "LST_mean ~ NDVI_mean + IMP_mean + BLD_Density + GRN_pct",
    x = NULL, y = "Coefficient Estimate (95% CI)", color = "Income Group"
  ) +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

print(fig3)

ggsave("4.Analysis/output_figures/fig03_coefficient_plot.png", fig3, width = 10, height = 5, dpi = 300)
