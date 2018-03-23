FROM conda/miniconda3:latest
RUN pip install locustio
COPY scripts/simple_locust.py /simple_locust.py