FROM maven:3-jdk-8-alpine as BUILD

ARG BUILD_VERSION
ARG APP_NAME

COPY src /usr/src/$APP_NAME/src
COPY pom.xml /usr/src/${APP_NAME}

RUN mvn -f /usr/src/${APP_NAME}/pom.xml clean package

FROM java:8

ARG BUILD_VERSION
ARG APP_NAME

ENV BUILD_VERSION ${BUILD_VERSION}
ENV APP_NAME ${APP_NAME}

COPY --from=BUILD /usr/src/${APP_NAME}/target/${APP_NAME}-${BUILD_VERSION}.jar /${APP_NAME}-${BUILD_VERSION}.jar
COPY dockerfiles/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
