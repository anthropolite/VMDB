function sql_results {
    Param (
        [string] $datasource = "$global:sqlsvr\$global:sqlinst",
        [string] $Database = "$global:CommonDB",
        [string] $sqlcommand = $(throw "Please enter a query")
        )

    $connectionString = "Data Source = $datasource; " + 
                        "Integrated Security=SSPI; " +
                        "Initial Catalog=$database"

    $connection = new-object System.Data.SqlClient.SqlConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlcommand,$connection)
    $connection.Open()

    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
    $dataset = New-Object System.Data.Dataset
    $adapter.fill($dataset)
    
    $connection.close()
    $data=$dataset.tables
    $data
}
