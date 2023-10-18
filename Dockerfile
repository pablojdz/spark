ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

# :::::::: INSTALL AND SET UP JAVA ::::::::::
ARG JAVA_VERSION=11
RUN apt-get update && \
    apt-get install -y openjdk-${JAVA_VERSION}-jdk && \
    apt-get clean;

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
ENV PATH="$PATH:$JAVA_HOME/bin"

# :::::::: INSTALL PYTHON :::::::::::::::::::
ARG SHARED_WORKSPACE=/opt/spark/work-dir
ARG PYTHON_VERSION=3.8.10
RUN mkdir -p ${SHARED_WORKSPACE} && \
    apt-get update -y && \
    apt-get install libssl-dev openssl make gcc -y wget -y zlib1g-dev -y libffi-dev -y libsqlite3-dev -y && \
    cd /opt && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar xzvf Python-${PYTHON_VERSION}.tgz && \
    rm Python-${PYTHON_VERSION}.tgz
RUN cd /opt/Python-${PYTHON_VERSION} && \
    ./configure && \
    make && \
    make install 

# :::::::::: INSTALL JupyterLab :::::::::::::
ARG SPARK_VERSION=3.5.0
ARG JUPYTERLAB_VERSION=4.0.7
RUN apt-get update -y && \
    pip3 install --upgrade pip && \
    pip3 install wget pyspark==${SPARK_VERSION} jupyterlab==${JUPYTERLAB_VERSION}

ENV SHARED_WORKSPACE=${SHARED_WORKSPACE}

# ::::::::::: Runtime :::::::::::::::::::::::
VOLUME ${SHARED_WORKSPACE}
EXPOSE 8888
WORKDIR ${SHARED_WORKSPACE}
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
