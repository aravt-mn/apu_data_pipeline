# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Mage AI and other dependencies
RUN apt-get update && \
    apt-get install -y libaio1 wget unzip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux.x64-19.8.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-19.8.0.0.0dbru.zip && \
    mv instantclient_19_8 /usr/lib/oracle/19.8/client64 && \
    ln -s /usr/lib/oracle/19.8/client64/lib/libclntsh.so.19.1 /usr/lib/libclntsh.so && \
    pip install mage-ai botocore boto3 pymssql cx_Oracle

# Expose the port Mage AI runs on
EXPOSE 6789

# Command to run Mage AI
CMD ["mage", "start", "apu_data_pipeline"]

# This is a comment to trigger an update
