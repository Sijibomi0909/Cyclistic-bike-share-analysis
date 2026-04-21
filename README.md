# Cyclistic Bike-Share Analysis: Strategic Recommendations for Membership Growth

**Analyst:** Oluwasijibomi Oderinde  
**Date:** April 2026  
**Tools:** SQL (DB Browser for SQLite) | R (tidyverse, ggplot2, patchwork) | Tableau Public

---

## Executive Summary

This analysis examines 12 months of trip data (April 2025 – March 2026) from Cyclistic, a Chicago-based bike-share service, to identify behavioral differences between casual riders and annual members. The primary objective was to inform a marketing strategy aimed at converting casual riders into profitable annual members.

**Key Findings:**
- Casual riders take **significantly longer trips** than members (22.5 vs. 12.1 minutes on average), indicating leisure-oriented usage.
- Members exhibit distinct **commuter patterns** with peak usage at 8 AM and 5 PM on weekdays, while casual riders peak on **Saturday afternoons**.
- Casual riders demonstrate a **stronger preference for electric bikes** (36% of rides) compared to members (22%).

**Recommendations Summary:**
1. Launch a **"Weekend Warrior" Summer Flex Pass** targeting casual riders during peak leisure hours.
2. Implement **in-app e-bike conversion prompts** after a casual rider's third electric bike unlock.
3. Target **"commuter fence-sitters"** with geofenced email offers based on weekday morning trip patterns.

---

## Business Context

Cyclistic operates a fleet of over 5,800 bicycles across 600+ docking stations in Chicago. The company offers flexible pricing: single-ride passes, full-day passes (casual riders), and annual memberships (members). Finance analysts have determined that annual members are significantly more profitable than casual riders.

The Director of Marketing, Lily Moreno, has set a clear goal: **design marketing strategies aimed at converting casual riders into annual members.**

This analysis addresses the question:

> *"How do annual members and casual riders use Cyclistic bikes differently, and what insights can inform a conversion-focused marketing campaign?"*

---

## Data Sources and Limitations

**Source:**  
Divvy Trip Data, publicly available via the Lyft Bikes and Scooters LLC data license agreement. The dataset includes 12 monthly CSV files covering all recorded trips in the Chicago service area.

**Time Period:** April 2025 – March 2026 (12 months)

**Dataset Size:**  
- Raw records: ~5.8 million  
- Cleaned records: **3.7 million** (after quality filters)

**Acknowledged Limitations:**
- Personally identifiable information (names, credit card numbers) is excluded for privacy compliance, preventing analysis of individual user behavior over time.
- The data does not include demographic variables (age, gender, income), limiting segmentation capabilities.
- Station location data is available but geographic analysis was outside the scope of this initial investigation.

Despite these constraints, the dataset provides robust **behavioral indicators** suitable for identifying actionable differences between user types.

---

## Repository Structure

---

## Data Processing Methodology

### SQL (Data Assembly and Feature Engineering)

The 12 monthly CSV files were imported into a SQLite database using DB Browser for SQLite. The following transformations were applied:

- **Data Aggregation:** Combined 12 monthly files into a single table using `.import` commands.
- **Feature Engineering:** Created calculated columns:
  - `ride_length_mins`: Trip duration in minutes using `JULIANDAY` difference.
  - `day_of_week`: Text-based day name using `STRFTIME('%w', started_at)`.
  - `start_hour`: Hour of trip initiation (0–23).
  - `month_num` and `year`: Temporal dimensions for seasonal analysis.
- **Quality Filters:**
  - Removed rides shorter than 1 minute (likely false starts or maintenance).
  - Removed rides longer than 24 hours (likely lost or stolen bikes).
  - Excluded records with missing station names or invalid timestamps.

**Script:** `cyclistic_data_cleaning.sql`

### R (Exploratory Analysis and Visualization)

Cleaned data was imported into R for further processing and visualization. Key steps included:

- Calculation of ride counts and average durations by user type.
- Statistical testing (two-sample t-test) to confirm significance of duration differences.
- Heatmap generation to visualize hourly and daily usage patterns.
- Stacked percentage bar chart for bike type preference analysis.

**Script:** `cyclistic_analysis.R`

**Statistical Note:** A two-sample t-test confirmed a statistically significant difference in average ride length between casual and member riders (p < 0.001).

---

## Key Findings and Supporting Visualizations

### Finding 1: Overall Ridership Distribution

Annual members account for approximately **64%** of total rides, while casual riders make up **36%** . This represents a substantial base of casual riders available for conversion.

![Overall Ridership](https://raw.githubusercontent.com/Sijibomi0909/Cyclistic-bike-share-analysis/main/03_Visuals/plot1_ridership_overall.png)

**Strategic Implication:**  
The 36% casual segment is large enough to justify dedicated marketing investment. Even a modest conversion rate improvement would yield meaningful membership growth.

---

### Finding 2: Ride Duration Differences

Casual riders average **22.5 minutes** per trip, nearly double the **12.1 minutes** average for members. This difference is statistically significant (p < 0.001).

![Average Ride Duration](https://raw.githubusercontent.com/Sijibomi0909/Cyclistic-bike-share-analysis/main/03_Visuals/plot2_avg_duration.png)

**Strategic Implication:**  
Casual riders use bikes primarily for **leisure and tourism**, while members use them for **utilitarian transportation**. Marketing messages should acknowledge and leverage this distinction rather than applying a one-size-fits-all approach.

---

### Finding 3: Temporal Usage Patterns

The heatmap reveals fundamentally different usage rhythms:

- **Members:** Strong peaks during weekday commute hours (7–9 AM and 4–6 PM). Minimal weekend usage.
- **Casual Riders:** Peak usage on **Saturday and Sunday afternoons** (12–4 PM). Weekday usage is distributed throughout the day with no clear commute pattern.

![Usage Heatmap](https://raw.githubusercontent.com/Sijibomi0909/Cyclistic-bike-share-analysis/main/03_Visuals/plot3_heatmap.png)

**Strategic Implication:**  
Timing matters. Conversion campaigns should target casual riders **when they are most engaged**—Saturday mornings and early afternoons. Commuter-oriented messaging will resonate poorly with this audience.

---

### Finding 4: Bike Type Preference

Casual riders choose **electric bikes** for 36% of their rides, compared to only 22% for members. This represents a 64% higher preference rate among casual users.

![Bike Preference](https://raw.githubusercontent.com/Sijibomi0909/Cyclistic-bike-share-analysis/main/03_Visuals/plot4_bike_preference.png)

**Strategic Implication:**  
Electric bikes serve as a **gateway feature** for casual riders. Marketing that highlights e-bike availability and positions membership as a cost-effective way to access them could accelerate conversion.

---

## Combined Dashboard

![Combined Dashboard](https://raw.githubusercontent.com/Sijibomi0909/Cyclistic-bike-share-analysis/main/03_Visuals/combined_dashboard.png)

---

## Strategic Recommendations

The following recommendations are derived from the analysis and are intended for evaluation by Cyclistic's marketing and executive teams.

| Priority | Recommendation | Supporting Insight | Expected Impact |
|:--------:|----------------|-------------------|-----------------|
| 1 | **Launch "Weekend Warrior" Summer Flex Pass** | Casual riders peak on Saturday afternoons and take 2x longer trips. | Lowers barrier to membership trial; targets users during peak engagement window. |
| 2 | **Implement E-Bike Conversion Prompts** | Casual riders prefer e-bikes at a 64% higher rate than members. | Connects demonstrated user behavior directly to membership savings proposition. |
| 3 | **Target Commuter Fence-Sitters with Geofenced Offers** | A subset of casual riders exhibit member-like commute patterns (8 AM weekday trips). | Converts high-frequency casuals who already demonstrate member behavior. |
| 4 | **Optimize Ad Spend Timing** | Casual engagement peaks Saturday 12–4 PM and summer months. | Improves campaign ROI by aligning media spend with peak casual user activity. |

---

## Recommendations for Further Analysis

Should additional data become available, the following avenues merit investigation:

- **User-Level Cohort Analysis:** Track individual casual riders over time to identify natural conversion paths and drop-off points.
- **Station-Level Geographic Analysis:** Identify high-casual-traffic stations (likely near tourist attractions) for targeted out-of-home advertising.
- **Pricing Sensitivity Testing:** Evaluate whether casual rider trip frequency correlates with single-ride vs. day-pass purchasing behavior.
- **Weather Data Integration:** Quantify the impact of temperature and precipitation on casual vs. member ridership to refine seasonal campaign timing.

---

## Technical Implementation Notes

- **SQL Environment:** All SQL operations were performed using SQLite (DB Browser). The `JULIANDAY` and `STRFTIME` functions were used for date/time calculations.
- **R Environment:** R version 4.5.3. Primary packages: `tidyverse` (data manipulation), `ggplot2` (visualization), `lubridate` (date handling), `patchwork` (dashboard assembly), `viridis` (color palettes).
- **Reproducibility:** All scripts are self-contained and documented. Running `cyclistic_analysis.R` will regenerate all figures in the `03_Visuals/` directory.

---

## Contact

**Oluwasijibomi Oderinde**  
Data Analyst

- 💼 [LinkedIn] https://www.linkedin.com/in/oluwasijibomi-oderinde-b1700724
- 💻 [GitHub] https://github.com/Sijibomi0909
- 📧 [Email] oderindesiji@gmail.com

---

*This case study was completed as part of a professional data analytics portfolio. For inquiries or collaboration opportunities, please reach out via LinkedIn or email.*