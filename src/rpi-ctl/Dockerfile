FROM python:3.9-alpine

WORKDIR /app

# install PDM
RUN pip install -U pip setuptools wheel
RUN pip install pdm

COPY . .

RUN pdm install

CMD ["pdm", "run", "python3", "main.py"]
