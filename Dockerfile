FROM ghcr.io/datacollectgmbh/l4t-release:l4t-r35.6.0 AS l4t-35.6.0
FROM ghcr.io/datacollectgmbh/l4t-release:l4t-r36.4.0 AS l4t-36.4.0
FROM ghcr.io/datacollectgmbh/l4t-release:l4t-r36.4.3 AS l4t-36.4.3
FROM ghcr.io/datacollectgmbh/l4t-release:l4t-r36.4.4 AS l4t-36.4.4
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
  device-tree-compiler \
  liblz4-tool \
  python3.10 \
  python3.10-dev \
  python3-pip \
  sbsigntool \
  && rm -rf /var/lib/apt/lists/*


RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

RUN pip3 install --upgrade pip

RUN pip3 install \
  PyYAML \
  cryptograpy \
  awscli \
  pycryptodome


ENV DIGSIGSERVER=/digsigserver
ENV DIGSIGSERVER_KEYFILE_URI=${DIGSIGSERVER}

WORKDIR ${DIGSIGSERVER}



COPY --from=l4t-35.6.0 /opt/nvidia /opt/nvidia
COPY --from=l4t-36.4.0 /opt/nvidia /opt/nvidia
COPY --from=l4t-36.4.3 /opt/nvidia /opt/nvidia
COPY --from=l4t-36.4.4 /opt/nvidia /opt/nvidia

COPY start_script.sh /start_script.sh

RUN chmod +x /start_script.sh

COPY digsigserver ${DIGSIGSERVER}/digsigserver
COPY requirements.txt ${DIGSIGSERVER}
COPY setup.cfg ${DIGSIGSERVER}
COPY setup.py ${DIGSIGSERVER}

RUN pip3 install -e .

#CMD [ "digsigserver", "--debug" ]
ENTRYPOINT ["/start_script.sh"]
