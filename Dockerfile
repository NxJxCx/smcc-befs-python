FROM python:3.11-slim

# Install dependencies (including CA certificates package)
RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas-base-dev \
    libstdc++6 \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Set working directory
WORKDIR /app

COPY ./app /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the HTTP port
EXPOSE 80

# Start Nginx + FastAPI
CMD service nginx start && uvicorn server:app --host 127.0.0.1 --port 8080
