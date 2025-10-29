# Stage 1: Build frontend
FROM node:18 AS frontend-builder
WORKDIR /app
RUN git clone -b master https://github.com/ravi98397/dhunn.git .
RUN npm install --force && npm run build

# Stage 2: Build backend
FROM maven:3.9.4-eclipse-temurin-17 AS backend-builder
WORKDIR /app
RUN git clone -b master https://github.com/ravi98397/musicapi.git musicapi
COPY --from=frontend-builder /app/build ./musicapi/src/main/resources/public
WORKDIR /app/musicapi
RUN mvn clean package -DskipTests

# Stage 3: Runtime image
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the compiled JAR
COPY --from=backend-builder /app/musicapi/target/music-0.0.1-SNAPSHOT.jar ./app.jar

# Copy entrypoint script from your local context
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Optional: use entrypoint
# ENTRYPOINT ["./entrypoint.sh"]

CMD ["java", "-jar", "app.jar"]