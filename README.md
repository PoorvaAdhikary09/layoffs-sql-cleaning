# 🧹 SQL Data Cleaning & EDA – Layoffs Dataset

This project demonstrates a complete **SQL-based workflow** — from **data cleaning** to **Exploratory Data Analysis (EDA)** — on a layoffs dataset.  
The goal was to transform messy, inconsistent data into a **standardized, analysis-ready format** and then uncover key insights.  

---

## 📂 Repository Structure
- **`layoffs.csv`** → Raw dataset (as received)  
- **`SQL Cleaning.sql`** → SQL scripts used for cleaning and transformation  
- **`layoffs_cleaned.csv`** → Final cleaned dataset (exported from MySQL)  
- **`SQL EDA.sql`** → SQL scripts for exploratory data analysis  

---

## 🔧 Data Cleaning Steps (MySQL)
1. **Standardized company names & industry labels**  
   - Trimmed extra spaces  
   - Unified inconsistent formats (e.g., `"crypto%" → "Crypto"`)  

2. **Fixed country names**  
   - Corrected typos (e.g., `United States.` → `United States`)  

3. **Converted date column**  
   - String format (`mm/dd/yyyy`) → SQL `DATE` type  

4. **Handled missing values**  
   - Replaced empty strings with `NULL`  
   - Populated missing industries (e.g., Airbnb → Travel, Carvana → Transportation)  

5. **Removed unnecessary data**  
   - Dropped helper columns  
   - Deleted rows where both `total_laid_off` & `percentage_laid_off` were `NULL`  

---

## 📊 Exploratory Data Analysis (EDA)
Key insights derived using SQL:  
- 🔝 **Largest layoffs** by company, country, and industry  
- 📆 **Trends over time** (monthly & yearly)  
- 🏆 **Top companies** ranked by layoffs across years  
- 📈 **Cumulative totals** to measure long-term impact  

---

## 🌟 Key Learnings
- ✅ Clean data ensures **consistency & accuracy**  
- ✅ SQL can handle both **data transformation** & **analysis** effectively  
- ✅ A cleaned dataset is a strong foundation for **Python, Tableau, or Power BI** projects  

---

## 🚀 Tools & Tech
- **MySQL** – Data cleaning & EDA  
- **Git & GitHub** – Version control & project hosting  

---

## 📌 Next Steps
- 📊 Create **visualizations** (Tableau / Power BI)  
- 🔍 Extend analysis: industry & geographic layoff patterns  
- 🔗 Compare SQL results with **Python-based EDA**  

---

## 👩‍💻 Author
**Poorva Adhikary**  
🎓 Final-year B.Tech student | 📈 Aspiring Data Analyst  
🔗 [LinkedIn](https://www.linkedin.com/in/poorva-adhikary-367458256/) | [GitHub](https://github.com/PoorvaAdhikary09)  
