# Leaf Backend

Minimal Spring Boot scaffold for the Leaf backend API. Scaffold-only — no business logic yet.

## Stack
- Java 21
- Spring Boot 3.3.5 (Spring Web, Spring Data JPA)
- H2 in-memory database

## Running locally

```
./mvnw spring-boot:run
```

On Windows (cmd/PowerShell):

```
mvnw.cmd spring-boot:run
```

The app starts on `http://localhost:8080`.

### H2 console

The H2 web console is off by default. To enable it locally, run with the `dev` profile:

```
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

Then visit `http://localhost:8080/h2-console` (JDBC URL: `jdbc:h2:mem:leafdb`, user: `sa`, no password).

## Health check

```
GET http://localhost:8080/api/health
```

Returns:

```json
{"status": "ok"}
```

## Build

```
./mvnw clean install
```
