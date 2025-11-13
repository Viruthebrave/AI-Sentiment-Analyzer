FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy only requirements first (this will be cached)
COPY requirements.txt .

# Install dependencies (cached unless requirements.txt changes)
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Run the app
CMD ["python", "app.py"]
