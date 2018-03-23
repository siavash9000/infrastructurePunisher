FROM conda/miniconda3:latest
RUN pip install locustio
COPY simple_locust.py /simple_locust.py