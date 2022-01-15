FROM python:3.9-alpine

WORKDIR /app

RUN apk --no-cache add curl
RUN curl -sSL https://raw.githubusercontent.com/pdm-project/pdm/main/install-pdm.py | python3 -
RUN export PATH=/root/.local/bin:$PATH

COPY pyproject.toml .
COPY pdm.lock .

RUN pdm install

COPY . .

CMD ["pdm", "run", "python3", "main.py"]