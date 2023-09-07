FROM openjdk:17-jdk
LABEL maintainer="test"
ARG JAR_FILE=build/libs/core-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} docker-springboot.jar
ENTRYPOINT ["java", "-Djava.security.edg=file:/dev/./urandom","-jar","/docker-springboot.jar"]