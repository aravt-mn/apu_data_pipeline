# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Mage AI and other dependencies
RUN pip install mage-ai botocore boto3

# Expose the port Mage AI runs on
EXPOSE 6789

# Command to run Mage AI
CMD ["mage", "start", "apu_data_pipeline"]

