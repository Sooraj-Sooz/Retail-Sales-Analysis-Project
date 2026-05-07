--CREATE DATABASE
CREATE DATABASE Payment_Log

--CUSTOMER DEMOGRAPHIC ANALYSIS
--1. Revenue by Age Group
SELECT 
CASE 
WHEN AGE<30 THEN 'Under 30'
WHEN AGE<40 THEN '30-39'
WHEN AGE<50 THEN '40-49'
ELSE '50+'
END AS Age_Group,
Round(SUM(Revenue),2) as Total_revenue
FROM [Payment_Log+Clean]
Group by
CASE 
WHEN AGE<30 THEN 'Under 30'
WHEN AGE<40 THEN '30-39'
WHEN AGE<50 THEN '40-49'
ELSE '50+'
END
Order by Total_revenue DESC

--2. Revenue by Gender
SELECT Gender, SUM(Revenue) as Total_revenue
From [Payment_Log+Clean]
Group by Gender
Order by Total_revenue Desc

--3. Loyalty Analysis
SELECT Loyalty_Member, round(sum(Revenue),2) as Total_revenue, round(Avg(Revenue),2) as Avg_Order_Value,
count(*) as Total_Orders, AVG(CAST(Cancelled_Flag AS DECIMAL(10,4))) AS Cancellation_Rate
from [Payment_Log+Clean]
Group by Loyalty_Member
Order by Total_revenue Desc
  
--PRODUCT PERFORMANCE ANAYSIS
--1. Product Type Analysis
SELECT Product_Type, ROUND(SUM(Revenue),2) AS Total_Revenue, SUM(Quantity) AS Total_Quantity,
ROUND(AVG(Rating),2) AS Avg_Rating,
AVG(CAST(Cancelled_Flag AS DECIMAL(10,4))) AS Cancellation_Rate
FROM [Payment_Log+Clean]
GROUP BY Product_Type
ORDER BY Total_Revenue

--2. SKU Analysis
SELECT SKU, ROUND(SUM(Revenue),2) AS Total_Revenue,
SUM(Quantity) AS Total_Quantity,
ROUND(AVG(Rating),2) AS Avg_Rating,
AVG(CAST(Cancelled_Flag AS DECIMAL(10,4))) AS Cancellation_Rate
FROM [Payment_Log+Clean]
GROUP BY SKU
ORDER BY Total_Revenue

--PAYMENT BEHAVIOUR ANALYSIS
--1. Payment method Analysis
SELECT 
Payment_Method,
COUNT(*) AS Total_Orders,
ROUND(SUM(Revenue),2) AS Total_Revenue,
ROUND(AVG(Revenue),2) AS Avg_Order_Value,
AVG(CAST(Cancelled_Flag AS DECIMAL(10,4))) AS Cancellation_Rate
FROM [Payment_Log+Clean]
GROUP BY Payment_Method
ORDER BY Total_Revenue DESC

--SHIPPING BEHAVIOUR ANALYSIS
--1. Total revenue per shipping type
SELECT Shipping_Type,
COUNT(*) AS Total_Orders,
ROUND(SUM(Revenue),2) AS Total_Revenue,
AVG(CAST(Cancelled_Flag AS DECIMAL(10,4))) AS Cancellation_Rate
FROM [Payment_Log+Clean]
GROUP BY Shipping_Type
ORDER BY Total_Revenue DESC

--ADD-ON PURCHASE ANALYSIS
--1. Percentage of Orders with Add-ons
SELECT 
AVG(CASE 
    WHEN Add_ons_Purchased = 'None' THEN 0.0
    ELSE 1.0
    END
    ) AS Addon_Attach_Rate
FROM [Payment_Log+Clean]

--2. Add-on Revenue Contribution Percentage
SELECT 
    ROUND(SUM(Add_on_Total) * 1.0 / SUM(Revenue),5) AS Addon_Revenue_Percentage
FROM [Payment_Log+Clean]

--3. Add-ons by Product Type
SELECT Product_Type,
ROUND(SUM(Add_on_Total),3) AS Addon_Revenue,
AVG(CASE 
    WHEN Add_ons_Purchased = 'None' THEN 0 ELSE 1 
    END
    ) AS Attach_Rate
FROM [Payment_Log+Clean]
GROUP BY Product_Type
ORDER BY Addon_Revenue DESC

--RATINGS & SATISFACTION ANALYSIS
--1. Product Satisfaction rate
SELECT Product_Type,
AVG(CAST(Rating AS DECIMAL(10,2))) AS Avg_Rating,
AVG(CAST(Cancelled_Flag AS DECIMAL(10,4))) AS Cancellation_Rate
FROM [Payment_Log+Clean]
GROUP BY Product_Type
ORDER BY Avg_Rating DESC

--2. Rating V/s Cancellation
SELECT Rating,
COUNT(*) AS Total_Orders,
AVG(CAST(Cancelled_Flag AS DECIMAL(10,4))) AS Cancellation_Rate
FROM [Payment_Log+Clean]
GROUP BY Rating
ORDER BY Rating

--3. Rating V/s repeated Purchase
WITH customer_orders AS (
    SELECT Customer_ID,
           COUNT(*) AS Order_Count
    FROM [Payment_Log+Clean]
    GROUP BY Customer_ID
)

SELECT 
    o.Rating,
    AVG(CASE WHEN c.Order_Count > 1.0 THEN 1 ELSE 0.0 END) AS Repeat_Rate
FROM [Payment_Log+Clean] o
JOIN customer_orders c
    ON o.Customer_ID = c.Customer_ID
GROUP BY o.Rating
ORDER BY Repeat_Rate DESC

--TIME BASED TRENDS
--1. Monthly Revenue & Orders
SELECT 
FORMAT(Purchase_Date,'yyyy-MM') AS Year_Month,
ROUND(SUM(Revenue),2) AS Monthly_Revenue,
COUNT(*) AS Monthly_Orders,
AVG(CAST(Cancelled_Flag AS DECIMAL(10,4))) AS Cancellation_Rate
FROM [Payment_Log+Clean]
GROUP BY FORMAT(Purchase_Date,'yyyy-MM')
ORDER BY Year_Month 

