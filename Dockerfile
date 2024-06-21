FROM jupyter/minimal-notebook:x86_64-2022-10-09

MAINTAINER Mainak Jas <mjas@mgh.harvard.edu>


# *********************As User ***************************
USER root

# *********************Unix tools ***************************
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
    openssh-client \
    vim \ 
    curl \
    gcc \
    && apt-get clean

# *********************As User ***************************
USER $NB_UID

RUN pip install --upgrade pip

# *********************Extensions ***************************

USER root

RUN apt-get install -yq --no-install-recommends \
    xvfb \
    x11-utils \
    libx11-dev \
    qtbase5-dev \
    qt5-qmake \
    && apt-get clean

ENV DISPLAY=:99

USER $NB_UID

RUN pip install vtk && \
    pip install numpy && \
    pip install scipy && \
    pip install pyqt5 && \
    pip install xvfbwrapper && \
    pip install pyvista && \
    pip install pyvistaqt && \
    pip install nibabel && \
    pip install ipyevents && \
    pip install darkdetect

    
RUN pip install mne && \
    pip install nbgitpuller

RUN ipython -c "import mne; print(mne.datasets.sample.data_path(verbose=False))"

# Add an x-server to the entrypoint. This is needed by Mayavi
ENTRYPOINT ["tini", "-g", "--", "xvfb-run"]
