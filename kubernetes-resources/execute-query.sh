#!/bin/bash
export MYSQL_HOST="mysql-read"
export MYSQL_PORT="3306"
export MYSQL_EXECUTE="SHOW TABLES;"
OVERRIDE_JSON_TEMPLATE='
{
  "apiVersion": "v1",
  "spec": {
    "imagePullSecrets": [{
      "name": "rh-registry-creds"
    }],
    "restartPolicy": "Never",
    "containers": [{
      "name": "mysql-command",
      "image": "registry.redhat.io/rhel9/mysql-80:latest",
      "imagePullPolicy": "IfNotPresent",
      "stdin": true,
      "securityContext": {
        "allowPrivilegeEscalation": false,
        "capabilities": {
          "drop": [ "ALL" ]
        },
        "runAsNonRoot": true,
        "seccompProfile": {
          "type": "RuntimeDefault"
        }
      },
      "command": [
        "bash",
        "-c",
        "mysql --user=\"${MYSQL_USER}\" --password=\"${MYSQL_PASSWORD}\" --host=\"${MYSQL_HOST}\" --port=${MYSQL_PORT} --database=\"${MYSQL_DATABASE}\" --execute=\"${MYSQL_EXECUTE}\" 2>&1"
      ],
      "env": [{
        "name": "MYSQL_USER",
        "valueFrom": {
          "secretKeyRef": {
            "key": "MYSQL_USER",
            "name": "mysql-creds"
          }
        }
      },
      {
        "name": "MYSQL_PASSWORD",
        "valueFrom": {
          "secretKeyRef": {
            "key": "MYSQL_PASSWORD",
            "name": "mysql-creds"
          }
        }
      },
      {
        "name": "MYSQL_DATABASE",
        "valueFrom": {
          "secretKeyRef": {
            "key": "MYSQL_DATABASE",
            "name": "mysql-creds"
          }
        }
      },
      {
        "name": "MYSQL_HOST",
        "value": "%MYSQL_HOST%"
      },
      {
        "name": "MYSQL_PORT",
        "value": "%MYSQL_PORT%"
      },
      {
        "name": "MYSQL_EXECUTE",
        "value": "%MYSQL_EXECUTE%"
      }]  
    }]
  }
}'
while getopts "h:p:c:" arg
do
   case "${arg}" in
   h)
      MYSQL_HOST="${OPTARG}"
      ;;
   p)
      MYSQL_PORT="${OPTARG}"
      ;;
   c)
      MYSQL_EXECUTE="${OPTARG}"
      ;;
   *)
      echo "Option '${arg}' is incorrect"
      echo "Usage: `basename $0` [-h host -p port ] -c \"sql-command\""
      exit 1
   esac
done
shift $(( OPTIND - 1 ))
OVERRIDE_JSON="$( echo ${OVERRIDE_JSON_TEMPLATE} | sed -e 's/%MYSQL_HOST%/'${MYSQL_HOST}'/g' -e 's/%MYSQL_PORT%/'${MYSQL_PORT}'/g' -e 's/%MYSQL_EXECUTE%/'"${MYSQL_EXECUTE}"'/g' )"
exec kubectl run mysql-command \
--image "registry.redhat.io/rhel9/mysql-80:latest" \
--overrides "${OVERRIDE_JSON}" \
-i --rm