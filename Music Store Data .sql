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

-- the top five customers in terms of sales i.e. find the five customers whose total combined invoice amounts are the highest. 
-- Give their name, CustomerId and total invoice amount.
SELECT CONCAT ("FirstName",' ', "LastName") AS "FullName",Inv."CustomerId", Inv."Total" FROM "Customer" Cus
JOIN "Invoice" Inv
ON Cus."CustomerId" = Inv."CustomerId"
ORDER BY "Total" DESC
LIMIT 5;

-- Find out the state-wise count of customerID and list the names of states with the count of customerID in decreasing order. 
-- Do not include where states isnull value.
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

-- A query showing the Invoices of customers who are from Brazil. 
-- The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country
SELECT inv."InvoiceId",inv."InvoiceDate",inv."BillingCountry",CONCAT("FirstName",' ',"LastName") AS "FullName" FROM "Invoice" inv 
JOIN "Customer" cus ON inv."CustomerId" = cus."CustomerId"
WHERE "BillingCountry" IN ('Brazil')

--Provide a query showing only the Employees who are Sales Agents
SELECT * FROM "Employee"
WHERE "Title" LIKE '%Sales Support Agent%'

-- query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name
SELECT 
	Emp."FirstName" || ' ' || Emp."LastName" AS "Employee Name",
	inv."InvoiceId"
FROM 
	"Employee" Emp
JOIN "Customer" Cus
ON Emp."EmployeeId" = Cus."SupportRepId"
JOIN "Invoice" inv
ON Cus."CustomerId" = inv."CustomerId"

-- Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT 
	Emp."FirstName" || ' ' || Emp."LastName" AS "Employee Name",
	inv."InvoiceId",
	inv."Total",
	Cus."FirstName" || ' ' || Cus."LastName" AS "Customer Name",
	Cus."Country"
	
FROM 
	"Employee" Emp
JOIN "Customer" Cus
ON Emp."EmployeeId" = Cus."SupportRepId"
JOIN "Invoice" inv
ON Cus."CustomerId" = inv."CustomerId"

--  Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37
SELECT COUNT (*) FROM "InvoiceLine"
WHERE "InvoiceId" = 37

-- A query that includes the purchased track name AND artist name with each invoice line item.
SELECT 
	invl."InvoiceLineId",
	tr."Name" as "Track Name",
	ar."Name" as "Artist Name"
from "InvoiceLine" invl
join "Track" tr on invl."TrackId" = invl."TrackId"
join "Album" al on tr."AlbumId" = al."AlbumId"
join "Artist" ar on al."ArtistId" = ar."ArtistId"

-- Provide a query that shows the # of invoices per country.
SELECT "BillingCountry",
COUNT ("InvoiceId") AS "Number of Invoice"
FROM "Invoice"
GROUP BY "BillingCountry"
ORDER BY "Number of Invoice" DESC

-- a query that shows the total number of tracks in each playlist. The Playlist name should be included on the resultant table.
SELECT Pl."Name",COUNT(Tr."TrackId") AS "TotalNumberTracks" FROM "Playlist" Pl
JOIN "PlaylistTrack" Plt
ON Pl."PlaylistId" = Plt."PlaylistId"
JOIN "Track" Tr
ON Plt."TrackId" = Tr."TrackId"
GROUP BY Pl."Name"

-- a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
SELECT Alb."Title" AS "AlbumName",Mdt."Name" AS "MediaType",Gnr."Name" AS "GenreName" FROM "Track" Tr
JOIN "MediaType" Mdt
ON Tr."MediaTypeId" = Mdt."MediaTypeId"
JOIN "Album" Alb
ON Tr."AlbumId" = Alb."AlbumId"
JOIN "Genre" Gnr
ON Tr."GenreId" = Gnr."GenreId"

-- a query that shows all invoices but includes the number of invoice line items
SELECT Inv."InvoiceId", COUNT ("InvoiceLineId") AS "NumberofInvoiceLine" FROM "Invoice" Inv
JOIN "InvoiceLine" Ivl
ON Inv."InvoiceId" = Ivl."InvoiceId"
GROUP BY Inv."InvoiceId"

-- a query that shows total sales made by each agent
SELECT Emp."FirstName" || ' ' || Emp."LastName" AS "Employee Name",Cus."CustomerId",  Inv."InvoiceId", SUM (Inv."Total") AS"Total Sales"
FROM "Invoice" Inv
JOIN "Customer" Cus
On Inv."CustomerId"= Cus."CustomerId"
JOIN "Employee" Emp
ON Cus."SupportRepId" = Emp."EmployeeId"
GROUP BY Emp."FirstName",Emp."LastName", Cus."CustomerId",Inv."InvoiceId")

-- Which sales agent made the most in sales in 2009?
SELECT "Employee Name",MAX ("Total Sales") AS "Total Sales" FROM 
	(SELECT Emp."FirstName" || ' ' || Emp."LastName" AS "Employee Name",Cus."CustomerId",  Inv."InvoiceId", SUM (Inv."Total") AS "Total Sales"
	FROM "Invoice" Inv
	JOIN "Customer" Cus
	On Inv."CustomerId"= Cus."CustomerId"
	JOIN "Employee" Emp
	ON Cus."SupportRepId" = Emp."EmployeeId"
	WHERE Inv."InvoiceDate" BETWEEN '2008-01-31' AND '2009-12-31'
	GROUP BY Emp."FirstName",Emp."LastName", Cus."CustomerId",Inv."InvoiceId") AS Subquery
GROUP BY "Employee Name"

-- Provide a query that shows the top 5 most purchased tracks overall.
SELECT Tra."Name",COUNT (Inv."InvoiceId") AS "Most Purchased Tracks" FROM "Invoice" Inv
JOIN "InvoiceLine" Invl
ON Inv."InvoiceId" = Invl."InvoiceId"
JOIN "Track" Tra
ON Invl."TrackId" = Tra."TrackId"
GROUP BY Tra."TrackId"
ORDER BY "Most Purchased Tracks" DESC
LIMIT 5

-- Provide a query that shows the top 3 best selling artists.
SELECT Art."Name",SUM(Ivl."UnitPrice") AS "Total", COUNT (Tra."TrackId") AS "Track Sold" FROM "Artist" Art
JOIN "Album" Alb
ON Art."ArtistId" = Alb."ArtistId"
JOIN "Track" Tra
ON Alb."AlbumId" = Tra."AlbumId"
JOIN "InvoiceLine" Ivl
ON Tra."TrackId" = Ivl."TrackId"
GROUP BY Art."Name"
ORDER BY "Total" DESC
LIMIT 3

-- Provide a query that shows the most purchased Media Type.
SELECT "Media Type", MAX ("Most Purchased") AS "Most Purchased Media Type" FROM 
	(SELECT (Mdt."Name") AS "Media Type",Mdt."MediaTypeId",Tra."TrackId", SUM (Ivl."UnitPrice") AS "Most Purchased",Ivl."InvoiceId" FROM "Track" Tra
	JOIN "MediaType" Mdt
	ON Tra."MediaTypeId" = Mdt."MediaTypeId"
	JOIN "InvoiceLine" Ivl
	ON Tra."TrackId" = Ivl."TrackId"
	GROUP BY Mdt."Name",Mdt."MediaTypeId",Tra."TrackId",Ivl."InvoiceId") AS Subquery
GROUP BY "Media Type"










