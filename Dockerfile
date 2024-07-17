FROM mageai/mageai:latest

# Install Oracle Instant Client
RUN apt-get update && apt-get install -y libaio1 wget unzip && \
    wget https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-basic-linux.x64-19.10.0.0.0dbru.zip && \
    unzip -o instantclient-basic-linux.x64-19.10.0.0.0dbru.zip -d /usr/lib/oracle && \  # Added -o to overwrite existing files
    rm -f instantclient-basic-linux.x64-19.10.0.0.0dbru.zip && \
    echo /usr/lib/oracle/instantclient_19_10 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

ARG PROJECT_NAME=apu_data_pipeline
ARG MAGE_CODE_PATH=/home/src
ARG USER_CODE_PATH=${MAGE_CODE_PATH}/${PROJECT_NAME}

ENV PYTHONPATH="${PYTHONPATH}:${MAGE_CODE_PATH}:${USER_CODE_PATH}"
ENV USER_CODE_PATH=${USER_CODE_PATH}

WORKDIR ${MAGE_CODE_PATH}

COPY ${PROJECT_NAME} ${PROJECT_NAME}

COPY io_config.yaml ${USER_CODE_PATH}/io_config.yaml

# Install custom Python libraries if requirements.txt exists
RUN if [ -f ${USER_CODE_PATH}/requirements.txt ]; then pip3 install -r ${USER_CODE_PATH}/requirements.txt; fi

# Install custom libraries within 3rd party libraries (e.g., DBT packages) if install_other_dependencies.py exists
RUN if [ -f /app/install_other_dependencies.py ]; then python3 /app/install_other_dependencies.py --path ${USER_CODE_PATH}; fi

CMD ["/bin/sh", "-c", "/app/run_app.sh"]
