# Use the latest Mage AI base image
FROM mageai/mageai:latest

# Define project-specific variables
ARG PROJECT_NAME=apu_data_pipeline
ARG MAGE_CODE_PATH=/home/src
ARG USER_CODE_PATH=${MAGE_CODE_PATH}/${PROJECT_NAME}

# Set Python path variables
ENV PYTHONPATH="${PYTHONPATH}:${MAGE_CODE_PATH}:${USER_CODE_PATH}"
ENV USER_CODE_PATH=${USER_CODE_PATH}

# Set working directory
WORKDIR ${MAGE_CODE_PATH}

# Copy the project code into the container
COPY ${PROJECT_NAME} ${PROJECT_NAME}

# Install custom Python libraries if requirements.txt exists
RUN if [ -f ${USER_CODE_PATH}/requirements.txt ]; then pip3 install -r ${USER_CODE_PATH}/requirements.txt; fi

# Install custom libraries within 3rd party libraries (e.g. DBT packages) if install_other_dependencies.py exists
RUN if [ -f /app/install_other_dependencies.py ]; then python3 /app/install_other_dependencies.py --path ${USER_CODE_PATH}; fi

# Set the command to run your application
CMD ["/bin/sh", "-c", "/app/run_app.sh"]
