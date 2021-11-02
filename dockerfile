ARG BASE_CONTAINER=condaforge/miniforge3:4.10.3-2
FROM $BASE_CONTAINER

ARG python=3.7

SHELL ["/bin/bash", "-c"]

ENV PATH /opt/conda/bin:$PATH
ENV PYTHON_VERSION=${python}

RUN conda install --yes nomkl cytoolz cmake \
    && conda install --yes mamba \
    && mamba install --yes -c conda-forge \
    python=${PYTHON_VERSION} \
    python-blosc \
    cytoolz \
    dask \
    lz4 \
    numpy==1.21.1 \
    pandas==1.3.0 \
    tini==0.18.0 \
    cachey \
    streamz \
    && mamba clean -tipsy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt

RUN mkdir /opt/app
