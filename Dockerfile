FROM tensorflow/tensorflow:2.4.1-gpu

#was hanging up while configuring tz data, this should fix that (https://grigorkh.medium.com/fix-tzdata-hangs-docker-image-build-cdb52cc3360d)

ENV TZ=Asia/Dubai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# RUN pip install --upgrade pip
# RUN pip install pandas

#https://stackoverflow.com/questions/36862589/install-opencv-in-a-docker-container

RUN mkdir -p /usr/src/app 
WORKDIR /usr/src/app 

# https://github.com/openai/roboschool/issues/209 ffmpeg replacing libav-tools

# Various Python and C/build deps
RUN apt-get update && apt-get install -y \ 
    wget \
    build-essential \ 
    cmake \ 
    git \
    unzip \ 
    pkg-config \
    python-dev \ 
    python-opencv \ 
    libopencv-dev \ 
    ffmpeg \ 
    libjpeg-dev \ 
    libpng-dev \ 
    libtiff-dev

# https://www.pyimagesearch.com/2018/05/28/ubuntu-18-04-how-to-install-opencv/ fix for missing libjasper

RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
RUN apt update
RUN apt install libjasper1 libjasper-dev

# continue with prereq install list
RUN apt-get install -y \ 
    libgtk2.0-dev \ 
    python-numpy \ 
    python-pycurl \ 
    libatlas-base-dev \
    gfortran \
    webp \ 
    python-opencv \ 
    qt5-default \
    libvtk6-dev \ 
    zlib1g-dev 

# Install Open CV - Warning, this takes absolutely forever
# adding DCMAKE_LIBRARY_PATH from https://github.com/opencv/opencv/issues/6577 to fix library errors
RUN mkdir -p ~/opencv cd ~/opencv && \
    wget https://github.com/opencv/opencv/archive/4.5.1.zip && \
    unzip 4.5.1.zip && \
    rm 4.5.1.zip && \
    mv opencv-4.5.1 OpenCV && \
    cd OpenCV && \
    mkdir build && \ 
    cd build && \
    cmake \
    -DCMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs \ 
    -DWITH_QT=ON \ 
    -DWITH_OPENGL=ON \ 
    -DFORCE_VTK=ON \
    -DWITH_TBB=ON \
    -DWITH_GDAL=ON \
    -DWITH_XINE=ON \
    -DBUILD_EXAMPLES=ON .. && \
    make -j4 && \
    make install && \ 
    ldconfig

COPY . /usr/src/app 
