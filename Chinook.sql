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


