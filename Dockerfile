FROM python:3.11-slim

# Create a virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Expose the FastAPI port
EXPOSE 8080

# Use environment variable for port if set, fallback to 8080
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8080"]
