FROM python:3.11-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas-base-dev \
    libstdc++6 \
    nginx \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create self-signed SSL certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/key.pem \
    -out /etc/nginx/ssl/cert.pem \
    -subj "/C=PH/ST=Denial/L=Nowhere/O=Dis/CN=localhost"

# Copy nginx config
COPY nginx/default.conf /etc/nginx/sites-available/default

# Set working directory
WORKDIR /app

COPY ./app /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the HTTP port
EXPOSE 443

# Start Nginx + FastAPI
CMD service nginx start && uvicorn server:app --host 127.0.0.1 --port 8080
