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
