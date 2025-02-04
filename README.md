
# MEIOSIS_MS_3: Community Reshuffling Analysis

## 🌍 **Overview**
This repository provides a comprehensive pipeline for **Community Reshuffling Analysis**, exploring how climate change and environmental factors drive shifts in butterfly community composition over time. The analysis leverages the **Community Weighted Length Index (CWLI)** to quantify changes in body size across different monitoring sites, comparing observed trends with null models generated through randomization.

---

## 📊 **Key Features**
- **Community Weighted Length Index (CWLI):** Quantifies butterfly body size shifts over time.
- **Null Model Simulations:** Assesses the significance of observed patterns against randomized expectations.
- **Advanced Statistical Modeling:** Uses linear mixed-effects models and generalized linear models (GLMs).
- **Dynamic Visualizations:** Highlights significant changes in community structure.
- **Exportable Outputs:** Structured results for research and conservation policy applications.

---

## 🚀 **Step-by-Step Guide**

### **Step 1: Load Required Libraries**
Import the necessary R packages for data manipulation, statistical modeling, and visualization.

### **Step 2: Set Working Directory & Load Data**
- Configure your working directory.
- Load the butterfly dataset, including species information, site locations, wing length measurements, and environmental variables.

### **Step 3: Data Preprocessing**
- Convert categorical variables (e.g., species names, site IDs) into factors.
- Filter out rows with missing values in body size measurements to ensure data consistency.

### **Step 4: Compute Observed CWLI**
- Calculate the CWLI for each site and year by computing the weighted mean of butterfly body sizes, using species abundance as weights.
- This establishes a baseline for comparison with null models.

### **Step 5: Generate Null Distributions**
- Randomize species occurrence data across years to disrupt temporal dependencies while preserving ecological structure.
- Compute CWLI under randomized conditions for each site-year combination.
- Perform 999 iterations to create robust null distributions.

### **Step 6: Compare Observed vs. Null Distributions**
- Calculate the mean and standard deviation of CWLI under the null model.
- Compare observed CWLI with null distributions using Z-scores and p-values.
- Identify statistically significant deviations from expected trends.

### **Step 7: Visualize Results**
- Plot observed CWLI trends over time for each monitoring site.
- Highlight significant deviations from null expectations.
- Use intuitive color coding to distinguish between significant and non-significant trends.

### **Step 8: Fit a Global Mixed-Effects Model**
- Apply a linear mixed-effects model (LME) to assess global CWLI trends while accounting for site-specific variability.
- Include **year** as a fixed effect and **site** as a random effect.

### **Step 9: Community Reshuffling GLM**
- Fit a Poisson GLM to explore the influence of environmental variables (e.g., elevation, species traits) on species abundance.
- Address overdispersion using a Negative Binomial GLM if needed.
- Perform model diagnostics, including residual analysis and multicollinearity checks.

### **Step 10: Save & Export Results**
- Export cleaned datasets and statistical outputs as CSV files.
- Outputs are optimized for further interpretation and integration into conservation strategies.

---

## 📦 **Project Structure**
```
MEIOSIS_MS3/
├── data/               # Raw and processed butterfly data
├── scripts/            # R scripts for data preprocessing, analysis, and visualization
├── results/            # Exported statistical outputs and plots
└── README.md           # Project documentation
```

---

## 🤝 **Contributions & Acknowledgments**
Contributions are welcome! Please feel free to fork this repository, submit issues, or create pull requests. For any data usage, kindly review the acknowledgment section in the manuscript to ensure proper citation.

---

## 📢 **Contact**
For questions or collaborations, please contact [Dina Zografou] at [dina.zografou@uoi.gr].

---

*This project provides critical insights into biodiversity responses to climate change, supporting conservation efforts and enhancing predictive models of species adaptation.*
