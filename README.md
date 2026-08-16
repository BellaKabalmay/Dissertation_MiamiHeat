# Urban Form, Heat Exposure, and Socioeconomic Status in Miami-Dade County


**Author:** Bella Chyntia Kabalmay 

This repository contains the analysis code for the dissertation *"To What Extent Does Urban Form Explain the Relationship Between Heat Exposure and Socioeconomic Status? A Decomposition Analysis of Miami-Dade County, Florida."*

## Repository Structure

​```
├── GEE/
│   └── LST_NDVI_MiamiDade_2022.js   # Extracts summer 2022 LST and NDVI from Landsat
├── R/
│   ├── 01_setup.R           # Load packages and data
│   ├── 02_descriptive.R     # Summary statistics, correlation, distribution plots
│   ├── 03_anova.R           # Income-group split + Welch t-test (SQ1)
│   ├── 04_regression.R      # OLS regressions by income group (SQ2)
│   ├── 05_decomposition.R   # Blinder-Oaxaca decomposition (SQ3)
│   └── 06_bimodality.R      # Bimodality test + building density check
└── README.md
​```

## Workflow

1. **Google Earth Engine**: extract LST/NDVI (`GEE/LST_NDVI_MiamiDade_2022.js`)
2. **QGIS** (not scripted): join rasters with SVI, building, impervious surface, and green space layers to census tracts
3. **R**: run `R/01_setup.R` through `R/06_bimodality.R` in order