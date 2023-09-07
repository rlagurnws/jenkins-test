FROM openjdk:17-jdk
ARG JAR_FILE=build/libs/com.example-0.0.1-SNAPSHOT.jar
ADD ${JAR_FILE} docker-springboot.jar
ENTRYPOINT ["java", "-Djava.security.edg=file:/dev/./urandom","-jar","/docker-springboot.jar"]
