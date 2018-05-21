.\New-LiquibaseConfiguration.ps1

# $retryTest = Test-Path .\Test-LiquibaseErrorRetriability.ps1

# if($retryTest -eq $false) {
#     Write-Warning "No retry test specified ('Test-LiquibaseErrorRetriability.ps1' does not exist). All errors will be terminating."
# }

# $retries = 5
# do{
#     try{
#         $err = & cmd /c liquibase.bat $args 2>&1
#         $success = $true
#     }
#     catch{
#         if($Error.Exception -is [array]) {
#             $latest = $Error.Exception[-1]
#         } else {
#             $latest = $Error.Exception
#         }
# 
#         if($retryTest -and (.\Test-LiquibaseErrorRetriability.ps1 $latest)) {
#             Write-Host "Retrying in five seconds..."
#             Start-Sleep -Seconds 5
#         } else {
#             throw
#         }
#     }
#     $retries--
# } until($retries -le 0 -or $success)
# 
# if($succes -ne $true) {
#     throw $Error.Exception[-1]
# }

if(Test-Path .\Invoke-PreMigrationInitialization.ps1) {
    .\Invoke-PreMigrationInitialization.ps1
}

& cmd /c liquibase.bat $args

if(Test-Path .\Invoke-PostMigrationInitialization.ps1) {
    .\Invoke-PostMigrationInitialization.ps1
}

if($LASTEXITCODE -ne 0) {
    throw "Liquibase migration failed."
}