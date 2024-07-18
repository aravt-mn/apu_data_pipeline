FROM mageai/mageai:latest

# Set default values for ARGs in case they are not provided
ARG PROJECT_NAME=apu_data_pipeline
ARG MAGE_CODE_PATH=/home/src
ARG USER_CODE_PATH=${MAGE_CODE_PATH}/${PROJECT_NAME}

# Set ENV based on ARG values
ENV PYTHONPATH="${PYTHONPATH}:${MAGE_CODE_PATH}:${USER_CODE_PATH}"
ENV USER_CODE_PATH=${USER_CODE_PATH}

# Set the working directory inside the container
WORKDIR ${MAGE_CODE_PATH}

# Copy the project directory into the container
COPY ${PROJECT_NAME} ${PROJECT_NAME}

# Ensure io_config.yaml is present in the context directory and copy it
# Adjust the source path if io_config.yaml is not directly in the context root
COPY io_config.yaml ${USER_CODE_PATH}/io_config.yaml

# Install custom Python libraries if requirements.txt exists
RUN if [ -f ${USER_CODE_PATH}/requirements.txt ]; then pip3 install -r ${USER_CODE_PATH}/requirements.txt; fi

# Install custom libraries within 3rd party libraries (e.g., DBT packages) if install_other_dependencies.py exists
RUN if [ -f /app/install_other_dependencies.py ]; then python3 /app/install_other_dependencies.py --path ${USER_CODE_PATH}; fi

CMD ["/bin/sh", "-c", "/app/run_app.sh"]