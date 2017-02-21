FROM python:3.6-alpine
MAINTAINER Eoin Houlihan <ehoulih@tcd.ie>

# Set exposed ports
EXPOSE 5000
ENV FLASK_APP=src/main.py

RUN apk add --update git

RUN mkdir -p /opt/app
WORKDIR /opt/app

# Cache DINTO
RUN git clone https://github.com/labda/DINTO.git

# Cache python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN cd DINTO && git checkout 68a29b568d6690fd04284feb06d152ca6e1e2e46

CMD ["flask", "run", "--host", "0.0.0.0"]
