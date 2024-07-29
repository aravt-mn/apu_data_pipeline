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
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux.x64-19.8.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-19.8.0.0.0dbru.zip -d /opt/oracle && \
    rm instantclient-basiclite-linux.x64-19.8.0.0.0dbru.zip && \
    ln -s /opt/oracle/instantclient_19_8 /opt/oracle/instantclient && \
    echo /opt/oracle/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

# Install cx_Oracle
RUN pip install cx_Oracle

# Copy project files
COPY ${PROJECT_NAME} ${PROJECT_NAME}

ENV USER_CODE_PATH=${USER_CODE_PATH}

# Set the command to run the application
CMD ["/bin/sh", "-c", "/app/run_app.sh"]