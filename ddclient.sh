#!/bin/bash

ROUTE53_ZONE=$1
DOMAIN_NAME=$2

if [ -z "$DOMAIN_NAME" ] || [ -z $ROUTE53_ZONE ]
then
   echo "usage: ddclient.sh {Route53 Zone ID} {some.domain.name}"
   exit
fi

MY_IP=$(curl --silent https://ifconfig.co)

ret=$?

for ip_cmd in \
    "curl --silent checkip.dyndns.org" \
    "curl --silent https://ifconfig.co" \
    "dig +short myip.opendns.com @resolver1.opendns.com" \
    ; do

    echo -n "Fetching IP using:  ${ip_cmd} ..."
    MY_IP=$($ip_cmd)
    MY_IP=$(echo $MY_IP | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

    if [ $? -eq 0 ]; then
        echo "[OK]"
        break
    else
        echo "[ERROR]"
    fi
done


echo -n "Updating ${DOMAIN_NAME} to point to ${MY_IP} ..."

TEMP_FILE=/tmp/DDCLIENT_CHANGE_BATCH.json

cat > $TEMP_FILE <<-EOF
{
    "Comment": "Update latest IP",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "${DOMAIN_NAME}",
                "Type": "A",
                "TTL": 300,
                "ResourceRecords": [
                    {"Value": "${MY_IP}"}
                ]
            }
        }
    ]
}
EOF

aws route53 change-resource-record-sets --hosted-zone-id $ROUTE53_ZONE --change-batch "file://${TEMP_FILE}"

if [ $? -eq 0 ]; then
    echo "[OK]"
else
    echo "[ERROR]"
    exit 1
fi
