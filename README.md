# Route53 ddclient

Docker image to update dynamic IP address into AWS Route53 DNS zone.

# Usage

1. Pull the docker image:
```shell
docker pull vedarthk/route53-ddclient:1.0.0
```

2. Run a docker container to update the IP address:
```shell
docker run --rm vedarthk/route53-ddclient:1.0.0 ROUTE53_ZONE_ID fully.qualified.domain.name
```

You can run this as a cron job which can keep updating the IP address.


# Development

This docker image is based on Python, which is used to install `awscli` a commandline tool to interact with AWS cloud infrastructure.

## Clone

```shell
git clone git@github.com:vedarthk/docker-route53-ddclient.git
```

## Build
```shell
cd docker-route53-ddclient
docker built -t image:tag .
```
