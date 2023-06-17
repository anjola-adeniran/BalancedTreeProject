-- The name and length (in seconds) of all tracks that have lengths between 50 and 70 seconds

SELECT * FROM public."Track"
ORDER BY "TrackId" ASC;

SELECT "Name","Milliseconds" FROM public."Track"
WHERE "Milliseconds" BETWEEN 50000 AND 70000;

-- all the albums by artists with the word ‘black’ in their name
SELECT * from public."Album";
SELECT * FROM public."Artist";

SELECT * FROM "Album" al
JOIN "Artist" ar 
ON ar."ArtistId" = al."ArtistId"
WHERE ar."Name" LIKE '%black%'

-- query showing a unique/distinct list of billing countries from the Invoice table
SELECT DISTINCT "BillingCountry" FROM "Invoice";

-- the city with the highest sum total invoice
select "BillingCity",sum("Total") as invoice_totals from "Invoice"
Group By 1
order by 2 Desc
limit 1;

-- A table that lists each country and the number of customers in that country
SELECT "BillingCountry", COUNT ("CustomerId") FROM "Invoice"
Group By "BillingCountry"

-- the top five customers in terms of sales i.e. find the five customers whose total combined invoice amounts are the highest. Give their name, CustomerId and total invoice amount.
SELECT CONCAT ("FirstName",' ', "LastName") AS "FullName",Inv."CustomerId", Inv."Total" FROM "Customer" Cus
JOIN "Invoice" Inv
ON Cus."CustomerId" = Inv."CustomerId"
ORDER BY "Total" DESC
LIMIT 5;

-- Find out the state-wise count of customerID and list the names of states with the count of customerID in decreasing order. Note:- do not include where states isnull value.
SELECT "State", COUNT ("CustomerId") AS "Numberofcustomers" FROM "Customer"
WHERE "State" IS NOT NULL 
GROUP BY "State"
ORDER BY "Numberofcustomers" DESC

-- How many Invoices were there in 2009 and 2011
SELECT COUNT ("Total") FROM "Invoice"
WHERE "InvoiceDate" BETWEEN '2009-01-01'AND '2011-01-01'

-- showing only the Employees who are Sales Agents
SELECT CONCAT ("FirstName",' ',"LastName") AS "FullName","Title" FROM "Employee"
WHERE "Title" = 'Sales Support Agent'

-- What was the invoice date for invoice ID 315?
SELECT "InvoiceDate","InvoiceId" FROM "Invoice"
WHERE "InvoiceId" = '315'
