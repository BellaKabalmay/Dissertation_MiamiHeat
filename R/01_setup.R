# ============================================================
# 01_setup.R
# Initial setup for dissertation analysis
# Bella Kabalmay — MSc Urban Spatial Science
# Created: 14 July 2026
# ============================================================
# ============================================================
# PART 1: INSTALL PACKAGES (run ONCE only)
# ============================================================

install.packages("tidyverse")
install.packages("car")
install.packages("oaxaca")
install.packages("broom")
# ============================================================
# PART 2: LOAD LIBRARIES (run every new session)
# ============================================================

library(tidyverse)
library(car)
library(oaxaca)
library(broom)

# ============================================================
# PART 3: LOAD DATA
# ============================================================

# Read the CSV exported from QGIS
data <- read_csv("3.DataProcessed/tracts_for_R.csv")

# Check: did the data load successfully?
glimpse(data)
