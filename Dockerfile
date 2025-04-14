FROM python:3.11-slim

# Install dependencies (including CA certificates package)
RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas-base-dev \
    libstdc++6 \
    nginx \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the self-signed certificate to the container
COPY ./cert/cert.pem /usr/local/share/ca-certificates/my-cert.crt

COPY ./cert/cert.pem /etc/ssl/certs/my-cert.pem
COPY ./cert/key.pem /etc/ssl/private/my-cert.pem

# Set working directory
WORKDIR /app

COPY ./app /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the HTTP port
EXPOSE 443 80

# Start Nginx + FastAPI
CMD service nginx start && uvicorn server:app --host 127.0.0.1 --port 8080
