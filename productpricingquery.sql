-- combining order years 
;with all_orders as(
SELECT OrderID,
	CustomerID,
	ProductID,
	OrderDate,
	Quantity,
	Revenue,
	COGS
FROM Orders_2023

union all
SELECT OrderID,
	CustomerID,
	ProductID,
	OrderDate,
	Quantity,
	Revenue,
	COGS
FROM Orders_2024

union all
SELECT OrderID,
	CustomerID,
	ProductID,
	OrderDate,
	Quantity,
	Revenue,
	COGS
FROM Orders_2025)

-- building the main dataset query 
Select 
	a.OrderID,
	a.CustomerID,
	c.Region,
	a.ProductID,
	a.OrderDate,
	DATEADD(WEEK, DATEDIFF(week,0, a.OrderDate),0) as Week_Date,
	c.CustomerJoinDate,
	a.Quantity,
	a.Revenue,
	CASE WHEN a.Revenue is NULL THEN p.Price * a.Quantity ELSE a.Revenue END as CleanedRevenue,
	a.Revenue - a.COGS as Profit,
	a.COGS,
	p.ProductName,
	p.ProductCategory,
	p.Price,
	p.Base_Cost
from all_orders a
left join customers c
on a.CustomerID = c.CustomerID
left join products p
on a.ProductID = p.ProductID
WHERE a.CustomerID is not NULL -- droppping the non customer ids 
