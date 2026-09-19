# UPI-Transaction-Analytics---End-to-End-Project
UPI Transaction analytics on 1 table with 500000+ rows &amp; 22 columns. Excel dashboard with Pivot Tables, Charts, Slicers &amp; summary, 40+ SQL queries using Group By, Order By, Having, Joins, Subqueries &amp; Window Functions, Python EDA via Pandas, Seaborn, Matplotlib &amp; Power BI dashboard with Power Query, DAX visuals &amp; transaction KPIs for total growth.

# 💸 UPI Transaction Analytics - End-to-End Project

> UPI Transaction analytics on 1 table with 50000+ rows & 12 columns. Excel dashboard with Pivot Tables, Charts, Slicers & summary, 40+ SQL queries using Group By, Order By, Having, Joins, Subqueries & Window Functions, Python EDA via Pandas, Seaborn, Matplotlib & Power BI dashboard with Power Query, DAX visuals & transaction KPIs for total growth.

### 📊 Dataset - 1 Table Only
- **File:** `upi_transactions.csv`
- **Rows:** 50000+ transactions
- **Columns:** 12 columns
- **How I Read:** `df = pd.read_csv('upi_transactions.csv')` -> `df.shape` = (50000, 12), `df.info()`, `df.isnull().sum()`
- **Columns:** transaction_id, sender_name, sender_bank, receiver_name, receiver_bank, amount, transaction_type (P2P/P2M), status (Success/Failed/Pending), timestamp, city, upi_app (PhonePe/GPay/Paytm), fee

### 🛠️ Workflow

**1. Excel - Dynamic Dashboard**
- Cleaning: Remove duplicates, format amount, handle failed status
- Pivot Tables: Bank-wise total amount, City-wise count, Status-wise success rate
- Charts: Monthly trend line, Bank share bar, App usage pie
- Slicers: City, Bank, Status, App
- Final: Summary sheet + Dynamic Dashboard with KPI - Total Amount, Success %

**2. SQL - 40+ Queries**
File: `upi_40_queries.sql`
- **Group By & Having:** Banks with transaction amount > 10L, Cities with >1000 transactions
- **Order By:** Top 10 highest amount transactions DESC, Latest transactions
- **Joins:** Self Join - Same sender doing multiple transactions, Sender vs Receiver bank comparison
- **Subqueries:** Users who transacted above avg amount, Banks with failed % > avg
- **Window Functions:** RANK() banks by volume, ROW_NUMBER() per user latest txn, LAG() MoM growth, SUM() OVER() running total, AVG() OVER() per city

**3. Python - Pandas, Seaborn, Matplotlib**
- `pd.read_csv()` - 500000 rows read
- EDA: Peak hours (7-9 PM), Success rate 92%, Top bank HDFC, Top app PhonePe
- Visuals: Bar, Line, Heatmap, Boxplot for amount distribution

**4. Power BI - Power Query, DAX, Visuals**
- Power Query: Split timestamp to Date/Time, Replace nulls
- DAX: Total Amount = SUM(amount), Success Rate = DIVIDE(Success, Total), Avg Amount = AVERAGE(amount), Failed Count
- Dashboard: KPI Cards, Map visual for city, Bar for bank, Line for trend, Slicers for app

### 📁 Structure
