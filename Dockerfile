FROM tensorflow/tensorflow:2.4.1-gpu
RUN pip install --upgrade pip

RUN pip install pandas