# 06_bimodality.R
library(tidyverse)

data <- read_csv("3.DataProcessed/tracts_for_R.csv")

median_val <- median(data$EP_POV150, na.rm = TRUE)

# 1: HISTOGRAM + DENSITY CURVE, with median split line
p <- ggplot(data, aes(x = EP_POV150)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30,
                 fill = "#2E5090", color = "white", alpha = 0.7) +
  geom_density(color = "black", linewidth = 1) +
  geom_vline(xintercept = median_val, color = "#d73027",
             linetype = "dashed", linewidth = 1) +
  labs(title = "Distribution of EP_POV150 across 697 census tracts",
       subtitle = paste0("Median split at ", round(median_val, 1), "%"),
       x = "EP_POV150 (% of population below 150% poverty line)",
       y = "Density") +
  theme_minimal(base_size = 13)
print(p)
ggsave("4.Analysis/output_figures/fig_EP_POV150_distribution.png",
       p, width = 8, height = 5, dpi = 300)

# 2: FORMAL STATISTICAL TEST FOR BIMODALITY (Hartigan's dip test)
install.packages("diptest")   # once only
library(diptest)
dip.test(data$EP_POV150)

# 3: SCATTER PLOT - LST vs BLD_Density per income group
# Verifies the Section SQ2/decomposition claim about building density
data_groups <- read_csv("3.DataProcessed/tracts_with_groups.csv")

fig_bld <- ggplot(data_groups, aes(x = BLD_Density, y = LST_mean, color = income_group)) +
  geom_point(alpha = 0.5, size = 2) +
  geom_smooth(method = "lm", se = TRUE, linewidth = 1.2) +
  scale_color_manual(values = c("Low-Income" = "#d73027", "High-Income" = "#4575b4")) +
  labs(
    title = "LST vs Building Density by Income Group",
    subtitle = "Miami-Dade County census tracts, 2022",
    x = "Building Density (BLD_Density)",
    y = "Mean LST (°C)",
    color = "Income Group"
  ) +
  theme_minimal(base_size = 13)
print(fig_bld)
ggsave("4.Analysis/output_figures/fig05_LST_vs_BLDDensity.png",
       fig_bld, width = 8, height = 5, dpi = 300)

# 4: COMPARE BLD_Density RANGE BY GROUP (Claire asked about this)
data_groups %>%
  group_by(income_group) %>%
  summarise(
    n = n(),
    min_BLD = min(BLD_Density, na.rm = TRUE),
    max_BLD = max(BLD_Density, na.rm = TRUE),
    mean_BLD = mean(BLD_Density, na.rm = TRUE),
    median_BLD = median(BLD_Density, na.rm = TRUE)
  )
