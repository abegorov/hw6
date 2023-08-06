FROM debian:bookworm AS builder
WORKDIR /build
COPY pom.xml ./
ADD https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz maven.tar.gz
RUN /bin/bash <<EOT
    set -xe
    apt update
    apt install --yes git
    git clone https://github.com/venkaDaria/puzzle15.git
    cp pom.xml puzzle15/
    mkdir maven
    tar --extract --file maven.tar.gz --strip-components=1 --directory maven
    pushd puzzle15
    find src -type f -name '*.java' -exec sed -i 's/javax\./jakarta\./g' {} \;
    find src -type f -name '*.jsp' -exec \
        sed -i 's@http://java.sun.com/jsp/jstl/core@jakarta.tags.core@g' {} \;
    apt install --yes defaultjdk
    /build/maven/bin/mvn clean
    /build/maven/bin/mvn package
    test -f /build/puzzle15/target/Puzzle15-1.0-SNAPSHOT.war
EOT

FROM debian:bookworm
RUN /bin/bash <<EOT
    set -xe
    apt update
    apt install --yes defaultjdk
    apt install --yes tomcat10
EOT
COPY --from=builder --link \
     /build/puzzle15/target/Puzzle15-1.0-SNAPSHOT.war \
     /var/lib/tomcat10/webapps/puzzle15.war
