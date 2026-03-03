USE churnsql;
-- ========================================
-- SECTION 1: DATA CLEANING
-- ========================================

-- Churn Customers
SELECT 
COUNT(*) AS churn_customers 
FROM cs_churn 
WHERE churn = 'Yes';

-- Create a View
CREATE OR REPLACE VIEW customer_final AS
 SELECT *,
 -- Create Tenure Group
     CASE 
         WHEN tenure_months < 6 THEN '0-6 Months'
         WHEN tenure_months BETWEEN 6 AND 12 THEN '6-12 Months'
         ELSE '1+ Year'
     END AS Tenure_Group,
     -- Create Usage Group
     CASE
         WHEN avg_weekly_usage_hours < 5 THEN 'Low Usage'
         WHEN avg_weekly_usage_hours BETWEEN 5 AND 15 THEN 'Medium Usage'
         ELSE 'High Usage'
     END AS Usage_Group,
     -- Create Payment Risk 
     CASE
         WHEN payment_failures > 2 THEN 'High Delay'
         ELSE 'No/Low Delay'
 	END AS Payment_Risk
 FROM cs_churn;


-- ========================================
-- SECTION 2: KPI CALCULATIONS
-- ========================================

-- Total Customers
SELECT 
COUNT(*) AS total_customers 
FROM cs_churn;

-- Churn Rate 
SELECT 
ROUND(100 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END ) / COUNT(*),2) AS Churn_rate_percent
FROM cs_churn; 


-- Revenue Lost
SELECT 
SUM(monthly_fee) AS Revenue_Lost 
FROM cs_churn 
WHERE churn = 'Yes' ;

-- ========================================
-- SECTION 3: DRIVER ANALYSIS
-- ========================================

-- Tenure Group vs Churn
SELECT 
 Tenure_Group,
 COUNT(*) AS Total_Customers,
 SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
 ROUND(100 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / cOUNT(*),2) AS Churn_Rate 
 From Customer_final
 GROUP BY Tenure_Group
 ORDER BY Churn_Rate DESC;

-- Subscription Type vs Churn
SELECT 
plan_type, 
COUNT(*) AS Total_Customers, 
 SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
 ROUND(100 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS churn_rate
 FROM cs_churn
 GROUP BY plan_type;
 
 -- Usage Group Vs Churn rate 
 SELECT 
 Usage_Group,
 ROUND(100 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS Churn_Rate
 FROM Customer_final
 GROUP BY Usage_Group;
 
 -- Support Group Vs Churn Rate 
SELECT 
 CASE
     WHEN support_tickets > 3 THEN 'Frequent Complaints'
     ELSE 'Normal'
END AS Support_Group,
ROUND(100 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),2) AS Churn_Rate
FROM customer_final
GROUP BY Support_Group;