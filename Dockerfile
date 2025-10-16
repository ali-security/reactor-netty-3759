# Dockerfile for building reactor-netty-core
FROM eclipse-temurin:8-jdk

WORKDIR /build

# Copy the source code
COPY . .

# Make gradlew executable and build both original and shaded JARs
RUN chmod +x gradlew && \
    ./gradlew reactor-netty-core:jar reactor-netty-core:shadowJar -x test

# Set the output directory
WORKDIR /output

# Copy all build artifacts (both original and shaded JARs)
RUN cp /build/reactor-netty-core/build/libs/*.jar /output/

# Copy POM file if it exists in gradle build output
RUN if [ -d /build/reactor-netty-core/build/publications/mavenJava ]; then \
        find /build/reactor-netty-core/build/publications -name "*.pom" -type f -exec cp {} /output/ \; ; \
    fi

# Display build artifacts
CMD ["ls", "-lah", "/output/"]