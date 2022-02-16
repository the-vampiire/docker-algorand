FROM ubuntu:20.04

ARG ALGORAND_DATA
ARG ALGORAND_NETWORK

ENV ALGORAND_DATA=${ALGORAND_DATA}
ENV ALGORAND_NETWORK=${ALGORAND_NETWORK}

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get upgrade -y \
    && apt-get -y install \
      wget curl

RUN groupadd algorand \
    && useradd -g algorand -s /usr/bin/bash -m algorand

RUN mkdir -p ${ALGORAND_DATA} \
    && chown algorand:algorand ${ALGORAND_DATA}

USER algorand:algorand

WORKDIR /home/algorand/node

RUN wget \
    https://raw.githubusercontent.com/algorand/go-algorand-doc/master/downloads/installers/update.sh

RUN bash update.sh -i -c stable -p ~/node -d ${ALGORAND_DATA} -n

RUN mv genesisfiles/${ALGORAND_NETWORK}/genesis.json ${ALGORAND_DATA}/genesis.json

# last to allow for changes
ADD ./scripts /home/algorand/scripts
ADD --chown=algorand:algorand ./config /home/algorand/config

WORKDIR ${ALGORAND_DATA}

EXPOSE 4001
EXPOSE 4002
VOLUME [ "${ALGORAND_DATA}" ]

ENTRYPOINT [ "/usr/bin/bash", "/home/algorand/scripts/entrypoint.sh" ]
CMD ["/usr/bin/bash", "/home/algorand/scripts/start.sh"]
