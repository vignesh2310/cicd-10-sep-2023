FROM maven as build
WORKDIR /uber
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /uber
COPY --from=build /uber/target/Uber.jar .
EXPOSE 7070
ENTRYPOINT ["java", "jar", "Uber.jar"]
