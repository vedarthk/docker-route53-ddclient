FROM python:3.11.0b5-slim

RUN pip install -U awscli==1.19.105

ADD ddclient.sh /ddclient.sh

CMD []
ENTRYPOINT ["/ddclient.sh"]
