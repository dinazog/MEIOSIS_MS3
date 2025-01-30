# MEIOSIS_MS3
**Community reshuffling**

**Summary**

This script provides a comprehensive Community Reshuffling Analysis, investigating how climate change and environmental factors drive shifts in butterfly community composition over time. The Community Weighted Length Index (CWLI) is used to quantify changes in body size at different monitoring sites, comparing observed trends with null models generated through randomization.
Key analytical steps include:
1.	Data Preprocessing – Cleaning species, site, and body size measurements.
2.	Null Model Simulations – Generating randomized distributions to test for significant deviations.
3.	Statistical Modeling – Applying linear mixed-effects models and generalized linear models (GLM) to assess global trends and environmental influences.
4.	Visualization – Plotting CWLI trends, highlighting significant community changes.
5.	Exporting Results – Producing structured outputs for further research and policy recommendations.
This pipeline provides valuable insights into biodiversity responses to climate change, aiding conservation efforts and predictive modeling of species adaptations in changing environments.



**Community Reshuffling Analysis** 

Step-by-Step Guide
This guide outlines the steps required to analyze community reshuffling in butterfly populations using observed and null models. The analysis quantifies changes in Community Weighted Length Index (CWLI) across monitoring sites over time and compares observed trends with null distributions generated through randomization.

**Step 1:** Load Required Libraries
Before starting the analysis, load the necessary R packages required for data manipulation, statistical modeling, and visualization.

**Step 2:** Set Working Directory and Load Data
Ensure that the working directory is set correctly and load the butterfly dataset, which includes species information, site locations, wing length measurements, and environmental variables.

**Step 3:** Data Preprocessing
•	Convert categorical variables (e.g., species names and site IDs) into factors.
•	Filter out rows with missing values in body size measurements (length_synthesis) to ensure data consistency.

**Step 4:** Compute Observed Community Weighted Length Index (CWLI)
•	Calculate CWLI for each site and year by computing the weighted mean of butterfly body sizes, using species abundance as weights.
•	This step provides a baseline for comparison with null models.

**Step 5:** Generate Null Distributions
•	Shuffle species occurrence data across years to break temporal dependencies while preserving the dataset’s ecological structure.
•	Compute CWLI for each site-year combination under randomized conditions.
•	Repeat this randomization process 999 times to create a null distribution for statistical comparisons.

**Step 6:** Compare Observed vs. Null Distributions
•	Compute the mean and standard deviation of CWLI under the null model for each site-year.
•	Compare the observed CWLI with the null distribution by calculating Z-scores and p-values.
•	Identify statistically significant deviations from expected trends.

**Step 7:** Visualize Results
•	Plot the observed CWLI trends over time for each site.
•	Highlight significant changes where observed values deviate from the null model.
•	Use color coding to distinguish between statistically significant and non-significant trends.

**Step 8:** Fit a Global Mixed-Effects Model
•	Apply a linear mixed-effects model (LME) to assess global trends in CWLI while accounting for site-level variability.
•	Use year as a fixed effect and site as a random effect to model variations across locations.

**Step 9:** Community Reshuffling Generalized Linear Model (GLM)
•	Fit a Poisson GLM to examine how environmental variables, such as elevation and species traits, influence species abundance.
•	Address potential overdispersion using a Negative Binomial GLM if needed.
•	Perform model diagnostics, including residual analysis and multicollinearity checks.

**Step 10:** Save and Export Results
•	Export cleaned datasets and statistical outputs as CSV files for further interpretation and conservation planning.



