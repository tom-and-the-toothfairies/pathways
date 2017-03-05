FROM python:3.6-alpine
MAINTAINER Eoin Houlihan <ehoulih@tcd.ie>

# Set exposed ports
EXPOSE 5000

ENV PYTHONPATH=asclepius
ENV FLASK_APP=asclepius/main.py
ENV ASCLEPIUS_FUSEKI_ADDRESS=chiron:3030

RUN apk add --update git

RUN mkdir -p /opt/app
WORKDIR /opt/app

# Cache python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["flask", "run", "--host", "0.0.0.0"]
