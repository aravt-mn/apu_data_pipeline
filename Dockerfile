# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install necessary packages
RUN apt-get update && apt-get install -y libaio1 wget unzip freetds-dev libpq-dev

# Download Oracle Instant Client
RUN wget https://download.oracle.com/otn_software/linux/instantclient/2340000/instantclient-basic-linux.x64-23.4.0.24.05.zip

# Unzip the downloaded file
RUN unzip instantclient-basic-linux.x64-23.4.0.24.05.zip

# Move and configure Oracle Instant Client
RUN mkdir -p /usr/lib/oracle/23.4/client64 && mv instantclient_23_4 /usr/lib/oracle/23.4/client64
RUN ln -s /usr/lib/oracle/23.4/client64/libclntsh.so /usr/lib/libclntsh.so

# Install Python dependencies, using psycopg2-binary to avoid needing pg_config
RUN pip install mage-ai[bigquery,redshift,snowflake,mssql,oracle,postgres] psycopg2-binary

# Copy the current directory contents into the container at /app
COPY . /app

# Ensure utils directory is copied
COPY utils /app/utils

# Expose the port Mage AI runs on
EXPOSE 6789

# Command to run Mage AI
CMD ["mage", "start", "apu_data_pipeline"]
