FROM mageai/mageai:latest

# Install necessary dependencies
RUN apt-get update --no-cache && \
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
SERVER=172.31.0.133;\
DATABASE=mage_db;\
UID=mage_user;\
PWD=Asuult12345;\
ENCRYPT=yes;\
TrustServerCertificate=yes;"

# Copy requirements file and install Python dependencies
COPY requirements.txt /home/src/requirements.txt
RUN pip3 install -r /home/src/requirements.txt

# Set the working directory
WORKDIR /home/src

# Copy the project files
COPY . .

# Run the initialization command
CMD ["bash", "-c", "mage migrate && mage start ${PROJECT_NAME}"]