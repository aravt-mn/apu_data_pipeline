FROM mageai/mageai:latest

# Use the correct project name
ARG PROJECT_NAME=apu_data_pipeline
ARG MAGE_CODE_PATH=/home/src
ARG USER_CODE_PATH=${MAGE_CODE_PATH}/${PROJECT_NAME}

# Set the MAGE_CODE_PATH and USER_CODE_PATH environment variables
ENV PYTHONPATH="${PYTHONPATH}:${MAGE_CODE_PATH}:${USER_CODE_PATH}"
ENV USER_CODE_PATH=${USER_CODE_PATH}

WORKDIR ${MAGE_CODE_PATH}

# Copy the project code into the container
COPY ${PROJECT_NAME} ${PROJECT_NAME}

# Install custom Python libraries if requirements.txt exists
RUN if [ -f ${USER_CODE_PATH}/requirements.txt ]; then pip3 install -r ${USER_CODE_PATH}/requirements.txt; fi

# Install custom libraries if install_other_dependencies.py exists
RUN if [ -f /app/install_other_dependencies.py ]; then python3 /app/install_other_dependencies.py --path ${USER_CODE_PATH}; fi

CMD ["/bin/sh", "-c", "/app/run_app.sh"]
