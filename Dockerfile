FROM mageai/mageai:latest

# Install necessary dependencies
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    libssl-dev \
    unixodbc-dev \
    msodbcsql17 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set project name argument and environment variable
ARG PROJECT_NAME=default_repo
ARG MAGE_CODE_PATH=/home/src
ARG USER_CODE_PATH=${MAGE_CODE_PATH}/${PROJECT_NAME}

# Set the MAGE_CODE_PATH variable to the path of the Mage code.
ENV PYTHONPATH="${PYTHONPATH}:${MAGE_CODE_PATH}"

WORKDIR ${MAGE_CODE_PATH}

# Set the database connection URL environment variable
ENV MAGE_DATABASE_CONNECTION_URL="mssql+pyodbc://?odbc_connect=DRIVER={ODBC Driver 18 for SQL Server};\
SERVER=172.31.0.112;\
DATABASE=mage_db;\
UID=mage_user;\
PWD=Asuult12345;\
ENCRYPT=yes;\
TrustServerCertificate=yes;\
Connection Timeout=30;"

# Copy the project files
COPY ${PROJECT_NAME} ${PROJECT_NAME}

# Set the USER_CODE_PATH variable to the path of user project.
ENV USER_CODE_PATH=${USER_CODE_PATH}

# Install custom Python libraries if requirements.txt exists
RUN if [ -f ${USER_CODE_PATH}/requirements.txt ]; then pip3 install -r ${USER_CODE_PATH}/requirements.txt; fi

# Install custom libraries within 3rd party libraries (e.g. DBT packages) if install_other_dependencies.py exists
RUN if [ -f /app/install_other_dependencies.py ]; then python3 /app/install_other_dependencies.py --path ${USER_CODE_PATH}; fi

ENV PYTHONPATH="${PYTHONPATH}:${MAGE_CODE_PATH}"

# Run the initialization command
CMD ["bash", "-c", "if [ ! -d ${USER_CODE_PATH} ]; then mage init ${USER_CODE_PATH}; fi && mage start ${PROJECT_NAME}"]