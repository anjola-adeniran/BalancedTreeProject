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







