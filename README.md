# Agriculture Sector Analysis using CRISP-DM Framework

This repository demonstrates how data science methods can optimize the agriculture sector analysis using the CRISP-DM framework. The project focuses on addressing agricultural price volatility and providing actionable insights through predictive models.

---

## Project Overview

### **Objective**
1. Predict future Agriculture Producer Price Index (PPI) using time series models.
2. Use other industries' PPI data to predict Agriculture PPI using regression models.

### **Key Features**
- Time series forecasting using ARIMA and ETS models.
- Regression-based predictions leveraging Random Forest, XGBoost, Linear Regression, and KNN.
- Feature selection using Random Forest importance ranking to optimize regression models.
- Sensitivity and uncertainty analysis to evaluate model performance.
- Alert system for price volatility detection.

### **CRISP-DM Framework**
This project adopts the CRISP-DM methodology:
1. **Business Understanding**: Define goals to optimize decision-making in the agriculture sector.
2. **Data Understanding**: Analyze PPI datasets from various industries.
3. **Data Preparation**: Clean, preprocess, and perform feature selection to improve model performance.
4. **Modeling**: Apply multiple algorithms, including KNN, to achieve optimal predictions.
5. **Evaluation**: Compare model performances using RMSE.
6. **Deployment**: Visualize results and implement alerts.

---

## Repository Structure
- `Agriculture Sector Analysis using CRISP-DM Framework.Rmd`: R Markdown file containing the full analysis and implementation.
- `ppi.csv`: Sample dataset used for analysis.
- `README.md`: Overview of the project.

---

## Requirements

### **Packages**
Ensure the following R packages are installed:
- `dplyr`
- `ggplot2`
- `caret`
- `forecast`
- `randomForest`
- `xgboost`
- `class`
- `shinny`

### **Setup Instructions**
1. Clone this repository:
   ```bash
   git clone https://github.com/LorraineWong/Agriculture-Sector-Analysis.git
   ```
2. Install required R packages:
   ```R
   install.packages(c("dplyr", "ggplot2", "caret", "forecast", "randomForest", "xgboost", "class","shinny"))
   ```
3. Open the `.Rmd` file in RStudio and run the analysis.

---

## Key Results
- **Best Time Series Model**: ARIMA achieved the lowest RMSE.
- **Best Regression Model**: Random Forest outperformed other models, followed closely by XGBoost and KNN.
- **Feature Selection**:
  - Random Forest identified key predictors: Mining PPI, Manufacturing PPI, and Electricity PPI.
  - Feature selection reduced model complexity and improved accuracy.
- **Insights**:
  - Mining PPI strongly correlates with Agriculture PPI.
  - Sensitivity analysis revealed a 10% increase in Mining PPI significantly impacts Agriculture PPI predictions.
- **Alert System**: Triggers warnings for significant price volatility, aiding proactive decision-making.

---

## Future Work
1. Include additional external factors (e.g., weather data) to enhance prediction accuracy.
2. Develop a web-based application for real-time PPI monitoring and forecasting.

---

## References
- Dataset: [PPI Data CSV](https://storage.dosm.gov.my/ppi/ppi.csv)
- CRISP-DM Framework: [CRISP-DM Overview](https://www.crisp-dm.org/)
- Shinnys: [Dynamic Prediction of Agrivulture PPI](https://qk8k0u-lorraine-wong.shinyapps.io/Agriculture_Sector_Analysis/)
- Poster: [Infographic Poster](https://www.canva.com/design/DAGa3ti-8YM/SGL8o9AWkLplmzttfp9JgQ/view?utm_content=DAGa3ti-8YM&utm_campaign=share_your_design&utm_medium=link&utm_source=shareyourdesignpanel)

---

## Author
Lorraine Wong

---

For more information or collaboration, feel free to raise an issue or contact me through GitHub.
