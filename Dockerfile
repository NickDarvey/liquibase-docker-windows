# escape=`

FROM openjdk:9.0.4-windowsservercore-1709

# Liquibase 3.6.1 has missing dependencies
# https://liquibase.jira.com/browse/CORE-3201?focusedCommentId=43574&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-43574
ARG liquibase_version=3.5.5
ARG liquibase_download_url=https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${liquibase_version}/liquibase-${liquibase_version}-bin.zip

ENV LIQUIBASE_DATABASE=${LIQUIBASE_DATABASE:-liquibase} `
    LIQUIBASE_USERNAME=${LIQUIBASE_USERNAME:-liquibase} `
    LIQUIBASE_PASSWORD=${LIQUIBASE_PASSWORD:-liquibase} `
    LIQUIBASE_HOST=${LIQUIBASE_HOST:-db} `
    LIQUIBASE_CHANGELOG=${LIQUIBASE_CHANGELOG:-db.changelog-master.yaml} `
    LIQUIBASE_LOGLEVEL=${LIQUIBASE_LOGLEVEL:-debug} `
    LIQUIBASE_PREMIGRATION_INIT=${LIQUIBASE_PREMIGRATION_INIT} `
    LIQUIBASE_POSTMIGRATION_INIT=${LIQUIBASE_POSTMIGRATION_INIT}

RUN Write-Host \"Downloading from $env:liquibase_download_url ...\"; `
    $download = 'liquibase.zip'; `
    $installation = Join-Path -Path $env:LOCALAPPDATA -ChildPath Liquibase; `
    New-Item -Path $installation -ItemType Directory -Force | Out-Null; `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest -Uri $env:liquibase_download_url -OutFile $download -UseBasicParsing; `
    Expand-Archive -Path $download -DestinationPath $installation -Force; `
    Remove-Item -Path $download; `
    $path = ('{0};{1}' -f $installation, $env:PATH); `
    setx /M PATH $path | Out-Null; `
    Write-Host \"Installed to $installation\"

RUN Get-PackageProvider -Name NuGet -Force | Out-Null; `
    Install-Module -Name SqlServer -RequiredVersion 21.0.17262 -Force -AllowClobber

RUN $workdir = Join-Path -Path $env:SystemDrive -ChildPath Config; `
    New-Item -Path $workdir -ItemType Directory -Force | Out-Null
WORKDIR C:\Config

COPY liquibase.properties .
COPY New-LiquibaseConfiguration.ps1 .
COPY Start-Liquibase.ps1 .

ENTRYPOINT .\Start-Liquibase.ps1