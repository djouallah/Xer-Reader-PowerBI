let
    Source = Folder.Files(Path),
    #"Filtered Rows" = Table.SelectRows(Source, each ([Extension] = ".xer")),
    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"Content"}),
    #"Combined Binaries" = Binary.Buffer(Binary.Combine(#"Removed Other Columns"[Content])),
    #"Imported CSV" = Csv.Document(#"Combined Binaries",[Delimiter="#(tab)", Columns=63, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Added Custom" = Table.AddColumn(#"Imported CSV", "Table ", each if [Column1]="%T" then [Column2] else null),
    #"Changed Type" = Table.TransformColumnTypes(#"Added Custom",{{"Table ", type text}}),
    #"Filled Down" = Table.FillDown(#"Changed Type",{"Table "})
in
    #"Filled Down"
