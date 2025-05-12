FROM ghcr.io/datacollectgmbh/docker-base-image-digsigserver:l4t-r35.6.0 AS l4t-35.6.0
FROM Dockerfile.l4t-r36.4.0 AS l4t-36.4.0
FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
  device-tree-compiler \
  liblz4-tool \
  python2.7 \
  python3.7 \
  python3.7-dev \
  python3-pip \
  sbsigntool \
  && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python  python  /usr/bin/python2.7 1
RUN update-alternatives --install /usr/bin/python2 python2 /usr/bin/python2.7 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1

RUN pip3 install --upgrade pip

RUN pip3 install \
  PyYAML \
  cryptograpy \
  awscli \
  pycryptodome

#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#    unzip awscliv2.zip \
#    ./aws/install

ENV DIGSIGSERVER=/digsigserver
ENV DIGSIGSERVER_KEYFILE_URI=${DIGSIGSERVER}

WORKDIR ${DIGSIGSERVER}



COPY --from=l4t-35.6.0 /opt/nvidia /opt/nvidia
COPY --from=l4t-36.4.0 /opt/nvidia /opt/nvidia
COPY start_script.sh /start_script.sh

RUN chmod +x /start_script.sh

COPY digsigserver ${DIGSIGSERVER}/digsigserver
COPY requirements.txt ${DIGSIGSERVER}
COPY setup.cfg ${DIGSIGSERVER}
COPY setup.py ${DIGSIGSERVER}

RUN pip3 install -e .

#CMD [ "digsigserver", "--debug" ]
ENTRYPOINT ["/start_script.sh"]
