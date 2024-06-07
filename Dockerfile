# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file into the container at /app
COPY requirements.txt /app/requirements.txt

# Install any dependencies specified in requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy the rest of the working directory contents into the container at /app
COPY . /app

# Define environment variable
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["python", "main.py"]
