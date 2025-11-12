# Step 1: Use a lightweight Python base image
FROM python:3.10-slim

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy project files into the container
COPY . .

# Step 4: Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Expose the app port
EXPOSE 5000

# Step 6: Run the application
CMD ["python", "app.py"]
