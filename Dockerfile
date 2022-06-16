ARG BASE_CONTAINER=condaforge/mambaforge:latest
FROM $BASE_CONTAINER

SHELL ["/bin/bash", "-c"]

ARG python=3.7

ENV PATH /opt/conda/bin:$PATH
ENV PYTHON_VERSION=${python}

RUN mamba install -y \
    python>=${PYTHON_VERSION} \
    bokeh \
    click==8.0.4 \
    fsspec \
    netcdf4 \
    pyyaml \
    retry \
    s3fs >=2022.1.0 \
    xarray \
    zarr \
    pytest \
    pytest-cov \
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

# Install requirements.txt defined libraries
COPY requirements.txt /tmp/
RUN apt-get update && apt-get -y install gcc vim nano libsqlite3-dev
RUN python -m pip install --upgrade pip \
    && pip install --requirement /tmp/requirements.txt

COPY prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

RUN ["chmod", "+x", "/usr/bin/prepare.sh"]
ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
