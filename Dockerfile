FROM python:3.11-slim

# Install dependencies (including CA certificates package)
RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas-base-dev \
    libstdc++6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

COPY ./app /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the HTTP port
EXPOSE 8080

# Start Nginx + FastAPI
CMD uvicorn server:app --host 0.0.0.0 --port 8080
