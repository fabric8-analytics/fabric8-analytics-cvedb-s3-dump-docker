#!/bin/bash -ex

upload ()
{
    cvedb=$1
    bucket=$2

    endpoint_arg="${S3_ENDPOINT_URL:+--endpoint-url ${S3_ENDPOINT_URL}}"

    aws ${endpoint_arg} s3 ls | grep ${bucket} || aws ${endpoint_arg} --region us-east-1 s3 mb s3://${bucket}
    aws ${endpoint_arg} s3 cp ${cvedb} s3://${bucket}
}

# OWASP dependency-check
upload "/tmp/cvedb/dc.h2.db.zip" "${DEPLOYMENT_PREFIX}-bayesian-core-vuln-db"
upload "/tmp/victims-cve-db.zip" "${DEPLOYMENT_PREFIX}-bayesian-core-vuln-db"
