# Urban Form, Heat Exposure, and Socioeconomic Status in Miami-Dade County

MSc Dissertation — UCL Centre for Advanced Spatial Analysis (CASA), MSc Urban Spatial Science

**Author:** Bella Kabalmay
**Supervisor:** Claire Dooley | **Tutor:** Jens Kandt
**Year:** 2026

## Project Overview

This repository contains the analysis code for the dissertation *"To What Extent Does Urban Form Explain the Relationship Between Heat Exposure and Socioeconomic Status? A Decomposition Analysis of Miami-Dade County, Florida."*

**Research question:** To what extent do urban form characteristics explain the relationship between heat exposure and socioeconomic status across neighbourhoods in Miami-Dade County?

- **SQ1:** Is there a significant gap in heat exposure between high- and low-income neighbourhoods?
- **SQ2:** How does urban form differ between the two groups?
- **SQ3:** What proportion of the heat exposure gap is explained by urban form?

**Method:** Blinder-Oaxaca decomposition (following Rahimi & Hashemi Nazari, 2021), grouping census tracts by socioeconomic status (`EP_POV150`, % of population below 150% of the poverty line, from the 2022 CDC/ATSDR Social Vulnerability Index) rather than by race. Anchor year: 2022. Unit of analysis: 697 census tracts in Miami-Dade County, Florida.

## Repository Structure

```
├── GEE/
│   └── LST_NDVI_MiamiDade_2022.js   # Google Earth Engine script: extracts summer 2022
│                                     # mean Land Surface Temperature (LST) and NDVI
│                                     # from Landsat imagery
├── R/
│   ├── 01_setup.R           # Load packages and the processed tract-level dataset
│   ├── 02_descriptive.R     # Summary statistics, correlation matrix, distribution plots
│   ├── 03_anova.R           # Income-group split + Welch t-test on LST (SQ1)
│   ├── 04_regression.R      # Separate OLS regressions by income group (SQ2)
│   └── 05_decomposition.R   # Blinder-Oaxaca decomposition of the LST gap (SQ3)
└── README.md
```

## Workflow

1. **Google Earth Engine** (`GEE/LST_NDVI_MiamiDade_2022.js`) — extracts summer 2022 mean LST and NDVI for Miami-Dade County from Landsat imagery.
2. **QGIS** (not scripted) — joins LST/NDVI rasters with SVI, building footprint, impervious surface, and green space layers to census tracts; cleans and exports `tracts_for_R.csv`.
3. **R** (`R/01_setup.R` → `R/05_decomposition.R`) — run in order. Each script assumes the previous one has been run in the same session (`01_setup.R` loads the data used by all subsequent scripts).

## Data

Raw and processed datasets are not included in this repository due to file size. Data sources:

- **Social Vulnerability Index (SVI) 2022** — CDC/ATSDR, poverty variable `EP_POV150`
- **Landsat 8/9 Collection 2 Level-2** — LST and NDVI, via Google Earth Engine
- **Building footprints** — Miami-Dade County Open Data
- **Impervious surface** — [source]
- **Park/green space boundaries** — Miami-Dade County Open Data (county + municipal)

Full citations with access dates and DOIs/URLs are provided in the dissertation's reference list.

## Dependencies

R packages: `tidyverse`, `car`, `oaxaca`, `broom`

Install with:
```r
install.packages(c("tidyverse", "car", "oaxaca", "broom"))
```

## Citation

If referencing this analysis, please cite the dissertation:

Kabalmay, B. (2026). *To What Extent Does Urban Form Explain the Relationship Between Heat Exposure and Socioeconomic Status? A Decomposition Analysis of Miami-Dade County, Florida.* MSc Dissertation, UCL Centre for Advanced Spatial Analysis.

## AI Acknowledgment

Generative AI (Claude) was used to assist with code translation/documentation and repository setup. See the dissertation's AI acknowledgment section for full disclosure of AI use in this project.
