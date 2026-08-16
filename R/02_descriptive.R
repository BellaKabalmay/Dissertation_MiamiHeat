# ============================================================
# 02_descriptive.R
# Stage A: Descriptive & Exploratory Analysis
# Bella Kabalmay
# ============================================================
# Prerequisite: 01_setup.R has been run (data already loaded)
# ============================================================
# ============================================================
# PART 1: SUMMARY STATISTICS
# ============================================================

# Select the 5 main variables for analysis
# (EP_POV150 = grouping variable + 4 urban form variables + 1 dependent variable)
vars_analysis <- c("LST_mean", "NDVI_mean", "IMP_mean",
                   "BLD_Density", "GRN_pct", "EP_POV150")

# Compute summary statistics for each variable
summary_stats <- data %>%
  select(all_of(vars_analysis)) %>%
  summarise(across(
    everything(),
    list(
      n = ~sum(!is.na(.)),
      mean = ~mean(., na.rm = TRUE),
      median = ~median(., na.rm = TRUE),
      sd = ~sd(., na.rm = TRUE),
      min = ~min(., na.rm = TRUE),
      max = ~max(., na.rm = TRUE)
    )
  )) %>%
  pivot_longer(everything(),
               names_to = c("variable", "statistic"),
               names_sep = "_(?=[^_]+$)") %>%
  pivot_wider(names_from = statistic, values_from = value)

# Display results
print(summary_stats)
# ============================================================
# PART 2: CORRELATION MATRIX
# ============================================================

# Take the 5 main variables to check correlation
data_corr <- data %>%
  select(LST_mean, NDVI_mean, IMP_mean, BLD_Density, GRN_pct, EP_POV150)

# Compute correlation matrix (Pearson)
corr_matrix <- cor(data_corr, use = "complete.obs")

# Round to 2 decimals for readability
corr_matrix <- round(corr_matrix, 2)

# Display
print(corr_matrix)
# ============================================================
# PART 3: VARIABLE DISTRIBUTION HISTOGRAMS
# ============================================================

# Reshape data to long format for easy faceted plotting
data_long <- data %>%
  select(all_of(vars_analysis)) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value")

# Create histogram grid for all variables
p_histogram <- ggplot(data_long, aes(x = value)) +
  geom_histogram(bins = 30, fill = "#2E5090", color = "white", alpha = 0.8) +
  facet_wrap(~ variable, scales = "free", ncol = 3) +
  labs(
    title = "Distribution of Analytical Variables",
    subtitle = "697 census tract in Miami-Dade County, 2022",
    x = "Value",
    y = "Number of Tracts"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    strip.text = element_text(face = "bold", size = 11),
    plot.title = element_text(face = "bold", size = 13)
  )

# Display
print(p_histogram)
# ============================================================
# PART 4: SAVE CHART TO FILE
# ============================================================

# Create output folder if it doesn't exist
if (!dir.exists("4.Analysis/output_figures")) {
  dir.create("4.Analysis/output_figures", recursive = TRUE)
}

# Save histogram grid
ggsave(
  filename = "4.Analysis/output_figures/fig01_histogram_distribution.png",
  plot = p_histogram,
  width = 10,
  height = 7,
  dpi = 300,
  bg = "white"
)

# Check: was the file saved?
list.files("4.Analysis/output_figures")
