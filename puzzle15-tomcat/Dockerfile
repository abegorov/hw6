FROM maven:3-eclipse-temurin-17 AS maven_builder
WORKDIR /build
RUN /bin/bash <<EOT
    set -xe
    apt update && apt install --yes git
    git clone https://github.com/venkaDaria/puzzle15.git
    pushd puzzle15
    rm target -rf
    rm target_heroku -rf
    sed 's@</modelVersion>@</modelversion>\n    <packaging>war</packaging>@' pom.xml
    mvn package
    popd
EOT

FROM tomcat:10-jdk17-temurin-jammy
COPY --from=maven_builder --link \
     /build/puzzle15/target/Puzzle15-1.0-SNAPSHOT.war \
     /usr/local/tomcat/webapps/puzzle15
