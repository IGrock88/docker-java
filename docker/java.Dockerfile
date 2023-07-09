FROM maven:3.6.3-openjdk-11 as build

WORKDIR /var/java/app
COPY /java/. /var/java/app/

RUN mvn -T 4 install:install-file -Dfile=/var/java/app/libfptr10.jar -DgroupId=libfptr -DartifactId=libfptr-sdk -Dversion=10.8.0.0 -Dpackaging=jar
RUN mvn -T 4 clean compile assembly:single

FROM mcr.microsoft.com/java/jre:11-zulu-debian10

COPY /java/. /var/java/app/
COPY --from=build /var/java/app/target /var/java/app/target

WORKDIR /var/java/app/target

CMD ["java", "-Dfile.encoding=UTF-8", "-Xms512m", "-Xmx512m", "-DdriverPath=/var/java/app/src/main/resources/libfptr10.so", "-DkktConfigPath=/var/java/app/kkt.json", "-jar", "AvKkt-1.0-jar-with-dependencies.jar"]
