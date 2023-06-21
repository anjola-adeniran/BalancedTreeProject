-- all the invoices from the billing city Edmonton, and Vancouver and sort in descending order by invoice ID
SELECT COUNT ("Total"),"InvoiceId" FROM "Invoice"
WHERE "BillingCity" IN ('Edmonton','Vancouver')
GROUP BY "InvoiceId"
ORDER BY "InvoiceId" DESC

-- all the customer emails that start with "J" and are from gmail.com
SELECT * FROM "Customer"
WHERE "Email" LIKE 'J%gmail.com'

-- a query showing Customers (just their full names, customer ID and country) who are not in the US
SELECT CONCAT ("FirstName", ' ',"LastName") AS "FullName","CustomerId","Country" FROM "Customer"
WHERE "Country" NOT IN ('USA')

-- A query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country
SELECT inv."InvoiceId",inv."InvoiceDate",inv."BillingCountry",CONCAT("FirstName",' ',"LastName") AS "FullName" FROM "Invoice" inv 
JOIN "Customer" cus ON inv."CustomerId" = cus."CustomerId"
WHERE "BillingCountry" IN ('Brazil')

--Provide a query showing only the Employees who are Sales Agents
SELECT * FROM "Employee"
WHERE "Title" LIKE '%Sales Support Agent%'