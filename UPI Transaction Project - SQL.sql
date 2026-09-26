-- 1. All transactions
SELECT * FROM upi_transaction_data utd ;

-- 2. Transactions above ₹10,000
SELECT * FROM upi_transaction_data utd 
WHERE utd."Amount_INR" > 10000;

-- 3. Transactions from HDFC bank
SELECT * FROM upi_transaction_data utd 
WHERE utd."Bank_Name"  = 'SBI';

-- 4. Failed transactions
SELECT * FROM upi_transaction_data utd  
WHERE utd."Status" = 'Failed';

-- 5. Transactions in July 2026
SELECT * FROM upi_transaction_data utd 
WHERE EXTRACT(MONTH FROM to_date(utd."Transaction_Date", 'DD-MM-YYYY')) = 5
  AND EXTRACT(YEAR FROM to_date(utd."Transaction_Date", 'DD-MM-YYYY')) = 2026;

-- 6. Total transaction amount per bank
SELECT "Bank_Name", SUM("Amount_INR") AS total_amount
FROM upi_transaction_data utd 
GROUP BY "Bank_Name";

-- 7. Average transaction per merchant
SELECT utd."Merchant_Name", AVG("Amount_INR") AS avg_amount
FROM upi_transaction_data utd 
GROUP BY utd."Merchant_Name";

-- 8. Count of transactions per payment app
SELECT utd."UPI_App", COUNT(*) AS txn_count
FROM upi_transaction_data utd 
GROUP BY utd."UPI_App";

-- 9. Merchants with more than 100 transactions
SELECT utd."Merchant_Name", COUNT(*) AS txn_count
FROM upi_transaction_data utd 
GROUP BY utd."Merchant_Name"
HAVING COUNT(*) > 100;

-- 10. Merchant Category with total transaction value above ₹1,00,000
SELECT utd."Merchant_Category", SUM("Amount_INR") AS total_value
FROM upi_transaction_data utd 
GROUP BY utd."Merchant_Category"
HAVING SUM("Amount_INR") > 100000;

-- 11. Top 10 highest transactions
SELECT * FROM upi_transaction_data utd 
ORDER BY utd."Amount_INR" DESC
LIMIT 10;

-- 12. Lowest 5 transactions
SELECT * FROM upi_transaction_data utd 
ORDER BY utd."Amount_INR" ASC
LIMIT 5;

-- 13. Top 5 merchants by transaction volume
SELECT utd."Merchant_Name", SUM("Amount_INR") AS total_sales
FROM upi_transaction_data utd 
GROUP BY utd."Merchant_Name"
ORDER BY total_sales DESC
LIMIT 5;

-- 14. Most active Customers
SELECT utd."Customer_ID", COUNT(*) AS txn_count
FROM upi_transaction_data utd 
GROUP BY UTD."Customer_ID"
ORDER BY txn_count DESC
LIMIT 10;

-- 15. Daily totals
SELECT DATE("Transaction_Date") AS txn_day, SUM("Amount_INR") AS Total_Amount
FROM upi_transaction_data utd 
GROUP BY txn_day;

-- 24. Monthly totals
SELECT DATE_TRUNC('month', to_date(utd."Transaction_Date",'DD-MM-YYYY')) AS txn_month, SUM("Amount_INR") AS total
FROM upi_transaction_data utd 
GROUP BY txn_month;

-- 17. Count distinct Customers
SELECT COUNT(DISTINCT "Customer_ID") AS unique_senders
FROM upi_transaction_data utd ;

-- 18. Count distinct receivers
SELECT COUNT(DISTINCT "Merchant_Name") AS unique_receivers
FROM upi_transaction_data utd ;

-- 19. Highest transaction per bank
SELECT "Bank_Name", MAX("Amount_INR") AS max_txn
FROM upi_transaction_data utd 
GROUP BY "Bank_Name";

-- 20. Lowest transaction per merchant category
SELECT utd."Merchant_Category", MIN("Amount_INR") AS min_txn
FROM upi_transaction_data utd 
GROUP BY "Merchant_Category";

-- 21. Transactions per Customer per day
SELECT utd."Customer_ID", DATE("Transaction_Date"), COUNT(*) AS txn_count
FROM upi_transaction_data utd 
GROUP BY utd."Customer_ID", DATE("Transaction_Date");

-- 22. Average transaction per day
SELECT DATE("Transaction_Date"), AVG("Amount_INR") AS avg_txn
FROM upi_transaction_data utd 
GROUP BY DATE("Transaction_Date");

-- 23. Top 3 senders per bank
SELECT "Bank_Name", "Customer_ID", txn_count
FROM (
    SELECT utd."Bank_Name", utd."Customer_ID", COUNT(*) AS txn_count,
           RANK() OVER (PARTITION BY "Bank_Name" ORDER BY COUNT(*) DESC) AS rnk
    FROM upi_transaction_data utd
    GROUP BY utd."Bank_Name",utd."Customer_ID"
) t
WHERE rnk <= 3;

-- 24. Match customers with merchants they paid
SELECT t1."Customer_ID", t2."Merchant_Name" , t1."Amount_INR", t1."Transaction_Date"
FROM upi_transaction_data t1
JOIN upi_transaction_data t2
  ON t1."Merchant_Name" = t2."Merchant_Name"
WHERE t1."Customer_ID" <> t2."Customer_ID";

-- 25. Find customers who paid the same merchant multiple times
SELECT t1."Customer_ID", 
       t1."Merchant_Name", 
       t1."Amount_INR", 
       t2."Amount_INR"
FROM upi_transaction_data t1
JOIN upi_transaction_data t2
  ON t1."Customer_ID" = t2."Customer_ID"
 AND t1."Merchant_Name" = t2."Merchant_Name"
 AND t1."Transaction_ID" <> t2."Transaction_ID";

-- 26. Customers with their highest transaction
SELECT t."Customer_ID", 
       t."Transaction_ID", 
       t."Amount_INR"
FROM upi_transaction_data t
JOIN (
    SELECT "Customer_ID", MAX("Amount_INR") AS max_amt
    FROM upi_transaction_data
    GROUP BY "Customer_ID"
) sub 
  ON t."Customer_ID" = sub."Customer_ID" 
 AND t."Amount_INR" = sub.max_amt;

-- 27. Merchants with their top customers
SELECT t."Customer_ID", 
       t."Merchant_Name", 
       t."Amount_INR"
FROM upi_transaction_data t
JOIN (
    SELECT "Merchant_Name", MAX("Amount_INR") AS max_amt
    FROM upi_transaction_data
    GROUP BY "Merchant_Name"
) sub 
  ON t."Merchant_Name" = sub."Merchant_Name" 
 AND t."Amount_INR" = sub.max_amt;

-- 28. Rank customers by spending per merchant
SELECT t."Customer_ID", 
       t."Merchant_Name", 
       SUM(t."Amount_INR") AS total_spent,
       RANK() OVER (PARTITION BY t."Merchant_Name" ORDER BY SUM(t."Amount_INR") DESC) AS rank_in_merchant
FROM upi_transaction_data t
GROUP BY t."Customer_ID", t."Merchant_Name";

-- 29. Transactions above average amount
SELECT * FROM upi_transaction_data
WHERE "Amount_INR" > (SELECT AVG("Amount_INR")
FROM upi_transaction_data);

-- 30. Merchants with avg txn > overall avg
SELECT "Merchant_Name", AVG("Amount_INR") AS avg_amount
FROM upi_transaction_data
GROUP BY "Merchant_Name"
HAVING AVG("Amount_INR") > (SELECT AVG("Amount_INR") 
FROM upi_transaction_data);

-- 31. Customers with more than 50 transactions
SELECT "Merchant_Name", AVG("Amount_INR") AS avg_amount
FROM upi_transaction_data
GROUP BY "Merchant_Name"
HAVING AVG("Amount_INR") > (SELECT AVG("Amount_INR")
FROM upi_transaction_data);

-- 32. Transactions from top 5 banks by volume
SELECT * FROM upi_transaction_data
WHERE "Bank_Name" IN (
    SELECT "Bank_Name"
    FROM upi_transaction_data
    GROUP BY "Bank_Name"
    ORDER BY SUM("Amount_INR") DESC
    LIMIT 5
);

-- 33. Rank transactions by amount
SELECT "Transaction_ID", 
       "Amount_INR",
       RANK() OVER (ORDER BY "Amount_INR" DESC) AS rank_amount
FROM upi_transaction_data;

-- 34. Running total per customers
SELECT "Transaction_ID", 
       "Amount_INR",
       RANK() OVER (ORDER BY "Amount_INR" DESC) AS rank_amount
FROM upi_transaction_data;

-- 35. Average transaction per bank
SELECT "Bank_Name", 
       "Transaction_ID", 
       "Amount_INR",
       AVG("Amount_INR") OVER (PARTITION BY "Bank_Name") AS avg_per_bank
FROM upi_transaction_data;

-- 36. Top transaction per merchant
SELECT "Bank_Name", 
       "Transaction_ID", 
       "Amount_INR",
       AVG("Amount_INR") OVER (PARTITION BY "Bank_Name") AS avg_per_bank
FROM upi_transaction_data;





