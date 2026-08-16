# 05_decomposition.R
# Install
install.packages("oaxaca")
library(oaxaca)
library(tidyverse)
library(oaxaca)

# 1: LOAD DATA
data <- read_csv("3.DataProcessed/tracts_with_groups.csv")

# oaxaca() requires the group variable in 0/1 (numeric) form, not factor/string
data <- data %>%
  mutate(group_numeric = if_else(income_group == "Low-Income", 1, 0))

# 2: RUN BLINDER-OAXACA DECOMPOSITION
oaxaca_result <- oaxaca(
  formula = LST_mean ~ NDVI_mean + IMP_mean + BLD_Density + GRN_pct | group_numeric,
  data = data,
  R = 100  # number of bootstrap replications for standard errors
)
summary(oaxaca_result)

# 3: PREPARE DATA FOR FIGURE 4 (weight = 0.5, Reimers)
decomp_df <- oaxaca_result$twofold$variables[[3]] %>%
  as.data.frame() %>%
  rownames_to_column("variable") %>%
  filter(variable != "(Intercept)") %>%
  select(variable, `coef(explained)`, `coef(unexplained)`) %>%
  pivot_longer(
    cols = c(`coef(explained)`, `coef(unexplained)`),
    names_to = "effect_type",
    values_to = "contribution"
  ) %>%
  mutate(effect_type = case_when(
    effect_type == "coef(explained)"   ~ "Endowment (Explained)",
    effect_type == "coef(unexplained)" ~ "Coefficient (Unexplained)"
  ))
print(decomp_df)

# 4: PLOT FIGURE 4
fig4 <- ggplot(decomp_df, aes(x = reorder(variable, contribution), y = contribution, fill = effect_type)) +
  geom_col(position = "dodge") +
  coord_flip() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
  scale_fill_manual(values = c(
    "Endowment (Explained)"       = "#1a9850",
    "Coefficient (Unexplained)"   = "#d73027"
  )) +
  labs(
    title = "Blinder-Oaxaca Decomposition of LST Gap",
    subtitle = "Contribution per variable (weight = 0.5, Reimers)",
    x = NULL,
    y = "Contribution to LST Gap (°C)",
    fill = "Effect Type"
  ) +
  theme_minimal(base_size = 12)
print(fig4)
ggsave(
  "4.Analysis/output_figures/fig04_oaxaca_decomposition.png",
  fig4, width = 8, height = 5, dpi = 300
)
