<#
C.
Name: Joseph Lepkowski
Student ID: 010128419
#>


<#try {
    $sqlServerInstanceName = "SRV19-PRIMARY\SQLEXPRESS"
    $databaseName = "ClientDB"

    # Check for the existence of the database
    $databaseExists = Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "SELECT COUNT(*) FROM sys.databases WHERE name = '$databaseName'"

    # if ($databaseExists -eq 1) {
        # Indicate existence of ClientDB
        #$confirmation = Read-Host "The database '$databaseName' already exists."
        # Delete if ClientDB exists
        if ($databaseExists -eq 1) {
            Write-Host -ForegroundColor Yellow  "Deleting the existing database '$databaseName'..."
            Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "DROP DATABASE [$databaseName]"
            Write-Host -ForegroundColor Green "The database '$databaseName' has been deleted."
        }
        #>
        try {
    $sqlServerInstanceName = "SRV19-PRIMARY\SQLEXPRESS"
    $databaseName = "ClientDB"
    
    # Loop until the database no longer exists
    $databaseExists = 1  # Initialize to enter the loop
    while ($databaseExists -eq 1) {
        # Check for the existence of the database
        $databaseExists = Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "SELECT COUNT(*) FROM sys.databases WHERE name = '$databaseName'"

        if ($databaseExists -eq 1) {
            Write-Host -ForegroundColor Yellow "Deleting the existing database '$databaseName'..."
            Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "DROP DATABASE [$databaseName]"
            Write-Host -ForegroundColor Green "The database '$databaseName' has been deleted."
        }
    }

    Write-Host -ForegroundColor Green "The database '$databaseName' no longer exists."
}
catch {
    Write-Host "An error occurred: $_"
}
}
        # Else move on with script
        else {
        if ($databaseExists -eq 0) {
            Write-Host -ForegroundColor Green "Database '$databaseName' Does not exist."
            return
            }
       # }
    }

    # Create the new database
    Write-Host "Creating the database '$databaseName'..."
    Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "CREATE DATABASE [$databaseName]"
    Write-Host "The database '$databaseName' has been created."

    # Create the new table only if it doesn't exist
    $tableName = "Client_A_Contacts"
    $tableExists = Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Database $databaseName -Query "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = '$tableName'"

    if ($tableExists -eq 0) {
        Write-Host "Creating the table '$tableName'..."
        $tableScript = @"
CREATE TABLE [$databaseName].[dbo].[$tableName] (
    ContactID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Phone NVARCHAR(15)
)
"@
        Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Database $databaseName -Query $tableScript
        Write-Host "The table '$tableName' has been created."
    }
    else {
        Write-Host "The table '$tableName' already exists. Skipping table creation."
    }
}
catch {
    Write-Host "An error occurred: $_"
}
