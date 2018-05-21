$version = $(select-string -Path Dockerfile -Pattern "ARG liquibase_version").ToString().split("=")[-1]
docker login -u="$env:DOCKER_USER" -p="$env:DOCKER_PASS"
docker tag liquibase:$version nickdarvey/liquibase-windows:$version
docker tag liquibase:$version nickdarvey/liquibase-windows:latest
docker push nickdarvey/liquibase-windows:$version
docker push nickdarvey/liquibase-windows:latest