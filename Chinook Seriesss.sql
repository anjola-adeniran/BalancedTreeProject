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
GROUP BY "NumberofInvoiceLine" 

-- a query that shows total sales made by each agent
