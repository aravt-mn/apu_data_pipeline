# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install necessary packages
RUN apt-get update && apt-get install -y libaio1 wget unzip

# Download Oracle Instant Client
RUN wget https://download.oracle.com/otn_software/linux/instantclient/2340000/instantclient-basic-linux.x64-23.4.0.24.05.zip

# Unzip the downloaded file
RUN unzip instantclient-basiclite-linux.x64-21.3.0.0.0.zip

# Move and configure Oracle Instant Client
RUN mkdir -p /usr/lib/oracle && mv instantclient_21_3 /usr/lib/oracle/21.3/client64
RUN ln -s /usr/lib/oracle/21.3/client64/libclntsh.so.21.1 /usr/lib/libclntsh.so

# Install Python dependencies
RUN pip install mage-ai botocore boto3 pymssql cx_Oracle

# Copy the current directory contents into the container at /app
COPY . /app

# Expose the port Mage AI runs on
EXPOSE 6789

# Command to run Mage AI
CMD ["mage", "start", "apu_data_pipeline"]
