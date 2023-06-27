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


