# 🧹 SQL Data Cleaning Project – Layoffs Dataset

This project demonstrates a full **SQL-based data cleaning workflow** on a raw layoffs dataset.  
The goal was to transform messy, inconsistent data into a standardized, analysis-ready format.  

---

## 📂 Repository Structure
- **layoffs.csv** → Raw dataset (as received)  
- **SQL Queries.sql** → SQL scripts used for cleaning and transformation    

---

## 🔧 Data Cleaning Steps
The following transformations were applied in **MySQL**:

1. **Standardized company names and industry labels**  
   - Removed leading/trailing spaces  
   - Unified inconsistent text formats (e.g., "crypto%" → "Crypto")  

2. **Fixed country names**  
   - Corrected typos and standardized naming (e.g., `United States.` → `United States`)  

3. **Converted date column**  
   - Transformed from string format (`mm/dd/yyyy`) → SQL `DATE` type  

4. **Handled missing values**  
   - Replaced empty strings with `NULL`  
   - Populated missing industries using company information (e.g., Airbnb → Travel, Carvana → Transportation)  

5. **Removed unnecessary data**  
   - Dropped unused helper columns  
   - Deleted rows where both `total_laid_off` and `percentage_laid_off` were `NULL`  

---

## 📊 Why This Matters
Cleaning data ensures:  
- Consistency for analysis  
- Accurate aggregations and visualizations  
- Better reliability for downstream tasks like **EDA** or **machine learning**  

---

## 🚀 Tools & Tech
- **SQL (MySQL)** – primary tool for data cleaning  
- **Git & GitHub** – version control and project hosting  

---

## 📌 Next Steps
- Perform **Exploratory Data Analysis (EDA)** on the cleaned dataset  
- Visualize layoff trends across industries, countries, and years  
- Share insights with interactive dashboards (Python / Tableau)  

---

## 👩‍💻 Author
**Poorva Adhikary**  
Final-year B.Tech student | Aspiring Data Analyst  
📬 [LinkedIn](https://https://www.linkedin.com/in/poorva-adhikary-367458256/) | [GitHub](https://github.com/PoorvaAdhikary09)  

