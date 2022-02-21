FROM ubuntu:20.04

ARG ALGORAND_TOKENS_DIR
ENV ALGORAND_TOKENS_DIR=${ALGORAND_TOKENS_DIR}

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get upgrade -y \
    && apt-get -y install \
      curl

RUN groupadd service-user \
    && useradd -g service-user -s /usr/bin/bash -m service-user

RUN mkdir -p ${ALGORAND_TOKENS_DIR} \
    && chown service-user:service-user ${ALGORAND_TOKENS_DIR}

USER service-user:service-user

COPY --chown=service-user:service-user ./scripts /tmp/scripts

VOLUME [ "${ALGORAND_TOKENS_DIR}" ]

ENTRYPOINT [ "/bin/bash", "/tmp/scripts/service-entrypoint.sh" ]

CMD [ "/bin/bash", "/tmp/scripts/start.sh"]
