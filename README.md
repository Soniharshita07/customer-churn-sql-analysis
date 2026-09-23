# 📉 Customer Churn & Revenue Risk Analysis

## 🎯 Project Overview
This project delivers a comprehensive exploratory data analysis (EDA) and financial risk assessment of customer churn for a subscription-based telecommunications business. Using **PostgreSQL**, this analysis uncovers behavioral patterns, quantifies monthly recurring revenue (MRR) leakage, and outlines prescriptive strategies to improve customer retention.

---

## 📂 Executive Summary & Key Findings

| Analysis Dimension | Core Finding | Financial / Business Impact |
| :--- | :--- | :--- |
| **Contract Type** | Month-to-month users churn at **42.71%** vs. 2.83% for 2-year contracts[cite: 2]. | Bleeding over **$120K in MRR ($1.4M+ annually)**[cite: 8]. |
| **Tenure** | **47.44%** of churn occurs within the first 12 months[cite: 5]. | Highlights a critical onboarding and early-lifecycle failure. |
| **Payment Method** | Electronic check users experience a **45.29%** churn rate[cite: 4]. | Manual billing friction significantly increases customer abandonment. |
| **Product Bundling** | Churn drops from **44.92%** (3 services) down to **5.29%** (all 9 services)[cite: 9]. | Cross-product integration creates an effective "retention moat." |

---

## 🛠️ SQL Queries & Analytical Workflow

### 1. Financial Impact Analysis (MRR Leakage by Contract)
Evaluated how much monthly revenue is walking out the door based on contract flexibility:
```sql
SELECT 
    contract,
    COUNT(customerid) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(CAST(SUM(monthlycharges) AS numeric), 2) AS total_monthly_revenue,
    ROUND(CAST(SUM(CASE WHEN churn = 'Yes' THEN monthlycharges ELSE 0 END) AS numeric), 2) AS monthly_revenue_lost
FROM customer
GROUP BY contract
ORDER BY monthly_revenue_lost DESC;
