# HR Attrition & Training Analytics

## Background
Adviti Pvt. Ltd. is a multifaceted consulting firm operating across various industry domains. The company focuses on leveraging data-driven insights to improve organizational efficiency and strategic decision-making.

This project analyzes HR data to identify factors influencing employee attrition and evaluate the effectiveness of employee training programs.

---

## Problem Statements

### 1. Employee Attrition Analysis
Objective:
Identify the key factors contributing to employee attrition and recommend strategies to improve employee retention.

### 2. Training Program Effectiveness
Objective:
Evaluate whether employee training programs improve employee performance and engagement.

---

## Tools & Technologies Used
- SQL
- Power BI
- Excel

---

## Dataset Features
The dataset includes:
- Employee Demographics
- Salary Information
- Department & Position
- Performance Ratings
- Work Hours
- Training Hours
- Promotion Status
- Employee Engagement Scores
- Attrition Information

---

## Data Cleaning & Preparation
The following preprocessing steps were performed:
- Checked for missing values
- Corrected data types
- Created binary columns for analysis
- Standardized categorical values
- Prepared data for SQL querying and dashboard visualization

---

## Analysis Performed

### Attrition Analysis
- Attrition by department
- Salary vs attrition
- Work hours vs attrition
- Promotion impact on attrition
- Employee engagement impact
- Years of service analysis

### Training Program Analysis
- Training hours vs performance rating
- Training hours vs attrition
- Department-wise training comparison
- Engagement score analysis

---

## Key Insights
- Employees with lower salaries showed higher attrition rates.
- Employees with low engagement scores were more likely to leave.
- Longer work hours did not always improve retention.
- Higher training hours alone did not significantly reduce attrition.
- Certain departments experienced consistently higher employee turnover.

---

## Recommendations
- Improve employee engagement initiatives.
- Introduce targeted retention programs for high-risk departments.
- Review compensation structures for lower salary groups.
- Optimize training quality instead of focusing only on training duration.
- Monitor employee workload and work-life balance.

---

## Dashboard Preview

### HR Attrition Dashboard
![Dashboard](images/dashboard.png)

---

## Project Structure

```text
HR-Attrition-Analysis/
│
├── dashboard/
│   └── HR_Attrition.pbix
│
├── sql_queries/
│   └── analysis.sql
│
├── images/
│   └── dashboard.png
│
└── README.md
```

---

## SQL Analysis
The SQL scripts include:
- Data cleaning queries
- Aggregation queries
- Attrition analysis
- Training effectiveness analysis
- KPI calculations

---

## Conclusion
This project demonstrates how HR analytics can support data-driven decision-making by identifying workforce trends, improving employee retention strategies, and evaluating training effectiveness.
