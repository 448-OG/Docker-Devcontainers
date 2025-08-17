FROM ubuntu:25.04

ARG CONFIG_DIR=/root/base

RUN mkdir -p ${CONFIG_DIR}
COPY ./base/ ${CONFIG_DIR}
COPY ./all.sh ${CONFIG_DIR}
WORKDIR ${CONFIG_DIR}

EXPOSE 4434

CMD ["bash", "all.sh"]