FROM python:3.11-slim

# Install necessary build tools and libraries
RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas-base-dev \
    libstdc++6 \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy nginx config
COPY nginx/default.conf /etc/nginx/sites-available/default

# Set working directory
WORKDIR /app

# Copy application files
COPY ./app ./app
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the HTTP port
EXPOSE 80

# Start Nginx + FastAPI
CMD service nginx start && uvicorn server:app --host 127.0.0.1 --port 8080
