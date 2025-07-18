#!/bin/bash
set -e

echo "Aguardando Localstack ficar pronto..."

until aws --endpoint-url=http://localstack:4566 s3 ls >/dev/null 2>&1; do
  echo "Esperando Localstack..."
  sleep 2
done


echo "Criando bucket no S3"
aws --endpoint-url=http://localstack:4566 s3 mb s3://arquivos-ria

echo "Criando fila SQS"
aws --endpoint-url=http://localstack:4566 sqs create-queue --queue-name file-events

echo "Configurando as notificações no S3"
aws --endpoint-url=http://localstack:4566 s3api put-bucket-notification-configuration \
  --bucket arquivos-ria \
  --notification-configuration file:///workspace/bucket-notification.json

echo "Finalizado com sucesso!"
tail -f /dev/null