# 01_setup.R
# 1: INSTALL PACKAGES

install.packages("tidyverse")
install.packages("car")
install.packages("oaxaca")
install.packages("broom")

# 2: LOAD LIBRARIES

library(tidyverse)
library(car)
library(oaxaca)
library(broom)

# 3: LOAD DATA
# Read CSV that export from QGIS
data <- read_csv("3.DataProcessed/tracts_for_R.csv")

# Check if the data successful loading
glimpse(data)
