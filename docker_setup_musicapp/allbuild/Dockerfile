FROM maven:3.9.4-eclipse-temurin-17

# Install Git, Node.js, and dependencies
RUN apt-get update && \
    apt-get install -y git curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Set working directory
WORKDIR /workspace

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Clone and build frontend
RUN git clone -b master https://github.com/ravi98397/dhunn.git && \
    cd dhunn && \
    npm install --force && \
    npm run build

# Clone backend from master branch
RUN git clone -b master https://github.com/ravi98397/musicapi.git

# Copy frontend build into backend resources
RUN mkdir -p musicapi/src/main/resources/public && \
    cp -r dhunn/build/* musicapi/src/main/resources/public

# Build backend using pom.xml from root of musicapi
WORKDIR /workspace/musicapi
RUN mvn clean install -DskipTests

# Run the Spring Boot application
CMD ["java", "-jar", "target/music-0.0.1-SNAPSHOT.jar"]
