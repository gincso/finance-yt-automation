# Alpine Linux Docker Image for Finance YouTube Automation
FROM alpine:3.19

# Install runtime dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-yaml \
    ffmpeg \
    tzdata \
    curl \
    git \
    && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app/

# Install Python dependencies
#RUN pip3 install --no-cache-dir -r requirements.tt
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

# Make scripts executable
RUN chmod +x /app/scripts/*.sh /app/docker-entrypoint.sh

# Set timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Run the entrypoint script
ENTRYPOINT ["/app/docker-entrypoint.sh"]
