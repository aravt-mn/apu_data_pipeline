FROM mageai/mageai:latest

ARG PROJECT_NAME

ENV PROJECT_NAME=${PROJECT_NAME}

COPY requirements.txt /home/src/requirements.txt

RUN pip3 install -r /home/src/requirements.txt