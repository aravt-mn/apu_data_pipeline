FROM mageai/mageai:latest

# Install necessary dependencies
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    libssl-dev \
    unixodbc-dev \
    msodbcsql17 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Mage AI CLI
RUN pip3 install mage-ai

# Set project name argument and environment variable
ARG PROJECT_NAME
ENV PROJECT_NAME=${PROJECT_NAME}

# Set the database connection URL environment variable
ENV MAGE_DATABASE_CONNECTION_URL="mssql+pyodbc://?odbc_connect=DRIVER={ODBC Driver 18 for SQL Server};\
SERVER=172.31.0.112;\
DATABASE=mage_db;\
UID=mage_user;\
PWD=Asuult12345;\
ENCRYPT=yes;\
TrustServerCertificate=yes;\
Connection Timeout=30;"

# Copy requirements file and install Python dependencies
COPY requirements.txt /home/src/${PROJECT_NAME}/requirements.txt
RUN pip3 install -r /home/src/${PROJECT_NAME}/requirements.txt

# Set the working directory
WORKDIR /home/src/${PROJECT_NAME}

# Copy the project files
COPY . /home/src/${PROJECT_NAME}

# Run the initialization command
CMD ["bash", "-c", "if [ ! -d /home/src/${PROJECT_NAME}/.mage ]; then echo '.mage directory does not exist, initializing...'; mage init /home/src/${PROJECT_NAME}; else echo '.mage directory exists, skipping initialization'; fi && mage start ${PROJECT_NAME}"]