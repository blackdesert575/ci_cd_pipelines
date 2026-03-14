# demo-spring-boot

* make simple spring boot app via [quick start](https://spring.io/quickstart)

## Prerequisites

* check env file: .sdkmanrc to install these runtime/SDK tools to run and build your spring boot app

```shell
java=17.0.18-amzn
maven=3.9.14
```

## Getting started

* running with maven

```shell
#localhost test via mvn tools to run spring-boot
cd demo/

./mvnw spring-boot:run

#Extra if Port 8080 was already in use.
./mvnw spring-boot:run -Dspring-boot.run.arguments="--server.port=8081"
```

* check API with browser

```shell
#open URL in browser
http://localhost:8081/hello

http://localhost:8081/hello

http://localhost:8081/hello?name=Amy
```

* Building a jar file with maven

```shell
cd demo/

./mvnw package
```

# Running with JVM

```shell
#Simply run with java cli
java -jar demo-api.jar

#with custom port
java -jar demo-api.jar --server.port=8081
```