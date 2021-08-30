FROM docker://jupyter/tensorflow-notebook

RUN pip install --upgrade pip
RUN pip install opencv-python

