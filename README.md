# Steam Game Market Analysis

A data analytics portfolio project exploring the Steam game market using live API data, R for data processing, and Power BI for visualization.

---

## Overview

This project analyzes the **Top 100 most played Steam games** to uncover pricing trends, review patterns, and ownership distribution across free and paid titles.

---

## Tools Used

- **R** — data collection, cleaning, and analysis
- **SteamSpy API** — live Steam game data
- **Power BI** — interactive dashboard and visualization

---

## Key Findings

- Free games have significantly more owners (median 20M) compared to paid games (median 10M)
- Paid games average a higher review score (88.3) than free games (74.7)
- The $5–$10 price range has the highest average review score (94) among paid tiers
- Free games make up the largest single category in the Top 100 (33 out of 100 games)
- The $1–$5 price range is nearly absent from the Top 100, with only 3 games
- Top rated games are almost exclusively paid and priced under $15

---

## Dashboard

![Steam Market Analysis Dashboard]<img width="1166" height="656" alt="Steam Market Analysis 4 24 2026" src="https://github.com/user-attachments/assets/4cd641c7-a50f-4b3d-83d6-9aa5f8726480" />

**Page 1 — Market Overview**
- KPI cards: Total Games, Avg Review Score, Estimate of All Owners
- Free/Paid slicer filtering all visuals
- Stacked bar chart: Top 12 Most Reviewed Games (positive vs negative reviews)
- Horizontal bar chart: Avg Review Score by Price Range
- Horizontal bar chart: # of Games by Price Range

---

## Data Pipeline

**1. Data Collection**
- Pulled live data from the SteamSpy API (`top100in2weeks` endpoint)
- Retrieved: game name, developer, publisher, owners estimate, price, positive/negative reviews

**2. Data Cleaning (R)**
- Calculated `review_score` as a percentage of positive reviews
- Extracted numeric `owners_lower` from SteamSpy's range strings (e.g. "20,000,000 .. 50,000,000")
- Added `is_free` flag based on price
- Filtered out games with no review data

**3. Analysis Tables Exported as CSV**

| File | Description |
|---|---|
| `steam_data.csv` | Full cleaned dataset (100 games) |
| `free_vs_paid.csv` | Aggregated comparison of free vs paid games |
| `top_rated.csv` | Top 10 highest rated games (min 10,000 reviews) |
| `most_owned.csv` | Top 10 most owned games by estimated owners |
| `price_summary.csv` | Price statistics for paid games only |

**4. Power BI Dashboard**
- Loaded all 5 CSVs as independent tables (no relationships)
- Created calculated columns: `price_bucket`, `price_bucket_order`
- Applied dark theme and interactive slicer

---

## Files in This Repo

```
steam-market-analysis/
├── steam_analysis.R        # Full R script for data collection and cleaning
├── steam_data.csv          # Main dataset
├── free_vs_paid.csv
├── top_rated.csv
├── most_owned.csv
├── price_summary.csv
├── Steam market Analysis 4 24 2026.pbix    # Power BI dashboard file
└── README.md
```

---

## How to Run

1. Clone this repo
2. Open `steam_analysis.R` in RStudio
3. Install required packages if needed:
```r
install.packages(c("httr", "jsonlite", "dplyr", "readr"))
```
4. Run the script — it will pull live data from SteamSpy and export all CSVs
5. Open `Steam Market Analysis 4 24 2026.pbix` in Power BI Desktop
6. Refresh data sources to point to your local CSV files

---

## Notes

- SteamSpy data is updated regularly so results may vary slightly from the dashboard screenshot
- Owner estimates are lower bound values from SteamSpy's range format
- Review score is calculated as: `(positive reviews / total reviews) × 100`
