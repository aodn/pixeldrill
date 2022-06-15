ARG BASE_CONTAINER=condaforge/mambaforge:latest
FROM $BASE_CONTAINER

ARG python=3.8

SHELL ["/bin/bash", "-c"]

ENV PATH /opt/conda/bin:$PATH
ENV PYTHON_VERSION=${python}

RUN mamba install -y \
    python=${PYTHON_VERSION} \
    bokeh \
    nomkl \
    cmake \
    python-blosc \
    cytoolz \
    dask \
    lz4 \
    numpy \
    pandas \
    tini==0.18.0 \
    cachey \
    streamz \
    && mamba clean -tipy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt

COPY environment.yml /tmp/
RUN conda env update -f /tmp/environment.yml

COPY prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

RUN ["chmod", "+x", "/usr/bin/prepare.sh"]
ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
