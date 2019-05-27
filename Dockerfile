FROM maven:3-jdk-8-alpine as BUILD

COPY src /usr/src/hello-world/src
COPY pom.xml /usr/src/hello-world

RUN mvn -f /usr/src/hello-world/pom.xml clean package

FROM java:8

COPY --from=BUILD /usr/src/hello-world/target/hello-world-0.1.0-SNAPSHOT.jar /hello-world-0.1.0-SNAPSHOT.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/hello-world-0.1.0-SNAPSHOT.jar"]
