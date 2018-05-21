$properties = (Get-Content -Path .\liquibase.properties) -Join [System.Environment]::NewLine


$result = Invoke-Expression """$properties"""

# Support two levels deep for things like
# formatting URLs for database connections
$result = Invoke-Expression """$result"""

Set-Content -Path .\liquibase.properties -Value $result