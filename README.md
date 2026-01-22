# COVID-19 Data Exploration Using SQL

## 1. Executive Summary
This project performs an in-depth analysis of global COVID-19 data to uncover trends in infections, deaths, and vaccination progress across countries and continents. The analysis is based on a **real-world dataset containing 85,000+ records**, making it representative of real analytical workloads. Advanced SQL techniques were used to transform raw pandemic data into meaningful insights that support data-driven public health decisions.

---

## 2. Business Problem
Governments and healthcare organizations need timely and accurate insights to:
- Identify countries and regions most affected by COVID-19
- Measure mortality impact relative to confirmed cases
- Track vaccination rollout and coverage
- Allocate resources effectively during a global health crisis

Raw COVID-19 data is large, complex, and contains missing or inconsistent values. The challenge is to convert this raw data into **reliable, actionable insights** using scalable SQL queries.

---

## 3. Methodology

### Data Understanding & Preparation
- Used two relational tables: **CovidDeaths** and **CovidVaccinations**
- Total dataset size: **~85,000+ rows**
- Filtered irrelevant records (e.g., null continent values)
- Converted data types to ensure accurate calculations

### Exploratory Data Analysis
- Analyzed total cases vs total deaths to calculate death percentages
- Calculated infection rates relative to population size
- Identified countries with the highest infection and death counts
- Aggregated continent-level and global COVID statistics

### Advanced SQL Techniques
- Used **window functions** to compute rolling vaccination totals
- Implemented **CTEs** and **temporary tables** for intermediate calculations
- Applied **aggregate functions** for regional comparisons

### Data Modeling
- Created reusable **SQL Views** for reporting and analysis:
  - Daily cases vs deaths
  - Country-level totals and death rates
  - Continent-level summaries
  - Vaccination progress by country

---

## 4. Skills Used
- SQL Joins  
- Common Table Expressions (CTEs)  
- Window Functions  
- Aggregate Functions  
- Temporary Tables  
- Views Creation  
- Data Type Conversion  
- Data Cleaning  
- Analytical & Business Problem Solving  

---

## 5. Results & Business Recommendations

### Key Results
- Some countries experienced high infection rates despite smaller populations
- Death rates varied significantly across continents
- Vaccination progress differed widely by country
- Higher vaccination coverage generally correlated with lower mortality impact

### Business Recommendations
- Prioritize healthcare resources in regions with high death-to-case ratios
- Accelerate vaccination efforts in countries with low coverage
- Track rolling vaccination metrics to monitor real-time progress
- Use country-level insights to support targeted public health policies

---

## Dataset Overview
- **Source:** Public COVID-19 dataset  
- **Tables:** CovidDeaths, CovidVaccinations  
- **Total Records:** ~85,000+ rows  
- **Granularity:** Daily, country-level data  
- **Key Metrics:** Cases, deaths, population, vaccinations  

---

