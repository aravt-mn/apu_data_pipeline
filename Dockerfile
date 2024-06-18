# Extend the mageai/mageai image
FROM mageai/mageai:latest

# Set the working directory inside the container
WORKDIR /app

# Install dependencies for the ODBC driver
RUN apt-get update && \
    apt-get install -y curl apt-transport-https gnupg2 && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev && \
    apt-get clean

# Copy ODBC configuration files
COPY odbcinst.ini /etc/odbcinst.ini
COPY odbc.ini /etc/odbc.ini

# Define environment variable
ENV PYTHONUNBUFFERED=1

# Run the application
CMD ["mage", "start", "--project", "apu_data_pipeline"]
