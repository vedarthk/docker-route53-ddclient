FROM python:3.9.7-slim

RUN pip install -U awscli==1.19.105

ADD ddclient.sh /ddclient.sh

CMD []
ENTRYPOINT ["/ddclient.sh"]
