$version = $(select-string -Path Dockerfile -Pattern "ARG liquibase_version").ToString().split("=")[-1]
docker build -t liquibase:$version .