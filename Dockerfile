FROM gcr.io/kaggle-gpu-images/python:latest

WORKDIR /kaggle

# Install additional Python libraries if needed
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN groupadd --gid 1000 kaggle \
    && useradd --uid 1000 --gid kaggle --create-home --shell /bin/bash kaggle \
    && chown -R kaggle:kaggle /kaggle

USER kaggle