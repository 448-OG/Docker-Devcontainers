FROM ubuntu25.04-rust

ARG CONFIG_DIR=/root/base

RUN mkdir -p ${CONFIG_DIR}
COPY ./nodejs.sh ${CONFIG_DIR}
WORKDIR ${CONFIG_DIR}

EXPOSE 4434

CMD ["bash","nodejs.sh"] 