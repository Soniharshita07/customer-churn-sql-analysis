
-- CUSTOMER CHURN & REVENUE RISK ANALYSIS
-- Database: PostgreSQL (pgAdmin)
-- Dataset: Telco Customer Churn


-- 1. Baseline Churn Rate Overview
SELECT 
    churn,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) AS percentage
FROM customers
GROUP BY churn;


-- 2. Churn by Contract Type
SELECT 
    contract, 
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY contract
ORDER BY churn_rate_pct DESC;


-- 3. Churn by Internet Service Type
SELECT 
    internetservice, 
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY internetservice
ORDER BY churn_rate_pct DESC;


-- 4. Churn by Payment Method
SELECT 
    paymentmethod, 
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY paymentmethod
ORDER BY churn_rate_pct DESC;


-- 5. Churn by Tenure Groups (The Onboarding Cliff)
SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-1 Year'
        WHEN tenure <= 24 THEN '1-2 Years'
        WHEN tenure <= 48 THEN '2-4 Years'
        ELSE '4+ Years'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY tenure_group
ORDER BY churn_rate_pct DESC;


-- 6. Churn by Monthly Charge Tiers
SELECT 
    CASE 
        WHEN monthlycharges < 30 THEN 'Low (< $30)'
        WHEN monthlycharges BETWEEN 30 AND 70 THEN 'Medium ($30-$70)'
        ELSE 'High (> $70)'
    END AS charge_tier,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY charge_tier
ORDER BY churn_rate_pct DESC;


-- 7. Churn by Tech Support Availability
SELECT 
    techsupport, 
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY techsupport;


-- 8. Financial Impact: Revenue at Risk by Contract Type
SELECT 
    contract,
    COUNT(customerid) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(CAST(SUM(monthlycharges) AS numeric), 2) AS total_monthly_revenue,
    ROUND(CAST(SUM(CASE WHEN churn = 'Yes' THEN monthlycharges ELSE 0 END) AS numeric), 2) AS monthly_revenue_lost
FROM customers
GROUP BY contract
ORDER BY monthly_revenue_lost DESC;


-- 9. Ecosystem Stickiness: Impact of Total Services Used on Churn
SELECT 
    (CASE WHEN phoneservice = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN multiplelines = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN internetservice != 'No' THEN 1 ELSE 0 END +
     CASE WHEN onlinesecurity = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN onlinebackup = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN deviceprotection = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN techsupport = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN streamingtv = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN streamingmovies = 'Yes' THEN 1 ELSE 0 END) AS total_services_used,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY total_services_used
ORDER BY total_services_used;
