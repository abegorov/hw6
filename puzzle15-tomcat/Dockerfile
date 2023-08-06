FROM maven:3-eclipse-temurin-17 AS maven_builder
WORKDIR /build
RUN /bin/bash <<EOT
    set -xe
    apt update && apt install --yes git
    git clone https://github.com/venkaDaria/puzzle15.git
    pushd puzzle15
    sed -i 's@</modelVersion>@</modelVersion>\n    <packaging>war</packaging>@' pom.xml
    mvn clean
    mvn package
    popd
    test -f /build/puzzle15/target/Puzzle15-1.0-SNAPSHOT.war
EOT

FROM tomcat:9-jdk17-temurin
COPY --from=maven_builder --link \
     /build/puzzle15/target/Puzzle15-1.0-SNAPSHOT.war \
     /usr/local/tomcat/webapps/puzzle15.war
