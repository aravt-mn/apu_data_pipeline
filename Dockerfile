FROM mageai/mageai:latest

ARG PROJECT_NAME=apu_data_pipeline
ARG MAGE_CODE_PATH=/home/src
ARG USER_CODE_PATH=${MAGE_CODE_PATH}/${PROJECT_NAME}

ENV PYTHONPATH="${PYTHONPATH}:${MAGE_CODE_PATH}"

# Set the working directory
WORKDIR ${MAGE_CODE_PATH}

# Install Oracle Instant Client
RUN apt-get update && \
    apt-get install -y libaio1 wget unzip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/2350000/instantclient-basic-linux.x64-23.5.0.24.07.zip && \
    unzip -o instantclient-basic-linux.x64-23.5.0.24.07.zip -d /opt/oracle && \
    rm instantclient-basic-linux.x64-23.5.0.24.07.zip && \
    if [ ! -L /opt/oracle/instantclient ]; then ln -s /opt/oracle/instantclient_23_5 /opt/oracle/instantclient; fi && \
    echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig
# Copy project files
COPY ${PROJECT_NAME} ${PROJECT_NAME}

# Copy requirements.txt and install dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && \
    pip install -r /app/requirements.txt --verbose

ENV USER_CODE_PATH=${USER_CODE_PATH}

# Set the command to run the application
CMD ["/bin/sh", "-c", "/app/run_app.sh"]